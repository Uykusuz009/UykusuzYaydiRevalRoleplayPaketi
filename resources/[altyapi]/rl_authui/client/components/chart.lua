Chart = {}
Chart.alias = "chart"
Chart.initialOptions = {
    position = {
        x = 0,
        y = 0,
    },
    size = {
        x = 0,
        y = 0,
    },

    color = "blue",
    data = {},
}

local linesGap = 24
local linesHeight = 1

local function drawLinesBackground(position, size, color)
    color = color or "GRAY"
    local linesCount = math.floor(size.y / (linesHeight + linesGap))
    local linesCountX = math.floor(size.x / (linesHeight + linesGap))

    for i = 1, linesCount do
        local y = position.y + (i - 1) * (linesHeight + linesGap)
        dxDrawRectangle(position.x, y, size.x, linesHeight, rgba(GRAY[700], 1))
    end

    for i = 1, linesCountX do
        local x = position.x + (i - 1) * (linesHeight + linesGap)
        dxDrawRectangle(x, position.y, linesHeight, size.y, rgba(GRAY[700], 1))
    end
end

Chart.render = function(options)
    local position = options.position or Chart.initialOptions.position
    local size = options.size or Chart.initialOptions.size

    local color = options.color or Chart.initialOptions.color
    local data = options.data or Chart.initialOptions.data

    local theme = useTheme()

    dxDrawRectangle(position.x, position.y, size.x, size.y, rgba(GRAY[900], 0.5))
    drawLinesBackground(position, size)

    dxDrawLine(position.x, position.y + size.y, position.x + size.x, position.y + size.y, rgba(GRAY[700]))
    dxDrawLine(position.x, position.y, position.x, position.y + size.y, rgba(GRAY[700]))

    dxDrawLine(position.x + size.x, position.y, position.x + size.x, position.y + size.y, rgba(GRAY[700]))

    local max = 0
    for _, row in ipairs(data) do
        if row.value > max then
            max = row.value
        end
    end

    local step = size.x / #data
    local stepHeight = size.y / max

    local lastX = position.x
    local lastY = position.y + size.y

    for index, row in ipairs(data) do
        local x = position.x + (index * step)
        local y = position.y + size.y - (row.value * stepHeight)

        if tonumber(y) >= 0 and tonumber(x) >= 0 then
            dxDrawLine(lastX, lastY, x, y, rgba(theme[color][500]))

            drawRoundedRectangle {
                position = {
                    x = x - 4,
                    y = y - 4,
                },
                size = {
                    x = 8,
                    y = 8,
                },

                color = theme[color][500],
                radius = 4,
            }
            drawTooltip {
                position = {
                    x = x - 4 - 30 / 2,
                    y = y - 4,
                },
                size = {
                    x = 30,
                    y = 30,
                },

                text = row.label or row.value,
                color = color,
            }

            lastX = x
            lastY = y
        end
    end

    if #data > 0 then
        for i = 1, 10 do
            local y = position.y + size.y - (i * (max / 10) * stepHeight)
            if tonumber(y) > 0 then
                local label = ("%.0f"):format(i * (max / 10))
                dxDrawText(label, position.x - 4, y, position.x + size.x - size.x - 4, 0, rgba(GRAY[500]), 1, fontElements.UbuntuRegular.caption, "right", "top")
            end
        end
    end
    return true
end

createComponent(Chart.alias, Chart.initialOptions, Chart.render)

function drawChart(options)
    return components[Chart.alias].render(options)
end