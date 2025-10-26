local screenSize = Vector2(guiGetScreenSize())

local theme = exports.rl_ui:useTheme()
local fonts = exports.rl_ui:useFonts()

local containerSize = {
    x = 1000,
    y = 800
}

local pageSize = 30
local currentPage = 1

local clickTick = 0

local scrollOffset = 0
local maxVisibleTypes = 20

local loading = false

local logs = {}
local logTypes = {}

local selectedLogType = "goto"

local playerNameFilter = ""
local inputActive = false
local inputCaretTick = 0

local clipboard = ""
local lastBackspaceTick = 0
local lastDeleteTick = 0
local backspaceHeld = false
local deleteHeld = false

addCommandHandler("logs", function()
    if exports.rl_integration:isPlayerManager(localPlayer) then
        if not isTimer(renderTimer) then
            loading = true
			currentPage = 1
			logs = {}
			logTypes = {}
            triggerServerEvent("logs.fetchLogTypes", localPlayer)
            fetchLogs(currentPage, selectedLogType)
            showCursor(true)

            addEventHandler("onClientKey", root, handleScroll)
            renderTimer = setTimer(function()
                local window = exports.rl_ui:drawWindow({
                    position = {
                        x = 0,
                        y = 0,
                    },
                    size = containerSize,

                    centered = true,

                    header = {
                        title = "Loglar",
                        close = true
                    },

                    postGUI = false
                })
				
				if window.clickedClose then
                    killTimer(renderTimer)
					removeEventHandler("onClientKey", root, handleScroll)
					showCursor(false)
                end

                if loading then
					exports.rl_ui:drawSpinner({
						position = {
							x = (screenSize.x - 128) / 2,
							y = ((screenSize.y - 128) / 2) + 25
						},
						size = 128,
						speed = 2,
						variant = "solid",
						color = "white"
					})
				else
					local logTypeButtonY = window.y
					local startIndex = math.max(1, scrollOffset + 1)
					local endIndex = math.min(#logTypes, scrollOffset + maxVisibleTypes)

					for i = startIndex, endIndex do
						local logType = logTypes[i]
						local isSelected = selectedLogType == logType
						
						local button = exports.rl_ui:drawButton({
							position = {
								x = window.x,
								y = logTypeButtonY
							},
							size = {
								x = 100,
								y = 30
							},

							radius = DEFAULT_RADIUS,
							variant = "rounded",
							alpha = 300,

							color = isSelected and "green" or "gray",
							disabled = loading,

							text = logType
						})
						
						if button.pressed and selectedLogType ~= logType and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							loading = true
							logs = {}
							selectedLogType = logType
							currentPage = 1
							fetchLogs(currentPage, selectedLogType)
						end

						logTypeButtonY = logTypeButtonY + 35
					end

					local scrollBarHeight = containerSize.y - 100
					local scrollThumbHeight = math.max(30, scrollBarHeight * (maxVisibleTypes / #logTypes))
					local scrollThumbY = window.y + (scrollBarHeight - scrollThumbHeight) * (scrollOffset / math.max(1, #logTypes - maxVisibleTypes))
					dxDrawRectangle(window.x + 105, window.y, 10, scrollBarHeight, exports.rl_ui:rgba(theme.GRAY[800]))
					dxDrawRectangle(window.x + 105, scrollThumbY, 10, scrollThumbHeight, exports.rl_ui:rgba(theme.GRAY[600]))

					-- Loglar listesi çizimi
					local logY = window.y
					for i = 1, #logs do
						local log = logs[i]
						if log then
							local lines = split(log.message, "\n")
							for _, line in ipairs(lines) do
								dxDrawText(log.timestamp .. " - " .. line, window.x + 120, logY, 0, 0, tocolor(255, 255, 255, 255), 1, fonts.UbuntuRegular.caption)
								logY = logY + 20
							end
						end
					end

					-- Sayfa butonları
					if currentPage > 1 then
						local button = exports.rl_ui:drawButton({
							position = {
								x = window.x,
								y = window.y + containerSize.y - 90
							},
							size = {
								x = 140,
								y = 30
							},

							radius = DEFAULT_RADIUS,
							variant = "rounded",
							alpha = 300,
							
							color = "green",
							disabled = loading,

							text = "Öncesi"
						})
						
						if button.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							loading = true
							logs = {}
							currentPage = currentPage - 1
							fetchLogs(currentPage, selectedLogType)
						end
					end
					
					if #logs == pageSize then
						local button = exports.rl_ui:drawButton({
							position = {
								x = window.x + containerSize.x - 160,
								y = window.y + containerSize.y - 90
							},
							size = {
								x = 140,
								y = 30
							},

							radius = DEFAULT_RADIUS,
							variant = "rounded",
							alpha = 300,
							
							color = "green",
							disabled = loading,

							text = "Sonraki"
						})
						
						if button.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							loading = true
							logs = {}
							currentPage = currentPage + 1
							fetchLogs(currentPage, selectedLogType)
						end
					end
				end

				-- İsim filtresi input alanı
				local inputY = window.y + containerSize.y - 45
				local inputX = window.x + 120
				local inputW = containerSize.x - 240
				local inputH = 30

				-- Input kutusu çizimi
				dxDrawRectangle(inputX, inputY, inputW, inputH, exports.rl_ui:rgba(theme.GRAY[800]))
				local caret = ""
				if inputActive and getTickCount() % 1000 < 500 then
					caret = "|"
				end
				dxDrawText("İsim filtrele: " .. playerNameFilter .. caret, inputX + 10, inputY, inputX + inputW, inputY + inputH, tocolor(255,255,255,255), 1, fonts.UbuntuRegular.caption, "left", "center")

				-- Inputa tıklama kontrolü
				if not inputActive and getKeyState("mouse1") then
					local cx, cy = getCursorPosition()
					if cx then
						cx = cx * screenSize.x
						cy = cy * screenSize.y
						if cx >= inputX and cx <= inputX + inputW and cy >= inputY and cy <= inputY + inputH then
							inputActive = true
							setTimer(function() inputActive = true end, 100, 1)
						else
							inputActive = false
						end
					end
				end
            end, 0, 0)
        else
            killTimer(renderTimer)
            removeEventHandler("onClientKey", root, handleScroll)
            showCursor(false)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", 255, 0, 0, true)
        playSoundFrontEnd(4)
    end
end, false, false)

function handleScroll(key, state)
    if key == "mouse_wheel_up" then
        scrollOffset = math.max(0, scrollOffset - 1)
    elseif key == "mouse_wheel_down" then
        scrollOffset = math.min(#logTypes - maxVisibleTypes, scrollOffset + 1)
    end
end

addEventHandler("onClientKey", root, function(button, press)
    if inputActive then
        -- Kopyala (Ctrl+C)
        if getKeyState("lctrl") or getKeyState("rctrl") then
            if press and button == "c" then
                setClipboard(playerNameFilter)
                cancelEvent()
            elseif press and button == "v" then
                local clip = getClipboard() or ""
                if utf8.len(playerNameFilter .. clip) <= 32 then
                    playerNameFilter = playerNameFilter .. clip
                else
                    playerNameFilter = utf8.sub(playerNameFilter .. clip, 1, 32)
                end
                cancelEvent()
            elseif press and button == "a" then
                -- Tümünü seç (mantıksal olarak, metni seçili yapmıyoruz ama kopyala/x ile uyumlu)
                -- Seçili mantığı yok, sadece kopyala/x ile tümünü kullanıyoruz
                cancelEvent()
            elseif press and button == "x" then
                setClipboard(playerNameFilter)
                playerNameFilter = ""
                cancelEvent()
            end
        end

        -- Backspace hızlı silme
        if button == "backspace" then
            if press then
                playerNameFilter = utf8.sub(playerNameFilter, 1, -2)
                lastBackspaceTick = getTickCount()
                backspaceHeld = true
            else
                backspaceHeld = false
            end
            cancelEvent()
        end

        -- Delete hızlı silme (imleç sonunda olduğu için backspace ile aynı davranır)
        if button == "delete" then
            if press then
                -- İmleç sonunda, delete ile bir şey silinmez
                lastDeleteTick = getTickCount()
                deleteHeld = true
            else
                deleteHeld = false
            end
            cancelEvent()
        end

        -- Enter ve Tab
        if press and button == "enter" then
            loading = true
            logs = {}
            currentPage = 1
            fetchLogs(currentPage, selectedLogType, playerNameFilter)
            inputActive = false
            cancelEvent()
        elseif press and button == "tab" then
            inputActive = false
            cancelEvent()
        end
    end
end)

addEventHandler("onClientRender", root, function()
    if inputActive then
        -- Backspace hızlı silme
        if backspaceHeld and getKeyState("backspace") then
            if getTickCount() - lastBackspaceTick > 350 then
                playerNameFilter = utf8.sub(playerNameFilter, 1, -2)
                lastBackspaceTick = getTickCount() - 250 -- hızlandırmak için
            end
        end
        -- Delete hızlı silme (imleç sonunda olduğu için bir şey yapmaz)
        -- Eğer imleç ortada olsaydı, burada delete işlemi yapılabilirdi
    end
end)

addEventHandler("onClientCharacter", root, function(char)
    if inputActive then
        if utf8.len(playerNameFilter) < 32 then
            playerNameFilter = playerNameFilter .. char
        end
        cancelEvent()
    end
end)

addEventHandler("onClientKey", root, function(button, press)
    if inputActive and press then
        if button == "backspace" then
            playerNameFilter = utf8.sub(playerNameFilter, 1, -2)
            cancelEvent()
        elseif button == "enter" then
            loading = true
            logs = {}
            currentPage = 1
            fetchLogs(currentPage, selectedLogType, playerNameFilter)
            inputActive = false
            cancelEvent()
        elseif button == "tab" then
            inputActive = false
            cancelEvent()
        end
    end
end)

function fetchLogs(page, logType, playerName)
    if logType == "joinquit" then
        pageSize = 10
    else
        pageSize = 35
    end
    -- Sadece yetkili ismine göre filtrele
    triggerServerEvent("logs.fetchLogs", localPlayer, page, pageSize, logType, playerName or playerNameFilter)
end

addEvent("logs.receiveLogs", true)
addEventHandler("logs.receiveLogs", root, function(_logs)
    -- Filtre: admin veya message alanında aranan metin geçiyorsa göster (case-insensitive)
    if playerNameFilter ~= "" then
        local filtered = {}
        local filterLower = string.lower(playerNameFilter)
        for _, log in ipairs(_logs) do
            local adminStr = log.admin and string.lower(log.admin) or ""
            local msgStr = log.message and string.lower(log.message) or ""
            if string.find(adminStr, filterLower, 1, true) or string.find(msgStr, filterLower, 1, true) then
                table.insert(filtered, log)
            end
        end
        logs = filtered
    else
        logs = _logs
    end
    loading = false
end)

addEvent("logs.receiveLogTypes", true)
addEventHandler("logs.receiveLogTypes", root, function(_logTypes)
    logTypes = _logTypes
end)

function split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end