# Azure Blob SAS URL for wallpaper
$wallpaperUrl = "PASTE_YOUR_SAS_URL_HERE"
$localPath = "C:\Windows\Web\Wallpaper\Company\wallpaper.jpg"

# Create local folder if missing
New-Item -Path "C:\Windows\Web\Wallpaper\Company" -ItemType Directory -Force | Out-Null

# Download wallpaper from blob storage
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $localPath

# Set wallpaper path in registry (current user)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name wallpaper -Value $localPath

# Create policy registry key to prevent wallpaper changes
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name NoChangingWallPaper -Value 1 -Type DWord

# Refresh desktop to apply wallpaper change immediately
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
