# ========================
# Miniconda Silent Install for Intune with System PATH
# ========================

$Installer   = "Miniconda3-latest-Windows-x86_64.exe"
$InstallPath = "C:\Program Files\Miniconda3"
$LogFolder   = "C:\Temp"
$LogPath     = Join-Path $LogFolder "Miniconda_Install.log"

# Ensure log folder exists
if (-not (Test-Path $LogFolder)) {
    try { New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null }
    catch { $LogFolder = $env:TEMP; $LogPath = Join-Path $LogFolder "Miniconda_Install.log" }
}

function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}

Write-Log "===== Starting Miniconda install ====="

# Run installer silently
try {
    Start-Process -FilePath $Installer `
        -ArgumentList "/InstallationType=AllUsers", "/AddToPath=0", "/S", "/D=$InstallPath" `
        -WindowStyle Hidden -Wait
    Write-Log "Miniconda installer executed."
} catch {
    Write-Log "Failed to start installer: $_"
    exit 1
}

# Add Miniconda to system PATH manually
$pathsToAdd = @(
    "$InstallPath",
    "$InstallPath\Scripts",
    "$InstallPath\Library\bin"
)

try {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $currentPath = (Get-ItemProperty -Path $regPath -Name Path).Path

    foreach ($p in $pathsToAdd) {
        if ($currentPath -notlike "*$p*") {
            $currentPath += ";$p"
            Write-Log "Added $p to system PATH."
        } else {
            Write-Log "$p already in system PATH."
        }
    }

    Set-ItemProperty -Path $regPath -Name Path -Value $currentPath
    Write-Log "System PATH updated successfully."

    # Broadcast environment change so CMD sees it immediately
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

# Small delay to ensure PATH propagation
Start-Sleep -Seconds 5

# Verify installation
if (Test-Path "$InstallPath\python.exe") {
    Write-Log "Python detected at $InstallPath\python.exe"
    Write-Host "Miniconda install successful."
    exit 0
} else {
    Write-Log "ERROR: Python not found after install."
    Write-Host "Miniconda install failed."
    exit 1
}
