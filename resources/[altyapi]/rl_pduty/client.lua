local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 1000, 655
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2

local theme = exports.rl_ui:useTheme()
local fonts = {
    titleIcon = exports.rl_fonts:getFont("FontAwesome", 23),
    title = exports.rl_fonts:getFont("sf-bold", 16),
    description = exports.rl_fonts:getFont("sf-regular", 11)
}

local panel = false

local col = createColSphere(1578.759765625, -1684.517578125, 16.1953125, 5)

local dutyMarker = exports.rl_marker:createCustomMarker(1578.55859375, -1685.4052734375, 16.1953125 - 1, "cylinder", 0.55, 255, 255, 255, 'arrow')

local pdSkins = {
    {id = 265, name = "PD Skin 1"},
    {id = 266, name = "PD Skin 2"},
    {id = 267, name = "PD Skin 3"},
    {id = 280, name = "PD Skin 4"},
    {id = 281, name = "PD Skin 5"},
    {id = 282, name = "PD Skin 6"},
    {id = 283, name = "PD Skin 7"},
    {id = 284, name = "PD Skin 8"},
    {id = 285, name = "PD Skin 9"},
    {id = 286, name = "PD Skin 10"},
}

local currentIndex = 1
local kelepceMiktar = 1 -- Başlangıçta 1 kelepçe

function dxDrawRoundedRectangle(x, y, w, h, radius, color, postGUI)
    radius = radius or 10
    dxDrawRectangle(x + radius, y, w - radius * 2, h, color, postGUI)
    dxDrawRectangle(x, y + radius, radius, h - radius * 2, color, postGUI)
    dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color, postGUI)
    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color, color, 7, 1, postGUI)
    dxDrawCircle(x + w - radius, y + radius, radius, 270, 360, color, color, 7, 1, postGUI)
    dxDrawCircle(x + radius, y + h - radius, radius, 90, 180, color, color, 7, 1, postGUI)
    dxDrawCircle(x + w - radius, y + h - radius, radius, 0, 90, color, color, 7, 1, postGUI)
end

addCommandHandler("duty", function()
    if getElementData(localPlayer, "logged") and isElementWithinColShape(localPlayer, col) then
        local dutyLevel = getElementData(localPlayer, "duty")
        local dutyPerk = tonumber(getElementData(localPlayer, "custom_duty")) 
        local pdFaction = getElementData(localPlayer, "faction")
        if not dutyLevel or dutyLevel == 0 or dutyPerk < 1 or pdFaction ~= 1 then
            if pdFaction ~= 1 then
                outputChatBox(">> #d0d0d0Polis olmadığınız için duty paneline erişemezsiniz!", 255, 0, 0, true)
                return
            end

            if getElementData(localPlayer, "duty") == 1 then
                triggerServerEvent("customduty:offduty", localPlayer, localPlayer)
            return end

        if not isTimer(renderTimer) then
            showCursor(true)
            showChat(false)
            guiSetInputMode("no_binds_when_editing")

            skinId = pdSkins[currentIndex].id

            setTimer(function()
                setElementModel(dutyPed, skinId)
            end, 0, 0)

            dutyPed = createPed(skinId, 0, 0, 0)

            dutyPedPreview = exports["rl_object-preview"]:createObjectPreview(dutyPed, 0, 0, 0, screenX + 600, screenY + 155, 330, 330, false, true)
            exports["rl_object-preview"]:setAlpha(dutyPedPreview, 255)
            exports["rl_object-preview"]:setRotation(dutyPedPreview, 0, 0, 180)

            local skinEk = true

            renderTimer = setTimer(function()
                local playernamebuba = getPlayerName(localPlayer)

                dxDrawRoundedRectangle(screenX, screenY, sizeX, sizeY, 15, tocolor(17, 17, 17, 155))
                dxDrawText("İstanbul Emniyet Müdürlüğü - Görev Arayüzü | Görevli: "..playernamebuba, screenX + 90, screenY + 20, sizeX, sizeY, tocolor(255, 255, 255, 244), 1, fonts.title)

                dxDrawText("Görev Kıyafeti", screenX + 678, screenY + 101, sizeX, sizeY, tocolor(255, 255, 255, 244), 1, fonts.title)

                dxDrawText("Teçhizat Listesi", screenX + 101, screenY + 101, sizeX, sizeY, tocolor(255, 255, 255, 244), 1, fonts.title)

				dxDrawText(
					"Silah Listesi",
					screenX + 101,
					screenY,
					screenX + sizeX + 100,
					screenY + sizeY,
					tocolor(255, 255, 255, 244),
					1,
					fonts.title,
					"left",   -- yatay ortalama
					"center"    -- dikey ortalama
				)

               -- dxDrawRectangle(sizeX - 540,sizeY - 385, 1000, 2, tocolor(255,255,255,100))
                
                local baslaButton = exports.rl_ui:drawButton({
                    position = {
                        x = screenX + 525,
                        y = screenY + 590
                    },
                    size = {
                        x = sizeX - 888,
                        y = 40
                    },
                    radius = DEFAULT_RADIUS,
                    variant = "rounded",
                    alpha = 300,

                    color = "gray",
                    disabled = false,

                    text = "Göreve Başla",
                    icon = "",

                    postGUI = false
                })

                local kapatButton = exports.rl_ui:drawButton({
                    position = {
                        x = screenX + 382,
                        y = screenY + 590
                    },
                    size = {
                        x = sizeX - 888,
                        y = 40
                    },
                    radius = DEFAULT_RADIUS,
                    variant = "rounded",
                    alpha = 300,

                    color = "gray",
                    disabled = false,

                    text = "Kapat",
                    icon = "",

                    postGUI = false
                })

                local solButton = exports.rl_ui:drawButton({
                    position = {
                        x = screenX + 600,
                        y = screenY + 277
                    },
                    size = {
                        x = sizeX - 944,
                        y = 40
                    },
                    radius = DEFAULT_RADIUS,
                    variant = "rounded",
                    alpha = 0,

                    color = "green",
                    disabled = false,

                    text = "<",
                    icon = "",

                    postGUI = false
                })

                local sagButton = exports.rl_ui:drawButton({
                    position = {
                        x = screenX + 900,
                        y = screenY + 277
                    },
                    size = {
                        x = sizeX - 944,
                        y = 40
                    },
                    radius = DEFAULT_RADIUS,
                    variant = "rounded",
                    alpha = 0,

                    color = "green",
                    disabled = false,

                    text = ">",
                    icon = "",

                    postGUI = false
                })

                -- Kelepçe miktar seçici için oklar
                local kelepceSolButton = exports.rl_ui:drawButton({
                    position = {
                        x = screenX + 195,
                        y = screenY + 155
                    },
                    size = {
                        x = 20,
                        y = 20
                    },
                    radius = DEFAULT_RADIUS,
                    variant = "rounded",
                    alpha = 0,

                    color = "gray",
                    disabled = (kelepceMiktar <= 1),

                    text = "<",
                    icon = "",

                    postGUI = false
                })

                local kelepceSagButton = exports.rl_ui:drawButton({
                    position = {
                        x = screenX + 245,
                        y = screenY + 155
                    },
                    size = {
                        x = 20,
                        y = 20
                    },
                    radius = DEFAULT_RADIUS,
                    variant = "rounded",
                    alpha = 0,

                    color = "gray",
                    disabled = (kelepceMiktar >= 8),

                    text = ">",
                    icon = "",

                    postGUI = false
                })

                -- Kelepçe miktarını göster
                dxDrawText("< " .. kelepceMiktar .. " >", screenX + 200, screenY + 155, screenX + 265, screenY + 175, tocolor(255, 255, 255, 255), 1, fonts.description, "center", "center")

                local kelepceCheckbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 155
                    },
                    size = 20,
        
                    name = "kelepceCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "Kelepçe",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                local kemerCheckbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 182
                    },
                    size = 20,
        
                    name = "kemerCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "Teçhizat Kemeri",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                local telsizCheckbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 209
                    },
                    size = 20,
        
                    name = "telsizCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "Telsiz",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                local jopCheckbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 236
                    },
                    size = 20,
        
                    name = "jopCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "Jop",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                -- Silah Checkbox

                local deagleCheckbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 355
                    },
                    size = 20,
        
                    name = "deagleCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "Deagle",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                local mp5Checkbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 382
                    },
                    size = 20,
        
                    name = "mpCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "MP5",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                local shotgunCheckbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 409
                    },
                    size = 20,
        
                    name = "shotgunCheckbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "Shotgun",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })

                local m4Checkbox = exports.rl_authui:drawCheckbox({
                    position = {
                        x = screenX + 105,
                        y = screenY + 436
                    },
                    size = 20,
        
                    name = "m4Checkbox",
                    regex = "^[a-zA-Z0-9_.@-]*$",
                    
                    disabled = false,
                    text = "M4",
                    helperText = {
                        text = "",
                        color = theme.GRAY[200],
                    },
        
                    variant = "soft",
                    color = "gray",
        
                    disabled = not loading
                })
                
                if baslaButton.pressed then
                    killTimer(renderTimer)
                    showCursor(false)
                    showChat(true)
                    exports["rl_object-preview"]:destroyObjectPreview(dutyPedPreview)
                    destroyElement(dutyPed)

                    triggerServerEvent("görevBasladi", localPlayer, localPlayer)
                    triggerServerEvent("duty-ui:equipOutfit", localPlayer, localPlayer, skinId)

                    if kelepceCheckbox.checked then
                        triggerServerEvent("kelepceCheckedBro", localPlayer, localPlayer, kelepceMiktar)
                    end

                    if kemerCheckbox.checked then
                        triggerServerEvent("kemerCheckedBro", localPlayer, localPlayer)
                    end
    
                    if telsizCheckbox.checked then
                        triggerServerEvent("telsizCheckedBro", localPlayer, localPlayer)
                    end
    
                    if jopCheckbox.checked then
                        triggerServerEvent("jopCheckedBro", localPlayer, localPlayer)
                    end

                    -- Silahlar
                    if deagleCheckbox.checked then
                        triggerServerEvent("giveWeapon:deagle", localPlayer, localPlayer)
                    end
    
                    if mp5Checkbox.checked then
                        triggerServerEvent("giveWeapon:mp5", localPlayer, localPlayer)
                    end
    
                    if shotgunCheckbox.checked then
                        triggerServerEvent("giveWeapon:shotgun", localPlayer, localPlayer)
                    end
    
                    if m4Checkbox.checked then
                        triggerServerEvent("giveWeapon:m4", localPlayer, localPlayer)
                    end
                end

                if kapatButton.pressed then
                    killTimer(renderTimer)
                    showCursor(false)
                    showChat(true)
                    exports["rl_object-preview"]:destroyObjectPreview(dutyPedPreview)
                    destroyElement(dutyPed)
                end

                if solButton.pressed then
                    currentIndex = currentIndex - 1
                    if currentIndex < 1 then
                        currentIndex = #pdSkins
                    end
                    skinId = pdSkins[currentIndex].id
                end

                if sagButton.pressed then
                    currentIndex = currentIndex + 1
                    if currentIndex > #pdSkins then
                        currentIndex = 1
                    end
                    skinId = pdSkins[currentIndex].id
                end

                -- Kelepçe miktar butonları
                if kelepceSolButton.pressed and kelepceMiktar > 1 then
                    kelepceMiktar = kelepceMiktar - 1
                end

                if kelepceSagButton.pressed and kelepceMiktar < 8 then
                    kelepceMiktar = kelepceMiktar + 1
                end

            end, 0, 0)
        else
            killTimer(renderTimer)
            showCursor(false)
            showChat(true)
            exports["rl_object-preview"]:destroyObjectPreview(dutyPedPreview)
            destroyElement(dutyPed)
        end
        else
            -- Mevcut kod...
        end
    end
end)