local listedekiler = {}
local myTimer = {}

addEvent("air.down", true)
addEventHandler("air.down", root, function()
	if not getElementData(source, "air_using") then
		if source.vehicle then
			if getElementVelocity(source.vehicle) == 0 then
				if exports.rl_items:hasItem(source.vehicle, 314) then
					local orginal = (getVehicleHandling(source.vehicle)["suspensionUpperLimit"] * -0.8)
					local option = (getVehicleHandling(source.vehicle)["suspensionLowerLimit"])
					if (option - 0.3 < orginal - 0.1) then
						setVehicleHandling(source.vehicle,"suspensionLowerLimit", option + 0.1)
						triggerClientEvent(root, "playVehicleSound", root, "public/sounds/airride.mp3", source.vehicle)
						source.vehicle:setData("air_default", nil)
						setElementData(client, "air_using", true)
						listedekiler[#listedekiler + 1] = source
						myTimer[source] = setTimer(function()
							local player = listedekiler[1]
							table.remove(listedekiler, 1)
							removeElementData(player, "air_using")
						end, 3000, 1)
					end
				end
			end
		end
	end
end)

addEvent("air.up", true)
addEventHandler("air.up", root, function()
	if not getElementData(source, "air_using") then
		if source.vehicle then
			if getElementVelocity(source.vehicle) == 0 then
				if exports.rl_items:hasItem(source.vehicle, 314) then
					local orginal = (getVehicleHandling(source.vehicle)["suspensionUpperLimit"] * -1.5)
					local option = (getVehicleHandling(source.vehicle)["suspensionLowerLimit"])
					if (option - 0.2 > orginal - 0.3) then
						setVehicleHandling(source.vehicle,"suspensionLowerLimit",option - 0.1)
						triggerClientEvent(root, "playVehicleSound", root, "public/sounds/airride.mp3", source.vehicle)
						source.vehicle:setData("air_default", nil)
						setElementData(client, "air_using", true)
						listedekiler[#listedekiler + 1] = source
						myTimer[source] = setTimer(function()
							local player = listedekiler[1]
							table.remove(listedekiler, 1)
							removeElementData(player, "air_using")
						end, 3000, 1)
					end
				end
			end
		end
	end
end)