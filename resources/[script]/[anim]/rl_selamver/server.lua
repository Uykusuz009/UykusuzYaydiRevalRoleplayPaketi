local animEnable = {}
local syncPlayers = {}

addCommandHandler("selamdur",
	function(player)
	veh = getPedOccupiedVehicle(player)
	if veh then outputChatBox("[!]#FFFFFF Bu komutu araçta kullanamazsınız.", player, 255, 0, 0, true) return end
		if (not animEnable[player]) then
			animEnable[player] = true
			triggerClientEvent(syncPlayers, "anim", player, true)
			outputChatBox("[!]#FFFFFF Selam veriyorsunuz. Bitirmek için komutu tekrarlayabilirsiniz.", player, 0, 255, 0, true)
		else
			animEnable[player] = false
			triggerClientEvent(syncPlayers, "anim", player, false)
			outputChatBox("[!]#FFFFFF Artık selam vermiyorsunuz. Eğer bugda kaldıysanız komutu tekrarlayın.", player, 255, 0, 0, true)
		end
	end
)

addEvent("onClientSync", true )
addEventHandler("onClientSync", resourceRoot,
    function()
        table.insert(syncPlayers, client)
		for player, enable in ipairs(animEnable) do
			if (enable) then
				triggerClientEvent(client, "anim", player, true)
			end
		end
    end 
)

addEventHandler("onPlayerQuit", root,
    function()
        for i, player in ipairs(syncPlayers) do
            if source == player then 
                table.remove(syncPlayers, i)
                break
            end 
        end
        if (animEnable[source] == true or animEnable[source] == false) then animEnable[source] = nil end
    end
)