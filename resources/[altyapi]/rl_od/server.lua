local function onPreEvent(sourceResource, eventName, eventSource, eventClient, luaFilename, luaLineNumber, ...)
    if eventClient and getElementType(eventClient) == "player" and eventSource and getElementType(eventSource) == "player" then
        if eventSource ~= eventClient then
            cancelEvent(true)
            outputChatBox("[Security] You have been banned for suspicious event triggering!", eventClient, 255, 0, 0)
            return
        end
    end
end