local chatFonts = {
    [0] = 'default',
    [1] = 'clear',
    [2] = 'default-bold',
    [3] = 'arial',
}
local lastUpdate

addEventHandler('onClientRender', root, function()
    local layout = getChatboxLayout()
    if lastUpdate ~= layout then
        local fontHeight = dxGetFontHeight(layout.text_scale, chatFonts[layout.chat_font])
        local height = (layout.chat_lines * fontHeight) * layout.chat_scale[2]
        inputX, inputY, inputWidth, inputHeight = sx * layout.chat_position_offset_x, sy * layout.chat_position_offset_y + height + (15 * psy) or 0, 770 * psx, 35 * psy
        chatSettings.inputFont = chatFonts[layout.chat_font]
        chatSettings.fontHeight = dxGetFontHeight(chatSettings.inputSize, chatFonts[layout.chat_font])
        lastUpdate = layout
    end
	toggleControl('chatbox', false)
end)

chatSettings = {
    type = 'IC',
    messages = {},
    inputShow = false,
    inputFont = 'default-bold',
    inputSize = 1,
    oldMessages = {},
    totalHeight = 0
}

local messageIndex = 0

addEventHandler('onClientResourceStart', root, function(resource)
	if resource == getThisResource() then
		loadLocalSettings()
		addEventHandler('onClientRender', root, renderChat)
			
		bindKey('t', 'down', openInput)
		bindKey('b', 'down', openInput)
		bindKey('y', 'down', openInput)
		bindKey('u', 'down', openInput)
	end

    clientSideCommands = {}
    for key, value in pairs(getCommandHandlers()) do
        local command, resource = unpack(value)
        clientSideCommands[command] = resource
    end
end)

function openInput(key)
    if chatSettings.inputShow then
        return
    end
	
	if getElementData(localPlayer, "hudclose") then
	    return
    end

    if key == 't' then
        chatSettings.type = 'IC'
    elseif key == 'b' then
        chatSettings.type = 'OOC'
    elseif key == 'y' then
        chatSettings.type = 'BIRLIK'
    elseif key == 'u' then
        chatSettings.type = 'PM'
    end

    labels['chatinput'] = ''
    showCursor(true)
    chatSettings.inputShow = true
    messageIndex = 0
    ignoreToClose = getTickCount() + 100
end

function enterInput(key)
    if getTickCount() < ignoreToClose then
        return
    end

    local msg = removeHex(labels['chatinput'])

    selectedLabel = false
    selectStart = false
    selectStop = false
    caretPosition = 0

    labels['chatinput'] = ''
    showCursor(false)

	chatSettings.inputShow = false

    if utf8.len(msg) > 0 then
        if chatSettings.oldMessages[#chatSettings.oldMessages] ~= msg then
            table.insert(chatSettings.oldMessages, msg)
        end
        if utf8.sub(msg, 1, 1) == '/' and chatSettings.type == "IC" then
            local command, arguments = getCommandArguments(msg)
            if command == 'cleardebug' then
                clearDebugBox()
                return
            end
            if clientSideCommands[command] then
                executeCommandHandler(command, table.concat(arguments, ' '))
                -- return
            end
        end
        triggerServerEvent('onClientSendMessage', resourceRoot, chatSettings.type, msg)
    end
end

addEventHandler('onClientKey', root, function(key)
    if key == 'escape' and chatSettings.inputShow then
        if getTickCount() < ignoreToClose then
            return
        end

        selectedLabel = false
        selectStart = false
        selectStop = false
        caretPosition = 0

        labels['chatinput'] = ''
		showCursor(false)
        chatSettings.inputShow = false

        cancelEvent()
	elseif chatSettings.inputShow then
		cancelEvent()
    end
end)

addKeyCallback('arrow_d', function()
    if chatSettings.inputShow then
        messageIndex = math.max(messageIndex - 1, 0)
        local message = chatSettings.oldMessages[(#chatSettings.oldMessages + 1) - messageIndex]
        if message then
            labels['chatinput'] = message
            caretPosition = utf8.len(message)
        else
            labels['chatinput'] = ''
            caretPosition = 0
        end
    end
end)

addKeyCallback('arrow_u', function()
    if chatSettings.inputShow then
        messageIndex = math.min(messageIndex + 1, #chatSettings.oldMessages)

        local message = chatSettings.oldMessages[(#chatSettings.oldMessages + 1) - messageIndex]
        if message then
            labels['chatinput'] = message
            caretPosition = utf8.len(message)
        end
    end
end)