# Cloudflare WARP - Rotador de IP para OpenCode

Scripts de PowerShell para rotar direcciones IP usando Cloudflare WARP.

## Qué hace?

Estos scripts te permiten rotar tu IP pública (IPv4 e IPv6) cuando Cloudflare WARP está instalado en tu sistema. Ideal para evitar rate limits en servicios como OpenCode.

## Archivos

| Archivo | Propósito |
|---------|-----------|
| `warp-flip.ps1` | Rotar IP (método disconnect + connect) |
| `warp-connect.ps1` | Conectar WARP |
| `warp-disconnect.ps1` | Desconectar WARP |
| `warp-status.ps1` | Ver estado actual con IPv4 e IPv6 |
| `warp-menu.ps1` | Menú interactivo para rotar IP o ver estado |

## Uso

```powershell
cd F:\Proyectos\warp-scripts

# Rotar IP antes de usar OpenCode
.\warp-flip.ps1

# Ver estado actual
.\warp-status.ps1

# Conectar/WARP
.\warp-connect.ps1

# Desconectar WARP
.\warp-disconnect.ps1

# Menu interactivo
.\warp-menu.ps1
```

## Version

- **Versión**: 1.1.0
- **Fecha**: 2026-11-15
- **Repositorio**: https://github.com/StiviS/warp-scripts

---

## Instrucciones de instalación

### 1. Instalar Cloudflare WARP via winget

```powershell
winget install --id Cloudflare.Warp
```

> El instalador aparecerá como "Cloudflare One Client" en el menú de inicio.

### 2. Verificar instalación

```powershell
Get-Service "Cloudflare One Client"
Test-Path "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
```

### 3. Activar WARP

1. Abrir "Cloudflare One Client" desde el menu de inicio
2. Hacer clic en "Turn On"
3. Seleccionar "Tráfico y DNS (TLS)" cuando solicite permiso

### 4. Verificar conexión

```powershell
.\warp-status.ps1
```

---

## Descubrimiento clave

WARP en modo **warp** (tunel completo) SI rota IPs al reconectar usando `warp-cli connect/disconnect`.

### Metodo correcto:
```powershell
& "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe" disconnect
Start-Sleep 3
& "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe" connect
```

### NO usar:
`net stop/start "Cloudflare One Client"` -> NO funciona, el servicio no rota IPs.

---

## Flujo para OpenCode

1. Ejecutar `.\warp-flip.ps1` -> nueva IP rotada
2. Usar OpenCode normalmente
3. Si te limitan, volver a ejecutar `.\warp-flip.ps1`
4. Repetir hasta terminar sesión

---

## Solución de problemas

### IP no cambia después de warp-flip.ps1

En Cloudflare gratuito, puede ser normal que la IP no cambie inmediatamente. Espera unos segundos y vuelve a ejecutar el script.

### WARP no esta instalado

```powershell
winget install --id Cloudflare.Warp
```

O descargar desde:
https://developers.cloudflare.com/cloudflare-one/connections/client-app/warp/download-guide/

### Servidor proxy local no esta escuchando

```powershell
Test-NetConnection -ComputerName localhost -Port 40000
```

### Error "The term 'warp-cli' is not recognized"

Cloudflare WARP no agrega warp-cli al PATH por defecto. Usa siempre la ruta completa:

```powershell
"C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
```

---

## Preguntas frecuentes

### ¿Necesito configurar algo en OpenCode?

**No necesitas configuración adicional** para que la rotación de IP funcione.

Cuando ejecutas `.\warp-flip.ps1`, estás rotando la IP de tu **conexión a internet en nivel de sistema**. Tanto OpenCode como cualquier otra aplicación que use tu conexión directa utilizarán la nueva IP automáticamente.

Esto solo funciona cuando:
- OpenCode hace conexiones DIRECTAS a internet
- No estás usando un proxy HTTP/SOCKS configurado en OpenCode
- No estás detrás de un proxy corporativo

**Si OpenCode NO ve la nueva IP:**
1. Verifica que warp esté conectado: `.\warp-status.ps1`
2. Reinicia OpenCode después de rotar IP
3. Si usas proxy explícito, configúralo en OpenCode con la nueva IP

### Qué hace warp-flip.ps1?

Desconecta y vuelve a conectar WARP, lo que fuerza a Cloudflare asignarte una IP nueva. Muestra tanto IPv4 como IPv6.

### Por qué net stop/start no funciona?

El servicio de Windows `Cloudflare One Client` solo maneja el estado del servicio, no la lógica de rotación de IPs. La rotación real la maneja el binario `warp-cli.exe` con los comandos `disconnect` y `connect`.

### Cuantas IPs diferentes puedo obtener?

Con Cloudflare gratuito, obtienes IPs de los nodos de Cloudflare (IPv6). La cantidad de IPs únicas depende del nodo y la carga del servidor. En nuestras pruebas, 10 reconexiones produjeron 10 IPs distintas.

---

## Requisitos

- Windows 10 o superior
- Cloudflare WARP instalado (via winget)
- PowerShell 5.1 o superior

## Importante

El método correcto para rotar IPs es usar `warp-cli connect/disconnect`, NO el servicio de Windows con `net stop/start`.

---

## Changelog

Ver [CHANGELOG.md](CHANGELOG.md) para historial de cambios.