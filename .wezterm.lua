local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- ESTA LÍNEA ES LA CLAVE: Define PowerShell 7 como default
config.default_prog = { "pwsh.exe" }

-- Configuraciones estéticas
config.color_scheme = "Tokyo Night"
config.window_decorations = "RESIZE"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12.0

-- =========================================================
-- BARRA SUPERIOR ESTILO GENTLEMAN (Fancy Tab Bar) 🎩
-- =========================================================

-- 1. Activar la barra de pestañas y quitar la barra de título de Windows
config.use_fancy_tab_bar = false -- Desactivamos la "fancy" por defecto para hacer la nuestra propia más pro
config.tab_bar_at_bottom = false -- La queremos arriba
config.hide_tab_bar_if_only_one_tab = false -- Siempre visible

-- Quitamos los bordes feos de Windows
config.window_decorations = "RESIZE"

-- 2. Colores de la Barra (Tokyo Night)
config.colors = {
	tab_bar = {
		background = "#1a1b26", -- Fondo oscuro

		-- La pestaña activa (Donde estás ahora)
		active_tab = {
			bg_color = "#7aa2f7", -- Azul brillante
			fg_color = "#1a1b26", -- Letra oscura
			intensity = "Bold",
		},

		-- Las pestañas inactivas
		inactive_tab = {
			bg_color = "#292e42", -- Gris azulado
			fg_color = "#c0caf5", -- Letra clara
		},

		-- El botón de "Nueva Pestaña" (+)
		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#7aa2f7",
		},
	},
}

-- =========================================================
-- TMUX WORKFLOW (Atajos de Teclado) ⚡
-- =========================================================

-- Definir la "Leader Key" (Gatillo): Ctrl + A
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- A. DIVIDIR PANTALLA (Splits)
	-- Ctrl+A -> % (Vertical)
	{
		mods = "LEADER|SHIFT",
		key = "%",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Ctrl+A -> " (Horizontal)
	{
		mods = "LEADER|SHIFT",
		key = '"',
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- B. NAVEGACIÓN (Vim Style)
	-- Ctrl+A -> h/j/k/l
	{ mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
	{ mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
	{ mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
	{ mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection("Down") },

	-- C. PESTAÑAS
	-- Ctrl+A -> c (Crear)
	{ mods = "LEADER", key = "c", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	-- Ctrl+A -> n/p (Siguiente/Anterior)
	{ mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },
	{ mods = "LEADER", key = "p", action = wezterm.action.ActivateTabRelative(-1) },

	-- D. CERRAR PANEL
	-- Ctrl+A -> x
	{ mods = "LEADER", key = "x", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- E. ZOOM (Maximizar panel)
	-- Ctrl+A -> z
	{ mods = "LEADER", key = "z", action = wezterm.action.TogglePaneZoomState },
}

-- 3. EL TRUCO: Información a la derecha (Hora, Usuario, etc)
-- Esto simula los stats de CPU/RAM de Tmux (pero native en WezTerm)
wezterm.on("update-right-status", function(window, pane)
	local date = wezterm.strftime("%H:%M ")

	-- Colores para la sección derecha
	local color_date = "#bb9af7" -- Violeta
	local color_bg = "#1a1b26" -- Fondo

	-- Formato del texto (Powerline style)
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = color_date } },
		{ Background = { Color = color_bg } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = " ⌚ " .. date }, -- Icono de reloj + hora
	}))
end)

-- =========================================================
-- CURSOR GENTLEMAN (Smooth & Violet) 🟣
-- =========================================================

-- 1. Estilo y Forma
config.default_cursor_style = "BlinkingBlock"

-- 2. La "Respiración" (Breathing Effect)
-- En lugar de "Constant" (golpe seco), usamos "EaseInOut"
-- Esto hace que el color se desvanezca suavemente.
config.cursor_blink_ease_in = "EaseIn"
config.cursor_blink_ease_out = "EaseOut"
config.cursor_blink_rate = 800 -- Velocidad del ciclo (ms)

-- 3. FPS (Frames por segundo)
-- Subimos a 60 para que la animación se vea fluida como mantequilla
config.animation_fps = 60

-- 4. COLORES PERSONALIZADOS
-- Aquí definimos ese color Violeta/Magenta característico
config.colors = {
	-- El color del bloque (Violeta Tokyo Night)
	cursor_bg = "#bb9af7",

	-- El color de la letra DENTRO del cursor (Negro para contraste)
	cursor_fg = "#1a1b26",

	-- El borde (mismo color para efecto neon sólido)
	cursor_border = "#bb9af7",
}

-- 5. Comportamiento en Neovim
config.force_reverse_video_cursor = true

return config
