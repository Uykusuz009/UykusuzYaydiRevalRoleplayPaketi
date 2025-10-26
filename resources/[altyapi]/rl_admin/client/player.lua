function developerMode(commandName)
	if exports.rl_integration:isPlayerDeveloper(localPlayer) then
		local developmentMode = not getDevelopmentMode()
		setDevelopmentMode(developmentMode)
		showCol(developmentMode)
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", 255, 0, 0, true)
		playSoundFrontEnd(4)
	end
end
addCommandHandler("devmode", developerMode, false, false)

function seeFar(commandName, value)
	if value and tonumber(value) then
		value = tonumber(value)
		if value >= 250 and value <= 20000 then
			setFarClipDistance(value)
		elseif value == -1 then
			resetFarClipDistance()
		else
			outputChatBox("[!]#FFFFFF Oluşturma mesafesi için maksimum değer 20000 ve minimum değer 250'dir.", 255, 0, 0, true)
            playSoundFrontEnd(4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Değer | -1 = Sıfırla]", 255, 194, 14)
	end
end
addCommandHandler("seefar", seeFar, false, false)

addEventHandler("onClientPlayerDamage", localPlayer, function()
	if (getElementData(source, "duty_admin")) and (not getElementData(source, "hidden_admin")) then
		cancelEvent()
	end
end)

addEventHandler("onClientVehicleDamage", root, function()
	local thePlayer = getVehicleOccupant(source)
	if thePlayer then
		if (getElementData(thePlayer, "duty_admin")) and (not getElementData(thePlayer, "hidden_admin")) then
			cancelEvent()
		end
	end
end)

addEvent("playNudgeSound", true)
addEventHandler("playNudgeSound", root, function()
    playSound("public/sounds/nudge.wav", false)
end)

addEvent("doEarthquake", true)
addEventHandler("doEarthquake", localPlayer, function()
	local x, y, z = getElementPosition(localPlayer) 
	createExplosion(x, y, z, -1, false, 3.0, false)
end)