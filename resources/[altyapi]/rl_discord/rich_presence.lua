
addEventHandler("onClientResourceStart", resourceRoot, function()
	local app_id = "1403407999262785690"
	if setDiscordApplicationID(app_id) then 
	  setDiscordRichPresenceAsset("dclogo", "Bize Katıl!")
	  setDiscordRichPresenceButton(1, "Sunucuya Bağlan", "mtasa://94.156.113.158")
	  setDiscordRichPresenceButton(2, "Discord Bağlan", "https://discord.gg/VfDPDWEN")
	  updateRPC()
	end 
end)

function updateRPC()
	local name = getPlayerName(localPlayer):gsub("_"," ")
	setDiscordRichPresenceState("Oyunda ("..#getElementsByType("player").."/500)")
	setDiscordRichPresenceDetails(""..name)
	--setDiscordRichPresenceDetails("Karakter İD: " ..id)
end
setTimer(updateRPC, 5000, 0)
