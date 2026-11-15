# Cloudflare WARP - Rotacion de IP para OpenCode

## Version
Cloudflare One Client v26.8.2115.0

---

## Instrucciones de instalacion

### 1. Instalar Cloudflare WARP via winget

```powershell
# Ejecutar como administrador
winget install --id Cloudflare.Warp
```

> El instalador aparecerá como "Cloudflare One Client" en el menú de inicio.

### 2. Verificar instalacion

```powershell
# Verificar que el servicio esta instalado
Get-Service "Cloudflare One Client"

# Verificar que warp-cli.exe existe
Test-Path "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
```

### 3. Activar WARP

1. Abrir "Cloudflare One Client" desde el menu de inicio
2. Hacer clic en "Turn On"
3. Seleccionar "Trafico y DNS (TLS)" cuando solicite permiso

### 4. Verificar conexion

```powershell
# Verificar estado
.\warp-status.ps1

# O desde PowerShell
$warpCli = "C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
& $warpCli status
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

## Archivos disponibles

| Archivo | Propósito |
|---------|-----------|
| `warp-flip.ps1` | Rotar IP (disconnect + connect) - Muestra IPv4 e IPv6 |
| `warp-status.ps1` | Ver estado actual con IPv4 e IPv6 |
| `warp-menu.ps1` | Menu interactivo para rotar IP o ver estado |

---

## Uso

```powershell
cd F:\Proyectos\warp-scripts

# Rotar IP (antes de usar OpenCode o cuando te salte rate limit)
.\warp-flip.ps1

# Ver estado actual
.\warp-status.ps1

# Menu interactivo
.\warp-menu.ps1
```

---

## Flujo para OpenCode

1. Ejecutar `.\warp-flip.ps1` -> nueva IP rotada
2. Usar OpenCode normalmente
3. Si te limitan, volver a ejecutar `.\warp-flip.ps1`
4. Repetir hasta terminar sesion

---

## Solucion de problemas

### IP no cambia despues de warp-flip.ps1

En Cloudflare gratuito, puede ser normal que la IP no cambie inmediatamente. Espera unos segundos y vuelve a ejecutar el script.

### WARP no esta instalado

```powershell
# Instalar vía winget
winget install --id Cloudflare.Warp

# O descargar desde:
# https://developers.cloudflare.com/cloudflare-one/connections/client-app/warp/download-guide/
```

### Servidor proxy local no esta escuchando

```powershell
# Verificar puerto 40000
Test-NetConnection -ComputerName localhost -Port 40000
```

### Error "The term 'warp-cli' is not recognized"

Cloudflare WARP no agrega warp-cli al PATH por defecto. Usa siempre la ruta completa:

```powershell
"C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
```

---

## Preguntas frecuentes

### ¿Que hace warp-flip.ps1?

Desconecta y vuelve a conectar WARP, lo que fuerza a Cloudflare asignarte una IP nueva (en el caso de Cloudflare gratuito). También muestra tanto IPv4 como IPv6.

### ¿Por que net stop/start no funciona?

El servicio de Windows `Cloudflare One Client` solo maneja el estado del servicio, no la logica de rotacion de IPs. La rotacion real la maneja el binario `warp-cli.exe` con los comandos `disconnect` y `connect`.

### ¿Cuantas IPs diferentes puedo obtener?

Con Cloudflare gratuito, obtienes IPs de los nodos de Cloudflare (IPv6). La cantidad de IPs unicas depende del nodo y la carga del servidor. En nuestras pruebas, 10 reconexiones produjeron 10 IPs distintas.

### ¿Necesito configurar algo en OpenCode?

**No necesitas configuración adicional** para que la rotación de IP funcione.

Cuando ejecutas `.\warp-flip.ps1`, estás rotando la IP de tu **conexión a internet en nivel de sistema**. Tanto OpenCode como cualquier otra aplicación que use tu conexión directa utilizarán la nueva IP automáticamente.

**Sin embargo**, esto solo funciona cuando:
- OpenCode hace conexiones DIRECTAS a internet
- No estás usando un proxy HTTP/SOCKS configurado en OpenCode
- No estás detrás de un proxy corporativo

**Si OpenCode NO ve la nueva IP:**
1. Verifica que warp esté conectado: `.\warp-status.ps1`
2. Reinicia OpenCode después de rotar IP
3. Si usas proxy explícito, configúralo en OpenCode con la nueva IP