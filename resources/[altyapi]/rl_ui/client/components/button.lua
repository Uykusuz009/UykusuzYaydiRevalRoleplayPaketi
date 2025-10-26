Button = {}
Button.alias = "button"
Button.initialOptions = {
    position = {
        x = 0,
        y = 0,
    },
    size = {
        x = 0,
        y = 0,
    },

    textProperties = {
        align = "center",
        color = nil,
        font = fontElements.UbuntuRegular.caption,
        scale = 1,
    },

    variant = "soft",
    color = "blue",
    disabled = false,

    text = "",

    postGUI = false
}
Button.enums = {}
Button.enums.variant = {
    solid = "solid",
    soft = "soft",
    outlined = "outlined",
    plain = "plain",
	rounded = "rounded",
}
Button.variants = {
    [Button.enums.variant.solid] = {
        default = {
            background = 800,
            foreground = 50,
            lines = 200
        },
        hover = {
            background = 600,
            foreground = 50,
            lines = 200
        },
        click = {
            background = 800,
            foreground = 50,
            lines = 200
        },
        disabled = {
            background = 300,
            foreground = 50,
            lines = 200
        },
    },
    [Button.enums.variant.soft] = {
        default = {
            background = 600,
            foreground = 200,
            lines = 200
        },
        hover = {
            background = 700,
            foreground = 200,
            lines = 200
        },
        click = {
            background = 700,
            foreground = 200,
            lines = 200
        },
        disabled = {
            background = 900,
            foreground = 800,
            lines = 200
        },
    },
	[Button.enums.variant.rounded] = {
        default = {
            background = 800,
            foreground = 50,
            lines = 200
        },
        hover = {
            background = 600,
            foreground = 50,
            lines = 200
        },
        click = {
            background = 800,
            foreground = 50,
            lines = 200
        },
        disabled = {
            background = 300,
            foreground = 50,
            lines = 200
        },
    },
    [Button.enums.variant.outlined] = {
        default = {
            background = 700,
            foreground = 200,
            lines = 200
        },
        hover = {
            background = 600,
            foreground = 200,
            lines = 500
        },
        click = {
            background = 500,
            foreground = 200,
            lines = 200
        },
        disabled = {
            background = 300,
            foreground = 50,
            lines = 200
        },
    },
    [Button.enums.variant.plain] = {
        default = {
            background = 50,
            foreground = 50,
            lines = 200
        },
        hover = {
            background = 50,
            foreground = 200,
            lines = 200
        },
        click = {
            background = 50,
            foreground = 700,
            lines = 200
        },
        disabled = {
            background = 50,
            foreground = 50,
            lines = 200
        },
    },
}

Button.render = function(options)
    local position = options.position or Button.initialOptions.position
    local size = options.size or Button.initialOptions.size

    local textProperties = options.textProperties or Button.initialOptions.textProperties
    local align = textProperties.align or Button.initialOptions.textProperties.align
    local textColor = textProperties.color or Button.initialOptions.textProperties.color
    local font = textProperties.font or Button.initialOptions.textProperties.color
    local scale = textProperties.scale or Button.initialOptions.textProperties.scale

    local variant = options.variant or Button.initialOptions.variant
    local color = options.color or Button.initialOptions.color
    local disabled = options.disabled or Button.initialOptions.disabled
	
	local alpha = options.alpha or 255

    local text = options.text or Button.initialOptions.text

    local postGUI = options.postGUI

    local colorData = Button.variants[variant]
    local defaultPalette = colorData.default
    local hoverPalette = colorData.hover
    local clickPalette = colorData.click
    local disabledPalette = colorData.disabled

    local hover = not disabled and inArea(position.x, position.y, size.x, size.y)
    local pressed = hover and isMouseClicked()

    local currentPalette = disabled and disabledPalette or pressed and clickPalette or hover and hoverPalette or defaultPalette

    if hover then
        exports.rl_cursor:setCursor("all", "pointinghand")
    end
	if variant == 'rounded' then
		drawRoundedRectangle({
			position = {
				x = position.x,
				y = position.y
			},
		
			size = {
				x = size.x,
				y = size.y
			},
		
			color = COLORS_BY_NAME[color][currentPalette.background],
		
			radius = 6,
		
			postGUI = postGUI,
			
			alpha = alpha or 255,
		})
    elseif variant ~= "plain" then
        if variant ~= "outlined" then
            dxDrawRectangle(position.x, position.y, size.x, size.y, rgba(COLORS_BY_NAME[color][currentPalette.background], 1), postGUI)
        end

        local linesR, linesG, linesB = rgbaUnpack(COLORS_BY_NAME[color][currentPalette.lines], 1)

       -- dxDrawGradient(position.x, position.y, size.x, 1, linesR, linesG, linesB, 255, false, true, postGUI)
       -- dxDrawGradient(position.x, position.y, 1, size.y, linesR, linesG, linesB, 255, true, true, postGUI)

       -- dxDrawGradient(position.x - 1, position.y + size.y, size.x, 1, linesR, linesG, linesB, 255, false, false, postGUI)
       -- dxDrawGradient(position.x + size.x - 1, position.y, 1, size.y, linesR, linesG, linesB, 255, true, false, postGUI)
    end
    dxDrawText(text, position.x, position.y, size.x + position.x, size.y + position.y, rgba(textColor or COLORS_BY_NAME[color][currentPalette.foreground], 1), scale, font, align, "center", false, false, postGUI, true)

    return {
        hover = hover,
        pressed = pressed,
    }
end

createComponent(Button.alias, Button.initialOptions, Button.render)

function drawButton(options)
    return components[Button.alias].render(options)
end