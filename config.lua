CONFIG = {}

--[[TOOD

    Check if player is in car
    Add Exports

]]

-- Move to a file
LOCALE = {}
LOCALE.menu_title = "DE UNDERGLOW"
LOCALE.menu_subtitle = "v1.0.0"
LOCALE.main_script = "⚙ Enable Effects"
LOCALE.toggle_neons = "⚙ Enable Neons" -- install all neons on current car
LOCALE.effects_menu_title = "🎨 Color Effects"
LOCALE.effects_menu_subtitle = "Color Effects"
LOCALE.toggles_menu_title = "🚦 Toggle Effects"
LOCALE.toggles_menu_subtitle = "Toggle Effects"

-- Move to a file
CONFIG.MENU_STYLE = {
	x = 0.0175,
	y = 0.025,
	width = 0.23,
	maxOptionCountOnScreen = 10,
	titleColor = { 0, 0, 0, 255 },
	titleBackgroundColor = { 245, 127, 23, 255 },
	titleBackgroundSprite = nil,
	subTitleColor = { 245, 127, 23, 255 },
	textColor = { 254, 254, 254, 255 },
	subTextColor = { 189, 189, 189, 255 },
	focusTextColor = { 0, 0, 0, 255 },
	focusColor = { 245, 245, 245, 255 },
	backgroundColor = { 0, 0, 0, 160 },
	subTitleBackgroundColor = { 0, 0, 0, 255 },
	buttonPressedSound = { name = 'SELECT', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' }, --https://pastebin.com/0neZdsZ5
}

CONFIG.COLORS = {
    {
        title = "🎨 Custom STEP",
        type = "step",
        input = true, -- Let the user to pick a color (it works only for the first one in the list)
        colors = {
            {255, 0, 0},
        }
    },
    {
        title = "🎨 Custom BREATH",
        type = "breath",
        input = true, -- Let the user to pick a color (it works only for the first one in the list)
        colors = {
            {255, 255, 255},
        }
    },
    {
        title = "🎨 Blue STEP",
        type = "step",
        colors = {
            {0, 0, 255},
        }
    },
    {
        title = "🎨 Blue & Red STEP",
        type = "step",
        colors = {
            {0, 0, 255},
            {255, 0, 0},
        }
    },
    {
        title = "🎨 7 Colors STEP",
        type = "step",
        colors = {
            {255, 0, 0},
            {255, 255, 0},
            {255, 0, 255},
            {0, 255, 0},
            {255, 255, 0},
            {0, 255, 255},
            {0, 0, 255},
        }
    },
    {
        title = "🎨 Blue BREATH",
        type = "breath",
        colors = {
            {0, 0, 255},
        },
    },
    {
        title = "🎨 3 Colors BREATH",
        type = "breath",
        colors = {
            {255, 1, 1},
            {1, 255, 1},
            {1, 1, 255},
        },
    },
}

-- anim: {LEFT, RIGHT, FRONT, BACK}
CONFIG.TOGGLES = {
    {
        title = "🚦 All Static",
        echo = false,
        anim = {
            {1, 1, 1, 1}
        }
    },
    {
        title = "🚦 Flip Flop",
        echo = false,
        anim = {
            {0, 0, 1, 1},
            {1, 1, 0, 0}
        }
    },
    {
        title = "🚦 Edges",
        echo = false,
        anim = {
            {1, 0, 0, 1},
            {0, 1, 1, 0}
        }
    },
    {
        title = "🚦 Linear",
        echo = false,
        anim = {
            {0, 0, 0, 1},
            {1, 1, 0, 0},
            {0, 0, 1, 0},
        }
    },
    {
        title = "🚦 Linear Reverse",
        echo = false,
        anim = {
            {0, 0, 1, 0},
            {1, 1, 0, 0},
            {0, 0, 0, 1},
        }
    },
    {
        title = "🚦 Linear Echo",
        echo = true,
        anim = {
            {0, 0, 0, 1},
            {1, 1, 0, 0},
            {0, 0, 1, 0},
        }
    },
    {
        title = "🚦 Zig Zag",
        echo = false,
        anim = {
            {0, 0, 0, 1},
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
        }
    },
    {
        title = "🚦 Zig Zag Echo",
        echo = true,
        anim = {
            {0, 0, 0, 1},
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
        }
    },
    {
        title = "🚦 Circle",
        echo = false,
        anim = {
            {0, 0, 0, 1},
            {1, 0, 0, 0},
            {0, 0, 1, 0},
            {0, 1, 0, 0},
        }
    },
    {
        title = "🚦 Circle Group",
        echo = false,
        anim = {
            {1, 0, 0, 1},
            {1, 0, 1, 0},
            {0, 1, 1, 0},
            {0, 1, 0, 1},
        }
    }
}
