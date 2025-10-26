Window = {}
Window.alias = "window"
Window.palette = {
    background = GRAY[900],
    foreground = GRAY[100]
}
Window.initialOptions = {
    position = {
        x = 0,
        y = 0,
    },
    size = {
        x = 0,
        y = 0,
    },

    centered = true,

    header = {
        title = "",
        close = false
    },
    frameGradient = { 105, 105, 105 },

    postGUI = false,
    palette = Window.palette,
}
Window.padding = 2
Window.radius = 6

Window.innerPadding = {
    x = 12,
    y = 12,
}

Window.references = {}

Window.render = function(options, _, reference)
    local position = options.position or Window.initialOptions.position
    local size = options.size or Window.initialOptions.size
    local centered = options.centered
    local header = options.header or Window.initialOptions.header
    local headerTitle = header.title
    local headerClose = header.close
    local headerDescription = header.description
    local postGUI = options.postGUI or Window.initialOptions.postGUI
    local palette = options.palette or Window.initialOptions.palette

    local renderTarget = reference.renderTarget
    local shouldRender = reference.shouldRender
    local frameGradient = options.frameGradient or Window.initialOptions.frameGradient

    if shouldRender then
        dxSetRenderTarget(renderTarget, true)
        dxDrawRectangle(0, 0, size.x, size.y, rgba(palette.background), postGUI)

        local frameGradientR, frameGradientG, frameGradientB = frameGradient[1], frameGradient[2], frameGradient[3]

        dxDrawGradient(0, 0, size.x, size.y, 155, 155, 155, 15, true, true, postGUI)

        dxDrawGradient(0, 0, size.x - Window.padding * 2, 1, frameGradientR, frameGradientG, frameGradientB, 255, false, true, postGUI)
        dxDrawGradient(0, 0, 1, size.y - Window.padding * 2, frameGradientR, frameGradientG, frameGradientB, 255, true, true, postGUI)

        dxDrawText(headerTitle,
                Window.innerPadding.x,
                Window.innerPadding.y, 0, 0,
                rgba(palette.foreground), 1, fontElements.BebasNeueBold.h5, "left", "top")

        if headerDescription then
            dxDrawText(headerDescription,
                    Window.innerPadding.x,
                    Window.innerPadding.y * 2.5, 0, 0,
                    rgba(palette.foreground), 1, fontElements.BebasNeueBold.h6, "left", "top", false, false, false, true)
        end

        if headerClose then
            drawButton {
                position = {
                    x = size.x - 24 - Window.innerPadding.x,
                    y = Window.innerPadding.y,
                },
                size = {
                    x = 24,
                    y = 24,
                },

                textProperties = {
                    align = "center",
                    color = GRAY[300],
                    font = fontElements.icon,
                    scale = 0.5,
                },

                variant = "plain",
                color = "gray",
                disabled = false,

                text = "",

                postGUI = false
            }
        end
        dxSetRenderTarget()
        reference.shouldRender = false
    end

    position = usePosition(position, size, centered)

    dxDrawImage(position.x, position.y, size.x, size.y, renderTarget)

    local closeHover = inArea(position.x + size.x - 24 - Window.innerPadding.x, position.y + Window.innerPadding.y, 24, 24)
    if closeHover then
        exports.rl_cursor:setCursor("all", "pointinghand")
    end

    return {
        x = position.x + Window.innerPadding.x,
        y = position.y + Window.innerPadding.y * 4,
        width = size.x - Window.innerPadding.x * 2,
        height = size.y - Window.innerPadding.y * 5,
        clickedClose = closeHover and isMouseClicked()
    }
end
createComponent(Window.alias, Window.initialOptions, Window.render)

function drawWindow(options)
    local key = (sourceResource and sourceResource.name or "this") .. ":" .. Window.alias .. ":render" .. ":" .. options.size.x .. ":" .. options.size.y

    if not Window.references[key] then
        Window.references[key] = {
            key = key,
            renderTarget = dxCreateRenderTarget(options.size.x, options.size.y, false),
            shouldRender = true,
        }
    end

    return components[Window.alias].render(options, Window.references[key])
end

function Window.onRestore()
    for _, reference in pairs(Window.references) do
        reference.shouldRender = true
    end
end
addEventHandler(ClientEventNames.onClientRestore, root, Window.onRestore)

test(function(kill)
	local theme = useTheme()
	
    local window = drawWindow({
        position = {
            x = 0,
            y = 0,
        },
        size = {
            x = 600,
            y = 400,
        },

        centered = true,

        header = {
            title = "Araçlarım",
            close = true
        },

        postGUI = false,
    })

    if window.clickedClose then
        kill()
    end

    local i = 0
    for variant in pairs(Button.enums.variant) do
        drawButton {
            position = {
                x = window.x + (i * 110),
                y = window.y
            },
            size = {
                x = 100,
                y = 30,
            },

            variant = variant,
            color = "red",
            disabled = false,

            text = variant,

            postGUI = false
        }
        i = i + 1
    end

    local i = 0
    for variant in pairs(Input.enums.variant) do
        drawInput({
            position = {
                x = window.x + (i * 160),
                y = window.y + 150
            },
            size = {
                x = 150,
                y = 30,
            },

            variant = variant,
            color = "red",
            disabled = false,

            name = variant,
            placeholder = variant,

            postGUI = false
        })
        i = i + 1
    end

    drawSpinner {
        position = {
            x = window.x + 20,
            y = window.y + 50,
        },
        size = 64,

        speed = 2,

        label = "Yükleniyor...",
    }
end)--.render()