local CONTAINER_SIZES = {
    x = 310,
    y = 620
}

local INPUT_SIZES = {
    x = 270,
    y = 35
}

local CHANGE_SKIN_CONTAINER = {
    x = screenSize.x * 0.070,
    y = screenSize.y
}

local renderInputs = {
    { key = "name", label = "Karakter Adı", placeholder = "örn: Uykusuz Reval" },
    { key = "age", label = "Yaş", placeholder = "örn: 24" },
    { key = "height", label = "Boy", placeholder = "örn: 181" },
    { key = "weight", label = "Kilo", placeholder = "örn: 88" }
}

local store = {
	currentSkin = 1,
	gender = 0,
	race = 1,
	currentCountry = 1
}

local lastClick = getTickCount()
local lastCreateButtonClickTime = 0

local function updatePedModel(diff)
    local ped = store.ped
    local currentSkin = store.currentSkin
    local gender = store.gender
    local race = store.race

    local skins = availableSkins[tonumber(gender)][tonumber(race)] or {}

    local skin = 0

    if diff then
        currentSkin = currentSkin + diff
        store.currentSkin = currentSkin
    end

    if currentSkin > #skins or currentSkin < 1 then
        currentSkin = 1
        skin = skins[currentSkin]
    else
        skin = skins[currentSkin]
    end

    if skin then
        ped:setModel(skin)
    end
end

function renderCharacterCreation()
	if not store.ped and not isElement(store.ped) then
        local ped = createPed(0, 258, -41.2, 1002, 87)
        localPlayer:setInterior(14)
		setCameraMatrix(254.7190, -41.1370, 1002, 256.7190, -41.1370, 1002)
        setCameraInterior(localPlayer:getInterior())
        ped:setDimension(localPlayer:getDimension())
        ped:setInterior(localPlayer:getInterior())
        store.ped = ped
    end
	
	local inputs = {}

    local x = CHANGE_SKIN_CONTAINER.x + 20
    local y = screenSize.y / 2 - CONTAINER_SIZES.y / 2

    dxDrawImage(x, y, CONTAINER_SIZES.x, CONTAINER_SIZES.y, "public/image/background.png")

    x, y = x + 20, y + 20
    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y,
        },

        text = "Karakter Oluştur",
        alignX = "left",
        alignY = "top",
        color = theme.GRAY[100],
        scale = "h5",
        wrap = false,

        fontWeight = "regular",
    })
	
	y = y + 25

    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y,
        },

        text = "Karakterinizi oluşturmak için\naşağıdaki bilgileri doldurun.",
        alignX = "left",
        alignY = "top",
        color = theme.GRAY[400],
        scale = "caption",
        wrap = false,

        fontWeight = "regular",
    })
	
	y = y + 60
	
	for _, value in ipairs(renderInputs) do
        inputs[value.key] = exports.cr_ui:drawInput({
            position = {
                x = x,
                y = y
            },
            size = INPUT_SIZES,
            radius = 8,
            padding = 10,

            name = "account_" .. value.key,

            label = value.label,
            placeholder = value.placeholder,
            value = "",
            helperText = {
                text = "",
                color = "gray"
            },

            variant = "outlined",
            color = "gray",

            textVariant = "body",
            textWeight = "regular",

            disabled = loading,

            mask = false,
        })
        y = y + INPUT_SIZES.y + 40
    end

    y = y - 20
	
	exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y,
        },

        text = "Cinsiyet",
        alignX = "left",
        alignY = "top",
        color = theme.GRAY[50],
        scale = "body",
        wrap = false,

        fontWeight = "regular",
    })

    y = y + 25

    genderRadioGroup = exports.cr_ui:drawRadioGroup({
        position = {
            x = x,
            y = y
        },

        name = "account_gender",
        options = {
            exports.cr_ui:drawRadio({ name = "0", text = "Erkek" }),
            exports.cr_ui:drawRadio({ name = "1", text = "Kadın" }),
        },
        defaultSelected = "0",
        placement = "vertical",

        variant = "soft",
        color = "gray",
    })
	
	if genderRadioGroup.current ~= store.gender then
        store.currentSkin = 1
        store.gender = genderRadioGroup.current
        updatePedModel()
    end
	
	y = y + 30
	
	exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y,
        },

        text = "Uyruk",
        alignX = "left",
        alignY = "top",
        color = theme.GRAY[50],
        scale = "body",
        wrap = false,

        fontWeight = "regular",
    })

    y = y + 25

    raceRadioGroup = exports.cr_ui:drawRadioGroup({
        position = {
            x = x,
            y = y
        },

        name = "account_race",
        options = {
            exports.cr_ui:drawRadio({ name = "1", text = "Beyaz" }),
            exports.cr_ui:drawRadio({ name = "2", text = "Siyahi" }),
            exports.cr_ui:drawRadio({ name = "3", text = "Asyalı" }),
        },
        defaultSelected = "1",
        placement = "vertical",

        variant = "soft",
        color = "gray",
    })
	
	if raceRadioGroup.current ~= store.race then
        store.currentSkin = 1
        store.race = raceRadioGroup.current
        updatePedModel()
    end
	
	y = y + 30

    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y,
        },

        text = "Ülke",
        alignX = "left",
        alignY = "top",
        color = theme.GRAY[50],
        scale = "body",
        wrap = false,

        fontWeight = "regular",
    })

    y = y + 25
	
	local countryLeftButton = exports.cr_ui:drawButton({
        position = {
            x = x,
            y = y
        },
        size = {
            x = 32,
            y = 32
        },
        radius = DEFAULT_RADIUS,

        textProperties = {
            align = "center",
            color = theme.WHITE,
            font = fonts.icon,
            scale = 0.5,
        },

        variant = "soft",
        color = "gray",
        disabled = false,

        text = "",
        icon = "",
    })
	
	exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y + 32 / 2 - 16 / 2,
        },
        size = {
            x = INPUT_SIZES.x,
            y = 20,
        },

        text = countries[store.currentCountry],
        alignX = "center",
        alignY = "top",
        color = theme.GRAY[300],
        scale = "caption",
        wrap = false,

        fontWeight = "regular",
    })
	
	local countryRightButton = exports.cr_ui:drawButton({
        position = {
            x = x + INPUT_SIZES.x - 32,
            y = y
        },
        size = {
            x = 32,
            y = 32
        },
        radius = DEFAULT_RADIUS,

        textProperties = {
            align = "center",
            color = theme.WHITE,
            font = fonts.icon,
            scale = 0.5,
        },

        variant = "soft",
        color = "gray",
        disabled = false,

        text = "",
        icon = "",
    })
	
	if countryLeftButton.pressed then
        store.currentCountry = math.max(store.currentCountry - 1, 1)
    end

    if countryRightButton.pressed then
        store.currentCountry = math.min(store.currentCountry + 1, #countries)
    end
	
	y = y + 45

    local createButton = exports.cr_ui:drawButton({
        position = {
            x = x,
            y = y
        },
        size = {
            x = INPUT_SIZES.x,
            y = 35
        },
        radius = DEFAULT_RADIUS,

        textProperties = {
            align = "center",
            color = theme.WHITE,
            font = fonts.body.regular,
            scale = 1,
        },

        variant = "solid",
        color = "gray",
        disabled = loading,

        text = "Oluştur",
    })
	
	if createButton.pressed and not loading then
        local currentTime = getTickCount()
        if currentTime - lastCreateButtonClickTime >= 5000 then
            lastCreateButtonClickTime = currentTime

            local name = inputs.name.value
            local age = tonumber(inputs.age.value) or 0
            local height = tonumber(inputs.height.value) or 0
            local weight = tonumber(inputs.weight.value) or 0

            local gender = tonumber(store.gender)
            local race = tonumber(store.race)
			local country = tonumber(store.currentCountry)

            local valid, reason = checkCharacterName(name)

            local characters = localPlayer:getData("characters") or {}
            local maxCharacterCount = tonumber(localPlayer:getData("max_characters") or 1) or 3
            local characterCount = (characters and #characters or 1) - 1

            if characterCount >= maxCharacterCount then
                exports.rl_infobox:addBox("error", "Maksimum karakter sayısına ulaştınız, marketten karakter slotu satın alınız.")
                return
            end

            if name == "" or age == "" or height == "" or weight == "" then
                exports.rl_infobox:addBox("error", "Lütfen tüm alanları doldurunuz.")
                return
            end

            if age < 16 or age > 90 then
                exports.rl_infobox:addBox("error", "Yaşınız 16 ile 90 arasında olmalıdır.")
                return
            end

            if weight < 50 and weight > 150 then
                exports.rl_infobox:addBox("error", "Kilonuz 50 ile 150 arasında olmalıdır.")
                return
            end

            if height < 150 and height > 200 then
                exports.rl_infobox:addBox("error", "Boyunuz 150 ile 200 arasında olmalıdır.")
                return
            end

            if not valid then
                exports.rl_infobox:addBox("error", reason)
                return
            end

            loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)

            local packedData = {
                name = name,
                age = age,
                gender = gender,
                height = height,
                weight = weight,
                race = race,
				country = country,
                skin = store.ped:getModel()
            }

            triggerServerEvent("account.createCharacter", localPlayer, packedData)
        else
            exports.rl_infobox:addBox("error", "5 saniyede bir karakter oluşturma butonuna tıklayabilirsiniz.")
        end
    end
	
	local leftArrowPosition = {
        x = 0,
        y = 0
    }

    local hover = exports.cr_ui:inArea(leftArrowPosition.x, leftArrowPosition.y, CHANGE_SKIN_CONTAINER.x, CHANGE_SKIN_CONTAINER.y)

    dxDrawImage(leftArrowPosition.x, leftArrowPosition.y, CHANGE_SKIN_CONTAINER.x, CHANGE_SKIN_CONTAINER.y, "public/image/background.png", 0, 0, 0, tocolor(255, 255, 255, 190), false)
    exports.cr_ui:drawButton({
        position = {
            x = CHANGE_SKIN_CONTAINER.x / 2 - 64 / 2,
            y = CHANGE_SKIN_CONTAINER.y / 2 - 64 / 2
        },
        size = {
            x = 64,
            y = 64
        },
        radius = DEFAULT_RADIUS,

        textProperties = {
            align = "center",
            color = theme.WHITE,
            font = fonts.icon,
            scale = 1,
        },

        variant = "plain",
        color = "purple",
        disabled = true,

        text = "",
        icon = "",
    })

    if hover then
        exports.rl_cursor:setCursor("all", "pointinghand")
        if getKeyState("mouse1") and lastClick + 200 <= getTickCount() then
            lastClick = getTickCount()
            updatePedModel(-1)
        end
    end

    local rightArrowPosition = {
        x = screenSize.x - CHANGE_SKIN_CONTAINER.x,
        y = 0
    }

    local hover = exports.cr_ui:inArea(rightArrowPosition.x, rightArrowPosition.y, CHANGE_SKIN_CONTAINER.x, CHANGE_SKIN_CONTAINER.y)

    dxDrawImage(rightArrowPosition.x, rightArrowPosition.y, CHANGE_SKIN_CONTAINER.x, CHANGE_SKIN_CONTAINER.y, "public/image/background.png", 0, 0, 0, tocolor(255, 255, 255, 190), false)
    exports.cr_ui:drawButton({
        position = {
            x = rightArrowPosition.x + CHANGE_SKIN_CONTAINER.x / 2 - 64 / 2,
            y = CHANGE_SKIN_CONTAINER.y / 2 - 64 / 2
        },
        size = {
            x = 64,
            y = 64
        },
        radius = DEFAULT_RADIUS,

        textProperties = {
            align = "center",
            color = theme.WHITE,
            font = fonts.icon,
            scale = 1,
        },

        variant = "plain",
        color = "purple",
        disabled = true,

        text = "",
        icon = "",
    })

    if hover then
        exports.rl_cursor:setCursor("all", "pointinghand")
        if getKeyState("mouse1") and lastClick + 200 <= getTickCount() then
            lastClick = getTickCount()
            updatePedModel(1)
        end
    end
end

addEvent("account.characterCreation", true)
addEventHandler("account.characterCreation", root, function()
    addEventHandler("onClientRender", root, renderCharacterCreation)
end)