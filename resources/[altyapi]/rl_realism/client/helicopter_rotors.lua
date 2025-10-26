local heli = nil

function updateRotor()
	if isElement(heli) then
		if not getVehicleEngineState(heli) and getHelicopterRotorSpeed(heli) > 0 then
			local new = getHelicopterRotorSpeed(heli) - 0.0012
			setVehicleRotorSpeed(heli, math.max(0, new))
		end
	else
		disableRotorUpdate()
	end
end

function disableRotorUpdate()
	if heli then
		heli = nil
		removeEventHandler("onClientPlayerVehicleExit", localPlayer, disableRotorUpdate)
		removeEventHandler("onClientPreRender", root, updateRotor)
	end
end

function enableRotorUpdate(theVehicle)
	if getVehicleType(theVehicle) == "Helicopter" then
		heli = theVehicle
		
		addEventHandler("onClientPlayerVehicleExit", localPlayer, disableRotorUpdate)
		addEventHandler("onClientPreRender", root, updateRotor)
	end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, enableRotorUpdate)