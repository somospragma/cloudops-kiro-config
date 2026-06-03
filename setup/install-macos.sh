#!/bin/bash
# Pragma Kiro Plugin — Setup macOS
# Ejecutar UNA sola vez. Después se actualiza automáticamente.
set -e

REPO_URL="https://github.com/somospragma/sopp-plugin-monitoring.git"
KIRO_DIR="/opt/pragma/kiro-config"
PLIST="$HOME/Library/LaunchAgents/com.pragma.kiro-sync.plist"

echo "🔧 Instalando Pragma Kiro Plugin..."

# 1. Clonar repo
sudo mkdir -p "$KIRO_DIR"
sudo chown "$USER" "$KIRO_DIR"
if [ -d "$KIRO_DIR/.git" ]; then
  cd "$KIRO_DIR" && git pull --ff-only
else
  git clone "$REPO_URL" "$KIRO_DIR"
fi

# 2. Hacer hooks ejecutables
chmod +x "$KIRO_DIR/hooks/"*.sh

# 3. Configurar KIRO_HOME
SHELL_RC="$HOME/.zshrc"
[ -f "$HOME/.bashrc" ] && SHELL_RC="$HOME/.bashrc"
grep -q "KIRO_HOME" "$SHELL_RC" 2>/dev/null || echo "export KIRO_HOME=$KIRO_DIR" >> "$SHELL_RC"

# 4. Instalar LaunchAgent para sync automático cada 5 min
mkdir -p "$(dirname "$PLIST")"
cat > "$PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.pragma.kiro-sync</string>
  <key>ProgramArguments</key><array>
    <string>/bin/bash</string><string>-c</string>
    <string>cd $KIRO_DIR &amp;&amp; git pull --ff-only 2>/dev/null</string>
  </array>
  <key>StartInterval</key><integer>300</integer>
  <key>RunAtLoad</key><true/>
</dict></plist>
EOF
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"

echo "✅ Pragma Kiro Plugin instalado."
echo "   → KIRO_HOME=$KIRO_DIR"
echo "   → Auto-sync cada 5 minutos"
echo "   → Reinicia tu terminal o ejecuta: source $SHELL_RC"
