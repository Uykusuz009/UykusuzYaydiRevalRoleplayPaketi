local clickTick = 0
local iconFont = exports.rl_fonts:getFont("FontAwesome", 9)

function renderSplash()
	dxDrawText(music.paused and "" or "", 48, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 150), 1, iconFont, "center")
	dxDrawText(music.sound and ((musics[music.index].name or "Müzik") .. (" (" .. convertMusicTime(math.floor(getSoundPosition(music.sound))) .. "/" .. convertMusicTime(math.floor(getSoundLength(music.sound))) .. ")") or "") or "Yükleniyor...", 40, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 150), 1, fonts.UbuntuRegular.caption)
	
	if music.sound and not loading then
		if exports.cr_ui:inArea(16, screenSize.y - 32, dxGetTextWidth(music.paused and "" or "", 1, iconFont), dxGetFontHeight(1, iconFont)) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			clickTick = getTickCount()
			setSoundPaused(music.sound, not music.paused)
			music.paused = not music.paused
		end
	end
end