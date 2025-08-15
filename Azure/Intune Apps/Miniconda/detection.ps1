# ========================
# Intune Detection Script for Miniconda
# ========================

$pathsToCheck = @(
    "C:\Program Files\Miniconda3\python.exe",
    "C:\Program Files\Miniconda3\condabin\conda.bat"
)

foreach ($path in $pathsToCheck) {
    if (Test-Path $path) {
        Write-Host "Miniconda detected at $path"
        exit 0
    }
}

Write-Host "Miniconda not found"
exit 1
