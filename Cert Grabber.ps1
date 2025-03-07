# Create the 'certs' directory if it doesn't exist
$certsDirectory = Join-Path -Path (Get-Location) -ChildPath 'certs'
if (-not (Test-Path $certsDirectory)) {
    New-Item -ItemType Directory -Path $certsDirectory
}

# Get all files in the current directory
Get-ChildItem -File | ForEach-Object {
    $file = $_.FullName
    $certFileName = "$($certsDirectory)\$($_.BaseName).cer"
    
    # Extract and export the certificate
    $certificate = Get-AuthenticodeSignature $file | Select-Object -ExpandProperty SignerCertificate
    if ($certificate) {
        Export-Certificate -Type CERT -FilePath $certFileName -Cert $certificate
        Write-Host "Exported certificate for $($_.Name) to $certFileName"
    } else {
        Write-Host "No certificate found for $($_.Name)"
    }
}