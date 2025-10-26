local variantColors = {
    solid = function(color)
        return {
            background = color[600],
            textColor = color[50],
            hover = color[800]
        }
    end,
    soft = function(color)
        return {
            background = color[800],
            textColor = color[200],
            hover = color[700]
        }
    end,
    outlined = function(color)
        return {
            background = color[800],
            textColor = color[500],
            hover = color[700]
        }
    end,
    plain = function(color)
        return {
            background = FULL_OPACITY,
            textColor = color[200],
            hover = color[700]
        }
    end
}

function useCheckboxVariant(variant, color)
    return variantColors[variant] and variantColors[variant](_G[string.upper(color)]);
end