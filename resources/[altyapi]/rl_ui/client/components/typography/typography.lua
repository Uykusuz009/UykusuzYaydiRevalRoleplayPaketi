local INITIAL_TYPOGRAPHY_OPTIONS = {
    position = {
        x = 0,
        y = 0,
    },
    size = {
        x = 0,
        y = 0
    },

    text = "",
    alignX = "left",
    alignY = "top",
    color = WHITE,
    scale = "h1",
    fontScale = 1,
    wrap = false,

    fontWeight = "regular",
    fillBackground = false,
}

createComponent("typography", INITIAL_TYPOGRAPHY_OPTIONS, function(options, store)
    local position = options.position or initialSize
    local size = options.size or initialPosition

    local text = options.text or INITIAL_TYPOGRAPHY_OPTIONS.text
    local alignX = options.alignX or INITIAL_TYPOGRAPHY_OPTIONS.alignX
    local alignY = options.alignY or INITIAL_TYPOGRAPHY_OPTIONS.alignY
    local color = options.color or INITIAL_TYPOGRAPHY_OPTIONS.color
    local scale = options.scale or INITIAL_TYPOGRAPHY_OPTIONS.scale
    local fontScale = options.fontScale or 1
    local wrap = options.wrap or INITIAL_TYPOGRAPHY_OPTIONS.wrap

    local fontWeight = options.fontWeight or INITIAL_TYPOGRAPHY_OPTIONS.fontWeight
    local fillBackground = options.fillBackground or INITIAL_TYPOGRAPHY_OPTIONS.fillBackground

    local fonts = useFonts()
    local font = fonts[scale][fontWeight]

    if CurrentTheme == Theme.NATIVE then
        font = fonts["gui"][scale][fontWeight]

        local guis = store.get("guis")

        if not guis then
            guis = {}

            local label = guiCreateLabel(position.x, position.y, size.x, size.y, text, false, false)
            guiLabelSetHorizontalAlign(label, alignX)
            guiLabelSetVerticalAlign(label, alignY)
            guiBringToFront(label)

            guis.label = label

            store.set("guis", guis)
        end

        return {
            textWidth = 0,
            textHeight = 0,
        }
    end

    local textWidth = dxGetTextWidth(text, 1, font)
    local textHeight = dxGetFontHeight(1, font)
    local hover = inArea(position.x, position.y, textWidth, textHeight)

    if fillBackground then
        for x = -1, 1 do
            for y = -1, 1 do
                dxDrawText(
                        text,
                        position.x + x,
                        position.y + y,
                        position.x + x + size.x,
                        position.y + y + size.y,
                        tocolor(0, 0, 0),
                        fontScale,
                        font,
                        alignX,
                        alignY,
                        wrap
                )
            end
        end
    end

    dxDrawText(
            text,
            position.x,
            position.y,
            position.x + size.x,
            position.y + size.y,
            rgba(color, 1),
            fontScale,
            font,
            alignX,
            alignY,
            wrap,
            false,
            false,
            false,
            true
    )

    return {
        textWidth = textWidth,
        textHeight = textHeight,
    }
end)

function drawTypography(options)
    return components.typography.render(options)
end