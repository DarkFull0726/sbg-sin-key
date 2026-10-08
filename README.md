# SBG Sin Key

SBG Installer sin verificacion de KEY — funciona 100% local, sin depender de ningun servidor externo, IP ni key.

## Instalacion

```bash
rm -f sbg.sh; curl -H "Cache-Control: no-cache" -sL "https://raw.githubusercontent.com/DarkFull0726/sbg-sin-key/main/sbg_nokey.sh?v=$(date +%s)" -o sbg.sh && chmod +x sbg.sh && bash sbg.sh
```

## Protocolos incluidos

| Protocolo | Estado |
|-----------|--------|
| SSH / OpenVPN | Funciona |
| Xray (VMess, VLess, Trojan, Shadowsocks) | Funciona |
| WebSocket (ws-stunnel) | Funciona |
| UDP Custom | Funciona |
| ZiVPN | Funciona |
| Hysteria (UDPMOD) | Funciona |
| SlowDNS | Funciona |

## Caracteristicas

- Sin verificacion de key ni IP
- Sin dependencia de servidores externos
- Todos los binarios y scripts alojados en este repositorio
- Gestion completa de usuarios y servicios desde el panel

## Uso

Una vez instalado, abre el panel con:

```bash
menu
```
