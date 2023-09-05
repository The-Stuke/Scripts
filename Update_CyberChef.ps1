# Script to download latest CyberChef release and remove old version
$ProgressPreference = 'SilentlyContinue' # Speed up Invoke-WebRequest

# Define Repo and Local Path
$repo = 'gchq/CyberChef'
$Local_Path = 'C:\Tools\CyberChef'

# Determine latest release
$releases = "https://api.github.com/repos/$repo/releases"
Write-Host Determining latest release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
$download_name = "CyberChef_" + $tag + ".zip"
$download_url = "https://github.com/$repo/releases/download/$tag/$download_name"
$dir = $download_name.Replace('.zip', '')

# Download latest release and extract
Write-Host 'Dowloading latest release'
Invoke-WebRequest $download_url -Out $download_name
Write-Host 'Extracting release files'
Expand-Archive $download_name -Force

# Remove downloaded zip
Write-Host 'Cleaning up target directory'
Remove-Item $download_name -Recurse -Force -ErrorAction SilentlyContinue 

# Delete old CyberChef
Remove-Item $Local_Path -Recurse -Force -ErrorAction SilentlyContinue 

# Moving CyberChef to local path location
Write-Host 'Moving Temp files'
Move-Item $dir -Destination $Local_Path -Force

# Rename CyberChef
$html_name = $Local_Path + '\CyberChef_' + $tag + '.html'
$new_name = $Local_Path + '\CyberChef.html'
Rename-Item $html_name -NewName $new_name