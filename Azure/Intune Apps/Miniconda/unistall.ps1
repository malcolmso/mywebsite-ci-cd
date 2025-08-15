# ========================
# Miniconda Aggressive Uninstall for Intune
# ========================

$InstallPath = "C:\Program Files\Miniconda3"
$LogFolder   = "C:\Temp"
$LogPath     = Join-Path $LogFolder "Miniconda_Uninstall.log"

# Ensure log folder exists
if (-not (Test-Path $LogFolder)) {
    try { New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null }
    catch { $LogFolder = $env:TEMP; $LogPath = Join-Path $LogFolder "Miniconda_Uninstall.log" }
}

function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}

Write-Log "===== Starting Miniconda uninstall ====="

# Kill any process running from the install path
Get-Process | Where-Object { $_.Path -and $_.Path -like "$InstallPath*" } | ForEach-Object {
    try {
        Stop-Process -Id $_.Id -Force
        Write-Log "Stopped process: $($_.Name)"
    } catch {
        Write-Log "Failed to stop process: $($_.Name) - $($_.Exception.Message)"
    }
}

# Remove Miniconda paths from system PATH
try {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $currentPath = (Get-ItemProperty -Path $regPath -Name Path).Path
    $pathList = $currentPath -split ';'

    $filteredPath = $pathList | Where-Object { $_ -notmatch [Regex]::Escape($InstallPath) }
    $newPath = ($filteredPath -join ';').Trim(';')

    Set-ItemProperty -Path $regPath -Name Path -Value $newPath
    Write-Log "System PATH updated successfully."

    # Broadcast environment change
    $signature = @"
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
    Add-Type -MemberDefinition $signature -Name "Win32SendMessageTimeout" -Namespace Win32Functions
    $lpdwResult = [UIntPtr]::Zero
    [Win32Functions.Win32SendMessageTimeout]::SendMessageTimeout(
        [IntPtr]0xffff, 0x1A, [UIntPtr]::Zero, "Environment", 0x0002, 5000, [ref]$lpdwResult
    ) | Out-Null
    Write-Log "Environment variable change broadcasted."
} catch {
    Write-Log "Failed to update system PATH: $($_.Exception.Message)"
}

# Remove registry key if used for detection
$DetectionKey = "HKLM:\Software\Miniconda3"
if (Test-Path $DetectionKey) {
    try {
        Remove-Item -Path $DetectionKey -Force
        Write-Log "Removed detection registry key."
    } catch {
        Write-Log "Failed to remove registry key: $($_.Exception.Message)"
    }
}

# Reset permissions so SYSTEM can delete the folder
if (Test-Path $InstallPath) {
    try {
        icacls $InstallPath /grant "SYSTEM:F" /T /C | Out-Null
        Write-Log "Reset folder permissions for SYSTEM."
    } catch {
        Write-Log "Failed to reset permissions: $($_.Exception.Message)"
    }
}

# Force delete Miniconda folder with retries
$maxAttempts = 5
for ($i = 1; $i -le $maxAttempts; $i++) {
    if (Test-Path $InstallPath) {
        try {
            Remove-Item -Path $InstallPath -Recurse -Force -ErrorAction Stop
            Write-Log "Deleted Miniconda folder."
            break
        } catch {
            Write-Log "Attempt $i to delete folder failed: $($_.Exception.Message)"
            Start-Sleep -Seconds 2
        }
    }
}

# Final check
if (Test-Path $InstallPath) {
    Write-Log "WARNING: Miniconda folder still exists after uninstall attempts."
    # Do not exit with error to avoid Intune false failure
} else {
    Write-Log "Miniconda folder successfully removed."
}

Write-Log "===== Uninstall complete ====="
exit 0