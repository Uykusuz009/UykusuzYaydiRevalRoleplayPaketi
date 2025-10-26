addEventHandler("onClientVehicleDamage", root, function()
    if (exports.rl_global:isVehicleEmpty(source) and exports.rl_global:getVehicleVelocity(source) < 10 and not getVehicleEngineState(source)) or source.health < 350 then
        cancelEvent()
    end
end)

setTimer(function()
    local nearbyVehicles = getElementsWithinRange(localPlayer.position, 20, "vehicle", localPlayer.interior, localPlayer.dimension)
    if #nearbyVehicles > 0 then
        for _, vehicle in ipairs(nearbyVehicles) do
            if vehicle.health < 350 or vehicle.type == "Boat" or vehicle.type == "BMX" then
                if not vehicle.damageProof then
                    setVehicleDamageProof(vehicle, true)
					setVehicleEngineState(vehicle, false)
					setElementData(vehicle, "engine", 0)
					setElementData(vehicle, "enginebroke", 1)
                end
            else
                if vehicle.damageProof then
                    setVehicleDamageProof(vehicle, false)
                end
            end
        end
    end
end, 200, 0)