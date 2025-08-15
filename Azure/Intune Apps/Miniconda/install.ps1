$Installer = "Miniconda3-latest-Windows-x86_64.exe"
$InstallPath = "C:\Program Files\Miniconda3"

Start-Process -FilePath $Installer `
    -ArgumentList "/InstallationType=AllUsers", "/AddToPath=0", "/S", "/D=$InstallPath" `
    -WindowStyle Hidden `
    -Wait

# Add to system PATH manually
$envPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($envPath -notlike "*$InstallPath*") {
    $newPath = "$envPath;$InstallPath;$InstallPath\Scripts;$InstallPath\Library\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "Miniconda path added to system PATH."
} else {
    Write-Host "Miniconda path already exists in system PATH."
}