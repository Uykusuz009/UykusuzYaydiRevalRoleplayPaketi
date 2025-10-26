--- Türkçe Kaliteli Scriptin Adresi : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İyi Oyunlar...

local animEnable = {}
local syncPlayers = {}

addCommandHandler("ellerarkada",
	function(player)
		if (not animEnable[player]) then
			animEnable[player] = true
			triggerClientEvent(syncPlayers, "anim", player, true)
		else
			animEnable[player] = false
			triggerClientEvent(syncPlayers, "anim", player, false)
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