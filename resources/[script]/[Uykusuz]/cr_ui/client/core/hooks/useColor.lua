AVAILABLE_COLORS = registerEnum({ "purple", "blue", "green", "orange", "red", "gray" })
DEFAULT_COLOR = AVAILABLE_COLORS.PURPLE

function checkColor(color)
    return AVAILABLE_COLORS[string.upper(color)] ~= nil
end

function useColor()
    local colors = {}
    for key, value in pairs(AVAILABLE_COLORS) do
        colors[value] = _G[key]
    end

    return colors
end

function useTheme()
    return {
        BLUE = BLUE,
        GREEN = GREEN,
        ORANGE = ORANGE,
        RED = RED,
        LIGHT = LIGHT,
        GRAY = GRAY,
        PURPLE = PURPLE,
        WHITE = WHITE,
        BLACK = BLACK,
        ORANGE = ORANGE,
        YELLOW = YELLOW,
        WHITEP = WHITEP,
        BACKGROUND = BACKGROUND,
        FULL_OPACITY = FULL_OPACITY,
        DEFAULT_RADIUS = DEFAULT_RADIUS,
    }
end