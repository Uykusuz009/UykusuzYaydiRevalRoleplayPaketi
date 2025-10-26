local INITIAL_LIST_OPTIONS = {
    position = {},
    size = {},

    padding = 10,
    rowHeight = 35,

    name = "list",
    header = false,
    items = {},

    variant = "soft",
    color = "gray",

    disabled = false
}
local lastTick = getTickCount()

createComponent("list", INITIAL_LIST_OPTIONS, function(options, store)
    local position = options.position or initialPosition
    local size = options.size or initialSize

    local padding = options.padding or INITIAL_LIST_OPTIONS.padding
    local rowHeight = options.rowHeight or INITIAL_LIST_OPTIONS.rowHeight

    local name = options.name
    if not name then
        return
    end

    local header = options.header or INITIAL_LIST_OPTIONS.header
    local items = options.items or INITIAL_LIST_OPTIONS.items

    local variant = options.variant or INITIAL_LIST_OPTIONS.variant
    local color = options.color or INITIAL_LIST_OPTIONS.color

    local disabled = options.disabled

    local fonts = useFonts()
    local theme = useTheme()
    local listColor = useListVariant(variant, color)

    local list = store.get(name)

    if not list then
        store.set(name, {
            current = 1,
            max = math.floor((size.y - 60) / rowHeight),
        })
        return
    end

    list.max = math.floor((size.y - 50) / rowHeight)

    local hover = inArea(position.x, position.y, size.x, size.y)

    local pressed = false

    if variant == AVAILABLE_VARIANTS.OUTLINED then
        drawRoundedRectangle({
            position = position,
            size = size,
            color = listColor.textColor,
            radius = 5,
        })

        drawRoundedRectangle({
            position = {
                x = position.x + 1,
                y = position.y + 1,
            },
            size = {
                x = size.x - 2,
                y = size.y - 2,
            },
            color = listColor.background,
            radius = 5,
        })
    elseif variant ~= AVAILABLE_VARIANTS.TRANSPARENT then
        drawRoundedRectangle({
            position = position,
            size = size,
            color = listColor.background,
            radius = 5,
        })
    end

    if #items > list.max then
        drawScrollBar({
            position = position,
            size = size,
            current = math.floor(list.current),
            total = #items,
            visibleCount = list.max,
        })
    end

    if hover and #items > list.max then
        if pressedKeys.mouse_wheel_down then
            list.current = math.min(list.current + 1, #items - list.max + 1)
            store.set(name, list)
        elseif pressedKeys.mouse_wheel_up then
            list.current = math.max(list.current - 1, 1)
            store.set(name, list)
        end
    end

    if header then
        local headerWidth = dxGetTextWidth(header, 1, fonts.h5.black)
        local fontSize = headerWidth + 2 * padding > size.x and (size.x / (headerWidth + 2 * padding)) or 1
        dxDrawText(header, position.x + padding, position.y + padding, position.x + size.x - padding, position.y + size.y - padding, rgba(WHITEP[100]), fontSize, fonts.h5.black, "left", "top", false, false, false, true)
    else
        position.y = position.y - rowHeight - padding
    end

    local i = 1
    for _ = list.current, list.current + list.max - 1 do
        local item = items[_]
        if item then
            local itemPosition = {
                x = position.x + padding,
                y = position.y + (padding + 10) + rowHeight + (i - 1) * (rowHeight + 5),
            }
            local itemSize = {
                x = size.x - padding * 2,
                y = rowHeight
            }

            local hover = inArea(itemPosition.x, itemPosition.y, itemSize.x, itemSize.y)

            if hover then
                drawRoundedRectangle({
                    position = itemPosition,
                    size = itemSize,
                    color = listColor.itemColor,
                    radius = 5,
                })
                exports.rl_cursor:setCursor("all", "pointinghand")
                if isMouseClicked() then
                    pressed = item.key
                end
            end
            if item.icon ~= "" then
                dxDrawText(item.icon, itemPosition.x + 10, itemPosition.y, itemPosition.x + itemSize.x, itemPosition.y + itemSize.y, rgba(GRAY[400], 1), 0.4, fonts.icon, "left", "center", false, false, false, true)
                itemPosition.x = itemPosition.x + 20
            end

            dxDrawText(item.text, itemPosition.x + padding, itemPosition.y, itemPosition.x + itemSize.x - padding, itemPosition.y + itemSize.y, rgba(theme[item.color or "GRAY"][400], 1), 1, fonts.body.regular, "left", "center", false, false, false, true)
            i = i + 1
        end
    end

    store.set(name, list)
    return {
        current = list.current,
        max = list.max,
        pressed = not disabled and pressed or false,
    }
end)

function drawList(options)
    return components.list.render(options)
end