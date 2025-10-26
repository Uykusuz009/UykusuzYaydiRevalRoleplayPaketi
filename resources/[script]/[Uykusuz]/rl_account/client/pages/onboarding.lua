local CONTAINER_SIZES = {
    x = 500,
    y = 500
}

local store = {
	username = "",
	password = "",
	promoCodeHelperText = ""
}

function renderOnboarding()
	local x, y = screenSize.x / 2 - CONTAINER_SIZES.x / 2, screenSize.y / 2 - CONTAINER_SIZES.y / 2
	
	dxDrawImage(0, 0, screenSize.x, screenSize.y, "public/image/background.png")
	dxDrawImage(x + CONTAINER_SIZES.x / 2 - 128 / 2, y, 128, 128, ":cr_ui/public/images/logo.png", 0, 0, 0, exports.cr_ui:getServerColor(1))

    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y + 200,
        },

        text = "Hopp! Merhaba, " .. store.username,
        alignX = "left",
        alignY = "top",
        color = theme.WHITE,
        scale = "h1",
        wrap = false,

        fontWeight = "bold",
    })

    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y + 250,
        },

        text = "Sunucuya başarıyla kayıt oldunuz. Şimdiden fazlasıyla heyecanlıyız.\nEğer bir promo kodunuz varsa girerek sürpriz hediyelerden yararlanabilirsiniz.\n\nHazırsan başlayalım!",
        alignX = "left",
        alignY = "top",
        color = theme.GRAY[300],
        scale = "body",
        wrap = false,

        fontWeight = "regular",
    })

    startButton = exports.cr_ui:drawButton({
        position = {
            x = x,
            y = y + 330,
        },
        size = {
            x = 120,
            y = 40,
        },
        radius = 8,

        textProperties = {
            align = "center",
            color = WHITE,
            font = fonts.body.regular,
            scale = 1,
        },

        variant = "soft",
        color = "purple",
        disabled = false,

        text = "Hemen Başla",
        icon = "",
    })
	
    exports.cr_ui:drawDivider({
        position = {
            x = x,
            y = y + 390,
        },
        size = {
            x = CONTAINER_SIZES.x,
            y = 1,
        },
        text = "promo kodun varsa",
    })

    promoCodeInput = exports.cr_ui:drawInput({
        position = {
            x = x + 110,
            y = y + 420,
        },
        size = {
            x = 150,
            y = 40,
        },
        radius = 6,
        padding = 10,

        name = "account_onboarding_promo_code",

        label = "",
        placeholder = "Promo kodu",
        value = "",
        helperText = {
            text = store.promoCodeHelperText,
            color = theme.RED[800]
        },

        variant = "soft",
        color = "gray",

        textVariant = "body",
        textWeight = "light",
        disabled = false,

        onChange = function()
        end,
        mask = false
    })

    promoCodeButton = exports.cr_ui:drawButton({
        position = {
            x = x + 270,
            y = y + 420,
        },
        size = {
            x = 120,
            y = 40,
        },
        radius = 8,

        textProperties = {
            align = "center",
            color = WHITE,
            font = fonts.body.regular,
            scale = 1,
        },

        variant = "soft",
        color = "green",
        disabled = false,

        text = "Kodu Kullan",
        icon = "",
    })

    if startButton.pressed or (promoCodeButton and promoCodeButton.pressed) then
        local promoCodeInputValue = promoCodeInput and promoCodeInput.value:upper() or ""
        local promoData = exports.rl_promo:getPromoData(promoCodeInput.value)

        if promoCodeButton and promoCodeButton.pressed then
            if promoCodeInputValue == "" then
                store.promoCodeHelperText = "Lütfen bir promo kodu girin."
                return
            end

            if not promoData then
                store.promoCodeHelperText = "Geçersiz bir promo kodu girdiniz."
                return
            end
        end
		
        if promoCodeInputValue ~= "" and not promoData then
            store.promoCodeHelperText = "Lütfen geçerli bir promo kod girin veya boş bırakın."
            return
        end

        triggerServerEvent("account.onboardingComplete", localPlayer, promoCodeInputValue)
        triggerServerEvent("account.requestLogin", localPlayer, store.username, store.password)
    end
end

addEvent("account.redirectOnboarding", true)
addEventHandler("account.redirectOnboarding", root, function(_username, _password)
	store = {
		username = _username,
		password = _password,
		promoCodeHelperText = ""
	}
	
	triggerEvent("account.removeAccount", localPlayer)
    addEventHandler("onClientRender", root, renderOnboarding)
	addEventHandler("onClientRender", root, renderSplash)
end)

addEvent("account.removeOnboarding", true)
addEventHandler("account.removeOnboarding", root, function()
    removeEventHandler("onClientRender", root, renderOnboarding)
	removeEventHandler("onClientRender", root, renderSplash)
end)