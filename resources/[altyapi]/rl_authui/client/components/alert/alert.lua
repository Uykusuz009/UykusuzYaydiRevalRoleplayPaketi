local INITIAL_ALERT_OPTIONS = {
    position = {
        x = 0,
        y = 0
    },
    size = {
        x = 0,
        y = 0
    },

    radius = 4,
    padding = 0,

    header = "",
    description = "",

    variant = "soft",
    color = "gray",
}

createComponent("alert", INITIAL_ALERT_OPTIONS, function(options, store)
    local position = options.position or initialPosition
    local size = options.size or initialSize

    local radius = options.radius or initialRadius
    local padding = options.padding or initialPadding

    local header = options.header or ""
    local description = options.description or ""

    local variant = options.variant or "soft"
    local color = options.color or "gray"

    local fonts = useFonts()
    local containerColor = useAlertVariant(variant, color)

    drawRoundedRectangle({
        position = position,
        size = size,

        color = containerColor.background,
        alpha = 1,
        radius = radius,

        section = false
    })

    dxDrawText(header,
            position.x + padding,
            position.y + padding,
            position.x + size.x,
            position.y + size.y,
            rgba(containerColor.textColor, 1),
            1,
            fonts.h6.bold,
            "left",
            "top",
            false,
            false,
            false,
            true
    )
    dxDrawText(description,
            position.x + padding,
            position.y + padding + 20,
            position.x + size.x,
            position.y + size.y,
            rgba(containerColor.textColor, 0.75),
            1,
            fonts.body.regular,
            "left",
            "top",
            false,
            false,
            false,
            true
    )
end)

function drawAlert(options)
    return components.alert.render(options)
end