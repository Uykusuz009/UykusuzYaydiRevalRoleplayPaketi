Input = {}
Input.alias = "input"
Input.initialOptions = {
    position = { x = 0, y = 0 },
    size = { x = 100, y = 20 },

    name = nil,
    regex = nil,

    label = nil,
    placeholder = nil,
    value = nil,
    helperText = {
        text = nil,
        color = nil,
    },

    startIcon = nil,

    variant = "soft",

    disabled = false,
    maxLength = false,

    mask = false,
}
Input.iconColor = "#868695"
Input.enums = {}
Input.enums.variant = {
    solid = "solid",
    soft = "soft",
    outlined = "outlined",
}
Input.defaultColor = "gray"
Input.variants = {
    [Input.enums.variant.solid] = {
        default = {
            background = 800,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        hover = {
            background = 600,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        click = {
            background = 800,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        disabled = {
            background = 300,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
    },
    [Input.enums.variant.soft] = {
        default = {
            background = 600,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        hover = {
            background = 500,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        click = {
            background = 600,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        disabled = {
            background = 300,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
    },
    [Input.enums.variant.outlined] = {
        default = {
            background = 50,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        hover = {
            background = 50,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        click = {
            background = 50,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
        disabled = {
            background = 50,
            lines = 600,
            text = {
                color = 50,
                placeholder = 500,
            }
        },
    },
}

Input.render = function(options, store)
    local position = options.position or Input.initialOptions.position
    local size = options.size or Input.initialOptions.size

    local name = options.name
    if not name then
        return
    end

    local regex = options.regex

    local label = options.label or Input.initialOptions.label
    local placeholder = options.placeholder or Input.initialOptions.placeholder
    local value = options.value or Input.initialOptions.value

    local helperText = options.helperText or Input.initialOptions.helperText

    local startIcon = options.startIcon

    local variant = options.variant or Input.initialOptions.variant

    local disabled = options.disabled

    local maxLength = options.maxLength or Input.initialOptions.maxLength

    local mask = options.mask

    local inputData = store.get(name)
    if not inputData then
        local guiElement = GuiEdit(-1, -1, 1, 1, value or "", false)

        if regex then
            guiElement:setProperty("ValidationString", regex)
        end

        addEventHandler("onClientGUIFocus", guiElement, function()
            store.set("currentInput", name)
        end)

        guiElement:setAlpha(0)
        guiElement:setMaxLength(maxLength or math.ceil(size.x / 9))

        store.set(name, {
            guiElement = guiElement,
        })
        inputData = store.get(name)
    end

    local input = inputData.guiElement
    local isInputFocused = store.get("currentInput") == name

    local colorData = Input.variants[variant]
    local defaultPalette = colorData.default
    local hoverPalette = colorData.hover
    local clickPalette = colorData.click
    local disabledPalette = colorData.disabled

    local hover = not disabled and inArea(position.x, position.y, size.x, size.y)
    local pressed = hover and isMouseClicked()

    local currentPalette = disabled and disabledPalette or pressed and clickPalette or defaultPalette

    if not Input.defaultFont then
        Input.defaultFont = fontElements.UbuntuRegular.caption
    end

    if hover then
        exports.rl_cursor:setCursor("all", "ibeam")

        if pressed then
            input:setCaretIndex(string.len(input.text))
            store.set("currentInput", name)
            guiSetInputEnabled(true)
            input:focus()
            input:bringToFront()
        end
    elseif isInputFocused and isMouseClicked() then
        store.set("currentInput", nil)
        guiSetInputEnabled(false)
        input:blur()
    end

    if label then
        dxDrawText(label,
                position.x,
                position.y - 20,
                0,
                0,
                rgba(COLORS_BY_NAME[Input.defaultColor][currentPalette.text.color], 1),
                1,
                Input.defaultFont,
                "left",
                "top"
        )
    end

    if variant ~= "plain" then
        if variant ~= "outlined" then
            dxDrawRectangle(position.x, position.y, size.x, size.y, rgba(COLORS_BY_NAME[Input.defaultColor][currentPalette.background], 1), postGUI)
        end

        local linesR, linesG, linesB = rgbaUnpack(COLORS_BY_NAME[Input.defaultColor][currentPalette.lines], 1)

        dxDrawGradient(position.x, position.y, size.x, 1, linesR, linesG, linesB, 255, false, true, postGUI)
        dxDrawGradient(position.x, position.y, 1, size.y, linesR, linesG, linesB, 255, true, true, postGUI)

        dxDrawGradient(position.x - 1, position.y + size.y, size.x, 1, linesR, linesG, linesB, 255, false, false, postGUI)
        dxDrawGradient(position.x + size.x - 1, position.y, 1, size.y, linesR, linesG, linesB, 255, true, false, postGUI)
    end

    local gap = size.x / size.y + 4

    if startIcon then
        dxDrawText(startIcon,
                position.x + gap,
                position.y,
                0,
                size.y + position.y,
                rgba(Input.iconColor, 1),
                0.5,
                fontElements.icon,
                "left",
                "center"
        )
        gap = gap + 24
    end

    if helperText.text and helperText.text ~= "" then
        dxDrawText(helperText.text,
                position.x,
                position.y + size.y + 5,
                0,
                0,
                rgba(helperText.color or COLORS_BY_NAME[Input.defaultColor][currentPalette.text.color], 1),
                1,
                fontElements.UbuntuRegular.caption,
                "left",
                "top"
        )
    end

    local value = input.text

    if not value or value == "" then
        if placeholder then
            dxDrawText(placeholder,
                    position.x + gap,
                    position.y,
                    0,
                    size.y + position.y,
                    rgba(COLORS_BY_NAME[Input.defaultColor][currentPalette.text.placeholder], 1),
                    1,
                    Input.defaultFont,
                    "left",
                    "center"
            )
        end
    else
        dxDrawText(mask and string.rep("*", #value) or value,
                position.x + gap,
                position.y,
                0,
                size.y + position.y,
                rgba(COLORS_BY_NAME[Input.defaultColor][currentPalette.text.color], 1),
                1,
                Input.defaultFont,
                "left",
                "center"
        )
    end

    if isInputFocused then
        local textWidth = dxGetTextWidth(input.text, 1, Input.defaultFont)
        local cursorPosition = position.x + textWidth
        local opacity = math.abs(math.sin(getTickCount() / 500))

        dxDrawLine(cursorPosition + gap + 2,
                position.y + (size.y / 4),
                cursorPosition + gap + 2,
                position.y + size.y - (size.y / 4),
                rgba(COLORS_BY_NAME[Input.defaultColor][currentPalette.text.color], opacity),
                1.5)

        if regex and string.len(value) <= 1 then
            if getKeyState("backspace") and lastClick + 200 <= getTickCount() then
                lastClick = getTickCount()
                guiSetText(input, "")
            end
        end
    end

    return {
        focus = isInputFocused,
        value = input.text,
        input = input,
    }
end
createComponent(Input.alias, Input.initialOptions, Input.render)

function drawInput(options)
    return components[Input.alias].render(options)
end