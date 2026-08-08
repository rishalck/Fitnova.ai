# Build a single self-contained HTML file with all CSS/JS inlined and images as base64
# Then upload to a free static hosting service

$siteDir = "C:\Users\RISHAL C K\.gemini\antigravity\scratch\fitnova"
$outputFile = "C:\Users\RISHAL C K\.gemini\antigravity\scratch\fitnova_standalone.html"

Write-Host "=== Building self-contained FitNova HTML ==="

# Read source files
$htmlContent = Get-Content "$siteDir\index.html" -Raw -Encoding UTF8
$cssContent = Get-Content "$siteDir\styles.css" -Raw -Encoding UTF8
$jsContent = Get-Content "$siteDir\app.js" -Raw -Encoding UTF8

# Convert images to base64
$logoBytes = [System.IO.File]::ReadAllBytes("$siteDir\assets\logo.jpg")
$logoB64 = [Convert]::ToBase64String($logoBytes)

$coachBytes = [System.IO.File]::ReadAllBytes("$siteDir\assets\ai_coach.jpg")
$coachB64 = [Convert]::ToBase64String($coachBytes)

$hwBytes = [System.IO.File]::ReadAllBytes("$siteDir\assets\hardware.jpg")
$hwB64 = [Convert]::ToBase64String($hwBytes)

Write-Host "Images converted to base64"

# Replace external CSS link with inline style
$htmlContent = $htmlContent -replace '<link rel="stylesheet" href="styles.css">', "<style>`n$cssContent`n</style>"

# Replace external JS src with inline script
$htmlContent = $htmlContent -replace '<script src="app.js"></script>', "<script>`n$jsContent`n</script>"

# Replace image references with base64 data URIs
$htmlContent = $htmlContent -replace 'assets/logo\.jpg', "data:image/jpeg;base64,$logoB64"
$htmlContent = $htmlContent -replace 'assets/ai_coach\.jpg', "data:image/jpeg;base64,$coachB64"
$htmlContent = $htmlContent -replace 'assets/hardware\.jpg', "data:image/jpeg;base64,$hwB64"

# Remove manifest and sw references (not needed for standalone)
$htmlContent = $htmlContent -replace '<link rel="manifest" href="manifest.json">', ''
$htmlContent = $htmlContent -replace "if \('serviceWorker'[\s\S]*?</script>", '</script>'

# Write the standalone file
[System.IO.File]::WriteAllText($outputFile, $htmlContent, [System.Text.Encoding]::UTF8)

$fileSize = (Get-Item $outputFile).Length
Write-Host "Standalone HTML created: $outputFile"
Write-Host "File size: $([math]::Round($fileSize / 1024)) KB"

# Now upload to surge.sh or similar service
# Try uploading to file hosting that returns a URL

# Method: Use Netlify's file-based deploy API (individual files)
# Actually let's try a different approach - upload the zip to static.app

# Create a proper zip for upload
$zipPath = "C:\Users\RISHAL C K\.gemini\antigravity\scratch\fitnova_single.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $outputFile -DestinationPath $zipPath -Force

Write-Host "`nZip size: $([math]::Round((Get-Item $zipPath).Length / 1024)) KB"

# Try uploading via PowerShell to static.app
Write-Host "`nTrying static.app upload..."
try {
    # static.app accepts zip uploads
    $boundary = [System.Guid]::NewGuid().ToString()
    $fileBin = [System.IO.File]::ReadAllBytes($zipPath)
    
    $bodyLines = @(
        "--$boundary",
        'Content-Disposition: form-data; name="file"; filename="fitnova.zip"',
        'Content-Type: application/zip',
        '',
        ''
    )
    
    $enc = [System.Text.Encoding]::UTF8
    $bodyStart = $enc.GetBytes(($bodyLines -join "`r`n"))
    $bodyEnd = $enc.GetBytes("`r`n--$boundary--`r`n")
    
    $body = New-Object byte[] ($bodyStart.Length + $fileBin.Length + $bodyEnd.Length)
    [System.Buffer]::BlockCopy($bodyStart, 0, $body, 0, $bodyStart.Length)
    [System.Buffer]::BlockCopy($fileBin, 0, $body, $bodyStart.Length, $fileBin.Length)
    [System.Buffer]::BlockCopy($bodyEnd, 0, $body, $bodyStart.Length + $fileBin.Length, $bodyEnd.Length)
    
    $response = Invoke-RestMethod -Uri "https://static.app/api/sites" `
        -Method Post `
        -ContentType "multipart/form-data; boundary=$boundary" `
        -Body $body `
        -TimeoutSec 120
    
    Write-Host "SUCCESS! URL: $($response.url)"
    Write-Host $response
} catch {
    Write-Host "static.app failed: $_"
}

# Fallback: try 0x0.st (accepts file uploads, returns URL)
Write-Host "`nTrying 0x0.st upload..."
try {
    # Use .NET WebClient for multipart upload
    Add-Type -AssemblyName System.Net.Http
    $client = New-Object System.Net.Http.HttpClient
    $client.Timeout = [TimeSpan]::FromSeconds(120)
    
    $content = New-Object System.Net.Http.MultipartFormDataContent
    $fileStream = [System.IO.File]::OpenRead($outputFile)
    $streamContent = New-Object System.Net.Http.StreamContent($fileStream)
    $streamContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue("text/html")
    $content.Add($streamContent, "file", "fitnova.html")
    
    $result = $client.PostAsync("https://0x0.st", $content).Result
    $responseText = $result.Content.ReadAsStringAsync().Result
    
    $fileStream.Close()
    $client.Dispose()
    
    Write-Host "0x0.st response: $responseText"
} catch {
    Write-Host "0x0.st failed: $_"
}

Write-Host "`n=== Done ==="
