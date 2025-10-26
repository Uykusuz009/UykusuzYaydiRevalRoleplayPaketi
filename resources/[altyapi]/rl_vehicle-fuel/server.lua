local fuellessVehicle = {
	[594] = true,
	[537] = true,
	[538] = true,
	[569] = true,
	[590] = true,
	[606] = true,
	[607] = true,
	[610] = true,
	[590] = true,
	[569] = true,
	[611] = true,
	[584] = true,
	[608] = true,
	[435] = true,
	[450] = true,
	[591] = true,
	[472] = true,
	[473] = true,
	[493] = true,
	[595] = true,
	[484] = true,
	[430] = true,
	[453] = true,
	[452] = true,
	[446] = true,
	[454] = true,
	[497] = true,
	[509] = true,
	[510] = true,
	[481] = true
}

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		if isPedInVehicle(player) then
			local vehicle = getPedOccupiedVehicle(player)
			if (vehicle) then
				local seat = getPedOccupiedVehicleSeat(player)	
				if (seat == 0) then
					local model = getElementModel(vehicle)
					if not (fuellessVehicle[model]) then
						local engine = getElementData(vehicle, "engine") or 0
						if engine == 1 then
							local fuel = getElementData(vehicle, "fuel") or 100
							if fuel >= 0 then
								local oldx = getElementData(vehicle, "oldx") or 0
								local oldy = getElementData(vehicle, "oldy") or 0
								local oldz = getElementData(vehicle, "oldz") or 0
								
								local x, y, z = getElementPosition(vehicle)
								
								local ignore = math.abs(oldz - z) > 50 or math.abs(oldy - y) > 1000 or math.abs(oldx - x) > 1000
								
								if not ignore then
									local distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
									if (distance < 10) then
										distance = 10
									end
									local handlingTable = getModelHandling(model)
									local mass = handlingTable["mass"]

									local newFuel = (distance / 500) + (mass / 20000)
									newFuel = fuel - ((newFuel / 100) * getMaxFuel(model))

									setElementData(vehicle, "fuel", newFuel)
									
									if newFuel < 0 then
										setElementData(vehicle, "fuel", 0)
										setVehicleEngineState(vehicle, false)
										setElementData(vehicle, "engine", 0)
										toggleControl(player, "brake_reverse", false)
									end
								end
								
								setElementData(vehicle, "oldx", x)
								setElementData(vehicle, "oldy", y)
								setElementData(vehicle, "oldz", z)	
							end
						end
					end
				end
			end
		end
	end
	
	for _, vehicle in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
		local engine = getElementData(vehicle, "engine") or 0
		if engine == 1 then
			local driver = getVehicleOccupant(vehicle)
			if not driver then
				local fuel = getElementData(vehicle, "fuel") or 100
				if fuel >= 0 then
					local oldx = getElementData(vehicle, "oldx") or 0
					local oldy = getElementData(vehicle, "oldy") or 0
					local oldz = getElementData(vehicle, "oldz") or 0
					
					local x, y, z = getElementPosition(vehicle)
					
					local model = getElementModel(vehicle)
					local distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
					if (distance < 10) then
						distance = 10
					end
					local handlingTable = getModelHandling(model)
					local mass = handlingTable["mass"]

					local newFuel = (distance / 500) + (mass / 20000)
					newFuel = fuel - ((newFuel / 100) * getMaxFuel(model))
					
					setElementData(vehicle, "fuel", newFuel)
					
					if newFuel < 0 then
						setElementData(vehicle, "fuel", 0)
						setVehicleEngineState(vehicle, false)
						setElementData(vehicle, "engine", 0)
					end
				end
			end
		end
	end
end, 10000, 0)