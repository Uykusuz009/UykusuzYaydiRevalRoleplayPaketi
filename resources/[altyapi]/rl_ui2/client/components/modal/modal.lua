local INITIAL_MODAL_OPTIONS = {
    size = {
        x = 0,
        y = 0
    },
    description = "",

    header = {
        title = "",
        description = "",
        icon = "",
        close = false
    },

    buttons = {},
    visible = false
}

local padding = 10

createComponent("modal", INITIAL_MODAL_OPTIONS, function(options)
    local size = options.size or initialSize
    local header = options.header or INITIAL_MODAL_OPTIONS.header
    local description = options.description or INITIAL_MODAL_OPTIONS.description

    local buttons = options.buttons or INITIAL_MODAL_OPTIONS.buttons
    local visible = options.visible or INITIAL_MODAL_OPTIONS.visible

    if not visible then
        return false
    end

    local theme = useTheme()

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, rgba(theme.GRAY[800], 0.8))

    local window = drawWindow({
        position = {},
        size = size,
        header = header,
        padding = padding,
        centered = true,

        close = options.close,
        radius = 8,
    })

    dxDrawText(description, window.x, window.y, 0, 0, rgba(GRAY[200], 1),
            1,
            fontElements.UbuntuRegular.caption,
            "left",
            "top",
            false,
            false,
            true,
            true
    )

    local buttonX = window.x + window.width
    local buttonData = {}
    for i = 1, #buttons do
        local button = buttons[i]
        if button then
            local textWidth = dxGetTextWidth(button.text, 1, fontElements.body.regular) + 40

            buttonX = buttonX - textWidth - 5
            local buttonElement = drawButton({
                position = {
                    x = buttonX,
                    y = window.y + window.height - 40
                },
                size = {
                    x = textWidth,
                    y = 30
                },
                radius = 8,

                textProperties = {
                    align = "center",
                    color = WHITE,
                    font = fontElements.body.regular,
                    scale = 1,
                },

                variant = "soft",
                color = button.color,
                disabled = button.disabled,

                text = button.text,
                icon = "",
            })
            buttonData[button.key or i] = buttonElement
        end
    end

    return {
        position = {
            x = window.x,
            y = window.y
        },
        size = {
            x = window.width,
            y = window.height
        },
        buttonData = buttonData,
        clickedClose = window.clickedClose
    }
end)

function drawModal(options)
    return components.modal.render(options)
end