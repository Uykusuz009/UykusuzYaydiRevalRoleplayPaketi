local rapor = false
function raporShow()
	local w, h = guiGetScreenSize()
	rapor = guiCreateStaticImage((w - 750) /2, (h - 600)/2, 750, 600, "files/bilgi31.png", false)
	local sound = playSound("files/cryder.m4a")   
	setSoundVolume(sound, 0.5) -- set the sound volume to 50%
end
addEvent("admin:raporShow", true)
addEventHandler("admin:raporShow", root, raporShow)

function noRapor()
	if rapor then
		destroyElement(rapor)
		rapor = false
	end
end
addEvent("admin:noRapor", true)
addEventHandler("admin:noRapor", root, noRapor)

function raporShow()
   local sound = playSound("files/sound.wav")   
   setSoundVolume(sound, 0.5) -- set the sound volume to 50%
end
addEvent("raporShow", true)
addEventHandler("raporShow", getLocalPlayer(), raporShow)
