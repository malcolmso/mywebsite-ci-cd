# ========================
# Intune Detection Script for Miniconda
# ========================

$pathsToCheck = @(
    "C:\Program Files\Miniconda3\python.exe",
    "C:\Program Files\Miniconda3\condabin\conda.bat"
)

# Optional: Log detection attempts
$logPath = "$env:ProgramData\IntuneMinicondaDetection.log"
Add-Content -Path $logPath -Value "[$(Get-Date)] Starting Miniconda detection..."

foreach ($path in $pathsToCheck) {
    Add-Content -Path $logPath -Value "Checking: $path"
    if (Test-Path $path) {
        Add-Content -Path $logPath -Value "Found: $path"
        Write-Host "Miniconda detected at $path"
        exit 0
    }
}

# Optional: Registry fallback
$regPath = "HKLM:\Software\Miniconda3"
if (Test-Path $regPath) {
    try {
        $installPath = Get-ItemProperty -Path $regPath -Name InstallPath -ErrorAction Stop | Select-Object -ExpandProperty InstallPath
        $fallbackPath = Join-Path $installPath "python.exe"
        Add-Content -Path $logPath -Value "Registry InstallPath: $installPath"
        if (Test-Path $fallbackPath) {
            Add-Content -Path $logPath -Value "Found via registry: $fallbackPath"
            Write-Host "Miniconda detected via registry at $fallbackPath"
            exit 0
        }
    } catch {
        Add-Content -Path $logPath -Value "Registry lookup failed: $_"
    }
}

Add-Content -Path $logPath -Value "Miniconda not found"
Write-Host "Miniconda not found"
exit 1