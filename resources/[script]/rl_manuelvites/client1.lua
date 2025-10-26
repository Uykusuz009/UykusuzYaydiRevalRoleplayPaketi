local playerGear = 0
local playerVehicleSeat = 0

function setPlayerGear( key )
	if not isPedInVehicle(localPlayer) then return end
	if getPedControlState("accelerate") and playerGear < 5 then return outputChatBox ("[!]#ffffff Vitesi değiştirmek için gaz pedalını bırakın.", 255, 0, 0, true) end
	if key == "num_add" then
		if playerGear < 5 then
			playerGear = playerGear + 1
		end
	elseif key == "num_sub" then
		if playerGear > -1 then
			playerGear = playerGear - 1
		end
	end
	if playerGear == -1 then
		guiSetPosition( marker, 0.01, 0.275, true )
	elseif playerGear == 0 then
		guiSetPosition( marker, 0.3067,0.14, true )
	elseif playerGear == 1 then
		guiSetPosition( marker, 0.1767,0.01, true )
	elseif playerGear == 2 then
		guiSetPosition( marker, 0.33, 0.36, true )
	elseif playerGear == 3 then
		guiSetPosition( marker, 0.49, -0.05, true )
	elseif playerGear == 4 then
		guiSetPosition( marker, 0.66, 0.22, true )
	elseif playerGear == 5 then
		guiSetPosition( marker, 0.73, -0.05, true )
	end
	playSoundFrontEnd( 4 )
	setPedControlState( "accelerate", false )
	setPedControlState( "brake_reverse", false )
end

function setPlayerGearByCmd( command )
	if command == "gearu" then
		setPlayerGear( "num_add" )
	elseif command == "geard" then
		setPlayerGear( "num_sub" )
	end
end	

function createImage()
gearbox = guiCreateStaticImage(0.8132,0.4408,0.1502,0.1963,"gearbox.png",true)
marker = guiCreateStaticImage(0.3067,0.14,0.3033,0.4533,"marker.png",true,gearbox)
end

local sX,sY = guiGetScreenSize()
local rpmWidth = sX/10

local speedPerGearPercentage = {
	[1] = 15, 
	[2] = 35,
	[3] = 50,
	[4] = 60,
	[5] = 999
}

function kpp()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and playerVehicleSeat == 0 then
		if not guiGetVisible(gearbox) then
			guiSetVisible(gearbox,true)
		end
		local vt = getVehicleType(vehicle)
		if vt == "Automobile" or vt == "Monster Truck"  then
			local speed = getElementSpeed(vehicle,1)
			local topSpeed = getVehicleHandling(vehicle).maxVelocity

			local maxForGear = percent(speedPerGearPercentage[playerGear],topSpeed)
			
			if maxForGear then
				local actualWidth = (rpmWidth/maxForGear)*speed
					if actualWidth >= rpmWidth then
						actualWidth = rpmWidth
					end
			end
			if playerGear > 0 then
							--dxDrawText("Devir: ".. math.ceil(speed*15), sX*0.89,sY*0.37, 100, 20,white,1.2,"default-bold")
				if not isControlEnabled("accelerate") then
					toggleControl("accelerate", true)
				end
				if speed >= maxForGear-1 then
					if getPedControlState("accelerate") then
						setElementSpeed(vehicle, speed, maxForGear)
					end
					if playerGear ~= 5 then
		         	dxDrawText("Vites atman gerek. (+)", sX*0.39,sY*0.37, 100, 20,white,1.7,"default-bold")
					end
				else
					if playerGear == 1 then return end
					local speedBiggerThanGearAllows = percent(speedPerGearPercentage[playerGear-1],topSpeed)
					if speed+13 <= speedBiggerThanGearAllows then
						if isControlEnabled("accelerate") then
							toggleControl("accelerate", false)
						end
					end
				end
			else
				if playerGear == -1 then
					local keys2 = getBoundKeys( "accelerate" )
					for key in pairs(keys2) do
						if getKeyState( key ) then
							setPedControlState("brake_reverse", true)
						else
							setPedControlState("brake_reverse", false)
						end
						break
					end
				else
					toggleControl("accelerate", false)
					toggleControl("brake_reverse", false)
				end
			end
		end
	else
		if isElement(gearbox) and guiGetVisible(gearbox) then
			guiSetVisible(gearbox, false)
		end
	end
end

function enableGears()
	if not isElement(gearbox) then
		createImage()
		bindKey( "num_add", "up", setPlayerGear )
		bindKey( "num_sub", "up", setPlayerGear )
		addEventHandler( "onClientRender", root, kpp )
		addCommandHandler( "gearu", setPlayerGearByCmd )
		addCommandHandler( "geard", setPlayerGearByCmd )
	else
		removeEventHandler( "onClientRender", root, kpp )
		if isElement(gearbox) then destroyElement(gearbox) end
		if isElement(marker) then destroyElement(marker) end
		unbindKey( "num_add", "up", setPlayerGear )
		unbindKey( "num_sub", "up", setPlayerGear )
		removeCommandHandler ( "gearu", setPlayerGearByCmd ) 
		removeCommandHandler ( "geard", setPlayerGearByCmd )
		toggleControl( "accelerate", true )
		toggleControl( "brake_reverse", true )
	end
end
addCommandHandler( "manuelvites", enableGears )

addEventHandler( "onClientPlayerVehicleEnter", localPlayer, function ( _,seat ) if source == localPlayer then playerVehicleSeat = seat end end )

function percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        local x = (maxvalue*percent)/100
        return x
    end
    return false
end

function getElementSpeed(theElement, unit)
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function setElementSpeed(element, acSpeed, speed)
	if not isVehicleOnGround(element) then return end
	local speed = tonumber(speed)
	local diff = speed/acSpeed
	local x,y,z = getElementVelocity(element)
	setElementVelocity(element,x*diff,y*diff,z*diff)
end