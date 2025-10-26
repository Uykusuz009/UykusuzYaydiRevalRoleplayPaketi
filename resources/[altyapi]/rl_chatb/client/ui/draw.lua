function renderChat()
    checkAndCloseChat()
end

function checkAndCloseChat()
    if chatSettings.inputShow then
        drawChatInput(inputX, inputY, inputWidth, inputHeight)
		setElementData(localPlayer, 'writting', true)
	else
		setElementData(localPlayer, 'writting', false)
    end
end

function drawChatInput(x, y, w, h)
    drawRoundedRectangle(x, y, w, h, tocolor(0, 0, 0, 100), 5 * psy)
	rectangle(x, y, w, h, tocolor(0, 0, 0, 50),{0.1,0.1,0.1,0.1}, true)
    dxDrawText(chatSettings.type, x + (10 * psx), y, x, y + h, tocolor(255, 255, 255, 255), 1, chatSettings.inputFont, 'left', 'center')
    local typeWidth = dxGetTextWidth(chatSettings.type, 1, chatSettings.inputFont)
    drawLabel('chatinput', '', x + (15 * psx) + typeWidth + (5 * psx), y, w - ((20 * psx) + typeWidth + (5 * psx)), h, tocolor(255, 255, 255, 225), chatSettings.inputFont, true)
	
	if chatSettings.type == 'IC' then
		commandlist(x, y + 40, w, h)
	end
	
    if getKeyState('enter') or getKeyState('num_enter') then
        enterInput('enter')
    end
end