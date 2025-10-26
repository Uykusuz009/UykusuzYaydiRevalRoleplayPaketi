local paginationSize = {
    x = 32,
    y = 32
}

local lastClick = getTickCount()

function drawSlider(options)
    local position = options.position
    local size = options.size
    local containerSize = options.containerSize

    local count = options.count
    local current = options.current

    local content = options.content
    local switch = options.switch

    local centerPosition = {
        x = position.x + size.x / 2 - containerSize.x / 2,
        y = position.y + size.y / 2 - containerSize.y / 2
    }

    content(centerPosition.x, centerPosition.y, containerSize.x, containerSize.y)

    local paginationPosition = {
        x = position.x + size.x / 2 - paginationSize.x / 2,
        y = position.y + size.y - paginationSize.y - 16
    }

    for i = 1, count do
        local x = paginationPosition.x + (i - 1) * (paginationSize.x + 15) - (count - 1) * (paginationSize.x + 15) / 2
        local y = position.y + size.y - 50

        local isCurrent = i == current
        local hover = exports.cr_ui:inArea(x, y, paginationSize.x, paginationSize.y)

        dxDrawRectangle(x, y, paginationSize.x, paginationSize.y, isCurrent and exports.cr_ui:rgba(theme.YELLOW[800]) or exports.cr_ui:rgba(theme.GRAY[900], 0.9), false, false, false)
        dxDrawText(i, x, y, x + paginationSize.x, y + paginationSize.y, isCurrent and exports.cr_ui:rgba(theme.YELLOW[400], 1) or exports.cr_ui:rgba(theme.GRAY[400], 1), 1, fonts.h6.regular, "center", "center")

        if hover then
            exports.rl_cursor:setCursor("all", "pointinghand")
            if exports.cr_ui:isKeyPressed("mouse1") and lastClick + 200 <= getTickCount() then
                lastClick = getTickCount()
                switch(i)
            end
        end
    end
end