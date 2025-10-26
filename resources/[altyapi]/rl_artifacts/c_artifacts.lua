addEvent('artifacts:startChecking', true)

local currentInterior, currentDimension = 0, 0
local checking = false

function doCheck()
	local newInterior, newDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
	if currentInterior ~= newInterior or currentDimension ~= newDimension then
		triggerServerEvent('artifacts:update', root, localPlayer, newInterior, newDimension)
		currentInterior, currentDimension = newInterior, newDimension
	end
end

function startChecking(check)
	check = check or false
	if check then
		if not checking then
			currentInterior, currentDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
			addEventHandler('onClientPreRender', root, doCheck)
			checking = true
		end
	else
		if checking then
			removeEventHandler('onClientPreRender', root, doCheck)
			checking = false
		end
	end
end
addEventHandler('artifacts:startChecking', root, startChecking)

function applyTextureToArtifact(object, texData)
	if object and isElement(object) and texData then
		for k,v in ipairs(texData) do
			local path = v[1]
			local name = v[2]
			local shader, tec = dxCreateShader("texreplace.fx", 2, 0, true, "object")
			local tex = dxCreateTexture("textures/" .. tostring(path))
			engineApplyShaderToWorldTexture(shader, tostring(name), object)
			dxSetShaderValue(shader, "gTexture", tex)
		end
	end
end
addEvent('artifacts:addTexture', true)
addEventHandler('artifacts:addTexture', root, applyTextureToArtifact)

function applyTexturesToAllArtifacts(textable)
	if textable then
		for k,v in ipairs(textable) do
			applyTextureToArtifact(v[1], v[2])
		end
	end
end
addEvent('artifacts:addAllTextures', true)
addEventHandler('artifacts:addAllTextures', root, applyTexturesToAllArtifacts)

addEventHandler("onClientResourceStart", resourceRoot, function()
	--triggerServerEvent("item-system:addPlayerArtifacts", localPlayer)
end)