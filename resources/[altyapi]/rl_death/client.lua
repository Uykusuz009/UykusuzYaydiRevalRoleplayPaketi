local screenX, screenY = guiGetScreenSize()
local fonts = exports.rl_ui2:useFonts()

local deathTimer = 60

function playerDeath()
	if isTimer(lowerTime) then
		killTimer(lowerTime)
	end

	deathTimer = 60
	lowerTime = setTimer(lowerTimer, 1000, deathTimer)
	
	toggleAllControls(false, false, false)
	setElementData(localPlayer, "dead", true)
	outputChatBox("[!]#FFFFFF Bayıldınız, " .. deathTimer .. " saniye sonra tekrar ayılacaksınız.", 0, 0, 255, true)
	addEventHandler("onClientRender", root, drawnTimer)
end
addEvent("death.renderUI", true)
addEventHandler("death.renderUI", localPlayer, playerDeath)

addEventHandler("onClientKey", root, function(button, press)
	if (getElementData(localPlayer, "dead")) then
		if (press) then 
			if button == "lctrl" or button == "rctrl" or button == "space"  then 
				cancelEvent()     
				return true 
			end
		end
	end
end)

function lowerTimer()
	deathTimer = deathTimer - 1
	if deathTimer <= 0 then
		triggerServerEvent("death.acceptDeath", localPlayer, localPlayer, victimDropItem)
		playerRespawn()
		removeEventHandler("onClientRender", root, drawnTimer)
	end
end

function drawnTimer()
	dxDrawText(deathTimer .. " saniye sonra ayılacaksınız.", 0, 130, screenX, screenY - 75, tocolor(255, 255, 255, 255), 1, fonts.UbuntuBold.h5, "center", "bottom")
end

function playerRespawn()
    removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
		setElementData(localPlayer, "dead", false)
	end
end
addEvent("death.revive", true)
addEventHandler("death.revive", root, playerRespawn)

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", localPlayer, function()
	start = getTickCount()
end)

function closeRespawnButton()
	removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
	end
end
addEvent("death.closeRespawnButton", true)
addEventHandler("death.closeRespawnButton", localPlayer, closeRespawnButton)

addEventHandler("onClientPlayerWasted", localPlayer, function(attacker, weapon, bodypart)
	if getElementData(source, "dead") or getElementData(source, "spawn_protection") then
		cancelEvent()
	end
end)

addEventHandler("onClientPlayerDamage", localPlayer, function()
	if getElementData(source, "dead") or getElementData(source, "spawn_protection") then
		cancelEvent()
	end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function()
	if getElementData(source, "dead") or getElementData(source, "spawn_protection") then
		setPedWeaponSlot(localPlayer, 0)
	end
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function()
	if getElementData(source, "dead") or getElementData(source, "spawn_protection") then
		setPedWeaponSlot(localPlayer, 0)
	end
end)