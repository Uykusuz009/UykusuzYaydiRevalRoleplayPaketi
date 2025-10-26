function playRadioSound()
	local sound = playSound("telsiz/radio.mp3", false)
	setSoundVolume(sound, 0.5)
end
addEvent("playRadioSound", true)
addEventHandler("playRadioSound", root, playRadioSound)