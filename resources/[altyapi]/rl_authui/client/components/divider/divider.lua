local INITIAL_DIVIDER_OPTIONS = {
    position = {},
    size = {},
    text = ""
}

createComponent("divider", INITIAL_DIVIDER_OPTIONS, function(options)
    local position = options.position or initialPosition
    local size = options.size or initialSize
    local text = options.text or ""
    local fonts = useFonts()
    if text ~= "" then
        local textWidth = dxGetTextWidth(text, 1, fonts.h6.thin) + 20
        local textPosition = {
            x = position.x + size.x / 2 - textWidth / 2,
            y = position.y + size.y / 2 - 10
        }
        dxDrawLine(position.x, position.y + size.y / 2, textPosition.x - 10, position.y + size.y / 2, rgba(GRAY[900]), 1)
        drawRoundedRectangle({
            position = {
                x = textPosition.x - 5,
                y = textPosition.y
            },
            size = {
                x = textWidth + 10,
                y = 20
            },
            color = GRAY[900],
            radius = 5
        })
        dxDrawText(text, textPosition.x, textPosition.y, textPosition.x + textWidth, textPosition.y + 20, rgba(GRAY[500]), 1, fonts.body.thin, "center", "center")
        dxDrawLine(textPosition.x + textWidth + 10, position.y + size.y / 2, position.x + size.x, position.y + size.y / 2, rgba(GRAY[900]), 1)
    else
        dxDrawLine(position.x, position.y + size.y / 2, position.x + size.x, position.y + size.y / 2, rgba(GRAY[500]), 1)
    end
    return {}
end)

function drawDivider(options)
    return components.divider.render(options)
end