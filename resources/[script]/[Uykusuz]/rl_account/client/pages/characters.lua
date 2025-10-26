local CONTAINER_PADDING = 20
local lastClick = getTickCount()

local store = {
	currentCharacter = 1
}

local pedPosition = {
	x = -2792.0048828125,
	y = 1128.5087890625,
	z = 26.952917098999,
	rz = 332.73974609375
}

function renderCharacters()
	local characters = getElementData(localPlayer, "characters")
    local characterCount = characters and #characters or 1
	
	if not store.ped and not isElement(store.ped) then
		setCameraMatrix(-2790.62, 1131, 26.740968704224, -2836.6921386719, 1046.5139160156, 42.553817749023)
		setCameraInterior(localPlayer.interior)
        
		local ped = createPed(0, pedPosition.x, pedPosition.y, pedPosition.z, pedPosition.rz)
		ped:setFrozen(true)
		ped:setModel(characters[store.currentCharacter].skin)
		ped:setAnimation("SMOKING", "M_smkstnd_loop")
        ped:setDimension(localPlayer.dimension)
        ped:setInterior(localPlayer.interior)
        store.ped = ped
		
		if isElement(characterLight) then
			characterLight:destroy()
		end
		characterLight = createLight(0, pedPosition.x + 2, pedPosition.y, pedPosition.z, 7, 195, 195, 195, pedPosition.x, pedPosition.y, pedPosition.z, true)
		characterLight:setDimension(localPlayer.dimension)
		characterLight:setInterior(localPlayer.interior)
		
		lastClick = getTickCount()
    end
	
    local ped = store.ped

    local joinCharacterButton1 = exports.cr_ui:drawButton({
        position = {
            x = CONTAINER_PADDING,
            y = CONTAINER_PADDING
        },
        size = {
            x = 200,
            y = 35
        },

        text = "Karaktere Gir",
        icon = "",
        radius = 8,

        variant = "soft",
        color = "purple",

        disabled = not characters or loading
    })
	
	local createCharacterButton = exports.cr_ui:drawButton({
        position = {
            x = CONTAINER_PADDING,
            y = CONTAINER_PADDING + 40
        },
        size = {
            x = 200,
            y = 35
        },

        icon = "",
        text = "Karakter Oluştur",
        radius = 8,

        variant = "soft",
        color = "gray",

        disabled = not characters or loading
    })

    exports.cr_ui:drawTypography({
        position = {
            x = CONTAINER_PADDING,
            y = screenSize.y - CONTAINER_PADDING * 3
        },
        text = getElementData(localPlayer, "account_username"),
        color = theme.GRAY[200],
        scale = "h1",
        alignX = "left",
        alignY = "top",
        fontWeight = "light",
        wrap = false,
    })

    if not characters then
        exports.cr_ui:drawSpinner({
            position = {
                x = screenSize.x / 2 - 128 / 2,
                y = screenSize.y / 2 - 128 / 2
            },
            size = 128,
            color = "purple",
            speed = 1,
            variant = "soft",
        })
    end

    drawSlider({
        position = {
            x = screenSize.x / 2 - 500 / 2,
            y = screenSize.y - 200
        },
        size = {
            x = 500,
            y = 200
        },
        containerSize = {
            x = 250,
            y = 70
        },
        count = characterCount,
        current = store.currentCharacter,
        content = function()
            local row = characters and characters[store.currentCharacter]
            if row and store.ped then
                local bonePositionX, bonePositionY, bonePositionZ = getPedBonePosition(store.ped, 32)
                local x, y = getScreenFromWorldPosition(bonePositionX, bonePositionY, bonePositionZ, 0, false)

                if x and y then
                    local name = row.name:gsub("_", " ")

                    exports.cr_ui:drawList({
                        position = {
                            x = x + 100,
                            y = y
                        },
                        size = {
                            x = 200,
                            y = 200
                        },

                        padding = 15,
                        rowHeight = 30,

                        name = "characters_list",
                        header = name:upper(),
                        items = {},

                        variant = "soft",
                        color = "gray",
                    })

                    local joinCharacterButton2 = exports.cr_ui:drawButton({
                        position = {
                            x = x + 100,
                            y = y + 210
                        },
                        size = {
                            x = 200,
                            y = 35
                        },
                        text = "Karaktere Gir",
                        icon = "",
                        radius = 8,

                        variant = "soft",
                        color = "purple",

                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.h6.regular,
                            scale = 1,
                        },

                        disabled = loading,
                    })

                    if joinCharacterButton1.pressed or joinCharacterButton2.pressed or exports.cr_ui:isKeyPressed("enter") and lastClick + 300 < getTickCount() and not loading then
                        lastClick = getTickCount()
                        triggerServerEvent("account.joinCharacter", localPlayer, row.id)
						loading = true
						addEventHandler("onClientRender", root, renderQueryLoading)
                    end
                end
            end
        end,
        switch = function(current)
            if not loading then
                store.currentCharacter = current
                ped:setModel(characters[store.currentCharacter].skin)
            end
        end
    })

    if characters and not loading then
        if exports.cr_ui:isKeyPressed("arrow_l") and lastClick + 300 <= getTickCount() then
            lastClick = getTickCount()
            local newIndex = math.max(1, store.currentCharacter - 1)
            store.currentCharacter = newIndex
            ped:setModel(characters[store.currentCharacter].skin)
        end

        if exports.cr_ui:isKeyPressed("arrow_r") and lastClick + 300 <= getTickCount() then
            lastClick = getTickCount()
            local newIndex = math.min(characterCount, store.currentCharacter + 1)
            store.currentCharacter = newIndex
            ped:setModel(characters[store.currentCharacter].skin)
        end

        if createCharacterButton.pressed then
            local characters = getElementData(localPlayer, "characters")
            local maxCharacterCount = tonumber(localPlayer:getData("max_characters") or 1)
            local characterCount = characters and #characters or 1

            if characterCount >= maxCharacterCount then
                exports.rl_infobox:addBox("error", "Maksimum karakter sayısına ulaştınız, marketten karakter slotu satın alınız.")
                return
            end

            local ped = store.ped
            if isElement(ped) then
                ped:destroy()
            end
			
			if isElement(characterLight) then
				characterLight:destroy()
			end
			
			removeEventHandler("onClientRender", root, renderCharacters)
            triggerEvent("account.characterCreation", localPlayer)
        end
    end
end

addEvent("account.characterSelection", true)
addEventHandler("account.characterSelection", root, function()
    addEventHandler("onClientRender", root, renderCharacters)
end)

addEvent("account.joinCharacterComplete", true)
addEventHandler("account.joinCharacterComplete", root, function()
	if isEventHandlerAdded("onClientRender", root, renderCharacters) then
		removeEventHandler("onClientRender", root, renderCharacters)
	end
	
	if isEventHandlerAdded("onClientRender", root, renderCharacterCreation) then
		removeEventHandler("onClientRender", root, renderCharacterCreation)
	end
	
	local ped = store.ped
	if isElement(ped) then
		ped:destroy()
	end
	
	if isElement(characterLight) then
		characterLight:destroy()
	end
	
	if isTimer(music.timer) then
		killTimer(music.timer)
	end
	
	if isElement(music.sound) then
		destroyElement(music.sound)
	end
	
	clearChatBox()
	showChat(true)
	showCursor(false)
	setCameraTarget(localPlayer, localPlayer)

	outputChatBox("[!]#FFFFFF " .. getPlayerName(localPlayer):gsub("_", " ") .. " isimli karaktere giriş sağlandı.", 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Keyifli çatışmalar ve eğlenceler dileriz.", 0, 255, 0, true)
	triggerEvent("playSuccessfulSound", localPlayer)
	
	setTimer(function()
		if not getElementData(localPlayer, "season_scene") then
			triggerEvent("season.startScene", localPlayer)
		end
	end, 1000, 1)
end)