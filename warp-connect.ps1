# Cloudflare WARP - Conectar
# Conecta el cliente WARP

$warpCli = "C:\\Program Files\\Cloudflare\\Cloudflare WARP\\warp-cli.exe"

Write-Host ""
Write-Host "Conectando a Cloudflare WARP..." -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

try {
    & $warpCli connect 2>&1 | Out-Null
    Start-Sleep -Seconds 5
    
    $status = & $warpCli status 2>&1
    Write-Host ""
    Write-Host "Estado:" -ForegroundColor Yellow
    Write-Host "  $status" -ForegroundColor Gray
    
    Write-Host ""
    Write-Host "Conectado exitosamente." -ForegroundColor Green
} catch {
    Write-Host "Error al conectar WARP." -ForegroundColor Red
}

Write-Host ""

# Mostrar IP actual
try {
    $resp = Invoke-WebRequest -Uri "https://www.cloudflare.com/cdn-cgi/trace" -UseBasicParsing -TimeoutSec 5
    $lines = $resp.Content -split "`n"
    foreach ($line in $lines) {
        if ($line.StartsWith("ip=")) { 
            $ip = $line.Substring(3).Trim()
            if ($ip -match ":") {
                Write-Host "IPv6: $ip" -ForegroundColor Cyan
            } else {
                Write-Host "IPv4: $ip" -ForegroundColor Cyan
            }
        }
        if ($line.StartsWith("colo=")) {
            Write-Host "Nodo: $($line.Substring(5).Trim())" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "No se pudo obtener IP." -ForegroundColor Yellow
}

Write-Host ""