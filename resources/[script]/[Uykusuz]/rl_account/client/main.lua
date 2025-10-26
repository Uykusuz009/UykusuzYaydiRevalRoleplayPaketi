screenSize = Vector2(guiGetScreenSize())

theme = exports.cr_ui:useTheme()
fonts = exports.cr_ui:useFonts()
iconFont = exports.rl_fonts:getFont("FontAwesome", 10)

loading = false

music = {
	sound = nil,
	timer = nil,
	index = 0,
	beginning = false,
	paused = false,
}

function playMusic()
	if not (music.beginning) then
		music.index = math.random(1, #musics)
		music.sound = playSound(musics[music.index].url, false)
		setSoundVolume(music.sound, 0.3)
		music.beginning = true
	else
		if (music.beginning) and (music.sound) and (not isElement(music.sound)) then
			music.index = music.index >= #musics and 1 or music.index + 1
			music.sound = playSound(musics[music.index].url, false)
			setSoundVolume(music.sound, 0.3)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	if not getElementData(localPlayer, "logged") then
		loading = true
		addEventHandler("onClientRender", root, renderLoading)
		
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		setCameraInterior(0)
		setCameraMatrix(1994.6162109375, -1603.8291015625, 43.31729888916, 1916.7744140625, -1543.861328125, 61.88049697876)
		fadeCamera(true)
		showCursor(true)
		showChat(false)
		
		triggerServerEvent("account.requestPlayerInfo", localPlayer)
	end
end)

addEventHandler("onClientPlayerChangeNick", root, function(oldNick, newNick)
	if (source == localPlayer) then
		local legalNameChange = getElementData(localPlayer, "legal_name_change")
		if (oldNick ~= newNick) and (not legalNameChange) then
			cancelEvent()
			triggerServerEvent("account.resetPlayerName", localPlayer, oldNick, newNick)
		end
	end
end)