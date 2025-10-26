local INITIAL_CHECKBOX_OPTIONS = {
    position = {},
    size = 24,

    name = "defaultCheckbox",
    disabled = false,
    text = "",
    helperText = {
        text = "",
        color = GRAY[200],
    },

    variant = DEFAULT_VARIANT,
    color = DEFAULT_COLOR,

    checked = 0,
}

createComponent("checkbox", INITIAL_CHECKBOX_OPTIONS, function(options, store)
    local position = options.position or initialPosition
    local size = options.size or INITIAL_CHECKBOX_OPTIONS.size

    local name = options.name
    if not name then
        return
    end

    local disabled = options.disabled or INITIAL_CHECKBOX_OPTIONS.disabled
    local text = options.text or INITIAL_CHECKBOX_OPTIONS.text
    local helperText = options.helperText or INITIAL_CHECKBOX_OPTIONS.helperText

    local variant = options.variant or INITIAL_CHECKBOX_OPTIONS.variant
    local color = options.color or INITIAL_CHECKBOX_OPTIONS.color

    local defaultChecked = options.checked

    local fonts = useFonts()

    local checkbox = store.get(name)
    local checkboxColor = useCheckboxVariant(variant, color)

    if not checkbox then
        store.set(name, {
            checked = defaultChecked,
            textWidth = dxGetTextWidth(text, 1, fonts.caption.regular),
        })

        checkbox = store.get(name)
    end

    local checked = checkbox.checked == true or checkbox.checked == 1
    local textWidth = checkbox.textWidth or 0

    local hover = inArea(position.x, position.y, size + textWidth, size)
    local pressed = false

    checkboxColor.background = hover and checkboxColor.hover or checkboxColor.background

    if variant == AVAILABLE_VARIANTS.OUTLINED then
        drawRoundedRectangle({
            position = position,
            size = {
                x = size,
                y = size
            },
            radius = 5,
            color = checkboxColor.textColor,
        })
        drawRoundedRectangle({
            position = {
                x = position.x + 1,
                y = position.y + 1,
            },
            size = {
                x = size - 2,
                y = size - 2
            },
            radius = 4,
            color = checkboxColor.background,
        })
    else
        drawRoundedRectangle({
            position = position,
            size = {
                x = size,
                y = size,
            },
            color = checkboxColor.background,
            radius = 5,
        })
    end

    if checked then
        dxDrawText("", position.x, position.y, position.x + size, position.y + size, rgba(checkboxColor.textColor), 0.4, fonts.icon, "center", "center")
    end

    dxDrawText(text, position.x + size + 5, position.y, position.x + size + textWidth, position.y + size, rgba(WHITE), 1, fonts.caption.regular, "left", "center")

    if helperText.text ~= "" then
        dxDrawText(helperText.text, position.x, position.y + size, position.x + size + textWidth, position.y + size + 20, rgba(helperText.color), 1, fonts.caption.regular, "left", "center")
    end

    if hover then
        exports.rl_cursor:setCursor("all", "pointinghand")
        if isMouseClicked() then
            store.set(name, {
                checked = not checked,
                textWidth = textWidth,
            })
            pressed = true
        end
    end

    return {
        checked = checkbox.checked,
        pressed = pressed,
    }
end)

function drawCheckbox(options)
    return components.checkbox.render(options)
end