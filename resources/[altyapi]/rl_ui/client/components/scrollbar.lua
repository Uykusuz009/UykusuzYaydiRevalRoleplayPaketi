ScrollBar = {}
ScrollBar.alias = "ScrollBar"
ScrollBar.initialOptions = {
    position = { x = 0, y = 0 },
    size = { x = 0, y = 0 },

    current = 0,
    total = 0,
    visibleCount = 0,
}
ScrollBar.defaultWidth = 10

ScrollBar.render = function(options)
    local position = options.position or ScrollBar.initialOptions.position
    local size = options.size or ScrollBar.initialOptions.size

    local current = options.current or ScrollBar.initialOptions.current
    local total = options.total or ScrollBar.initialOptions.total
    local visibleCount = options.visibleCount or ScrollBar.initialOptions.visibleCount

    dxDrawRectangle(position.x + size.x - ScrollBar.defaultWidth, position.y, ScrollBar.defaultWidth, size.y, rgba(GRAY[800], 1))

    local scrollBarHeight = size.y / total * visibleCount
    local scrollBarPosition = position.y + (size.y - scrollBarHeight) / total * current

    dxDrawRectangle(position.x + size.x - ScrollBar.defaultWidth, scrollBarPosition, ScrollBar.defaultWidth, scrollBarHeight, rgba(GRAY[400], 1))
end
createComponent(ScrollBar.alias, ScrollBar.initialOptions, ScrollBar.render)

function drawScrollBar(options)
    return components[ScrollBar.alias].render(options)
end