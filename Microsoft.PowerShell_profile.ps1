# =================================================
#  GENTLEMAN PROFILE (Optimized for Bun & Windows)
# =================================================

# --- 1. CONFIGURACIÓN VISUAL (CEREBRO) ---
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Windows
    
    # GHOST TEXT (Estilo Fish) 👻
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView 

    # COLORES (Tokyo Night) 🎨
    Set-PSReadLineOption -Colors @{
        "Command" = "#7aa2f7"          # Azul
        "Parameter" = "#bb9af7"        # Violeta
        "String" = "#9ece6a"           # Verde
        "InlinePrediction" = "#6c6c6c" # Gris
    }
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# --- 2. INICIALIZAR HERRAMIENTAS ---

# A. ATUIN (El Historial Mágico) 🐢
if (Get-Command atuin -ErrorAction SilentlyContinue) {
    Invoke-Expression (&atuin init powershell | Out-String)
}

# B. ZOXIDE (Navegación inteligente)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
    $env:_ZO_FZF_OPTS = '--height 40% --layout=reverse --border'
}

# C. STARSHIP (Prompt visual)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# --- 3. AUTOCOMPLETADO ZOXIDE ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    $zoxideCompleter = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        $results = zoxide query --list --score $wordToComplete
        $results | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
    Register-ArgumentCompleter -CommandName 'z','zi' -ScriptBlock $zoxideCompleter
}

# =========================================================
#  ALIASES & WORKFLOW (BUN EDITION) ⚡
# =========================================================

# --- 4. BUN SHORTCUTS (Velocidad Pura) ---
function b { bun $args }             # b = bun
function bi { bun install $args }    # bi = install
function bd { bun run dev }          # bd = modo desarrollo (lo más usado)
function br { bun run $args }        # br nombre = correr script
function bx { bunx $args }           # bx = ejecutar paquetes
function bt { bun test }             # bt = test

# --- 5. EDITORES ---
function v { nvim $args }            # Neovim
function vi { nvim $args }
function config { v $PROFILE }       # Editar perfil rápido

# Windsurf (w o ws)
function w { 
    if (Get-Command "windsurf" -ErrorAction SilentlyContinue) {
        windsurf.cmd $args 
    } else {
        Write-Warning "Windsurf no encontrado en el PATH."
    }
}

# Explorador de Windows
function ii { explorer.exe . }

# --- 6. ARCHIVOS Y NAVEGACIÓN ---
# Eza (Listado con iconos)
function l { eza --icons --group-directories-first $args }
function ll { eza -l --icons --group-directories-first --git $args }
function la { eza -la --icons --group-directories-first --git $args }
function tree { eza --tree --icons $args }

# Touch (Crear archivo vacío)
function touch { New-Item -ItemType File -Name $args[0] -Force }

# Navegación
function .. { cd .. }
function ... { cd ../.. }
function .... { cd ../../.. }

# FE: Find & Edit (Busca archivo y abre en Neovim)
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    function fe {
        $file = fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
        if ($file) { v $file }
    }
}

# BAT (Mejor visualización de archivos)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat $args }
}

# SEGURIDAD (Trash en vez de rm)
if (Get-Command trash -ErrorAction SilentlyContinue) {
    function rm { trash $args; Write-Host "🗑️  Enviado a la papelera" -ForegroundColor DarkGray }
}

# --- 7. GIT (KIT GENTLEMAN BLINDADO) ---
# 🛡️ IMPORTANTE: Esto evita que PowerShell use sus propios 'gc' y 'gp'
if (Test-Path alias:gc) { Remove-Item alias:gc -Force }
if (Test-Path alias:gp) { Remove-Item alias:gp -Force }
if (Test-Path alias:gl) { Remove-Item alias:gl -Force }

function g { git $args }
function ga { git add $args }
function gaa { git add . }
function gc { git commit -m $args }
function gs { git status }
function gd { git diff }
function gl { git pull }
function gp { git push }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gb { git branch $args }
function gm { git merge $args }
function glo { git log --oneline --graph --decorate --all }
function lg { lazygit } 

# DELTA (Mejor Diff)
if (Get-Command delta -ErrorAction SilentlyContinue) {
    function diff { delta $args }
}

# GITHUB CLI
if (Get-Command gh -ErrorAction SilentlyContinue) {
    function gweb { gh repo view --web }
    function gpr { gh pr list }
}

# --- 8. UTILIDADES DEL SISTEMA ---
function c { clear }
function q { exit }  # Salir rápido
function reload { . $PROFILE; Write-Host "♻️ Config recargada" -ForegroundColor Green }

# Listar puertos escuchando y qué proceso los usa
function ports {
    Get-NetTCPConnection -State Listen | 
    Select-Object LocalPort, @{N="Process";E={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}}, OwningProcess | 
    Sort-Object LocalPort | 
    Format-Table -AutoSize
}

# KILL PORT (Matar puerto bloqueado)
function kp {
    param([int]$port)
    $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($connection) {
        $pid_num = $connection.OwningProcess
        Stop-Process -Id $pid_num -Force
        Write-Host "💀 Proceso $pid_num en puerto $port eliminado." -ForegroundColor Red
    } else {
        Write-Host "👻 Puerto $port libre." -ForegroundColor Gray
    }
}

# UPDATE ALL (Actualizar todo el sistema)
function update-all {
    Write-Host "📦 Actualizando Scoop..." -ForegroundColor Cyan
    scoop update *
    
    Write-Host "⚡ Actualizando Bun..." -ForegroundColor Cyan
    bun upgrade
    
    Write-Host "编辑器 Actualizando Neovim Plugins..." -ForegroundColor Cyan
    nvim --headless "+Lazy! sync" +qa
    
    Write-Host "✅ Todo actualizado al 100%." -ForegroundColor Green
}

# --- 9. FIN ---
Write-Host "🦾 Ready to code" -ForegroundColor Cyan
