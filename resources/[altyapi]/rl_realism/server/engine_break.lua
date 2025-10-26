function engineBreak()
	local health = getElementHealth(source)
	local driver = getVehicleController(source)
	local vehID = getElementData(source, "dbid")
	
	if (driver) then
		if (health <= 300) then
			local rand = math.random(1, 2)

			if (rand == 1) then
				setVehicleEngineState(source, false)
				setElementData(source, "engine", 0)
				exports.rl_global:sendLocalDoAction(driver, "Aracınızın motoru arızalandı.")
				if exports.rl_global:hasItem(source, 3, vehID) then
					exports.rl_global:takeItem(source, 3, vehID)
					exports.rl_global:giveItem(driver, 3, vehID)
				end
			end
		elseif (health <= 400) then
			local rand = math.random(1, 5)

			if (rand == 1) then
				setVehicleEngineState(source, false)
				setElementData(source, "engine", 0)
				exports.rl_global:sendLocalDoAction(driver, "Aracınızın motoru arızalandı.")
				if exports.rl_global:hasItem(source, 3, vehID) then
					exports.rl_global:takeItem(source, 3, vehID)
					exports.rl_global:giveItem(driver, 3, vehID)
				end
			end
		end
	end
end
addEventHandler("onVehicleDamage", root, engineBreak)