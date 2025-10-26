--// noclip by chris1384 (client-side)

--// editable

local speed = {horizontal = 3, vertical = 1}

--//

local activated = false

local pos = {0, 0, 0}

addEvent("command:noclip", true)
addEventHandler("command:noclip", root, function()

	if source == localPlayer then -- useless condition, since the server trigger is always pointing to the player who entered the command
	
		if isPedDead(localPlayer) or getCameraTarget() ~= localPlayer or getPedOccupiedVehicle(localPlayer) then return outputChatBox("noclip could not be activated") end --// safety measure
	
		if activated then
			activated = false
			removeEventHandler("onClientPreRender", root, noclipRender)
			outputChatBox("noclip OFF")
		else
			activated = true
			pos = {getElementPosition(localPlayer)}
			addEventHandler("onClientPreRender", root, noclipRender)
			outputChatBox("noclip ON")
		end
		
	end
	
end)

addCommandHandler("noclipspeed", function(cmd, x)

	if tonumber(x) then
		speed = {horizontal = x, vertical = x/3}
		outputChatBox("noclip: speed changed to "..tostring(x))
	else
		outputChatBox("noclip: value must be a number")
	end
	
end)

function noclipRender()

	if isPedDead(localPlayer) or getCameraTarget() ~= localPlayer or getPedOccupiedVehicle(localPlayer) then --// safety measure
		activated = false
		removeEventHandler("onClientPreRender", root, noclipRender)
		outputChatBox("forced noclip OFF")
		return
	end
	
	local _, _, camera_rotation = getElementRotation(getCamera())
	
	if not isMTAWindowActive() and not isCursorShowing() then --// prevents moving when cursor is visible
		if getKeyState("w") then
			setElementPosition(localPlayer, 
				pos[1]+math.sin(math.rad((getKeyState("d") and 45-camera_rotation) or (getKeyState("a") and -45-camera_rotation) or -camera_rotation))*speed.horizontal,
				pos[2]+math.cos(math.rad((getKeyState("d") and 45-camera_rotation) or (getKeyState("a") and -45-camera_rotation) or -camera_rotation))*speed.horizontal,
				(getKeyState("space") and pos[3]+speed.vertical) or (getKeyState("lshift") and pos[3]-speed.vertical) or pos[3]
			)
			
		elseif getKeyState("s") then
			setElementPosition(localPlayer, 
				pos[1]-math.sin(math.rad((getKeyState("d") and -45-camera_rotation) or (getKeyState("a") and 45-camera_rotation) or -camera_rotation))*speed.horizontal,
				pos[2]-math.cos(math.rad((getKeyState("d") and -45-camera_rotation) or (getKeyState("a") and 45-camera_rotation) or -camera_rotation))*speed.horizontal,
				(getKeyState("space") and pos[3]+speed.vertical) or (getKeyState("lshift") and pos[3]-speed.vertical) or pos[3]
			)
			
		elseif getKeyState("d") then
			setElementPosition(localPlayer, 
				pos[1]+math.sin(math.rad(90-camera_rotation))*speed.horizontal,
				pos[2]+math.cos(math.rad(90-camera_rotation))*speed.horizontal,
				(getKeyState("space") and pos[3]+speed.vertical) or (getKeyState("lshift") and pos[3]-speed.vertical) or pos[3]
			)
			
		elseif getKeyState("a") then
			setElementPosition(localPlayer, 
				pos[1]-math.sin(math.rad(90-camera_rotation))*speed.horizontal,
				pos[2]-math.cos(math.rad(90-camera_rotation))*speed.horizontal,
				(getKeyState("space") and pos[3]+speed.vertical) or (getKeyState("lshift") and pos[3]-speed.vertical) or pos[3]
			)
			
		elseif getKeyState("space") then
			setElementPosition(localPlayer, pos[1], pos[2], pos[3]+speed.vertical)
			
		elseif getKeyState("lshift") then
			setElementPosition(localPlayer, pos[1], pos[2], pos[3]-speed.vertical)
		else
			setElementPosition(localPlayer, pos[1], pos[2], pos[3]) --// not to mess with gravity
		end
	else
		setElementPosition(localPlayer, pos[1], pos[2], pos[3]) --// not to mess with gravity
	end
	setElementRotation(localPlayer, 0, 0, -camera_rotation)
	
	pos = {getElementPosition(localPlayer)} --// important
end