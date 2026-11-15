# Cloudflare WARP - Menu Interactivo (version PS)
$warpCli = "C:\\Program Files\\Cloudflare\\Cloudflare WARP\\warp-cli.exe"

function Get-TraceInfo {
    param($Name)
    try {
        $resp = Invoke-WebRequest -Uri "https://www.cloudflare.com/cdn-cgi/trace" -UseBasicParsing -TimeoutSec 5
        foreach ($line in $resp.Content -split "`n") {
            if ($line.StartsWith("$Name=")) { return $line.Substring($Name.Length + 1).Trim() }
        }
    } catch {}
    return ""
}

function Get-IPv4 {
    try {
        $ip = Invoke-RestMethod -Uri "https://api.ipify.org" -UseBasicParsing -TimeoutSec 5
        return $ip
    } catch {
        return ""
    }
}

do {
    Clear-Host
    Write-Host ""
    Write-Host "Cloudflare WARP - Menu Interactivo" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""

    # Estado servicio
    Write-Host "[Estado]" -ForegroundColor Yellow
    $svc = Get-Service "Cloudflare One Client" -ErrorAction SilentlyContinue
    if ($svc) {
        Write-Host "   Servicio: $($svc.Status)" -ForegroundColor $(if ($svc.Status -eq "Running") { "Green" } else { "Yellow" })
    } else {
        Write-Host "   Servicio: NO instalado" -ForegroundColor Red
    }

    # IP y detalles
    $ip = Get-TraceInfo -Name "ip"
    $colo = Get-TraceInfo -Name "colo"
    $ip4 = Get-IPv4
    
    if ($ip -match ":") {
        Write-Host "   IPv6: $ip" -ForegroundColor Cyan
    } else {
        Write-Host "   IP: $ip" -ForegroundColor Cyan
    }
    
    if ($ip4 -ne "") {
        Write-Host "   IPv4: $ip4" -ForegroundColor Cyan
    }
    
    if ($colo -ne "") {
        Write-Host "   Nodo: $colo" -ForegroundColor Gray
    }
    Write-Host ""

    # Menu opciones
    Write-Host "[Opciones]" -ForegroundColor Yellow
    Write-Host "  1) Rotar IP AHORA"
    Write-Host "  2) Desconectar WARP"
    Write-Host "  3) Conectar WARP"
    Write-Host "  4) Ver estado completo"
    Write-Host "  5) Salir"
    Write-Host ""

    $choice = Read-Host "Elige una opcion (1-5)"

    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "Rotando IP..." -ForegroundColor Yellow
            
            $ipBefore = Get-TraceInfo -Name "ip"
            if ($ipBefore -match ":") {
                Write-Host "   IPv6 antes: $ipBefore" -ForegroundColor Gray
            } else {
                Write-Host "   IP antes: $ipBefore" -ForegroundColor Gray
            }

            & $warpCli disconnect 2>&1 | Out-Null
            Start-Sleep -Seconds 3
            & $warpCli connect 2>&1 | Out-Null
            Start-Sleep -Seconds 8

            $ipAfter = Get-TraceInfo -Name "ip"
            if ($ipAfter -match ":") {
                Write-Host "   IPv6 despues: $ipAfter" -ForegroundColor Cyan
            } else {
                Write-Host "   IP despues: $ipAfter" -ForegroundColor Cyan
            }
            
            if ($ipBefore -ne $ipAfter -and $ipBefore -ne "" -and $ipAfter -ne "") {
                Write-Host "   OK: IP cambiada!" -ForegroundColor Green
            }
            Write-Host ""
            Read-Host "Presiona Enter para continuar"
        }
        "2" {
            & $warpCli disconnect 2>&1 | Out-Null
            Write-Host "Desconectado." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
        "3" {
            & $warpCli connect 2>&1 | Out-Null
            Write-Host "Conectado." -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        "4" {
            Write-Host ""
            Write-Host "Estado completo:" -ForegroundColor Yellow
            & $warpCli status 2>&1
            Write-Host ""
            & $warpCli stats 2>&1 | Select-Object -First 20
            Write-Host ""
            Read-Host "Presiona Enter para continuar"
        }
    }
} while ($choice -ne "5")