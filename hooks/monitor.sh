#!/bin/bash
# Pragma Kiro Activity Monitor
# Registra toda la actividad en JSONL para auditoría
EVENT=$(cat)
LOG_DIR="$HOME/.kiro/audit"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(date +%Y-%m-%d).jsonl"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
USER_ID=$(whoami)

# Escribir evento como JSON line
printf '{"ts":"%s","user":"%s","session":"%s","event":%s}\n' \
  "$TIMESTAMP" "$USER_ID" "$KIRO_SESSION_ID" "$EVENT" >> "$LOG_FILE"

exit 0
