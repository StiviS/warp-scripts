# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-11-15

### Added
- `warp-connect.ps1` - Script para conectar WARP
- `warp-disconnect.ps1` - Script para desconectar WARP
- Documentación completa en README.md con:
  - Instrucciones de instalación paso a paso
  - Descubrimiento clave: método correcto para rotar IPs
  - Flujo recomendado para OpenCode
  - Sección de solución de problemas
  - Preguntas frecuentes
- Referencia al CHANGELOG.md en el README.md

### Changed
- Unificado README.md (antes era README.md y WARP-INFO.md)
- Scripts ahora muestran tanto IPv4 como IPv6
- Mejorado manejo de errores con fallback a api.ipify.org
- Archivos renombrados y organizados correctamente

### Fixed
- Scripts ahora muestran IPv4 e IPv6 de forma clara
- Tiempos de espera optimizados para reconexiones
- Error "The term 'warp-cli' is not recognized" documentado

## [1.0.0] - 2026-11-15

### Added
- `warp-flip.ps1` - Rotar IP (método disconnect + connect)
- `warp-status.ps1` - Ver estado actual con IPv4 e IPv6
- `warp-menu.ps1` - Menú interactivo
- `README.md` - Instrucciones básicas
- `WARP-INFO.md` - Documentación técnica (ahora integrada en README.md)

### Key Discovery
- WARP en modo `warp` (túnel completo) SI rota IPs al reconectar
- Método correcto: `warp-cli disconnect` + `warp-cli connect`
- NO usar: `net stop/start "Cloudflare One Client"`