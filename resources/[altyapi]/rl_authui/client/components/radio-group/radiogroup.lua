local INITIAL_RADIOGROUP_OPTIONS = {
    position = {},

    name = "",
    options = {},
    defaultSelected = 1,

    placement = "horizontal",

    variant = "soft",
    color = DEFAULT_COLOR,
}

local RADIO_CIRCLE_SIZE = 16

function drawRadio(options)
    return {
        name = options.name,
        text = options.text,
    }
end

createComponent("radioGroup", INITIAL_RADIOGROUP_OPTIONS, function(options, store)
    local position = options.position or initialPosition

    local name = options.name
    if not name then
        return
    end

    local opts = options.options or INITIAL_RADIOGROUP_OPTIONS.options
    local defaultSelected = options.defaultSelected or INITIAL_RADIOGROUP_OPTIONS.defaultSelected
    local placement = options.placement or INITIAL_RADIOGROUP_OPTIONS.placement

    local variant = options.variant or INITIAL_RADIOGROUP_OPTIONS.variant
    local color = options.color or INITIAL_RADIOGROUP_OPTIONS.color

    local fonts = useFonts()
    local radioGroupColor = useRadioGroupVariant(variant, color)

    local radioGroup = store.get(name)
    if not radioGroup then
        store.set(name, {
            name = name,
            current = defaultSelected,
        })
        radioGroup = {
            name = name,
            current = defaultSelected,
        }
    end

    for i = 1, #opts do
        local option = opts[i]
        if not option then
            return false
        end

        local optionPosition = {}

        local textWidth = dxGetTextWidth(option.text, 1, fonts.body.regular)

        if placement == "vertical" then
            optionPosition.x = position.x
            optionPosition.y = position.y
        else
            optionPosition.x = position.x
            optionPosition.y = i == 1 and position.y or position.y + (i - 1) * (RADIO_CIRCLE_SIZE + 8)
        end

        local optionSize = {
            x = RADIO_CIRCLE_SIZE,
            y = RADIO_CIRCLE_SIZE
        }

        local itemHover = inArea(optionPosition.x, optionPosition.y, optionSize.x + textWidth + 10, optionSize.y)

        local color = itemHover and radioGroupColor.hover or radioGroupColor

        drawRoundedRectangle({
            position = optionPosition,
            size = optionSize,
            color = color.textColor,
            radius = optionSize.x / 2,
            alpha = 1,
            section = false,
        })

        if radioGroup.current ~= option.name then
            drawRoundedRectangle({
                position = {
                    x = optionPosition.x + 2,
                    y = optionPosition.y + 2,
                },
                size = {
                    x = optionSize.x - 4,
                    y = optionSize.y - 4,
                },
                color = color.background,
                alpha = 1,
                section = false,
                radius = optionSize.x - 4 / 2,
            })
        end

        dxDrawText(option.text, optionPosition.x + RADIO_CIRCLE_SIZE + 5, optionPosition.y, optionPosition.x + RADIO_CIRCLE_SIZE + 5, optionPosition.y + optionSize.y, rgba(color.textColor, 1), 1, fonts.UbuntuRegular.caption, "left", "center")

        if itemHover then
            exports.rl_cursor:setCursor("all", "pointinghand")
            if isMouseClicked() then
                radioGroup.current = option.name
                store.set(name, radioGroup)
            end
        end

        if placement == "vertical" then
            position.x = position.x + textWidth + 40
        end
    end

    return {
        name = radioGroup.name,
        current = radioGroup.current
    }
end)

function drawRadioGroup(options)
    return components.radioGroup.render(options)
end