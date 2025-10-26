addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
	if seat == 0 then
		setVehicleEngineState(vehicle, false)
	end
end)