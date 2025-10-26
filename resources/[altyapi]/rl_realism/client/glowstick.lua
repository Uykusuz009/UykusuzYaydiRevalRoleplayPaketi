cooldown = 0

function dropGlowStick()
	if (cooldown == 0) then
		local x, y, z = getElementPosition(localPlayer)
		local rot = getPedRotation(localPlayer)
		local x = x + math.sin(math.rad(rot)) * 1
		local y = y + math.cos(math.rad(rot)) * 1
		local ground = getGroundPosition(x, y, z)
		
		cooldown = 1
		setTimer(resetCooldown, 5000, 1)
		triggerServerEvent("createGlowStick", localPlayer, x, y, ground) 
	else
		outputChatBox("[!]#FFFFFF Başka bir parlak çubuk atmadan önce bekleyin.", 255, 0, 0, true)
		playSoundFrontEnd(4)
	end
end

function resetCooldown()
	cooldown = 0
end