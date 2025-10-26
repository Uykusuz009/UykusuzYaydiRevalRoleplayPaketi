local INITIAL_STATIC_IMAGE_OPTIONS = {
    position = {},
    size = {},

    color = WHITE,
    alpha = 1,

    image = "",

    postGUI = false,
}

createComponent("staticImage", INITIAL_STATIC_IMAGE_OPTIONS, function(options, store)
    if PAUSE_RENDERING then
        return false
    end

    local position = options.position
    local size = options.size
    local image = options.image
    local color = options.color
    local alpha = options.alpha
    local postGUI = options.postGUI

    local x, y = position.x, position.y
    local width, height = size.x, size.y

    dxDrawImage(x, y, width, height, image, 0, 0, 0, rgba(color, alpha), postGUI)
end)

function drawStaticImage(options)
    return components.staticImage.render(options)
end