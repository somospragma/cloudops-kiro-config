# Pragma Kiro Plugin — Setup Windows
# Ejecutar UNA sola vez en PowerShell como Administrador.
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/somospragma/cloudops-kiro-config.git"
$KiroDir = "$env:LOCALAPPDATA\pragma-kiro-config"

Write-Host "🔧 Instalando Pragma Kiro Plugin..." -ForegroundColor Cyan

# 1. Clonar repo
if (Test-Path "$KiroDir\.git") {
    Set-Location $KiroDir
    git pull --ff-only
} else {
    git clone $RepoUrl $KiroDir
}

# 2. Configurar KIRO_HOME permanentemente
[Environment]::SetEnvironmentVariable("KIRO_HOME", $KiroDir, "User")
$env:KIRO_HOME = $KiroDir

# 3. Task Scheduler: sync cada 5 minutos
$TaskName = "PragmaKiroSync"
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

$Action = New-ScheduledTaskAction -Execute "git" -Argument "pull --ff-only" -WorkingDirectory $KiroDir
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Force | Out-Null

Write-Host "✅ Pragma Kiro Plugin instalado." -ForegroundColor Green
Write-Host "   → KIRO_HOME=$KiroDir"
Write-Host "   → Auto-sync cada 5 minutos (Task Scheduler)"
Write-Host "   → Reinicia tu terminal para aplicar KIRO_HOME"
