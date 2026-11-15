# Cloudflare WARP - Estado actual
$warpCli = "C:\\Program Files\\Cloudflare\\Cloudflare WARP\\warp-cli.exe"

Write-Host ""
Write-Host "Cloudflare WARP - Estado actual" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Estado del servicio
Write-Host "Servicio:" -ForegroundColor Yellow
$svc = Get-Service "Cloudflare One Client" -ErrorAction SilentlyContinue
if ($svc) {
    Write-Host "   Estado: $($svc.Status)" -ForegroundColor $(if ($svc.Status -eq "Running") { "Green" } else { "Yellow" })
} else {
    Write-Host "   NO encontrado" -ForegroundColor Red
}

# Estado de conexion
Write-Host ""
Write-Host "Conexion:" -ForegroundColor Yellow
$statusOutput = & $warpCli status 2>&1
Write-Host "   $statusOutput" -ForegroundColor Gray

# IP publica
Write-Host ""
Write-Host "IP publica:" -ForegroundColor Yellow
try {
    $resp = Invoke-WebRequest -Uri "https://www.cloudflare.com/cdn-cgi/trace" -UseBasicParsing
    $lines = $resp.Content -split "`n"
    foreach ($line in $lines) {
        if ($line.StartsWith("ip=")) { 
            $ip = $line.Substring(3).Trim()
            # Verificar si es IPv6
            if ($ip -match ":") {
                Write-Host "   IPv6: $ip" -ForegroundColor Cyan
            } else {
                Write-Host "   IPv4: $ip" -ForegroundColor Cyan
            }
        }
        if ($line.StartsWith("colo=")) { Write-Host "   Nodo: $($line.Substring(5).Trim())" -ForegroundColor Gray }
        if ($line.StartsWith("loc=")) { Write-Host "   Pais: $($line.Substring(4).Trim())" -ForegroundColor Gray }
        if ($line.StartsWith("warp=")) { Write-Host "   WARP: $($line.Substring(5).Trim())" -ForegroundColor Gray }
    }
} catch {
    Write-Host "   No disponible" -ForegroundColor Red
}

# IP IPv4 alternativa
Write-Host ""
Write-Host "IP IPv4 alternativa:" -ForegroundColor Yellow
try {
    $ip4 = Invoke-RestMethod -Uri "https://api.ipify.org" -UseBasicParsing -ErrorAction Stop
    Write-Host "   $ip4" -ForegroundColor Cyan
} catch {
    Write-Host "   No disponible" -ForegroundColor Gray
}

# IP IPv6 alternativa
Write-Host ""
Write-Host "IP IPv6 alternativa:" -ForegroundColor Yellow
try {
    $ip6 = Invoke-RestMethod -Uri "https://api64.ipify.org" -UseBasicParsing -ErrorAction Stop
    Write-Host "   $ip6" -ForegroundColor Cyan
} catch {
    Write-Host "   No disponible" -ForegroundColor Gray
}

Write-Host ""

# Comandos rapidos
Write-Host "Comandos rapidos:" -ForegroundColor Yellow
Write-Host "--------------------" -ForegroundColor Yellow
Write-Host "  .\warp-flip.ps1            : Rotar IP"
Write-Host ""
