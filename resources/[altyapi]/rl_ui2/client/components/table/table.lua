local INITIAL_TABLE_OPTIONS = {
    position = { x = 0, y = 0 },
    size = { width = 0, height = 0 },

    padding = 10,

    name = "table",

    columns = {},
    rows = {},

    variant = "soft",
    color = "gray",

    radius = DEFAULT_RADIUS,
    disabled = false,
}

local function measureText(text, font, fontSize)
    local textWidth = dxGetTextWidth(text, fontSize, font)
    local textHeight = dxGetFontHeight(fontSize, font)

    return {
        width = textWidth,
        height = textHeight,
    }
end

createComponent("table", INITIAL_TABLE_OPTIONS, function(options, store)
    local position = options.position or initialPosition
    local size = options.size or initialSize

    local padding = options.padding or INITIAL_TABLE_OPTIONS.padding

    local name = options.name
    if not name then
        return
    end

    local columns = options.columns or INITIAL_TABLE_OPTIONS.columns
    local rows = options.rows or INITIAL_TABLE_OPTIONS.rows

    local variant = options.variant or INITIAL_TABLE_OPTIONS.variant
    local color = options.color or INITIAL_TABLE_OPTIONS.color

    local radius = options.radius or INITIAL_TABLE_OPTIONS.radius
    local disabled = options.disabled or INITIAL_TABLE_OPTIONS.disabled

    local fonts = useFonts()

    local columnWidth = (size.width - padding * 2) / #columns

    local columnHeight = 20

    local rowHeight = 30

    local headerHeight = columnHeight + padding * 2

    local tableHeight = size.height - headerHeight

    local rowsPerPage = math.floor(tableHeight / rowHeight)

    local pages = math.ceil(#rows / rowsPerPage)

    local tableStore = useStore(name)
    if not tableStore then
        tableStore.set("currentPage", 1)
    end

    local currentPage = tableStore.get("currentPage") or 1

    local headerPosition = {
        x = position.x,
        y = position.y,
    }

    local headerSize = {
        width = size.width,
        height = headerHeight,
    }

    local tablePosition = {
        x = position.x,
        y = position.y + headerHeight + 2,
    }

    local tableSize = {
        width = size.width,
        height = tableHeight,
    }

    local variantData = useTableTheme(variant, color)

    drawRoundedRectangle({
        position = headerPosition,
        size = {
            x = headerSize.width,
            y = headerSize.height,
        },

        color = variantData.header,
        variant = variant,
        radius = radius,
    })

    drawRoundedRectangle({
        position = tablePosition,
        size = {
            x = tableSize.width,
            y = tableSize.height,
        },

        color = variantData.background,
        variant = variant,
        radius = radius,
    })

    local columnPosition = {
        x = headerPosition.x + padding,
        y = headerPosition.y + padding,
    }

    local columnSize = {
        width = columnWidth - padding * 2,
        height = columnHeight,
    }

    for i, column in ipairs(columns) do
        local columnText = column.text

        local columnWidth = column.width and (size.width * column.width) or columnSize.width

        local columnFont = column.font or fonts.body.regular
        local columnFontSize = column.fontSize or 1

        local columnFontColor = column.fontColor or WHITE
        if disabled then
            columnFontColor = GRAY[700]
        end

        local columnTextSize = measureText(columnText, columnFont, columnFontSize)

        local columnTextPosition = {
            x = columnPosition.x,
            y = columnPosition.y + columnSize.height / 2 - columnTextSize.height / 2,
        }

        dxDrawText(columnText, columnTextPosition.x, columnTextPosition.y, columnTextPosition.x + columnTextSize.width, columnTextPosition.y + columnTextSize.height, rgba(columnFontColor, 1), columnFontSize, columnFont, "left", "center", false, false, false, false, false)
        columnPosition.x = columnPosition.x + columnWidth
    end

    local rowPosition = {
        x = tablePosition.x + padding,
        y = tablePosition.y + padding,
    }

    local rowSize = {
        width = columnWidth - padding * 2,
        height = rowHeight,
    }

    local rowStart = (currentPage - 1) * rowsPerPage + 1
    local rowEnd = currentPage * rowsPerPage

    local hoverRow = nil
    local pressedRow = nil
    local hoverColumn = nil

    local showingRowCount = 0
    for i = rowStart, rowEnd do
        local row = rows[i]
        if row then
            if not disabled then
                if inArea(rowPosition.x, rowPosition.y, size.width, rowSize.height) then
                    hoverRow = row
                    if isMouseClicked() then
                        pressedRow = row
                    end
                else
                    hoverRow = nil
                end
                if hoverRow then
                    exports.rl_cursor:setCursor("all", "pointinghand")
                end
            end
            for j, column in ipairs(columns) do
                local columnText = row[j]

                local columnWidth = column.width and (size.width * column.width) or columnSize.width

                local columnFont = column.font or fonts.body.light
                local columnFontSize = column.fontSize or 1

                local columnFontColor = column.fontColor or GRAY[hoverRow and 200 or 400]
                if disabled then
                    columnFontColor = GRAY[700]
                end

                local columnTextSize = measureText(columnText, columnFont, columnFontSize)

                local columnTextPosition = {
                    x = rowPosition.x,
                    y = rowPosition.y + rowSize.height / 2 - columnTextSize.height / 2,
                }

                if not disabled and inArea(columnTextPosition.x, columnTextPosition.y, columnTextSize.width, columnTextSize.height) then
                    hoverColumn = j
                end

                dxDrawText(columnText, columnTextPosition.x, columnTextPosition.y, columnTextPosition.x + columnTextSize.width, columnTextPosition.y + columnTextSize.height, rgba(columnFontColor, 1), columnFontSize, columnFont, "left", "center", false, false, false, true, false)
                rowPosition.x = rowPosition.x + columnWidth
            end
            showingRowCount = showingRowCount + 1
            rowPosition.x = tablePosition.x + padding
            rowPosition.y = rowPosition.y + rowHeight
        end
    end

    local paginationSize = {
        x = 30,
        y = 30,
    }

    local paginationPosition = {
        x = tablePosition.x,
        y = tablePosition.y + tableSize.height + 5,
    }

    for i = 1, pages do
        local paginationText = i
        local active = i == currentPage

        local button = drawButton({
            position = {
                x = paginationPosition.x + (i - 1) * (paginationSize.x + 5),
                y = paginationPosition.y,
            },
            size = paginationSize,
            text = paginationText,
            name = "pagination_" .. i,

            variant = "soft",
            color = active and "blue" or "gray",
            disabled = disabled,
        })

        if button.pressed then
            tableStore.set("currentPage", i)
        end
    end

    dxDrawText(#rows .. " satırdan " .. rowStart .. "-" .. showingRowCount .. " arası gösteriliyor", paginationPosition.x, paginationPosition.y, paginationPosition.x + headerSize.width, paginationPosition.y + paginationSize.y, rgba(GRAY[600], 1), 1, fonts.body.regular, "right", "center", false, false, false, false, false)

    return {
        hoverRow = hoverRow,
        pressedRow = pressedRow,
        hoverColumn = hoverColumn,
    }
end)

function drawTable(options)
    return components.table.render(options)
end