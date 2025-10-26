local screenSize = {
    x = screenSize.x,
    y = screenSize.y
}

local screenRatio = screenSize.x / screenSize.y
local baseScale = math.min(screenSize.x / 1920, screenSize.y / 1080)
local adaptiveScale = math.min(1, math.max(0.6, baseScale))

local sizeX, sizeY = 250 * baseScale, 40 * baseScale
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2

local MIN_LOGO_SIZE = math.max(64, screenSize.y * 0.06)
local MAX_LOGO_SIZE = math.min(256, screenSize.y * 0.24)
local MIN_LINE_WIDTH = math.max(2, screenSize.x * 0.001)
local MAX_LINE_WIDTH = math.min(4, screenSize.x * 0.002)
local MIN_LINE_MARGIN = screenSize.y * 0.1
local MAX_LINE_MARGIN = screenSize.y * 0.2
local LOGO_BASE_SIZE = 128 * adaptiveScale

local logoSize = {
    x = math.min(MAX_LOGO_SIZE, math.max(MIN_LOGO_SIZE, LOGO_BASE_SIZE)),
    y = math.min(MAX_LOGO_SIZE, math.max(MIN_LOGO_SIZE, LOGO_BASE_SIZE))
}

local logoPosition = {
    x = screenSize.x / 2 - logoSize.x / 2,
    y = screenSize.y * 0.08
}

local partyImageSize = {
    x = math.min(600, math.max(200, 400 * baseScale)),
    y = math.min(600, math.max(200, 400 * baseScale))
}

local partyImagePosition = {
    x = screenSize.x / 2 + (335 * baseScale),
    y = screenSize.y / 2 - partyImageSize.y / 1.8
}

local partyMusicPosition = {
    x = partyImagePosition.x,
    y = partyImagePosition.y + partyImageSize.y + (10 * baseScale)
}

local store = {
	selectedPage = 1,
	loginUsername = "",
	loginPassword = "",
	rememberMe = false,
	accountData = false,
	fadeAlpha = 255,
	fadeTarget = 255,
	lastPageChange = 0,
	isTransitioning = false
}

local logoAnimationTick = getTickCount()
local logoAnimationSpeed = 0.0015 
local logoAnimationScale = 0.05 

function renderAccount()
	if not store.accountData then
		local data, status = exports.rl_json:jsonGet("account", true)
		
		if status then
			if data.rememberMe then
				store.loginUsername = tostring(data.username)
				store.loginPassword = tostring(data.password)
				store.rememberMe = true
			else
				store.rememberMe = false
			end
		end
		
		store.accountData = true
	end
	
    -- Arka plan resmi
    dxDrawImage(0, 0, screenSize.x, screenSize.y, "public/image/background.png")
	
	local lineX = screenSize.x / 2
	local lineMargin = 250 * baseScale
	local bottomMargin = 180 * baseScale
	local lineWidth = 2 * adaptiveScale
    dxDrawRectangle(lineX, lineMargin, lineWidth, screenSize.y - (lineMargin + bottomMargin), tocolor(159, 122, 234, 255))
	local elementX = lineX - sizeX - (screenSize.x * 0.13)
	local animProgress = math.sin((getTickCount() - logoAnimationTick) * logoAnimationSpeed)
	local currentLogoSize = {
		x = logoSize.x * (1 + animProgress * logoAnimationScale),
		y = logoSize.y * (1 + animProgress * logoAnimationScale)
	}
	local currentLogoPosition = {
		x = screenSize.x / 2 - currentLogoSize.x / 2,
		y = logoPosition.y
	}
	dxDrawImage(currentLogoPosition.x, currentLogoPosition.y, currentLogoSize.x, currentLogoSize.y, ":cr_ui/public/images/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	dxDrawImage(partyImagePosition.x, partyImagePosition.y, partyImageSize.x, partyImageSize.y, "public/image/party.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	if music.sound and not loading then
		dxDrawText(music.paused and "" or "", 
			partyImagePosition.x + partyImageSize.x/2 - (16 * baseScale),
			partyImagePosition.y + partyImageSize.y + (10 * baseScale),
			0, 
			0, 
			tocolor(255, 255, 255, 150),
			1, 
			iconFont, 
			"center"
		)
		local musicText = music.sound and ((musics[music.index].name or "Müzik") .. (" (" .. convertMusicTime(math.floor(getSoundPosition(music.sound))) .. "/" .. convertMusicTime(math.floor(getSoundLength(music.sound))) .. ")") or "") or "Yükleniyor..."
		dxDrawText(musicText,
			partyImagePosition.x,
			partyImagePosition.y + partyImageSize.y + (10 * baseScale),
			partyImagePosition.x + partyImageSize.x,
			0,
			tocolor(255, 255, 255, 150),
			1,
			fonts.UbuntuRegular.caption,
			"center"
		)
		if exports.cr_ui:inArea(partyMusicPosition.x, partyMusicPosition.y, dxGetTextWidth(music.paused and "" or "", 1, iconFont), dxGetFontHeight(1, iconFont)) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			clickTick = getTickCount()
			setSoundPaused(music.sound, not music.paused)
			music.paused = not music.paused
		end
	end
	local currentTick = getTickCount()
	local elapsedTime = currentTick - store.lastPageChange
	local duration = 300 
	if elapsedTime < duration then
		local progress = elapsedTime / duration
		store.fadeAlpha = interpolateBetween(
			store.fadeAlpha, 0, 0,
			store.fadeTarget, 0, 0,
			progress, "Linear"
		)
	else
		store.isTransitioning = false
	end
	
	if store.selectedPage == 1 then
		local alpha = store.fadeAlpha
		dxDrawText("GİRİŞ YAP", 
			elementX - (screenSize.x * 0.05),
			screenY - (160 * baseScale),
			elementX + sizeX - (screenSize.x * 0.05),
			screenY - (140 * baseScale), 
			tocolor(255, 255, 255, alpha), 
			1.0,
			fonts.UbuntuBold.h4, 
			"center", 
			"center", 
			false, false, true,
			false
		)
		dxDrawText("Bilgilerinizi girerek hesabınıza erişin", 
			elementX - (screenSize.x * 0.05),
			screenY - (135 * baseScale),
			elementX + sizeX - (screenSize.x * 0.05),
			screenY - (115 * baseScale), 
			tocolor(255, 255, 255, alpha * 0.7), 
			1.0,
			fonts.UbuntuRegular.body, 
			"left", 
			"center", 
			false, false, true,
			false
		)
		
		loginUsernameInput = exports.cr_ui:drawInput({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY - (95 * baseScale)
            },
            size = {
				x = sizeX,
				y = sizeY
			},
            radius = 6 * baseScale,
            padding = 10 * baseScale,

            name = "account_login_username",
            regex = "^[a-zA-Z0-9_.@-]*$",

            placeholder = "Kullanıcı Adı / E-posta",
            value = store.loginUsername,
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 40, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha)
        })
		loginPasswordInput = exports.cr_ui:drawInput({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY - (45 * baseScale)
            },
            size = {
				x = sizeX,
				y = sizeY
			},
            radius = 6 * baseScale,
            padding = 10 * baseScale,

            name = "account_login_password",

            placeholder = "Şifre",
            value = store.loginPassword,
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 40, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha),
            mask = true
        })
		rememberMeCheckbox = exports.cr_ui:drawCheckbox({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (5 * baseScale)
            },
            size = 20 * baseScale,

            name = "account_rememberMe",
			
            disabled = false,
            text = "Beni Hatırla",
            helperText = {
                text = "",
                color = theme.GRAY[200],
            },

            variant = "soft",
            color = "gray",
            checked = store.rememberMe,

            disabled = not loading
        })
		
		loginButton = exports.cr_ui:drawButton({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (40 * baseScale)
            },
            size = {
                x = sizeX,
                y = sizeY
            },
            radius = 6 * baseScale,
            text = "Giriş Yap",
            variant = "solid",
            color = "purple",
            backgroundColor = tocolor(40, 180, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha)
        })
		
		registerPageButton = exports.cr_ui:drawButton({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (90 * baseScale)
            },
            size = {
                x = sizeX,
                y = sizeY
            },
            radius = 6 * baseScale,
            text = "Kayıt Ol",
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 80, 40, 0),
            textColor = tocolor(255, 255, 255, 255)
        })
		
		if (loginButton.pressed or exports.cr_ui:isKeyPressed("enter")) and not loading then
            if loginUsernameInput.value == "" then
                exports.rl_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
				return
            end

            if loginPasswordInput.value == "" then
                exports.rl_infobox:addBox("error", "Şifre boş bırakılamaz.")
				return
            end
			
			if string.match(loginUsernameInput.value, "['\"\\%;]") or string.match(loginPasswordInput.value, "['\"\\%;]") then
                loginUsernameInput.value = ""
                loginPasswordInput.value = ""
				exports.rl_infobox:addBox("error", "Geçersiz karakterler algılandı.")
                return
            end

            if string.len(loginUsernameInput.value) < 3 or string.len(loginUsernameInput.value) > 32 then
                exports.rl_infobox:addBox("error", "Kullanıcı adı 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(loginPasswordInput.value) < 6 or string.len(loginPasswordInput.value) > 32 then
                exports.rl_infobox:addBox("error", "Şifre 6 ile 32 karakter arasında olmalıdır.")
                return
            end

            if isTransferBoxActive() then
                exports.rl_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza erişemezsiniz.")
                return
            end

            if isTimer(spamTimer) then
                exports.rl_infobox:addBox("error", "Art arda birden fazla işlem yaptınız, lütfen 3 saniye bekleyin.")
                return
            end

            spamTimer = setTimer(function() end, 3000, 1)
			
			loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)
			triggerServerEvent("account.requestLogin", localPlayer, loginUsernameInput.value, loginPasswordInput.value)
			
			if rememberMeCheckbox.checked then
				exports.rl_json:jsonSave("account", {
					username = loginUsernameInput.value,
					password = loginPasswordInput.value,
					rememberMe = rememberMeCheckbox.checked
				}, true)
			end
		end
		
		if registerPageButton.pressed and not loading and not store.isTransitioning then
			store.lastPageChange = getTickCount()
			store.fadeTarget = 0
			store.isTransitioning = true
			setTimer(function()
				store.selectedPage = 2
				store.fadeAlpha = 0
				store.fadeTarget = 255
				store.lastPageChange = getTickCount()
			end, 300, 1)
		end
	elseif store.selectedPage == 2 then
		local alpha = store.fadeAlpha

		dxDrawText("KAYIT OL", 
			elementX - (screenSize.x * 0.05),
			screenY - (160 * baseScale),
			elementX + sizeX - (screenSize.x * 0.05),
			screenY - (140 * baseScale), 
			tocolor(255, 255, 255, alpha), 
			1.0,
			fonts.UbuntuBold.h4, 
			"center", 
			"center", 
			false, false, true,
			false
		)

		dxDrawText("Bilgilerinizi girerek hesabınıza erişin", 
			elementX - (screenSize.x * 0.05),
			screenY - (135 * baseScale),
			elementX + sizeX - (screenSize.x * 0.05),
			screenY - (115 * baseScale), 
			tocolor(255, 255, 255, alpha * 0.7), 
			1.0,
			fonts.UbuntuRegular.body, 
			"left", 
			"center", 
			false, false, true,
			false
		)
		
		registerUsernameInput = exports.cr_ui:drawInput({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY - (95 * baseScale)
            },
            size = {
				x = sizeX,
				y = sizeY
			},
            radius = 6 * baseScale,
            padding = 10 * baseScale,

            name = "account_register_username",
            regex = "^[a-zA-Z0-9_.-]*$",

            placeholder = "Kullanıcı Adı",
            value = "",
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 40, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha)
        })
		
		registerPasswordInput = exports.cr_ui:drawInput({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY - (45 * baseScale)
            },
            size = {
				x = sizeX,
				y = sizeY
			},
            radius = 6 * baseScale,
            padding = 10 * baseScale,

            name = "account_register_password",
            placeholder = "Şifre",
            value = "",
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 40, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha),
            mask = true
        })
		
		registerPasswordAgainInput = exports.cr_ui:drawInput({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (5 * baseScale)
            },
            size = {
				x = sizeX,
				y = sizeY
			},
            radius = 6 * baseScale,
            padding = 10 * baseScale,

            name = "account_register_password_again",
            placeholder = "Şifre Tekrarı",
            value = "",
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 40, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha),
            mask = true
        })
		
		registerEmailInput = exports.cr_ui:drawInput({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (55 * baseScale)
            },
            size = {
				x = sizeX,
				y = sizeY
			},
            radius = 6 * baseScale,
            padding = 10 * baseScale,

            name = "account_register_email",
            placeholder = "E-posta",
            value = "",
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 40, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha)
        })
		local gradientStartY = screenY + (115 * baseScale)
		local gradientHeight = 1 * baseScale
		local gradientWidth = sizeX
		local gradientStartX = elementX - (screenSize.x * 0.05)
		
		for i = 0, gradientWidth/2 do
			local gradientAlpha = (i/(gradientWidth/2)) * 255 * (alpha/255)
			dxDrawRectangle(
				gradientStartX + i, 
				gradientStartY, 
				1, 
				gradientHeight, 
				tocolor(255, 255, 255, gradientAlpha)
			)
			
			gradientAlpha = (1 - i/(gradientWidth/2)) * 255 * (alpha/255)
			dxDrawRectangle(
				gradientStartX + (gradientWidth/2) + i, 
				gradientStartY, 
				1, 
				gradientHeight, 
				tocolor(255, 255, 255, gradientAlpha)
			)
		end
		
		registerButton = exports.cr_ui:drawButton({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (135 * baseScale)
            },
            size = {
                x = sizeX,
                y = sizeY
            },
            radius = 6 * baseScale,
            text = "Kayıt Ol",
            variant = "solid",
            color = "purple",
            backgroundColor = tocolor(40, 180, 40, alpha),
            textColor = tocolor(255, 255, 255, alpha)
        })
		
		loginPageButton = exports.cr_ui:drawButton({
            position = {
                x = elementX - (screenSize.x * 0.05),
                y = screenY + (185 * baseScale)
            },
            size = {
                x = sizeX,
                y = sizeY
            },
            radius = 6 * baseScale,
            text = "Geri Dön",
            variant = "solid",
            color = "gray",
            backgroundColor = tocolor(40, 80, 40, 0),
            textColor = tocolor(255, 255, 255, 255)
        })
		
		if (registerButton.pressed or exports.cr_ui:isKeyPressed("enter")) and not loading then
            if registerUsernameInput.value == "" then
                exports.rl_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
				return
            end

            if registerPasswordInput.value == "" then
                exports.rl_infobox:addBox("error", "Şifre boş bırakılamaz.")
				return
            end
			
            if registerPasswordAgainInput.value == "" then
                exports.rl_infobox:addBox("error", "Şifre tekrarı boş bırakılamaz.")
				return
            end
			
			if registerEmailInput.value == "" then
                exports.rl_infobox:addBox("error", "E-posta boş bırakılamaz.")
				return
            end
			
			if string.match(registerUsernameInput.value, "['\"\\%;]") or string.match(registerPasswordInput.value, "['\"\\%;]") or string.match(registerPasswordAgainInput.value, "['\"\\%;]") or string.match(registerEmailInput.value, "['\"\\%;]") then
                registerUsernameInput.value = ""
                registerPasswordInput.value = ""
                registerPasswordAgainInput.value = ""
				exports.rl_infobox:addBox("error", "Geçersiz karakterler algılandı.")
                return
            end

            if string.len(registerUsernameInput.value) < 3 or string.len(registerUsernameInput.value) > 32 then
                exports.rl_infobox:addBox("error", "Kullanıcı adı 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(registerPasswordInput.value) < 6 or string.len(registerPasswordInput.value) > 32 then
                exports.rl_infobox:addBox("error", "Şifre 6 ile 32 karakter arasında olmalıdır.")
                return
            end
			
			if registerPasswordInput.value ~= registerPasswordAgainInput.value then
				exports.rl_infobox:addBox("error", "Şifreler uyuşmuyor.")
                return
            end
			
			if not checkMail(registerEmailInput.value) then
				exports.rl_infobox:addBox("error", "E-posta geçerli değil.")
                return
            end

            if isTimer(spamTimer) then
                exports.rl_infobox:addBox("error", "Art arda birden fazla işlem yaptınız, lütfen 3 saniye bekleyin.")
                return
            end
			
			spamTimer = setTimer(function() end, 3000, 1)
			
			loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)
			triggerServerEvent("account.requestRegister", localPlayer, registerUsernameInput.value, registerPasswordInput.value, registerEmailInput.value)
		end
		
		if loginPageButton.pressed and not loading and not store.isTransitioning then
			store.lastPageChange = getTickCount()
			store.fadeTarget = 0
			store.isTransitioning = true
			setTimer(function()
				store.selectedPage = 1
				store.fadeAlpha = 0
				store.fadeTarget = 255
				store.lastPageChange = getTickCount()
			end, 300, 1)
		end
	end
end

addEvent("account.accountScreen", true)
addEventHandler("account.accountScreen", root, function()
	loading = false
	removeEventHandler("onClientRender", root, renderLoading)
	
	music.timer = setTimer(playMusic, 0, 0)
	addEventHandler("onClientRender", root, renderAccount)
	addEventHandler("onClientRender", root, renderSplash)
end)

addEvent("account.removeAccount", true)
addEventHandler("account.removeAccount", root, function()
    removeEventHandler("onClientRender", root, renderAccount)
    removeEventHandler("onClientRender", root, renderSplash)
end)