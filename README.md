# Cloudflare WARP - Rotador de IP para OpenCode

Scripts de PowerShell para rotar direcciones IP usando Cloudflare WARP.

## ¿Qué hace?

Estos scripts te permiten rotar tu IP pública (IPv4 e IPv6) cuando Cloudflare WARP está instalado en tu sistema. Ideal para evitar rate limits en servicios como OpenCode.

## Archivos

| Archivo | Propósito |
|---------|-----------|
| `warp-flip.ps1` | Rotar IP (método disconnect + connect) |
| `warp-status.ps1` | Ver estado actual con IPv4 e IPv6 |
| `warp-menu.ps1` | Menú interactivo para rotar IP o ver estado |
| `WARP-INFO.md` | Documentación completa |

## Uso

```powershell
cd F:\Proyectos\warp-scripts

# Rotar IP antes de usar OpenCode
.\warp-flip.ps1

# Ver estado actual
.\warp-status.ps1

# Menu interactivo
.\warp-menu.ps1
```

## Instalación

Ver `WARP-INFO.md` para instrucciones detalladas de instalación.

## Requisitos

- Windows 10 o superior
- Cloudflare WARP instalado (via winget)
- PowerShell 5.1 o superior

## Importante

El método correcto para rotar IPs es usar `warp-cli connect/disconnect`, NO el servicio de Windows con `net stop/start`.