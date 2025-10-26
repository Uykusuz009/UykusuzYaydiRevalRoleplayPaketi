addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle)
	setElementData(vehicle, "groundoffset", 0.2 + getElementDistanceFromCentreOfMassToBaseOfModel(vehicle))
end)

addEvent("CantFallOffBike", true)
addEventHandler("CantFallOffBike", localPlayer, function()
	setPedCanBeKnockedOffBike(localPlayer, false)
	setTimer(setPedCanBeKnockedOffBike, 5000, 1, localPlayer, true)
end)