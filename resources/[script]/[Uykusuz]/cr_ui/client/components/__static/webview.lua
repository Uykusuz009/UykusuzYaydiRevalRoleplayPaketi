local requests = {}

function emitView(browserStore, name, details)
    local toInject = "window[`" .. name .. "`](" .. json.encode(details) .. ")"

    if browserStore.loaded then
        executeBrowserJavascript(browserStore.element, toInject)
        focusBrowser(browserStore.element)
    else
        if not requests[browserStore.element] then
            requests[browserStore.element] = {}
        end

        table.insert(requests[browserStore.element], {
            element = browserStore.element,
            name = browserStore.name,
            content = toInject,
        })
    end
end

addEvent("browser.ready", true)
addEventHandler("browser.ready", root, function(name)
    local browserRequests = table.filter(requests, function(value, key)
        return value.name == name
    end)

    if not browserRequests then
        return
    end

    for _, request in pairs(browserRequests) do
        executeBrowserJavascript(request.element, request.content)
        focusBrowser(request.element)
    end
end)

createComponent("webview", {
    position = {
        x = 0,
        y = 0,
    },
    size = {
        width = 0,
        height = 0,
    },

    element = nil,
}, function(options, store)
    local position = options.position
    local size = options.size

    local element = options.element

    if not isElement(element) then
        return
    end

    dxDrawImage(position.x, position.y, size.width, size.height, element)
end)

function drawWebView(options)
    return components.webview.render(options)
end