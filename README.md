# Cloudflare WARP - Scripts PowerShell

> 💡 **PILDORA 1**: WARP en modo `warp` (túnel completo) **SI rota IPs** al reconectar. El método correcto es `warp-cli disconnect + connect`, NO usar `net stop/start` del servicio.

> ⚠️ **PILDORA 2**: El instalador aparece como "Cloudflare One Client" en el menú de inicio. El ejecutable está en: `C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe`

> 🚨 **PILDORA 3**: Para rotar IP, usa siempre `.\warp-flip.ps1` desde PowerShell. El script incluye fallback a api.ipify.org si Cloudflare falla.

## Scripts disponibles

| Archivo | Propósito |
|---------|-----------|
| `warp-connect.ps1` | Conectar a Cloudflare WARP |
| `warp-disconnect.ps1` | Desconectar de Cloudflare WARP |
| `warp-flip.ps1` | Rotar IP (método disconnect + connect) |
| `warp-status.ps1` | Ver estado actual con IPv4 e IPv6 |
| `warp-menu.ps1` | Menú interactivo interactivo |

## Instalación

1. Descargar e instalar Cloudflare WARP desde: https://1.1.1.1/
2. El instalador aparecerá como "Cloudflare One Client" en el menú de inicio
3. Verificar instalación:
   ```powershell
   Test-Path "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
   ```

## Uso rápido

```powershell
# Conectar
.\warp-connect.ps1

# Desconectar
.\warp-disconnect.ps1

# Rotar IP (recomendado)
.\warp-flip.ps1

# Ver estado
.\warp-status.ps1

# Menú interactivo
.\warp-menu.ps1
```

## Rotación de IPs

**Método correcto:**
```powershell
.\warp-flip.ps1
# O desde el menú: .\warp-menu.ps1 -> opción 1
```

**Qué NO funciona:**
```powershell
# ESTO NO ROTA LA IP:
net stop "Cloudflare One Client"
net start "Cloudflare One Client"
```

## Solución de problemas

### Error "The term 'warp-cli' is not recognized"

No están en el PATH. Usar siempre la ruta completa:
```powershell
"C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe" status
```

### IP no cambia después de rotar

1. Verificar estado de conexión: `warp-cli.exe status`
2. Verificar modo WARP: `warp-cli.exe mode`
3. Asegurar que el modo es `warp` (túnel completo)

## Comandos rápidos

Desde `warp-status.ps1`, verás al final:
```powershell
# Comandos rápidos
  .\warp-flip.ps1            : Rotar IP
```

## Archivos

- `AGENTS.md` - Instrucciones para agentes OpenCode
- `CHANGELOG.md` - Historial de cambios
- `LICENSE` - Licencia MIT

## Descubrimiento clave

El método correcto para rotar IPs es usar `warp-cli disconnect` seguido de `warp-cli connect`. Cualquier otro método (incluyendo reiniciar el servicio) no rota la IP.