local isSpeaker = false
speakerBox = {}

addCommandHandler("ses2", function(thePlayer, commandName)
	if (isElement(speakerBox[thePlayer])) then
		isSpeaker = true
	end
	triggerClientEvent(thePlayer, "onPlayerViewSpeakerManagment", thePlayer, isSpeaker)
end)

addEvent("onPlayerPlaceSpeakerBox", true)
addEventHandler("onPlayerPlaceSpeakerBox", root, function(url, isCar) 
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if (url) then
		if (isElement(speakerBox[client])) then
			local x, y, z = getElementPosition(speakerBox[client]) 
			outputChatBox("[!]#FFFFFF Ses başarıyla silindi.", client, 255, 0, 0, true)
			destroyElement(speakerBox[client])
			removeEventHandler("onPlayerQuit", client, destroySpeakersOnPlayerQuit)
		end
		
		local x, y, z = getElementPosition(client)
		local rx, ry, rz = getElementRotation(client)
		local interior = getElementInterior(client)
		local dimension = getElementDimension(client)
		speakerBox[client] = createObject(2226, x - 0.5, y + 0.5, z - 1, 0, 0, rx)
		setElementInterior(speakerBox[client], interior)
		setElementDimension(speakerBox[client], dimension)
		outputChatBox("[!]#FFFFFF Ses başarıyla oluşturuldu.", client, 0, 255, 0, true)
		addEventHandler("onPlayerQuit", client, destroySpeakersOnPlayerQuit)
		triggerClientEvent(root, "onPlayerStartSpeakerBoxSound", root, client, url, isCar)
		
		if (isCar) then
			local car = getPedOccupiedVehicle(client)
			attachElements(speakerBox[client], car, -0.7, -1.5, -0.5, 0, 90, 0)
		end
	end
end)

addEvent("onPlayerDestroySpeakerBox", true)
addEventHandler("onPlayerDestroySpeakerBox", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if (isElement(speakerBox[client])) then
		destroyElement(speakerBox[client])
		triggerClientEvent(root, "onPlayerDestroySpeakerBox", root, client)
		removeEventHandler("onPlayerQuit", client, destroySpeakersOnPlayerQuit)
		outputChatBox("[!]#FFFFFF Ses başarıyla silindi.", client, 255, 0, 0, true)
	else
		outputChatBox("[!]#FFFFFF Şu anda eklediğiniz ses yok.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
	end
end)

addEvent("onPlayerChangeSpeakerBoxVolume", true) 
addEventHandler("onPlayerChangeSpeakerBoxVolume", root, function(to)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end

	triggerClientEvent(root, "onPlayerChangeSpeakerBoxVolumeC", root, client, to)
end)

function destroySpeakersOnPlayerQuit()
	if (isElement(speakerBox[source])) then
		destroyElement(speakerBox[source])
		triggerClientEvent(root, "onPlayerDestroySpeakerBox", root, source)
	end
end