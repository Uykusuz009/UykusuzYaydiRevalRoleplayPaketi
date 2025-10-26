function playVehicleSound(soundPath, theVehicle)
    local x, y, z = getElementPosition(theVehicle)
    local sound = playSound3D(soundPath, x, y, z, false)
    if sound then
		attachElements(sound, theVehicle)
		setSoundVolume(sound, 0.5)
		setSoundMaxDistance(sound, 50)
		setElementDimension(sound, getElementDimension(theVehicle))
    end
end
addEvent("playVehicleSound", true)
addEventHandler("playVehicleSound", root, playVehicleSound)

addEvent("vehicleHorn", true)
addEventHandler("vehicleHorn", root, function(state, theVehicle)
    if isElement(trainSound) and (state) then
    	if isTimer(decrease) then
    		killTimer(decrease)
    	end
    	destroyElement(trainSound)
    end

    if not (state) then
    	decrease = setTimer(function() 
    		local time, final = getTimerDetails(decrease)
    		if isElement(trainSound) then
    			if final ~= 1 then
    				local volume = getSoundVolume(trainSound)
    				setSoundVolume(trainSound, volume - 0.5)
    			else
    				destroyElement(trainSound)
    			end
    		end
    	end, 300, 10)
    end
	
    if (state) then
        local x, y, z = getElementPosition(theVehicle)
        trainSound = playSound3D("public/sounds/train_horn.mp3", x, y, z)
        setSoundVolume(trainSound, 5.0)
        setSoundMaxDistance(trainSound, 190)
        attachElements(trainSound, theVehicle)
    end
end)