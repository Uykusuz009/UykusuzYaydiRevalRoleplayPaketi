addEventHandler("onVehicleEnter", root,
	function(player)
		if exports.rl_global:hasItem(source, 84) then
			setTimer(triggerClientEvent, 1000, 1, player, "enablePoliceRadar", player)
		end
	end
)