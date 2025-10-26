local screenSize = Vector2(guiGetScreenSize())
local theme = exports.rl_ui:useTheme()
local fonts = exports.rl_ui:useFonts()
local showLogMenu = false
local currentLogType = nil
local currentPage = 1
local logsPerPage = 10
local currentLogs = {}
local searchText = ""
local isSearchActive = false
local filteredLogs = {}
local cursorBlinkTimer = 0
local showTextCursor = true
local function escapePattern(str)
    local escaped = string.gsub(str, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    return escaped
end
local function performSearch()
    if searchText == "" then
        filteredLogs = currentLogs 
        return
    end

    filteredLogs = {}
    local searchLower = string.lower(escapePattern(searchText))
    
    for _, log in ipairs(currentLogs) do
        local timestamp = string.lower(log.timestamp or "")
        local admin = string.lower(log.admin or "")
        local target = string.lower(log.target or "")
        local reason = string.lower(log.reason or "")
        if string.find(timestamp, searchLower, 1, true) or
           string.find(admin, searchLower, 1, true) or
           string.find(target, searchLower, 1, true) or
           string.find(reason, searchLower, 1, true)
        then
            table.insert(filteredLogs, log)
        end
    end
    
    currentPage = 1 
end
addCommandHandler("dxlog", function()
    if exports.rl_integration:isPlayerManager(localPlayer) then
        showLogMenu = not showLogMenu
        if showLogMenu then
            showCursor(true)
        else
            showCursor(false)
        end
    else
        outputChatBox("[!] #FFFFFFBu komutu kullanmak için Manager yetkisine sahip olmanız gerekiyor.", 255, 0, 0, true)
    end
end)
addEvent("receiveDxLogs", true)
addEventHandler("receiveDxLogs", localPlayer, function(logs)
    currentLogs = logs
    currentPage = 1
end)
addEventHandler("onClientRender", root, function()
    if not showLogMenu then return end
    if not exports.rl_integration:isPlayerManager(localPlayer) then
        triggerServerEvent("notifyAdminsAboutDxHack", localPlayer)
        showLogMenu = false
        showCursor(false)
        return
    end
    local logPanelSize = {x = 1000, y = 600}
    local logPanelPos = {
        x = (screenSize.x - logPanelSize.x) / 2,
        y = (screenSize.y - logPanelSize.y) / 2
    }
    dxDrawRectangle(logPanelPos.x, logPanelPos.y, logPanelSize.x, logPanelSize.y, exports.rl_ui:rgba(theme.GRAY[900]))
    dxDrawRectangle(logPanelPos.x, logPanelPos.y - 30, logPanelSize.x, 30, exports.rl_ui:rgba(theme.GRAY[800]))
    dxDrawText("DX admin logları", logPanelPos.x + 10, logPanelPos.y - 30, logPanelPos.x + logPanelSize.x, logPanelPos.y, tocolor(255, 255, 255, 255), 1, fonts.UbuntuBold.body, "left", "center")
    local buttonWidth = 150
    local buttonHeight = 40
    local buttonSpacing = 10
    local banButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "bans" and "solid" or "outlined",
        color = "red",
        text = "Ban Logları",
    })
    local kickButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + buttonHeight + buttonSpacing + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "kicks" and "solid" or "outlined",
        color = "orange",
        text = "Kick Logları",
    })
    local gotoButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + (buttonHeight + buttonSpacing) * 2 + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "gotos" and "solid" or "outlined",
        color = "green",
        text = "Goto Logları",
    })
    local ahealButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + (buttonHeight + buttonSpacing) * 3 + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "aheals" and "solid" or "outlined",
        color = "blue",
        text = "AHeal Logları",
    })
    local gethereButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + (buttonHeight + buttonSpacing) * 4 + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "getheres" and "solid" or "outlined",
        color = "purple",
        text = "Gethere Logları",
    })
    local sehreButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + (buttonHeight + buttonSpacing) * 5 + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "sehre" and "solid" or "outlined",
        color = "orange",
        text = "Şehre Logları",
    })
    local setarmorButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + (buttonHeight + buttonSpacing) * 6 + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "setarmor" and "solid" or "outlined",
        color = "yellow",
        text = "Setarmor Logları",
    })
    local watchButton = exports.rl_ui:drawButton({
        position = {x = logPanelPos.x + 10, y = logPanelPos.y + (buttonHeight + buttonSpacing) * 7 + 10},
        size = {x = buttonWidth, y = buttonHeight},
        radius = 0,
        textProperties = {
            align = "center",
            color = "#FFFFFF",
            font = fonts.body.regular,
            scale = 1,
        },
        variant = currentLogType == "watch" and "solid" or "outlined",
        color = "blue",
        text = "Watch Logları",
        icon = "",
    })
    if not isSearchActive then 
        if banButton.pressed then
            currentLogType = "bans"
            triggerServerEvent("getDxLogs", localPlayer, "bans")
        elseif kickButton.pressed then
            currentLogType = "kicks"
            triggerServerEvent("getDxLogs", localPlayer, "kicks")
        elseif gotoButton.pressed then
            currentLogType = "gotos"
            triggerServerEvent("getDxLogs", localPlayer, "gotos")
        elseif ahealButton.pressed then
            currentLogType = "aheals"
            triggerServerEvent("getDxLogs", localPlayer, "aheals")
        elseif gethereButton.pressed then
            currentLogType = "getheres"
            triggerServerEvent("getDxLogs", localPlayer, "getheres")
        elseif sehreButton.pressed then
            currentLogType = "sehre"
            triggerServerEvent("getDxLogs", localPlayer, "sehre")
        elseif setarmorButton.pressed then
            currentLogType = "setarmor"
            triggerServerEvent("getDxLogs", localPlayer, "setarmor")
        elseif watchButton.pressed then
            currentLogType = "watch"
            triggerServerEvent("getDxLogs", localPlayer, "watch")
        end
    end
    local listX = logPanelPos.x + buttonWidth + 30
    local listY = logPanelPos.y + 10
    local listWidth = logPanelSize.x - buttonWidth - 40
    local listHeight = logPanelSize.y - 20
    if currentLogType then
        dxDrawRectangle(listX, logPanelPos.y - 30, listWidth, 30, exports.rl_ui:rgba(theme.GRAY[700]))
        if isSearchActive then
            dxDrawRectangle(listX, logPanelPos.y - 30, listWidth, 30, exports.rl_ui:rgba(theme.GRAY[600]))
            dxDrawBorder(listX, logPanelPos.y - 30, listWidth, 30, 2, exports.rl_ui:rgba(theme.BLUE[500]))
        end
        if searchText ~= "" then
            local textWidth = dxGetTextWidth(searchText, 1, fonts.body.regular)
            dxDrawText(searchText,
                listX + 10,
                logPanelPos.y - 30,
                listX + listWidth - 10,
                logPanelPos.y,
                tocolor(255, 255, 255, 255),
                1,
                fonts.body.regular,
                "left",
                "center")
            if isSearchActive then
                cursorBlinkTimer = cursorBlinkTimer + 0.05
                if cursorBlinkTimer >= 1 then
                    cursorBlinkTimer = 0
                    showTextCursor = not showTextCursor
                end
                
                if showTextCursor then
                    dxDrawRectangle(
                        listX + 10 + textWidth,
                        logPanelPos.y - 25,
                        2,
                        20,
                        tocolor(255, 255, 255, 255)
                    )
                end
            end
        else
            dxDrawText("Aramak için tıklayın...",
                listX + 10,
                logPanelPos.y - 30,
                listX + listWidth - 10,
                logPanelPos.y,
                tocolor(150, 150, 150, 255),
                1,
                fonts.body.regular,
                "left",
                "center")
        end
    end
    local logsToShow = #searchText > 0 and filteredLogs or currentLogs
    if #logsToShow > 0 then
        local startIndex = (currentPage - 1) * logsPerPage + 1
        local endIndex = math.min(startIndex + logsPerPage - 1, #logsToShow)
        for i = startIndex, endIndex do
            local log = logsToShow[i]
            local yPos = listY + ((i - startIndex) * 50)  
            dxDrawRectangle(listX + 5, yPos + 5, listWidth - 10, 45, exports.rl_ui:rgba(theme.GRAY[700]))
            dxDrawText("Admin: " .. log.admin,
                listX + 10,
                yPos + 5,
                listX + listWidth - 10,
                yPos + 25,
                tocolor(255, 255, 255, 255),
                1,
                fonts.body.regular,
                "left",
                "center")
            local logText = "Hedef: " .. log.target
            if currentLogType == "setarmor" then
                local armorValue = string.match(log.reason or "", "Zırh değeri: (%d+)")
                logText = logText .. " | Zırh: " .. (armorValue or "Bilinmiyor")
            else
                logText = logText .. " | Sebep: " .. (log.reason or "Belirtilmedi")
            end

            dxDrawText(logText,
                listX + 10,
                yPos + 25,
                listX + listWidth - 10,
                yPos + 45,
                tocolor(200, 200, 200, 255),
                1,
                fonts.body.regular,
                "left",
                "center")
            dxDrawText(log.timestamp,
                listX + 10,
                yPos + 5,
                listX + listWidth - 10,
                yPos + 25,
                tocolor(200, 200, 200, 255),
                1,
                fonts.body.regular,
                "right",
                "center")
        end
        if #logsToShow > logsPerPage and not isSearchActive then 
            if currentPage > 1 then
                local prevButton = exports.rl_ui:drawButton({
                    position = {x = listX + 5, y = listY + listHeight - 40},
                    size = {x = 100, y = 30},
                    radius = 0,
                    textProperties = {
                        align = "center",
                        color = "#FFFFFF",
                        font = fonts.body.regular,
                        scale = 1,
                    },
                    variant = "solid",
                    color = "blue",
                    text = "< Önceki",
                })
                
                if prevButton.pressed then
                    currentPage = currentPage - 1
                end
            end
            if currentPage * logsPerPage < #logsToShow then
                local nextButton = exports.rl_ui:drawButton({
                    position = {x = listX + listWidth - 105, y = listY + listHeight - 40},
                    size = {x = 100, y = 30},
                    radius = 0,
                    textProperties = {
                        align = "center",
                        color = "#FFFFFF",
                        font = fonts.body.regular,
                        scale = 1,
                    },
                    variant = "solid",
                    color = "blue",
                    text = "Sonraki >",
                })
                
                if nextButton.pressed then
                    currentPage = currentPage + 1
                end
            end
            local pageInfo = string.format("Sayfa %d / %d", currentPage, math.ceil(#logsToShow / logsPerPage))
            dxDrawText(pageInfo, 
                listX, 
                listY + listHeight - 40, 
                listX + listWidth, 
                listY + listHeight - 10, 
                tocolor(255, 255, 255, 255), 
                1, 
                fonts.body.regular, 
                "center", 
                "center")
        end
    else
        dxDrawText(currentLogType and "Bu kategoride log bulunmuyor." or "Lütfen bir kategori seçin.", 
            listX + 10, 
            listY, 
            listX + listWidth - 10, 
            listY + listHeight, 
            tocolor(255, 255, 255, 255), 
            1, 
            fonts.body.regular, 
            "center", 
            "center")
    end
end)
bindKey("escape", "down", function()
    if isSearchActive then
        isSearchActive = false 
        searchText = ""
        filteredLogs = currentLogs 
        return
    end
    
    if showLogMenu then
        showLogMenu = false
        showCursor(false)
    end
end)
addEventHandler("onClientClick", root, function(button, state, x, y)
    if not showLogMenu then return end
    
    local listX = (screenSize.x - 1000) / 2 + 180  
    local searchBoxX = listX
    local searchBoxY = (screenSize.y - 600) / 2 - 30
    local searchBoxWidth = 1000 - 180 - 110  
    local searchBoxHeight = 30
    
    if button == "left" and state == "down" then
        if x >= searchBoxX and x <= searchBoxX + searchBoxWidth and
           y >= searchBoxY and y <= searchBoxY + searchBoxHeight then
            isSearchActive = true
        else
            if isSearchActive then
                isSearchActive = false
                if searchText == "" then
                    filteredLogs = currentLogs 
                end
            end
        end
    end
end)

addEventHandler("onClientCharacter", root, function(character)
    if not isSearchActive then return end 
    
    searchText = searchText .. character
    performSearch() 
end)

addEventHandler("onClientKey", root, function(button, press)
    if not isSearchActive then return end 
    
    if press then
        if button == "backspace" then
            searchText = string.sub(searchText, 1, -2)
            performSearch() 
        end
    end
end)
function dxDrawBorder(x, y, width, height, borderWidth, color)
    dxDrawRectangle(x - borderWidth, y - borderWidth, width + (borderWidth * 2), borderWidth, color) 
    dxDrawRectangle(x - borderWidth, y + height, width + (borderWidth * 2), borderWidth, color) 
    dxDrawRectangle(x - borderWidth, y, borderWidth, height, color) 
    dxDrawRectangle(x + width, y, borderWidth, height, color) 
end
