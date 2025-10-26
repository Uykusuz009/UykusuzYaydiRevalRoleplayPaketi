local animEnable = {}
local syncPlayers = {}

addCommandHandler("motorayat",
	function(player)
		if (not animEnable[player]) then
			animEnable[player] = true
			triggerClientEvent(syncPlayers, "yat", player, true)
			outputChatBox("[!]#FFFFFF Motora yatıyorsun.", player, 0, 255, 0, true)
		else
			animEnable[player] = false
			triggerClientEvent(syncPlayers, "yat", player, false)
			outputChatBox("[!]#FFFFFF Artık motora yatmıyorsun.", player, 255, 0, 0, true)
		end
	end
)

addEvent("onClientSync", true )
addEventHandler("onClientSync", resourceRoot,
    function()
        table.insert(syncPlayers, client)
		for player, enable in ipairs(animEnable) do
			if (enable) then
				triggerClientEvent(client, "yat", player, true)
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

