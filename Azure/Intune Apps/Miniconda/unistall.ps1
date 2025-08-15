# Define install path and uninstaller
$InstallPath = "C:\Program Files\Miniconda3"
$Uninstaller = Join-Path $InstallPath "Uninstall.exe"

# Define log folder and path
$LogFolder = "C:\Temp"
$LogPath = Join-Path $LogFolder "Miniconda_Uninstall.log"

# Ensure log folder exists or fallback to system temp
try {
    if (-not (Test-Path $LogFolder)) {
        New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
    }
}
catch {
    $LogFolder = $env:TEMP
    $LogPath = Join-Path $LogFolder "Miniconda_Uninstall.log"
}

# Logging function
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPath -Value "[$timestamp] $Message"
}

Write-Log "Starting Miniconda uninstall script..."

# Kill blocking processes
$processes = "conda", "python", "Uninstall"
foreach ($proc in $processes) {
    try {
        Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force
        Write-Log "Killed process: $proc"
    } catch {
        Write-Log "Process $proc not running or could not be stopped."
    }
}

# Run uninstaller
try {
    if (Test-Path $Uninstaller) {
        Write-Log "Uninstaller found at $Uninstaller. Executing..."
        & $Uninstaller /S
        Write-Log "Uninstall process completed."
    } else {
        Write-Log "Uninstaller not found. Skipping uninstall."
    }

    # Remove Miniconda paths from system PATH via registry
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $currentPath = (Get-ItemProperty -Path $regPath -Name Path).Path

    $pathsToRemove = @(
        "$InstallPath",
        "$InstallPath\Scripts",
        "$InstallPath\Library\bin"
    )

    foreach ($p in $pathsToRemove) {
        $escaped = [Regex]::Escape(";$p")
        $currentPath = $currentPath -replace $escaped, ""
        Write-Log "Removed PATH entry: $p"
    }

    Set-ItemProperty -Path $regPath -Name Path -Value $currentPath
    Write-Log "Updated system PATH via registry."

    # Broadcast environment variable change
    $signature = @"
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
    Add-Type -MemberDefinition $signature -Name "Win32SendMessageTimeout" -Namespace Win32Functions

    $lpdwResult = [UIntPtr]::Zero
    [Win32Functions.Win32SendMessageTimeout]::SendMessageTimeout(
        [IntPtr]0xffff,
        0x1A,
        [UIntPtr]::Zero,
        "Environment",
        0x0002,
        5000,
        [ref]$lpdwResult
    ) | Out-Null
    Write-Log "Broadcasted environment variable change."

    # Remove leftover folder
    if (Test-Path $InstallPath) {
        Remove-Item -Path $InstallPath -Recurse -Force
        Write-Log "Deleted leftover Miniconda folder."
    } else {
        Write-Log "No leftover folder found."
    }

    Write-Log "Miniconda uninstall completed successfully."
    exit 0
}
catch {
    Write-Log "Uninstall failed: $_"
    exit 1
}