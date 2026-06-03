# SOPP Plugin Monitoring — Kiro Config Corporativo

Configuración centralizada de Kiro CLI para el equipo CloudOps de Pragma. Se instala una vez y se actualiza automáticamente.

## ¿Qué incluye?

| Componente | Descripción |
|------------|-------------|
| **Agent** | `pragma` — agent con monitoreo de actividad y MCPs preconfigurados |
| **MCPs** | Datadog, Terraform, AWS Docs, Pragma Local |
| **Hooks** | Auditoría JSONL de toda la actividad (prompts, tools, respuestas) |
| **Steering** | Reglas de seguridad, tagging SOPP, convenciones de equipo |
| **Skills** | AWS Infrastructure, Terraform, Kubernetes (EKS) |

## Instalación (una sola vez)

### macOS
```bash
curl -sSL https://raw.githubusercontent.com/somospragma/cloudops-kiro-config/main/setup/install-macos.sh | bash
```

### Linux
```bash
curl -sSL https://raw.githubusercontent.com/somospragma/cloudops-kiro-config/main/setup/install-linux.sh | bash
```

### Windows (PowerShell Admin)
```powershell
irm https://raw.githubusercontent.com/somospragma/cloudops-kiro-config/main/setup/install-windows.ps1 | iex
```

## ¿Cómo funciona?

1. El script clona este repo en una ruta local
2. Configura `KIRO_HOME` para apuntar a esa ruta
3. Instala un sync automático cada 5 minutos (LaunchAgent/systemd/Task Scheduler)
4. Kiro CLI usa esta configuración como su directorio global

**Resultado**: Cada vez que abren Kiro, usan el agent `pragma` con monitoreo activo y reglas del equipo.

## Actualización

Las actualizaciones son automáticas. Push a `main` → en máximo 5 minutos todos los usuarios tienen la nueva versión.

Para forzar actualización inmediata:
```bash
cd $KIRO_HOME && git pull
```

## Estructura

```
├── agents/pragma.json         ← Agent con MCPs, hooks, tools
├── hooks/monitor.sh           ← Script de auditoría JSONL
├── settings/cli.json          ← Settings globales (default agent)
├── steering/
│   ├── security-rules.md      ← Políticas de seguridad
│   ├── tagging.md             ← Tags obligatorios SOPP
│   └── conventions.md         ← Convenciones del equipo
├── skills/
│   ├── aws-infrastructure/    ← Guía AWS
│   ├── terraform/             ← Guía Terraform
│   └── kubernetes/            ← Guía EKS/K8s
├── prompts/pragma-system.txt  ← Prompt del sistema
└── setup/
    ├── install-macos.sh
    ├── install-linux.sh
    └── install-windows.ps1
```

## Logs de auditoría

Los logs se guardan en `~/.kiro/audit/YYYY-MM-DD.jsonl` de cada usuario:

```json
{"ts":"2026-06-03T17:30:00Z","user":"cristian.noguera","session":"uuid","event":{...}}
```

## Requisitos previos

- Kiro CLI instalado
- Git instalado
- Para Datadog MCP: variables `DD_API_KEY` y `DD_APP_KEY` en el environment

## Desinstalación

```bash
# macOS
launchctl unload ~/Library/LaunchAgents/com.pragma.kiro-sync.plist
rm ~/Library/LaunchAgents/com.pragma.kiro-sync.plist
sudo rm -rf /opt/pragma/kiro-config
# Remover la línea KIRO_HOME de ~/.zshrc

# Linux
systemctl --user disable --now kiro-sync.timer
rm ~/.config/systemd/user/kiro-sync.*
rm -rf ~/.pragma-kiro-config
# Remover la línea KIRO_HOME de ~/.bashrc
```
