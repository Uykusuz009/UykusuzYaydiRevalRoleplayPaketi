local variantColors = {
    solid = function(color)
        return {
            background = color[600],
            textColor = color[50],
            placeholderColor = color[700],
            hover = {
                background = color[700],
                textColor = color[50],
            },
            click = {
                background = color[800],
                textColor = color[50],
            },
        }
    end,
    soft = function(color)
        return {
            background = color[900],
            textColor = color[200],
            placeholderColor = color[700],
            hover = {
                background = color[800],
                textColor = color[200],
            },
            click = {
                background = color[700],
                textColor = color[200],
            },
        }
    end,
    outlined = function(color)
        return {
            background = color[700],
            textColor = color[200],
            placeholderColor = color[700],
            hover = {
                background = color[600],
                textColor = color[200],
            },
            click = {
                background = color[500],
                textColor = color[200],
            },
        }
    end,
    plain = function(color)
        return {
            background = FULL_OPACITY,
            textColor = color[600],
            placeholderColor = color[700],
            hover = {
                background = FULL_OPACITY,
                textColor = color[700],
            },
            click = {
                background = FULL_OPACITY,
                textColor = color[800],
            },
        }
    end,
}

function useRadioGroupVariant(variant, color)
    return variantColors[variant] and variantColors[variant](_G[string.upper(color)]);
end