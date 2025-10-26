local variantColors = {
    solid = function(color)
        return {
            background = color[600],
            textColor = color[25],
            itemColor = color[900],
        }
    end,
    soft = function(color)
        return {
            background = color[900],
            textColor = color[200],
            itemColor = color[700],
        }
    end,
    outlined = function(color)
        return {
            background = color[900],
            textColor = color[700],
            itemColor = color[600],
        }
    end,
    plain = function(color)
        return {
            background = color[800],
            textColor = color[600],
            itemColor = color[700],
        }
    end,
    transparent = function(color)
        return {
            background = '',
            textColor = color[600],
            itemColor = color[800],
        }
    end,
}

function useListVariant(variant, color)
    return variantColors[variant] and variantColors[variant](_G[string.upper(color)]);
end