# Instrucciones para agentes - Scripts Cloudflare WARP

## Licencia

MIT License - Ver archivo `LICENSE`

## Qué es este proyecto

Repositorio de scripts PowerShell para gestionar el cliente Cloudflare WARP:
- `warp-connect.ps1` - Conectar a WARP
- `warp-disconnect.ps1` - Desconectar de WARP
- `warp-flip.ps1` - Rotar IP (método disconnect + connect)
- `warp-status.ps1` - Ver estado con IPv4 e IPv6
- `warp-menu.ps1` - Menú interactivo

## Comandos importantes

**Rotar IP (método correcto):**
```powershell
.\warp-flip.ps1
# O desde menú: .\warp-menu.ps1 -> opción 1
```

**Verificar warp-cli existe:**
```powershell
Test-Path "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
```

## Key Discovery - Rotación de IPs

- WARP en modo `warp` (túnel completo) **SI rota IPs** al reconectar
- Método correcto: `warp-cli disconnect` + `warp-cli connect`
- ❌ **NO usar**: `net stop/start "Cloudflare One Client"` (NO rota IP)

## Comandos rápidos desde estado

Ejecutar desde `warp-status.ps1` al final:
```powershell
.\warp-flip.ps1
```

## Notas técnicas

- Los scripts muestran tanto IPv4 como IPv6
- Uso de `https://www.cloudflare.com/cdn-cgi/trace` como fuente principal de IP
- Fallback a `api.ipify.org` cuando falla Cloudflare
- Tiempo de espera optimizado: 5s para conectar, 3s para disconnect, 8s para flip

## Qué NO hacer

- No usar `net stop/start` del servicio para rotar IPs
- No asumir que cualquier reinicio de servicio rota la IP
- No usar rutas relativas sin verificar que warp-cli está en el path correcto