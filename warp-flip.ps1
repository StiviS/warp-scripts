# Cloudflare WARP - Rotador de IP para OpenCode
# Usa warp-cli connect/disconnect (NO net stop/start del servicio)

$warpCli = "C:\\Program Files\\Cloudflare\\Cloudflare WARP\\warp-cli.exe"

Write-Host ""
Write-Host "Cloudflare WARP - Rotador de IP" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

# IP actual antes de rotar
Write-Host "IP actual:" -ForegroundColor Yellow
try {
    $resp = Invoke-WebRequest -Uri "https://www.cloudflare.com/cdn-cgi/trace" -UseBasicParsing -TimeoutSec 10
    $lines = $resp.Content -split "`n"
    foreach ($line in $lines) {
        if ($line.StartsWith("ip=")) { 
            $ip = $line.Substring(3).Trim()
            if ($ip -match ":") {
                Write-Host "   IPv6: $ip" -ForegroundColor Cyan
            } else {
                Write-Host "   IPv4: $ip" -ForegroundColor Cyan
            }
        }
    }
} catch {
    # Fallback a ipify
    try {
        $ip = Invoke-RestMethod -Uri "https://api.ipify.org" -UseBasicParsing -TimeoutSec 5
        Write-Host "   IPv4: $ip" -ForegroundColor Cyan
    } catch {
        Write-Host "   No disponible" -ForegroundColor Red
    }
}

# Desconectar y reconectar
Write-Host ""
Write-Host "Rotando IP..." -ForegroundColor Yellow
try {
    & $warpCli disconnect 2>&1 | Out-Null
    Start-Sleep -Seconds 3
    & $warpCli connect 2>&1 | Out-Null
    Start-Sleep -Seconds 8
} catch {
    Write-Host "Error al rotar IP" -ForegroundColor Red
}

# Nueva IP
Write-Host ""
Write-Host "Nueva IP:" -ForegroundColor Yellow
try {
    $resp = Invoke-WebRequest -Uri "https://www.cloudflare.com/cdn-cgi/trace" -UseBasicParsing -TimeoutSec 10
    $lines = $resp.Content -split "`n"
    foreach ($line in $lines) {
        if ($line.StartsWith("ip=")) { 
            $ip = $line.Substring(3).Trim()
            if ($ip -match ":") {
                Write-Host "   IPv6: $ip" -ForegroundColor Cyan
            } else {
                Write-Host "   IPv4: $ip" -ForegroundColor Cyan
            }
        }
        if ($line.StartsWith("colo=")) {
            Write-Host "   Nodo: $($line.Substring(5).Trim())" -ForegroundColor Gray
        }
        if ($line.StartsWith("loc=")) {
            Write-Host "   Pais: $($line.Substring(4).Trim())" -ForegroundColor Gray
        }
    }
} catch {
    # Fallback a ipify
    try {
        $ip = Invoke-RestMethod -Uri "https://api.ipify.org" -UseBasicParsing -TimeoutSec 5
        Write-Host "   IPv4: $ip" -ForegroundColor Cyan
    } catch {
        Write-Host "   No disponible" -ForegroundColor Red
    }
}
Write-Host ""
Write-Host "Rotacion completa" -ForegroundColor Green
Write-Host ""