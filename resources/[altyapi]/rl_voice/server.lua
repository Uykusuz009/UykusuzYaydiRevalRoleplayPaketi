addEvent("voice.stream.update", true)
addEventHandler("voice.stream.update", root, function(newStreams)
    if client ~= source then
		return
	end
	
    setPlayerVoiceIgnoreFrom(client, nil)
    setPlayerVoiceBroadcastTo(client, newStreams)
end)

addEvent("voice.setChannel", true)
addEventHandler("voice.setChannel", root, function(channel)
	if client ~= source then
        exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if not channel then
		return
	end
	
	setElementData(client, "voice_channel", channel)
end)

if isVoiceEnabled() then
	local playerChannels = {}
	local channels = {}
	
	addEventHandler("onPlayerJoin", root, function()
		setPlayerVoiceBroadcastTo(source, getElementsByType("player"))
		setPlayerInternalChannel(source, root)
	end)

	addEventHandler("onResourceStart", resourceRoot, function()
		refreshPlayers()
		setTimer(refreshPlayers, 1000 * 60, 0)
	end)

	function refreshPlayers()
		for _, player in ipairs(getElementsByType("player")) do
			setPlayerInternalChannel(player, root)
		end
	end

	function setPlayerInternalChannel(player, element)
		if playerChannels[player] == element then
			return false
		end
		playerChannels[player] = element
		channels[element] = player
		setPlayerVoiceBroadcastTo(player, element)
		return true
	end
end

function setVoice(thePlayer, commandName, targetPlayer, channel)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer and channel and tonumber(channel) then
            channel = tonumber(math.floor(channel))
			if channel > 0 and channel <= #voiceChannels then
				if targetPlayer == "all" then
					for _, player in ipairs(getElementsByType("player")) do
						if getElementData(player, "logged") then
							setElementData(player, "voice_channel", channel)
						end
					end
					outputChatBox("[!]#FFFFFF Başarıyla tüm oyuncuların konuşma kanalı [" .. channel .. "] olarak ayarlandı.", thePlayer, 0, 255, 0, true)
				else
					local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "logged") then
							setElementData(targetPlayer, "voice_channel", channel)
							outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun konuşma kanalı [" .. channel .. "] olarak ayarlandı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili konuşma kanalınızı [" .. channel .. "] olarak ayarladı.", targetPlayer, 0, 0, 255, true)
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				end
			else
				outputChatBox("[!]#FFFFFF Bu sayıya ait bir konuşma kanalı bulunmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [1-" .. #voiceChannels .. "]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setvoice", setVoice, false, false)

function voice(thePlayer, commandName, channel)
	if channel and tonumber(channel) then
        channel = tonumber(math.floor(channel))
		if channel > 0 and channel <= 3 then
			if getElementData(thePlayer, "logged") then
				setElementData(thePlayer, "voice_channel", channel)
				outputChatBox("[!]#FFFFFF Başarıyla konuşma kanalınız [" .. channel .. "] olarak ayarlandı.", thePlayer, 0, 255, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Bu sayıya ait bir konuşma kanalı bulunmuyor.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
        outputChatBox("KULLANIM: /" .. commandName .. " [1-3]", thePlayer, 255, 194, 14)
    end
end
addCommandHandler("voice", voice, false, false)