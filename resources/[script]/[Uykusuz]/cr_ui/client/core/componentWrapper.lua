components = {}
PAUSE_RENDERING = false

setTimer(function()
    isMousePressed = getKeyState("mouse1")
end, 0, 0)

function createComponent(componentName, initialOptions, renderFunction)
    assert(type(componentName) == "string", "Component name must be a string.")
    assert(type(initialOptions) == "table", "Initial options must be a table.")
    assert(type(renderFunction) == "function", "Render function must be a function.")

    local function renderMiddleware(_options, reference)
        local store = components[componentName].store
        store.updateRenderTickCount()
        if reference then
            store.updateReference(reference.key, reference)
        end

        return renderFunction(_options, store, reference)
    end

    local component = {
        name = componentName,
        render = renderMiddleware,

        state = {
            renderTickCount = getTickCount(),
            references = {},
        },

        store = {
            set = function(key, value)
                components[componentName].state[key] = value
            end,
            get = function(key)
                return components[componentName].state[key]
            end,
            updateRenderTickCount = function()
                components[componentName].state.renderTickCount = getTickCount()
            end,
            updateReference = function(key, value)
                if not components[componentName].state.references then
                    components[componentName].state.references = {}
                end

                components[componentName].state.references[key] = value
            end,
        }
    }

    components[componentName] = component
end

function getComponentState(componentName, key)
    if not components[componentName] then
        return
    end

    return components[componentName].state[key]
end

function getComponents()
    return components
end

addEventHandler("onClientMinimize", root, function()
    PAUSE_RENDERING = true
end)

addEventHandler("onClientRestore", root, function()
    PAUSE_RENDERING = false
end)

setTimer(function()
    for componentName, component in pairs(components) do
        if componentName ~= "roundedRectangle" then
            if component.state.renderTickCount and component.state.renderTickCount + 4000 < getTickCount() then
                if componentName == "input" and guiGetInputEnabled() then
                    guiSetInputEnabled(false)
                end
                if component.state.references then
                    for key, reference in pairs(component.state.references) do
                        if isElement(reference.renderTarget) then
                            destroyElement(reference.renderTarget)
                            Window.references[key] = nil
                        end
                    end
                end

                components[componentName].state = {}
                collectgarbage()
            end
        end
    end
end, 15000, 0)

setTimer(function()
    for componentName, component in pairs(components) do
        if component.state.renderTickCount and component.state.renderTickCount + 200 < getTickCount() then
            if component.state.guis then
                for _, gui in pairs(component.state.guis) do
                    if isElement(gui) then
                        destroyElement(gui)
                    end
                end
                components[componentName].state.guis = nil
            end

            for key, element in pairs(component.state) do
                if type(element) == "table" and element.guiElement then
                    destroyElement(element.guiElement)
                    components[componentName].state[key] = nil
                end
            end

        end
    end
end, 50, 0)