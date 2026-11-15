<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg">
  <img src="https://img.shields.io/badge/language-PowerShell-powershell?logo=powershell&labelColor=2d2d2d">
</p>

# Cloudflare WARP - Scripts PowerShell

Scripts para gestionar el cliente Cloudflare WARP.

## Tabla de contenidos

- [Instalación](#instalación)
- [Uso](#uso)
- [Scripts](#scripts)
- [Rotación de IPs](#rotación-de-ips)
- [Solución de problemas](#solución-de-problemas)

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

## Scripts

| Archivo | Propósito |
|---------|-----------|
| `warp-connect.ps1` | Conectar a Cloudflare WARP |
| `warp-disconnect.ps1` | Desconectar de Cloudflare WARP |
| `warp-flip.ps1` | Rotar IP (método disconnect + connect) |
| `warp-status.ps1` | Ver estado actual con IPv4 e IPv6 |
| `warp-menu.ps1` | Menú interactivo |

## Rotación de IPs

**Importante**: WARP en modo `warp` (túnel completo) **SI rota IPs** al reconectar.

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

## Uso con OpenCode

1. Ejecutar `.\warp-flip.ps1` -> nueva IP rotada
2. Usar OpenCode normalmente
3. Si te limitan, volver a ejecutar `.\warp-flip.ps1`
4. Repetir hasta terminar sesión

### ¿Necesito configurar algo en OpenCode?

**No necesitas configuración adicional** para que la rotación de IP funcione.

Cuando ejecutas `.\warp-flip.ps1`, estás rotando la IP de tu **conexión a internet en nivel de sistema**. Tanto OpenCode como cualquier otra aplicación que use tu conexión directa utilizarán la nueva IP automáticamente.

**Esto solo funciona cuando:**
- OpenCode hace conexiones DIRECTAS a internet
- No estás usando un proxy HTTP/SOCKS configurado en OpenCode
- No estás detrás de un proxy corporativo

## Descubrimiento clave

El método correcto para rotar IPs es usar `warp-cli disconnect` seguido de `warp-cli connect`. Cualquier otro método (incluyendo reiniciar el servicio) no rota la IP.

---

## Archivos

- `CHANGELOG.md` - Historial de cambios
- `README.md` - Este documento
- `warp-flip.ps1` - Rotar IP
- `warp-connect.ps1` - Conectar WARP
- `warp-disconnect.ps1` - Desconectar WARP
- `warp-status.ps1` - Ver estado con IPv4 e IPv6
- `warp-menu.ps1` - Menú interactivo

## Requisitos

- Windows 10 o superior
- Cloudflare WARP instalado (via winget)
- PowerShell 5.1 o superior

## Licencia

MIT License