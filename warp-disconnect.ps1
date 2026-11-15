# Cloudflare WARP - Desconectar
# Desconecta el cliente WARP

$warpCli = "C:\\Program Files\\Cloudflare\\Cloudflare WARP\\warp-cli.exe"

Write-Host ""
Write-Host "Desconectando de Cloudflare WARP..." -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow

try {
    & $warpCli disconnect 2>&1 | Out-Null
    Write-Host ""
    Write-Host "Estado:" -ForegroundColor Yellow
    Write-Host "  Desconectado" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Desconectado exitosamente." -ForegroundColor Green
} catch {
    Write-Host "Error al desconectar WARP." -ForegroundColor Red
}

Write-Host ""

# Verificar estado
try {
    $status = & $warpCli status 2>&1
    Write-Host "Nuevo estado: $status" -ForegroundColor Gray
} catch {
    Write-Host "No se pudo obtener estado." -ForegroundColor Yellow
}

Write-Host ""