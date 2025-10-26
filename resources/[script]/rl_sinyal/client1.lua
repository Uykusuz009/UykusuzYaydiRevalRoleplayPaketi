local shader = {}
shader[1] = dxCreateShader("files/shader.fx") -- Blinkers
shader[2] = dxCreateShader("files/shader3.fx") -- Alternative blinkers
local animShads = {}

local tex_left = "leftflash" -- Левая сторона мигает текстуры
local tex_right = "rightflash" -- Правая сторона мигает текстуры
local tex_reverse = "vehiclelights128" -- Текста фары

function getShaderType(veh)
	if aVehicles[getElementModel(veh)] then 
		return 2 
	else 
		return 1
	end
end

function updateShaders(veh)
	local state = getElementData(veh,"signal")
	local t = getShaderType(veh)
	if state == 0 then
		engineRemoveShaderFromWorldTexture(shader[t], tex_left, veh)
		engineRemoveShaderFromWorldTexture(shader[t], tex_right, veh)
	elseif state == 1 then
		engineApplyShaderToWorldTexture(shader[t], tex_left, veh)
		engineRemoveShaderFromWorldTexture(shader[t], tex_right, veh)
	elseif state == 2 then
		engineApplyShaderToWorldTexture(shader[t], tex_right, veh)
		engineRemoveShaderFromWorldTexture(shader[t], tex_left, veh)
	elseif state == 3 then
		engineApplyShaderToWorldTexture(shader[t], tex_left, veh)
		engineApplyShaderToWorldTexture(shader[t], tex_right, veh)
	end
end

function updateLights(veh)
	local state = getElementData(veh,"lights")
	if state == 0 then
		setVehicleOverrideLights(veh, 1)
		if animShads[veh] then
			destroyElement(animShads[veh][1])
			animShads[veh] = nil
		end
	elseif state == 1 then
		local shad = dxCreateShader("files/shader2.fx")
		animShads[veh] = {shad, false} -- False: Off, True: On
		engineApplyShaderToWorldTexture(shad, tex_reverse, veh)
	elseif state == 2 then
		setVehicleOverrideLights(veh, 2)
		-- Get headlight color from server
		triggerServerEvent("getVehicleHeadlightColor", localPlayer, veh)
	end
end

function updateMultipliers()
	for veh, v in pairs(animShads) do
		v[2] = not v[2] -- Toggle state between true (on) and false (off)
		dxSetShaderValue(v[1], "gMultiplier", v[2] and 1 or 0) -- 1 for on, 0 for off
		if not v[2] then -- If the state is off
			destroyElement(v[1])
			setVehicleOverrideLights(veh, 2)
			setVehicleHeadLightColor(veh, 0, 0, 0)
			animShads[veh] = nil
		end
	end
end
addEventHandler("onClientRender", root, updateMultipliers)

-- L tuşuna basıldığında farları açma
bindKey("l", "down", function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getVehicleController(veh) ~= localPlayer then return end
        triggerServerEvent("switchLights", localPlayer, veh)
    end
end)

-- /far komutu yazıldığında farları açma
addCommandHandler("far", function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getVehicleController(veh) ~= localPlayer then return end
        triggerServerEvent("switchLights", localPlayer, veh)
    end
end)


bindKey("8", "down", function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		if getVehicleController(veh) ~= localPlayer then return end
		local cur = getElementData(veh, "signal")
		if cur == 1 then
			setElementData(veh, "signal", 0)
		else
			setElementData(veh, "signal", 1)
		end
	end
end)

bindKey("9", "down", function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		if getVehicleController(veh) ~= localPlayer then return end
		local cur = getElementData(veh, "signal")
		if cur == 2 then
			setElementData(veh, "signal", 0)
		else
			setElementData(veh, "signal", 2)
		end
	end
end)

bindKey("0", "down", function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		if getVehicleController(veh) ~= localPlayer then return end
		local cur = getElementData(veh, "signal")
		if cur == 3 then
			setElementData(veh, "signal", 0)
		else
			setElementData(veh, "signal", 3)
		end
	end
end)

toggleControl("vehicle_look_right", false)
toggleControl("vehicle_look_left", false)

addEventHandler("onClientElementDataChange", getRootElement(),
function(dataName)
	if getElementType(source) == "vehicle" then
		if dataName == "signal" then
			updateShaders(source)
		elseif dataName == "lights" then
			updateLights(source)
		end
	end
end)

-- Add client event handler
addEvent("onClientHeadlightColor", true)
addEventHandler("onClientHeadlightColor", root, function(vehicle, r, g, b)
	setVehicleHeadLightColor(vehicle, r, g, b)
end)
