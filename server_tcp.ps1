$port = 3000
$root = "C:\Users\RISHAL C K\.gemini\antigravity\scratch\fitnova"

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
$listener.Start()
Write-Host "FitNova TCP Web Server running on port $port..."

while ($true) {
    try {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        
        $buffer = New-Object byte[] 8192
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -le 0) { $client.Close(); continue }
        
        $requestText = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
        $firstLine = $requestText.Split("`n")[0].Trim()
        
        $parts = $firstLine.Split(' ')
        $path = if ($parts.Length -gt 1) { $parts[1] } else { "/" }
        $urlPath = $path.Split('?')[0]
        if ($urlPath -eq "/") { $urlPath = "/index.html" }

        $relativePath = $urlPath.TrimStart('/')
        $localPath = [System.IO.Path]::Combine($root, $relativePath)

        if ([System.IO.File]::Exists($localPath)) {
            $bytes = [System.IO.File]::ReadAllBytes($localPath)
            $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
            
            $mime = switch ($ext) {
                ".html" { "text/html; charset=utf-8" }
                ".css"  { "text/css; charset=utf-8" }
                ".js"   { "text/javascript; charset=utf-8" }
                ".jpg"  { "image/jpeg" }
                ".jpeg" { "image/jpeg" }
                ".png"  { "image/png" }
                ".json" { "application/json" }
                default { "application/octet-stream" }
            }

            $header = "HTTP/1.1 200 OK`r`nAccess-Control-Allow-Origin: *`r`nContent-Type: $mime`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)
            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($bytes, 0, $bytes.Length)
        } else {
            $notFound = "404 Not Found"
            $header = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain`r`nContent-Length: $($notFound.Length)`r`nConnection: close`r`n`r`n$notFound"
            $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)
            $stream.Write($headerBytes, 0, $headerBytes.Length)
        }
        $stream.Flush()
        $client.Close()
    } catch {
        # continue loop
    }
}
