local screenSize = Vector2(guiGetScreenSize())
local theme = exports.rl_ui:useTheme()
local fonts = exports.rl_ui:useFonts()

local function formatPlayerName(name)
    return string.gsub(name, "_", " ")
end

local panelSize = {
    x = 300,
    y = 400
}

local panelPosition = {
    x = screenSize.x - panelSize.x - 400,
    y = (screenSize.y - panelSize.y) / 2
}

local actionPanelSize = {
    x = 300,
    y = 400
}

local actionPanelPos = {
    x = panelPosition.x + panelSize.x + 20,
    y = panelPosition.y
}

local buttonSize = {
    x = actionPanelSize.x - 40,
    y = 40
}

local clickTick = 0
local selectedPlayer = nil
local showReasonInput = false
local reasonInputType = nil
local inputText = ""

local scrollOffset = 0
local maxScroll = 0
local searchText = ""

local logButtons = {
    {text = "Ban Logları", type = "bans"},
    {text = "Kick Logları", type = "kicks"},
    {text = "Goto Logları", type = "gotos"},
    {text = "Aheal Logları", type = "aheals"},
    {text = "Gethere Logları", type = "gethere"},
    {text = "Watch Logları", type = "watch"}
}

local showArmorInput = false
local armorInputText = ""
local isArmorInputSelected = true

local isSearchBoxActive = false
local searchBoxHovered = false

local banDurationText = ""
local showBanDuration = false

local isReasonInputSelected = false
local isBanDurationSelected = false

local inputPanelW, inputPanelH = 400, 200
local inputPanelX = (screenSize.x - inputPanelW) / 2
local inputPanelY = (screenSize.y - inputPanelH) / 2

addCommandHandler("dx", function()
    local adminLevel = getElementData(localPlayer, "admin_level") or 0
    
    if adminLevel < 1 then
        outputChatBox("[!]#FFFFFF Bu komutu kullanmak için yetkiniz bulunmuyor.", 255, 0, 0, true)
        return
    end

    if not isTimer(renderTimer) then
        showCursor(true)
        guiSetInputMode("allow_binds")
        
        renderTimer = setTimer(function()
            dxDrawRectangle(panelPosition.x, panelPosition.y, panelSize.x, panelSize.y, exports.rl_ui:rgba(theme.GRAY[900]))
            
            dxDrawRectangle(panelPosition.x, panelPosition.y - 30, panelSize.x, 30, exports.rl_ui:rgba(theme.GRAY[800]))
            dxDrawText("Oyuncu Listesi", panelPosition.x + 10, panelPosition.y - 30, panelPosition.x + panelSize.x, panelPosition.y, tocolor(255, 255, 255, 255), 1, fonts.UbuntuBold.body, "left", "center")
            
            local mouseX, mouseY = getCursorPosition()
            if mouseX then
                mouseX, mouseY = mouseX * screenSize.x, mouseY * screenSize.y
                searchBoxHovered = mouseX >= panelPosition.x + 10 and mouseX <= panelPosition.x + panelSize.x - 10 and
                                  mouseY >= panelPosition.y + 10 and mouseY <= panelPosition.y + 50
            else
                searchBoxHovered = false
            end

            dxDrawRectangle(panelPosition.x + 10, panelPosition.y + 10, panelSize.x - 20, 40, 
                exports.rl_ui:rgba(theme.GRAY[searchBoxHovered and 700 or 800]))

            local borderColor = isSearchBoxActive and tocolor(0, 150, 255, 255) or 
                               (searchBoxHovered and tocolor(200, 200, 200, 255) or tocolor(255, 255, 255, 255))

            dxDrawLine(panelPosition.x + 10, panelPosition.y + 10, panelPosition.x + panelSize.x - 10, panelPosition.y + 10, borderColor, 1)
            dxDrawLine(panelPosition.x + 10, panelPosition.y + 50, panelPosition.x + panelSize.x - 10, panelPosition.y + 50, borderColor, 1)
            dxDrawLine(panelPosition.x + 10, panelPosition.y + 10, panelPosition.x + 10, panelPosition.y + 50, borderColor, 1)
            dxDrawLine(panelPosition.x + panelSize.x - 10, panelPosition.y + 10, panelPosition.x + panelSize.x - 10, panelPosition.y + 50, borderColor, 1)

            local searchDisplayText = isSearchBoxActive and (searchText == "" and "Aramak için yazın..." or searchText) or "Oyuncu ara..."
            local textColor = isSearchBoxActive and (searchText == "" and tocolor(150, 150, 150, 255) or tocolor(255, 255, 255, 255)) 
                             or tocolor(150, 150, 150, 255)

            dxDrawText(searchDisplayText, 
                panelPosition.x + 20, panelPosition.y + 10, 
                panelPosition.x + panelSize.x - 20, panelPosition.y + 50, 
                textColor, 
                1, fonts.body.regular, "left", "center")

            if isSearchBoxActive and searchText ~= "" then
                local cursorBlink = getTickCount() % 1000 < 500
                if cursorBlink then
                    local textWidth = dxGetTextWidth(searchText, 1, fonts.body.regular)
                    dxDrawLine(
                        panelPosition.x + 20 + textWidth,
                        panelPosition.y + 20,
                        panelPosition.x + 20 + textWidth,
                        panelPosition.y + 40,
                        tocolor(255, 255, 255, 255),
                        1
                    )
                end
            end

            local listContainerHovered = mouseX and mouseY and
                mouseX >= panelPosition.x + 10 and mouseX <= panelPosition.x + panelSize.x - 10 and
                mouseY >= panelPosition.y + 60 and mouseY <= panelPosition.y + panelSize.y - 10

            dxDrawRectangle(panelPosition.x + 10, panelPosition.y + 60, panelSize.x - 20, panelSize.y - 70, exports.rl_ui:rgba(theme.GRAY[800]))

            local listBorderColor = listContainerHovered and tocolor(200, 200, 200, 255) or tocolor(255, 255, 255, 255)

            dxDrawLine(panelPosition.x + 10, panelPosition.y + 60, panelPosition.x + panelSize.x - 10, panelPosition.y + 60, listBorderColor, 1)
            dxDrawLine(panelPosition.x + 10, panelPosition.y + panelSize.y - 10, panelPosition.x + panelSize.x - 10, panelPosition.y + panelSize.y - 10, listBorderColor, 1)
            dxDrawLine(panelPosition.x + 10, panelPosition.y + 60, panelPosition.x + 10, panelPosition.y + panelSize.y - 10, listBorderColor, 1)
            dxDrawLine(panelPosition.x + panelSize.x - 10, panelPosition.y + 60, panelPosition.x + panelSize.x - 10, panelPosition.y + panelSize.y - 10, listBorderColor, 1)
            
            local filteredPlayers = {}
            for _, player in ipairs(getElementsByType("player")) do
                local playerName = getPlayerName(player)
                if string.find(string.lower(playerName), string.lower(searchText)) then
                    table.insert(filteredPlayers, player)
                end
            end
            
            maxScroll = math.max(0, (#filteredPlayers * 40) - (panelSize.y - 80))
            
            local startY = panelPosition.y + 70 - scrollOffset
            for _, player in ipairs(filteredPlayers) do
                if startY + 40 >= panelPosition.y + 60 and startY <= panelPosition.y + panelSize.y - 10 then
                    local isSelected = selectedPlayer == player
                    
                    local playerButton = exports.rl_ui:drawButton({
                        position = {x = panelPosition.x + 20, y = startY},
                        size = {x = panelSize.x - 40, y = 30},
                        radius = 0,
                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.body.regular,
                            scale = 1,
                            padding = 0,
                        },
                        variant = isSelected and "solid" or "outlined",
                        color = isSelected and "blue" or "white",
                        text = formatPlayerName(getPlayerName(player)),
                        icon = "",
                    })
                    
                    if playerButton.pressed and clickTick + 500 <= getTickCount() then
                        clickTick = getTickCount()
                        selectedPlayer = player
                    end
                end
                
                startY = startY + 40
            end
            
            if selectedPlayer then
                dxDrawRectangle(actionPanelPos.x, panelPosition.y - 30, actionPanelSize.x, 30, exports.rl_ui:rgba(theme.GRAY[800]))
                dxDrawText("İşlemler", actionPanelPos.x + 10, panelPosition.y - 30, actionPanelPos.x + actionPanelSize.x, panelPosition.y, tocolor(255, 255, 255, 255), 1, fonts.UbuntuBold.body, "left", "center")
                
                local newButtonSize = {
                    x = (actionPanelSize.x - 40) / 3,
                    y = 40
                }
                
                local gotoButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + 10, y = panelPosition.y + 20},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "green", text = "Goto", icon = "",
                })
                
                local banButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + newButtonSize.x + 15, y = panelPosition.y + 20},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "red", text = "Ban", icon = "",
                })
                
                local kickButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + (newButtonSize.x * 2) + 20, y = panelPosition.y + 20},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "orange", text = "Kick", icon = "",
                })

                local setarmorButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + 10, y = panelPosition.y + 120},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "yellow", text = "Setarmor", icon = "",
                })

                if setarmorButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    showArmorInput = true
                    armorInputText = ""
                end

                local gethereButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + newButtonSize.x + 15, y = panelPosition.y + 70},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "purple", text = "Gethere", icon = "",
                })

                local sehreButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + (newButtonSize.x * 2) + 20, y = panelPosition.y + 70},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "orange", text = "Şehre", icon = "",
                })

                if gotoButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    triggerServerEvent("teleportToPlayer", localPlayer, selectedPlayer)
                    killTimer(renderTimer)
                    showCursor(false)
                end
                
                if banButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    showReasonInput = true
                    reasonInputType = "ban"
                    inputText = ""
                end
                
                if kickButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    showReasonInput = true
                    reasonInputType = "kick"
                    inputText = ""
                end

                local ahealButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + 10, y = panelPosition.y + 70},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "blue", text = "Aheal", icon = "",
                })

                if ahealButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    local adminName = getPlayerName(localPlayer)
                    local targetName = getPlayerName(selectedPlayer)
                    triggerServerEvent("ahealPlayer", localPlayer, selectedPlayer, adminName, targetName)
                    killTimer(renderTimer)
                    showCursor(false)
                end

                if gethereButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    local adminName = getPlayerName(localPlayer)
                    local targetName = getPlayerName(selectedPlayer)
                    triggerServerEvent("getherePlayer", localPlayer, selectedPlayer, adminName, targetName)
                    killTimer(renderTimer)
                    showCursor(false)
                end

                if sehreButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    local adminName = getPlayerName(localPlayer)
                    local targetName = getPlayerName(selectedPlayer)
                    triggerServerEvent("sehrePlayer", localPlayer, selectedPlayer, adminName, targetName)
                    killTimer(renderTimer)
                    showCursor(false)
                end

                local watchButton = exports.rl_ui:drawButton({
                    position = {x = actionPanelPos.x + newButtonSize.x + 15, y = panelPosition.y + 120},
                    size = newButtonSize,
                    radius = 0,
                    textProperties = {align = "center", color = "#FFFFFF", font = fonts.body.regular, scale = 1},
                    variant = "solid", color = "purple", text = "Watch", icon = "",
                })

                if watchButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    
                    if selectedPlayer then
                        triggerServerEvent("startWatchingPlayer", localPlayer, selectedPlayer)
                        
                        killTimer(renderTimer)
                        showCursor(false)
                        
                        local adminName = getPlayerName(localPlayer)
                        local targetName = getPlayerName(selectedPlayer)
                        triggerServerEvent("addWatchLog", localPlayer, adminName, targetName)
                    end
                end
            end
            
            if showReasonInput then
                dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))
                
                local inputPanelW, inputPanelH = 400, 200
                local inputPanelX = (screenSize.x - inputPanelW) / 2
                local inputPanelY = (screenSize.y - inputPanelH) / 2

                if not showBanDuration then
                    dxDrawText(reasonInputType == "ban" and "Ban Sebebi" or "Kick Sebebi", 
                        inputPanelX, 
                        inputPanelY + 20, 
                        inputPanelX + inputPanelW, 
                        inputPanelY + 50, 
                        tocolor(255, 255, 255, 255), 
                        1, 
                        fonts.UbuntuBold.body, 
                        "center")

                    dxDrawRectangle(inputPanelX + 20, inputPanelY + 60, inputPanelW - 40, 40, exports.rl_ui:rgba(theme.GRAY[800]))
                    
                    dxDrawLine(inputPanelX + 20, inputPanelY + 60, inputPanelX + inputPanelW - 20, inputPanelY + 60, tocolor(255, 255, 255, 255), 1)
                    dxDrawLine(inputPanelX + 20, inputPanelY + 100, inputPanelX + inputPanelW - 20, inputPanelY + 100, tocolor(255, 255, 255, 255), 1)
                    dxDrawLine(inputPanelX + 20, inputPanelY + 60, inputPanelX + 20, inputPanelY + 100, tocolor(255, 255, 255, 255), 1)
                    dxDrawLine(inputPanelX + inputPanelW - 20, inputPanelY + 60, inputPanelX + inputPanelW - 20, inputPanelY + 100, tocolor(255, 255, 255, 255), 1)

                    dxDrawText(inputText, 
                        inputPanelX + 25, 
                        inputPanelY + 60, 
                        inputPanelX + inputPanelW - 25, 
                        inputPanelY + 100, 
                        tocolor(255, 255, 255, 255), 
                        1, 
                        fonts.body.regular, 
                        "left", 
                        "center")

                    if getTickCount() % 1000 < 500 then
                        local textWidth = dxGetTextWidth(inputText, 1, fonts.body.regular)
                        dxDrawLine(
                            inputPanelX + 25 + textWidth,
                            inputPanelY + 70,
                            inputPanelX + 25 + textWidth,
                            inputPanelY + 90,
                            tocolor(255, 255, 255, 255),
                            1
                        )
                    end

                    local buttonContainerW = 320
                    local buttonX = inputPanelX + (inputPanelW - buttonContainerW) / 2
                    
                    local confirmButton = exports.rl_ui:drawButton({
                        position = {x = buttonX, y = inputPanelY + 120},
                        size = {x = 150, y = 40},
                        radius = 5,
                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.body.regular,
                            scale = 1,
                        },
                        variant = "solid",
                        color = "green",
                        text = "Onayla",
                        icon = "",
                    })

                    local cancelButton = exports.rl_ui:drawButton({
                        position = {x = buttonX + 170, y = inputPanelY + 120},
                        size = {x = 150, y = 40},
                        radius = 5,
                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.body.regular,
                            scale = 1,
                        },
                        variant = "solid",
                        color = "red",
                        text = "İptal",
                        icon = "",
                    })

                    if confirmButton.pressed and clickTick + 500 <= getTickCount() then
                        clickTick = getTickCount()
                        if reasonInputType == "ban" then
                            showBanDuration = true
                        else
                            triggerServerEvent("kickPlayer", localPlayer, selectedPlayer, inputText)
                            showReasonInput = false
                            killTimer(renderTimer)
                            showCursor(false)
                        end
                    end

                    if cancelButton.pressed and clickTick + 500 <= getTickCount() then
                        clickTick = getTickCount()
                        showReasonInput = false
                        inputText = ""
                    end

                else
                    local durationBoxWidth = 150
                    local durationBoxX = inputPanelX + (inputPanelW - durationBoxWidth) / 2
                    local durationBoxY = inputPanelY + 80

                    dxDrawText("Ban Süresi (Saat Cinsinden)\nÖrnek: 24 = 1 gün, 48 = 2 gün\n0 = Sınırsız Ban\nGirilen değer saat olarak hesaplanır.", 
                        inputPanelX, 
                        inputPanelY + 5,
                        inputPanelX + inputPanelW, 
                        durationBoxY - 10, 
                        tocolor(200, 200, 200, 255), 
                        1, 
                        fonts.body.regular, 
                        "center", 
                        "center")

                    dxDrawRectangle(durationBoxX, durationBoxY, durationBoxWidth, 35, exports.rl_ui:rgba(theme.GRAY[800]))
                    
                    dxDrawLine(durationBoxX, durationBoxY, durationBoxX + durationBoxWidth, durationBoxY, tocolor(255, 255, 255, 255), 1)
                    dxDrawLine(durationBoxX, durationBoxY + 35, durationBoxX + durationBoxWidth, durationBoxY + 35, tocolor(255, 255, 255, 255), 1)
                    dxDrawLine(durationBoxX, durationBoxY, durationBoxX, durationBoxY + 35, tocolor(255, 255, 255, 255), 1)
                    dxDrawLine(durationBoxX + durationBoxWidth, durationBoxY, durationBoxX + durationBoxWidth, durationBoxY + 35, tocolor(255, 255, 255, 255), 1)

                    dxDrawText(banDurationText, 
                        durationBoxX + 5, 
                        durationBoxY, 
                        durationBoxX + durationBoxWidth - 5, 
                        durationBoxY + 35, 
                        tocolor(255, 255, 255, 255), 
                        1,
                        fonts.body.regular,
                        "center", 
                        "center",
                        false, false, false, true)

                    if getTickCount() % 1000 < 500 then
                        local textWidth = dxGetTextWidth(banDurationText, 1, fonts.body.regular)
                        local cursorX = durationBoxX + (durationBoxWidth / 2) + (textWidth / 2) + 2
                        dxDrawRectangle(
                            cursorX,
                            durationBoxY + 8,
                            2,
                            20,
                            tocolor(255, 255, 255, 255)
                        )
                    end

                    local buttonContainerW = 320
                    local buttonX = inputPanelX + (inputPanelW - buttonContainerW) / 2

                    local banButton = exports.rl_ui:drawButton({
                        position = {x = buttonX, y = inputPanelY + 140},
                        size = {x = 150, y = 40},
                        radius = 5,
                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.body.regular,
                            scale = 1,
                        },
                        variant = "solid",
                        color = "red",
                        text = "Banla",
                        icon = "",
                    })

                    local cancelButton = exports.rl_ui:drawButton({
                        position = {x = buttonX + 170, y = inputPanelY + 140},
                        size = {x = 150, y = 40},
                        radius = 5,
                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.body.regular,
                            scale = 1,
                        },
                        variant = "solid",
                        color = "red",
                        text = "İptal",
                        icon = "",
                    })

                    if banButton.pressed and clickTick + 500 <= getTickCount() then
                        clickTick = getTickCount()
                        local duration = tonumber(banDurationText) or 0
                        triggerServerEvent("banPlayer", localPlayer, selectedPlayer, inputText, duration)
                        showReasonInput = false
                        showBanDuration = false
                        inputText = ""
                        banDurationText = ""
                        killTimer(renderTimer)
                        showCursor(false)
                    end

                    if cancelButton.pressed and clickTick + 500 <= getTickCount() then
                        clickTick = getTickCount()
                        showReasonInput = false
                        showBanDuration = false
                        inputText = ""
                        banDurationText = ""
                    end
                end
            end
            
            if showArmorInput then
                dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))
                
                local inputPanelW, inputPanelH = 400, 200
                local inputPanelX = (screenSize.x - inputPanelW) / 2
                local inputPanelY = (screenSize.y - inputPanelH) / 2
                
                local armorInputHovered = mouseX and mouseY and
                    mouseX >= inputPanelX + 20 and mouseX <= inputPanelX + inputPanelW - 20 and
                    mouseY >= inputPanelY + 60 and mouseY <= inputPanelY + 100

                dxDrawRectangle(inputPanelX + 20, inputPanelY + 60, inputPanelW - 40, 40, exports.rl_ui:rgba(theme.GRAY[800]))
                
                local armorBorderColor = armorInputHovered and tocolor(200, 200, 200, 255) or tocolor(255, 255, 255, 255)
                
                dxDrawLine(inputPanelX + 20, inputPanelY + 60, inputPanelX + inputPanelW - 20, inputPanelY + 60, armorBorderColor, 1)
                dxDrawLine(inputPanelX + 20, inputPanelY + 100, inputPanelX + inputPanelW - 20, inputPanelY + 100, armorBorderColor, 1)
                dxDrawLine(inputPanelX + 20, inputPanelY + 60, inputPanelX + 20, inputPanelY + 100, armorBorderColor, 1)
                dxDrawLine(inputPanelX + inputPanelW - 20, inputPanelY + 60, inputPanelX + inputPanelW - 20, inputPanelY + 100, armorBorderColor, 1)
                
                local cursorBlink = getTickCount() % 1000 < 500
                local textWidth = dxGetTextWidth(armorInputText, 1, fonts.body.regular)
                
                dxDrawText(armorInputText, 
                    inputPanelX + 25, 
                    inputPanelY + 60, 
                    inputPanelX + inputPanelW - 25, 
                    inputPanelY + 100, 
                    tocolor(255, 255, 255, 255), 
                    1, 
                    fonts.body.regular, 
                    "left", 
                    "center")
                
                if cursorBlink then
                    dxDrawLine(
                        inputPanelX + 25 + textWidth, 
                        inputPanelY + 70,
                        inputPanelX + 25 + textWidth, 
                        inputPanelY + 90,
                        tocolor(255, 255, 255, 255),
                        1
                    )
                end
                
                local buttonContainerW = 320
                local buttonX = inputPanelX + (inputPanelW - buttonContainerW) / 2
                
                local confirmButton = exports.rl_ui:drawButton({
                    position = {
                        x = buttonX,
                        y = inputPanelY + 120
                    },
                    size = {
                        x = 150,
                        y = 40
                    },
                    radius = 5,
                    textProperties = {
                        align = "center",
                        color = "#FFFFFF",
                        font = fonts.body.regular,
                        scale = 1,
                    },
                    variant = "solid",
                    color = "green",
                    text = "Onayla",
                    icon = "",
                })
                
                local cancelButton = exports.rl_ui:drawButton({
                    position = {
                        x = buttonX + 170,
                        y = inputPanelY + 120
                    },
                    size = {
                        x = 150,
                        y = 40
                    },
                    radius = 5,
                    textProperties = {
                        align = "center",
                        color = "#FFFFFF",
                        font = fonts.body.regular,
                        scale = 1,
                    },
                    variant = "solid",
                    color = "red",
                    text = "İptal",
                    icon = "",
                })
                
                if confirmButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    local armorValue = tonumber(armorInputText) or 0
                    if armorValue >= 0 and armorValue <= 100 then
                        local adminName = getPlayerName(localPlayer)
                        local targetName = getPlayerName(selectedPlayer)
                        triggerServerEvent("setPlayerArmor", localPlayer, selectedPlayer, armorValue, adminName, targetName)
                        showArmorInput = false
                        killTimer(renderTimer)
                        showCursor(false)
                    end
                end
                
                if cancelButton.pressed and clickTick + 500 <= getTickCount() then
                    clickTick = getTickCount()
                    showArmorInput = false
                    armorInputText = ""
                end
                
                dxDrawText("Zırh Değeri - " .. formatPlayerName(getPlayerName(selectedPlayer)), 
                    inputPanelX, 
                    inputPanelY + 20, 
                    inputPanelX + inputPanelW, 
                    inputPanelY + 50, 
                    tocolor(255, 255, 255, 255), 
                    1, 
                    fonts.UbuntuBold.body, 
                    "center")
            end
            
        end, 0, 0)
    else
        killTimer(renderTimer)
        showCursor(false)
        guiSetInputMode("allow_binds")
    end
end)

addEventHandler("onClientKey", root, function(button, press)
    if isTimer(renderTimer) then
        if button == "mouse_wheel_up" then
            scrollOffset = math.max(0, scrollOffset - 40)
        elseif button == "mouse_wheel_down" then
            scrollOffset = math.min(maxScroll, scrollOffset + 40)
        end
    end
end)

addEventHandler("onClientCharacter", root, function(character)
    if isTimer(renderTimer) then
        if showReasonInput then
            if showBanDuration then
                if string.match(character, "%d") then
                    local newValue = tonumber(banDurationText .. character)
                    if newValue and #banDurationText < 6 then
                        banDurationText = banDurationText .. character
                    end
                end
            else
                inputText = inputText .. character
            end
        elseif isSearchBoxActive then
            searchText = searchText .. character
        end
    end
end)

addEventHandler("onClientKey", root, function(button, press)
    if isTimer(renderTimer) and press then
        if showReasonInput then
            if button == "backspace" then
                if showBanDuration then
                    banDurationText = string.sub(banDurationText, 1, -2)
                else
                    inputText = string.sub(inputText, 1, -2)
                end
            end
        elseif isSearchBoxActive and button == "backspace" then
            searchText = string.sub(searchText, 1, -2)
        end
    end
end)

function viewLogs(logType)
    if logType then
        triggerServerEvent("getDxLogs", localPlayer, logType)
        
        local logHeaders = {
            bans = {"Tarih", "Admin", "Oyuncu", "Sebep"},
            kicks = {"Tarih", "Admin", "Oyuncu", "Sebep"},
            gotos = {"Tarih", "Admin", "Oyuncu", "İşlem"},
            aheals = {"Tarih", "Admin", "Oyuncu", "İşlem"},
            gethere = {"Tarih", "Admin", "Oyuncu", "İşlem"},
            watch = {"Tarih", "Admin", "Oyuncu", "İşlem"}
        }
        
        currentLogHeaders = logHeaders[logType]
    end
end

addEventHandler("onClientCharacter", root, function(character)
    if isTimer(renderTimer) and showArmorInput and isArmorInputSelected then
        if string.match(character, "%d") then
            local newValue = tonumber(armorInputText .. character)
            if newValue and newValue <= 100 then
                armorInputText = armorInputText .. character
            end
        end
    end
end)

addEventHandler("onClientKey", root, function(button, press)
    if isTimer(renderTimer) and showArmorInput and isArmorInputSelected and press then
        if button == "backspace" then
            armorInputText = string.sub(armorInputText, 1, -2)
        end
    end
end)

addEventHandler("onClientClick", root, function(button, state)
    if isTimer(renderTimer) and button == "left" and state == "down" then
        if searchBoxHovered then
            isSearchBoxActive = true
        else
            isSearchBoxActive = false
        end

        if showReasonInput then
            local reasonInputHovered = mouseX and mouseY and
                mouseX >= inputPanelX + 20 and mouseX <= inputPanelX + inputPanelW - 20 and
                mouseY >= inputPanelY + 60 and mouseY <= inputPanelY + 100
            
            local durationBoxY = inputPanelY + 80
            local durationBoxWidth = 150
            local durationBoxX = inputPanelX + (inputPanelW - durationBoxWidth) / 2
            local durationInputHovered = mouseX and mouseY and
                mouseX >= durationBoxX and mouseX <= durationBoxX + durationBoxWidth and
                mouseY >= durationBoxY and mouseY <= durationBoxY + 35

            isReasonInputSelected = reasonInputHovered
            isBanDurationSelected = reasonInputType == "ban" and durationInputHovered

            if not reasonInputHovered and not durationInputHovered then
                isReasonInputSelected = false
                isBanDurationSelected = false
            end
        end
    end
end)
