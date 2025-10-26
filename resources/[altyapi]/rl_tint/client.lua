local sx, sy = guiGetScreenSize()
local scrSrc = dxCreateScreenSource(sx, sy)

local shaderFX = dxCreateShader("public/shaders/tinted_windows.fx", 1, 200, true)

function goodWindowTint()
	for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if (getElementData(vehicle, "tinted")) then
			engineApplyShaderToWorldTexture(shaderFX, "vehiclegeneric256", vehicle)
			engineApplyShaderToWorldTexture(shaderFX, "hotdog92glass128", vehicle)
			engineApplyShaderToWorldTexture(shaderFX, "okoshko", vehicle)
			engineApplyShaderToWorldTexture(shaderFX, "@hite", vehicle)
		else
			engineRemoveShaderFromWorldTexture(shaderFX, "vehiclegeneric256", vehicle)
			engineRemoveShaderFromWorldTexture(shaderFX, "hotdog92glass128", vehicle)
			engineRemoveShaderFromWorldTexture(shaderFX, "okoshko", vehicle)
			engineRemoveShaderFromWorldTexture(shaderFX, "@hite", vehicle)
		end
	end
end
addEvent("legitimateResponceRecived", true)
addEventHandler("legitimateResponceRecived", root, goodWindowTint)

function startTheRes()
	triggerServerEvent("tintDemWindows", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, startTheRes)
addEventHandler("onVehicleRespawn", resourceRoot, startTheRes)
addEvent("tintWindows", true)
addEventHandler("tintWindows", root, startTheRes)

function loadPoliceTextures(pixels, type)
	for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if (getElementData(vehicle, "faction") == 1) and type == "car" then
			local shader, tec = dxCreateShader("public/shaders/texreplace.fx")
			local tex = dxCreateTexture(pixels)
			engineApplyShaderToWorldTexture(shader, "vehiclepoldecals128", vehicle)
			engineApplyShaderToWorldTexture(shader, "vehiclepoldecals128lod", vehicle)
			dxSetShaderValue(shader, "gTexture", tex)
		end
		
		if (getElementData(vehicle, "faction") == 1) and type == "bike" then
			local shader, tec = dxCreateShader("public/shaders/texreplace.fx")
			local tex = dxCreateTexture(pixels)
			engineApplyShaderToWorldTexture(shader, "copbike92decalSA64", vehicle)
			dxSetShaderValue(shader, "gTexture", tex)
		end
		
		if (getElementData(vehicle, "faction") == 1) and type == "bike2" and getElementModel(vehicle) == 523 then
			local shader, tec = dxCreateShader("public/shaders/texreplace.fx")
			local tex = dxCreateTexture(pixels)
			engineApplyShaderToWorldTexture(shader, "vehiclepoldecals128", vehicle)
			engineApplyShaderToWorldTexture(shader, "vehiclepoldecals128lod", vehicle)
			dxSetShaderValue(shader, "gTexture", tex)
		end
	end
end
addEvent("loadPoliceTextures", true)
addEventHandler("loadPoliceTextures", root, loadPoliceTextures)