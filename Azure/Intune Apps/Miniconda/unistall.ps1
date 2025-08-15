# ========================
# Aggressive Miniconda Uninstall for Intune (with System PATH cleanup)
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

Write-Log "===== Starting aggressive Miniconda uninstall ====="

# Kill any process running from the install path
Get-Process | Where-Object { $_.Path -and $_.Path -like "$InstallPath*" } | ForEach-Object {
    try {
        Stop-Process -Id $_.Id -Force
        Write-Log "Stopped process: $($_.Name)"
    } catch {
        Write-Log "Failed to stop process: $($_.Name) - $_"
    }
}

# Remove Miniconda paths from system PATH
$pathsToRemove = @(
    "$InstallPath",
    "$InstallPath\Scripts",
    "$InstallPath\Library\bin"
)

try {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $currentPath = (Get-ItemProperty -Path $regPath -Name Path).Path

    foreach ($p in $pathsToRemove) {
        $escaped = [Regex]::Escape(";$p")
        $currentPath = $currentPath -replace $escaped, ""
        Write-Log "Removed PATH entry: $p"
    }

    Set-ItemProperty -Path $regPath -Name Path -Value $currentPath
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
    Write-Log "Failed to update system PATH: $_"
}

# Reset permissions so SYSTEM can delete the folder
if (Test-Path $InstallPath) {
    try { icacls $InstallPath /grant "SYSTEM:F" /T /C | Out-Null; Write-Log "Reset folder permissions for SYSTEM." } catch { Write-Log "Failed reset permissions: $_" }
}

# Force delete Miniconda folder with retries
for ($i=1; $i -le 5; $i++) {
    if (Test-Path $InstallPath) {
        try {
            Remove-Item -Path $InstallPath -Recurse -Force -ErrorAction Stop
            Write-Log "Deleted Miniconda folder."
            break
        } catch {
            Write-Log "Attempt $i to delete folder failed: $_"
            Start-Sleep -Seconds 2
        }
    }
}

if (Test-Path $InstallPath) {
    Write-Log "ERROR: Miniconda folder still exists after uninstall attempts."
    exit 1
}

Write-Log "===== Aggressive uninstall complete ====="
exit 0
