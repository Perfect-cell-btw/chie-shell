-- =========================================================
-- Chie Shell v0.1 - Clean Bootstrap
-- Hyprland 0.56+
-- =========================================================

-- ---------------------------------------------------------
-- Monitor
-- ---------------------------------------------------------

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- ---------------------------------------------------------
-- Input
-- ---------------------------------------------------------

hl.config({
    input = {
        kb_layout = "@KEYBOARD@",
        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- ---------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        layout = "dwindle",

        col = {
            active_border = {
                colors = {
                    "rgba(A8D84EEE)",
                    "rgba(EACF52EE)",
                },
                angle = 45,
            },

            inactive_border = "rgba(30352AAA)",
        },
    },

    decoration = {
        rounding = 10,

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

-- ---------------------------------------------------------
-- Programs
-- ---------------------------------------------------------

local terminal = "@TERMINAL@"
local fileManager = "@FILE_MANAGER@"
local launcher = "rofi -show drun"

-- ---------------------------------------------------------
-- Keybindings
-- ---------------------------------------------------------
-- =========================================================
-- Keybindings
-- =========================================================

local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(launcher))

-- Window actions
hl.bind(mainMod .. " + A", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Focus navigation
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.focus({ direction = "right" }))

-- Mouse move / resize
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
-- ---------------------------------------------------------
-- Autostart
-- ---------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
end)
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

-- Chie Shell power menu
hl.bind("SUPER + SHIFT + E",
    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/powermenu.sh"))

-- Screenshots
hl.bind("SUPER + SHIFT + X",
    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/screenshot-area.sh"))

hl.bind("SUPER + PRINT",
    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/screenshot-full.sh"))

-- =========================================================
-- Workspaces - French AZERTY number row

-- =========================================================
-- Workspaces - French AZERTY
-- =========================================================

local workspace_keys = {
    { key = "@WS1_KEY@", ws = 1 },
    { key = "@WS2_KEY@", ws = 2 },
    { key = "@WS3_KEY@", ws = 3 },
    { key = "@WS4_KEY@", ws = 4 },
    { key = "@WS5_KEY@", ws = 5 },
    { key = "@WS6_KEY@", ws = 6 },
    { key = "@WS7_KEY@", ws = 7 },
    { key = "@WS8_KEY@", ws = 8 },
    { key = "@WS9_KEY@", ws = 9 },
}

for _, item in ipairs(workspace_keys) do
    hl.bind(
        "SUPER + " .. item.key,
        hl.dsp.focus({ workspace = item.ws })
    )

    hl.bind(
        "SUPER + SHIFT + " .. item.key,
        hl.dsp.window.move({ workspace = item.ws })
    )
end

-- Notification center
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t"))

-- Wallpaper picker
hl.bind("SUPER + W",
    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper-picker.sh"))

-- Fullscreen
hl.bind("SUPER + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle"
    })
)

-- Volume keys
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)

-- Kitty: floating terminal window
hl.window_rule({
    match = {
        class = "@TERMINAL_CLASS@"
    },

    float = true,
    center = true,
    size = { 1050, 700 },
    rounding = 14
})
