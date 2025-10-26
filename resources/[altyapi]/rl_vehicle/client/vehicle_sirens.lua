function clientUpdateSirens()
	if (source == localPlayer) then
		local vehicles = getElementsByType("vehicle")
		for k,v in ipairs(vehicles) do
			local model = getElementModel(v)
			if (model == 525) then
				addVehicleSirens(veh, 3, 4, true, true, true, true)
				triggerEvent("sirens:setroofsiren", localPlayer, veh, 1, -0.7, -0.35, -0.7, 255, 0, 0)
				triggerEvent("sirens:setroofsiren", localPlayer, veh, 2, 0, -0.35, -0.7)
				triggerEvent("sirens:setroofsiren", localPlayer, veh, 3, 0.7, -0.35, -0.7, 255, 0, 0)
				return true
			elseif (exports.rl_global:hasItem(v, 144)) then
				addVehicleSirens(veh, 1, 2, true, true, false, true)
				triggerClientEvent(root, "sirens:setroofsiren", localPlayer, veh, 1, 0, 0, -0.2)
			end
		end
	end
end
addEventHandler("onClientPlayerJoin", root, clientUpdateSirens)