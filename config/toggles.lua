-- anim order = {LEFT, RIGHT, FRONT, BACK}

TOGGLES = {
    {
        title = "🚦 All On",
        echo = false,
        anim = {
            { 1, 1, 1, 1 }
        },
        xenon = false
    },
    {
        title = "🚦 Flip Flop",
        echo = false,
        anim = {
            { 0, 0, 1, 1 },
            { 1, 1, 0, 0 },
        },
        xenon = {1, 0},
    },
    {
        title = "🚦 Edges",
        echo = false,
        anim = {
            { 1, 0, 0, 1 },
            { 0, 1, 1, 0 }
        },
        xenon = {0, 1},
    },
    {
        title = "🚦 Linear",
        echo = false,
        anim = {
            { 0, 0, 0, 1 },
            { 1, 1, 0, 0 },
            { 0, 0, 1, 0 },
        },
        xenon = {0, 0, 1},
    },
    {
        title = "🚦 Linear Reverse",
        echo = false,
        anim = {
            { 0, 0, 1, 0 },
            { 1, 1, 0, 0 },
            { 0, 0, 0, 1 },
        },
        xenon = {1, 0, 0},
    },
    {
        title = "🚦 Linear Echo",
        echo = true,
        anim = {
            { 0, 0, 0, 1 },
            { 1, 1, 0, 0 },
            { 0, 0, 1, 0 },
        },
        xenon = {0, 0, 1},
    },
    {
        title = "🚦 Zig Zag",
        echo = false,
        anim = {
            { 0, 0, 0, 1 },
            { 1, 0, 0, 0 },
            { 0, 1, 0, 0 },
            { 0, 0, 1, 0 },
        },
        xenon = {0, 0, 0, 1},
    },
    {
        title = "🚦 Zig Zag Echo",
        echo = true,
        anim = {
            { 0, 0, 0, 1 },
            { 1, 0, 0, 0 },
            { 0, 1, 0, 0 },
            { 0, 0, 1, 0 },
        },
        xenon = {0, 0, 0, 1}
    },
    {
        title = "🚦 Circle",
        echo = false,
        anim = {
            { 0, 0, 0, 1 },
            { 1, 0, 0, 0 },
            { 0, 0, 1, 0 },
            { 0, 1, 0, 0 },
        },
        xenon = {0, 0, 1, 0}
    },
    {
        title = "🚦 Circle Group",
        echo = false,
        anim = {
            { 1, 0, 0, 1 },
            { 1, 0, 1, 0 },
            { 0, 1, 1, 0 },
            { 0, 1, 0, 1 },
        },
        xenon = {0, 1, 1, 0},
    },
}
