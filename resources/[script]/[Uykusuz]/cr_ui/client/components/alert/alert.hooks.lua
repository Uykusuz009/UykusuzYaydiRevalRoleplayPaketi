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
            disabled = {
                background = color[300],
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
            disabled = {
                background = color[900],
                textColor = color[800],
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
            disabled = {
                background = color[300],
                textColor = color[50],
            },
        }
    end,
    plain = function(color)
        return {
            background = FULL_OPACITY,
            textColor = color[200],
            placeholderColor = color[700],
            hover = {
                background = FULL_OPACITY,
                textColor = color[700],
            },
            click = {
                background = FULL_OPACITY,
                textColor = color[800],
            },
            disabled = {
                background = FULL_OPACITY,
                textColor = color[50],
            },
        }
    end,
}

function useAlertVariant(variant, color)
    return variantColors[variant] and variantColors[variant](_G[string.upper(color)]);
end