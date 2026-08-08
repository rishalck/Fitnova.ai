# Deploy FitNova to Netlify via their API (drag-and-drop equivalent)
# This creates a zip of the site and uploads it

$siteDir = "C:\Users\RISHAL C K\.gemini\antigravity\scratch\fitnova"
$zipPath = "C:\Users\RISHAL C K\.gemini\antigravity\scratch\fitnova_deploy.zip"

# Remove old zip if exists
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

# Create zip with only the web files (exclude deploy script and server script)
$filesToInclude = @(
    "$siteDir\index.html",
    "$siteDir\app.js",
    "$siteDir\styles.css",
    "$siteDir\manifest.json",
    "$siteDir\sw.js"
)

# Create a temp staging directory
$stagingDir = "$env:TEMP\fitnova_staging"
if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null
New-Item -ItemType Directory -Path "$stagingDir\assets" -Force | Out-Null

# Copy files to staging
foreach ($f in $filesToInclude) {
    Copy-Item $f -Destination $stagingDir -Force
}

# Copy assets
Copy-Item "$siteDir\assets\*" -Destination "$stagingDir\assets\" -Force

Write-Host "Staging directory contents:"
Get-ChildItem $stagingDir -Recurse | ForEach-Object { Write-Host $_.FullName }

# Create the zip
Compress-Archive -Path "$stagingDir\*" -DestinationPath $zipPath -Force
Write-Host "`nZip created at: $zipPath"
Write-Host "Zip size: $((Get-Item $zipPath).Length) bytes"

# Upload to Netlify API (no auth needed for anonymous deploys)
Write-Host "`nUploading to Netlify..."

try {
    $response = Invoke-RestMethod -Uri "https://api.netlify.com/api/v1/sites" `
        -Method Post `
        -ContentType "application/zip" `
        -InFile $zipPath `
        -TimeoutSec 120

    $siteUrl = $response.ssl_url
    if (-not $siteUrl) { $siteUrl = $response.url }
    
    Write-Host "`n=========================================="
    Write-Host "DEPLOYMENT SUCCESSFUL!"
    Write-Host "=========================================="
    Write-Host "Your public URL: $siteUrl"
    Write-Host "Site ID: $($response.id)"
    Write-Host "=========================================="
} catch {
    Write-Host "Error during upload: $_"
    Write-Host "Response: $($_.Exception.Response)"
}

# Cleanup staging
Remove-Item $stagingDir -Recurse -Force -ErrorAction SilentlyContinue
