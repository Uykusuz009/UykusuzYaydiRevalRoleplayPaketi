local subTrackOnSoundDown = 0.1
local subTrackOnSoundUp = 0.1

local rx, ry = guiGetScreenSize()
button = {}
speakerSound = {}

window = guiCreateWindow((rx - 295), (ry / 2 - 253 / 2), 293, 257, "Ses Sistemi", false)
guiWindowSetSizable(window, false)
guiSetVisible(window, false)

currentSpeaker = guiCreateLabel(10, 25, 254, 17, "Durum: Yok", false, window)
volume = guiCreateLabel(10, 42, 252, 17, "Ses: 100%", false, window)
pos = guiCreateLabel(10, 59, 252, 17, "X: 0 | Y: 0 | Z: 0", false, window)
guiCreateLabel(10, 78, 252, 17, "URL:", false, window)
url = guiCreateEdit(10, 96, 272, 23, "", false, window)
guiEditSetMaxLength(url, 500)

button["place"] = guiCreateButton(9, 127, 274, 25, "Oluştur", false, window)
button["remove"] = guiCreateButton(9, 158, 274, 25, "Sil", false, window)
button["v-"] = guiCreateButton(9, 189, 128, 25, "Ses -", false, window)
button["v+"] = guiCreateButton(155, 189, 128, 25, "Ses +", false, window)
button["close"] = guiCreateButton(9, 220, 274, 25, "Kapat", false, window)  

local isSound = false
addEvent("onPlayerViewSpeakerManagment", true)
addEventHandler("onPlayerViewSpeakerManagment", root, function(current)
	local toState = not guiGetVisible(window)
	guiSetVisible(window, toState)
	showCursor(toState) 
	
	if (toState) then
		guiSetInputMode("no_binds_when_editing")
		
		local x, y, z = getElementPosition(localPlayer)
		guiSetText(pos, "X: " .. math.floor(x) .. " | Y: " .. math.floor(y) .. " | Z: " .. math.floor(z))
		
		if (current) then
			guiSetText(currentSpeaker, "Durum: Var")
			isSound = true
		else
			guiSetText(currentSpeaker, "Durum: Yok")
		end
	end
end)

addEventHandler("onClientGUIClick", root, function()
	if (source == button["close"]) then
		guiSetVisible (window, false) 
		showCursor(false)
	elseif (source == button["place"]) then
		if (isURL()) then
			triggerServerEvent("onPlayerPlaceSpeakerBox", localPlayer, guiGetText(url), isPedInVehicle(localPlayer))
			guiSetText(currentSpeaker, "Durum: Var")
			isSound = true
			guiSetText(volume, "Ses: 100%")
		else
			outputChatBox("[!]#FFFFFF Sesi açmak için URL eklemeniz gerekmektedir.", 255, 0, 0, true)
			playSoundFrontEnd(4)
		end
	elseif (source == button["remove"]) then
		triggerServerEvent("onPlayerDestroySpeakerBox", localPlayer)
		guiSetText(currentSpeaker, "Durum: Yok")
		isSound = false
		guiSetText (volume, "Ses: 100%")
	elseif (source == button["v-"]) then
		if (isSound) then
			local toVol = math.round(getSoundVolume(speakerSound[localPlayer]) - subTrackOnSoundDown, 2)
			if (toVol > 0.0) then
				triggerServerEvent("onPlayerChangeSpeakerBoxVolume", localPlayer, toVol)
				guiSetText(volume, "Ses: " .. math.floor(toVol * 100) .. "%")
			end
		end
	elseif (source == button["v+"]) then
		if (isSound) then
			local toVol = math.round(getSoundVolume (speakerSound[localPlayer]) + subTrackOnSoundUp, 2)
			if (toVol < 1.1) then
				triggerServerEvent("onPlayerChangeSpeakerBoxVolume", localPlayer, toVol)
				guiSetText(volume, "Ses: " .. math.floor(toVol * 100) .. "%")
			end
		end
	end
end)

addEvent("onPlayerStartSpeakerBoxSound", true)
addEventHandler("onPlayerStartSpeakerBoxSound", root, function(player, url, isCar)
	if (isElement(speakerSound[player])) then destroyElement(speakerSound[player]) end
	local x, y, z = getElementPosition(player)
	local interior = getElementInterior(player)
	local dimension = getElementDimension(player)
	speakerSound[player] = playSound3D(url, x, y, z, true)
	setSoundVolume(speakerSound[player], 1)
	setSoundMinDistance(speakerSound[player], 10)
	setSoundMaxDistance(speakerSound[player], 40)
	setElementInterior(speakerSound[player], interior)
	setElementDimension(speakerSound[player], dimension)
	if (isCar) then
		local car = getPedOccupiedVehicle(player)
		attachElements(speakerSound[player], car, 0, 5, 1)
	end
end)

addEvent("onPlayerDestroySpeakerBox", true)
addEventHandler ("onPlayerDestroySpeakerBox", root, function(player) 
	if (isElement(speakerSound[player])) then 
		destroyElement(speakerSound[player]) 
	end
end)

addEvent("onPlayerChangeSpeakerBoxVolumeC", true)
addEventHandler("onPlayerChangeSpeakerBoxVolumeC", root, function(player, vol) 
	if (isElement(speakerSound[player])) then
		setSoundVolume(speakerSound[player], tonumber(vol))
	end
end)

function isURL()
	if (guiGetText(url) ~= "") then
		return true
	else
		return false
	end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%." .. decimals .. "f"):format(number)) end
end