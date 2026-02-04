# ==========================================
#  🎩 SETUP DOTFILES INSTALLER
#
# ==========================================

# Requiere ejecutar como Administrador

Write-Host "🚀 Iniciando configuración..." -ForegroundColor Cyan

# 1. WezTerm Link
$wez_source = "$env:USERPROFILE\dotfiles\.wezterm.lua"
$wez_dest = "$env:USERPROFILE\.wezterm.lua"

if (Test-Path $wez_dest) { Remove-Item $wez_dest -Force }
cmd /c mklink "$wez_dest" "$wez_source"

# 2. PowerShell Profile Link
$ps_source = "$env:USERPROFILE\dotfiles\Microsoft.PowerShell_profile.ps1"
$ps_dest = $PROFILE

# Crear carpeta si no existe (vital en PCs nuevas)
$parent = Split-Path $ps_dest
if (!(Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force }

if (Test-Path $ps_dest) { Remove-Item $ps_dest -Force }
cmd /c mklink "$ps_dest" "$ps_source"

Write-Host "✅ ¡Instalación completada! Reinicia la terminal." -ForegroundColor Green
