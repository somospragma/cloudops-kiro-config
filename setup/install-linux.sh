#!/bin/bash
# Pragma Kiro Plugin — Setup Linux
# Ejecutar UNA sola vez. Después se actualiza automáticamente.
set -e

REPO_URL="https://github.com/somospragma/sopp-plugin-monitoring.git"
KIRO_DIR="$HOME/.pragma-kiro-config"

echo "🔧 Instalando Pragma Kiro Plugin..."

# 1. Clonar repo
if [ -d "$KIRO_DIR/.git" ]; then
  cd "$KIRO_DIR" && git pull --ff-only
else
  git clone "$REPO_URL" "$KIRO_DIR"
fi

# 2. Hacer hooks ejecutables
chmod +x "$KIRO_DIR/hooks/"*.sh

# 3. Configurar KIRO_HOME
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"
grep -q "KIRO_HOME" "$SHELL_RC" 2>/dev/null || echo "export KIRO_HOME=$KIRO_DIR" >> "$SHELL_RC"

# 4. Instalar systemd timer para sync automático
mkdir -p "$HOME/.config/systemd/user"

cat > "$HOME/.config/systemd/user/kiro-sync.service" << EOF
[Unit]
Description=Sync Pragma Kiro Config
[Service]
Type=oneshot
ExecStart=/bin/bash -c 'cd $KIRO_DIR && git pull --ff-only 2>/dev/null'
EOF

cat > "$HOME/.config/systemd/user/kiro-sync.timer" << EOF
[Unit]
Description=Sync Pragma Kiro Config every 5 min
[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now kiro-sync.timer

echo "✅ Pragma Kiro Plugin instalado."
echo "   → KIRO_HOME=$KIRO_DIR"
echo "   → Auto-sync cada 5 minutos (systemd timer)"
echo "   → Reinicia tu terminal o ejecuta: source $SHELL_RC"
