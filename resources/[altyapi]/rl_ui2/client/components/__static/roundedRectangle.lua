local INITIAL_ROUNDED_RECTANGLE_OPTIONS = {
    position = {},
    size = {},

    color = WHITE,
    alpha = 1,
    radius = 4,

    section = false,
    postGUI = false,
}

local roundedRectangleSvgPath = [[
<svg viewBox="0 0 [width] [height]" fill="white" xmlns="http://www.w3.org/2000/svg">
  <rect width="[width]" height="[height]" rx="[radius]" />
</svg>
]]

createComponent("roundedRectangle", INITIAL_ROUNDED_RECTANGLE_OPTIONS, function(options, store)
    if PAUSE_RENDERING then
        return false
    end

    local position = options.position
    local size = options.size
    local color = options.color
    local alpha = options.alpha
    local radius = options.radius
    local section = options.section
    local postGUI = options.postGUI

    local x, y = position.x, position.y
    local width, height = size.x, size.y

    local radiusKey = "radius_" .. radius .. "_" .. width .. "_" .. height

    if not store.get(radiusKey) then
        local svgPath = roundedRectangleSvgPath:gsub("%[width%]", width):gsub("%[height%]", height):gsub("%[radius%]", radius)
        local svg = svgCreate(width, height, svgPath)
        store.set(radiusKey, svg)
    end

    if section then
        local percentage = section.percentage
        local direction = section.direction

        if direction == "left" then
            local sectionWidth = math.min(width, width * percentage / 100)
            dxDrawImageSection(x, y, sectionWidth, height, 0, 0, sectionWidth, height, store.get(radiusKey), 0, 0, 0, rgba(color, alpha))
        else
            local sectionHeight = math.min(height, height * percentage / 100)
            dxDrawImageSection(x, y + height, width, -sectionHeight, 0, 0, width, -sectionHeight, store.get(radiusKey), 0, 0, 0, rgba(color, alpha))
        end
    else
        dxDrawImage(x, y, width, height, store.get(radiusKey), 0, 0, 0, rgba(color, alpha), postGUI)
    end
end)

function drawRoundedRectangle(options)
    return components.roundedRectangle.render(options)
end