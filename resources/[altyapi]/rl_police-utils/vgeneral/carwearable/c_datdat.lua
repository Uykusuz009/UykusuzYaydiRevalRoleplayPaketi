local sounds = { }

-- Bind Keys required
function bindKeys(res)
	bindKey("num_3", "down", toggleSirensDatdat)
	for key, value in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(value) then
			if getElementData(value, "lspd:datdat") and not getElementData(value, "lspd:siren1") and not getElementData(value, "lspd:siren2") and not getElementData(source, "lspd:siren3") then
				sounds[value] = playSound3D("sirens/datdat.wav", 0, 0, 0, true)
				attachElements(sounds[value], value)
				setSoundVolume(sounds[value], 0.7)
				setSoundMaxDistance(sounds[value], 180)
				setElementDimension(sounds[value], getElementDimension(value))
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function toggleSirensDatdat()
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (theVehicle) then
		local occupants = getVehicleOccupants(theVehicle)
		if occupants[0]==getLocalPlayer() then
			triggerServerEvent("lspd:setDatdatState", theVehicle)
		end
	end
end
addCommandHandler("togglesirens", toggleSirensDatdat, false)

function streamIn()
	if getElementType(source) == "vehicle" and getElementData(source, "lspd:datdat") and not getElementData(source, "lspd:siren2") and not getElementData(source, "lspd:siren1") and not getElementData(source, "lspd:siren2") and not getElementData(source, "lspd:siren3") and not sounds[source] then
		sounds[source] = playSound3D("sirens/datdat.wav", 0, 0, 0, true)
		attachElements(sounds[source], source)
		setSoundVolume(sounds[source], 0.7)
		setSoundMaxDistance(sounds[source], 180)
		setElementDimension(sounds[source], getElementDimension(source))
		setElementInterior(sounds[source], getElementInterior(source))
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if getElementType(source) == "vehicle" and sounds[source] then
		destroyElement(sounds[source])
		sounds[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function updateSirens(name)
	if name == "lspd:datdat" and isElementStreamedIn(source) and getElementType(source) == "vehicle" then
		local attached = getAttachedElements(source)
		if attached then
			for key, value in ipairs(attached) do
				if getElementType(value) == "sound" and value ~= sounds[source] then
					destroyElement(value)
				end
			end
		end
		
		if not getElementData(source, name) then
			if sounds[source] then
				destroyElement(sounds[source])
				sounds[source] = nil
			end
		else
			if not sounds[source] then
				sounds[source] = playSound3D("sirens/datdat.wav", 0, 0, 0, true)
				attachElements(sounds[source], source)
				setSoundVolume(sounds[source], 0.7)
				setSoundMaxDistance(sounds[source], 180)
				setElementDimension(sounds[source], getElementDimension(source))
				setElementInterior(sounds[source], getElementInterior(source))
			end
		end
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateSirens)