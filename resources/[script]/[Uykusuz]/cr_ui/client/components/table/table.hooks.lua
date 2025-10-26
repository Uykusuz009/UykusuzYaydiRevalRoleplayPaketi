local variantColors = {
    solid = function(color)
        return {
            background = color[600],
            textColor = color[25],
            header = color[700],
            tab = color[900],
            active = {
                background = color[500],
                textColor = color[50],
                header = color[700],
            },
            disabled = {
                background = color[900],
                textColor = color[700],
            }
        }
    end,
    soft = function(color)
        return {
            background = color[900],
            textColor = color[200],
            header = color[900],
            tab = color[900],
            active = {
                background = color[700],
                textColor = color[300],
                header = color[700]
            },
            disabled = {
                background = color[900],
                textColor = color[700],
            }
        }
    end,
    outlined = function(color)
        return {
            background = color[900],
            textColor = color[700],
            header = color[700],
            tab = color[900],
            active = {
                background = color[800],
                textColor = color[200],
                header = color[700],
            },
            disabled = {
                background = color[900],
                textColor = color[700],
            }
        }
    end,
    plain = function(color)
        return {
            background = color[900],
            textColor = color[600],
            header = color[700],
            tab = color[900],
            active = {
                background = color[700],
                textColor = color[300],
                header = color[700],
            },
            disabled = {
                background = color[900],
                textColor = color[700],
            }
        }
    end,
}

function useTableTheme(variant, color)
    return variantColors[variant] and variantColors[variant](_G[string.upper(color)]);
end