local screenX, screenY
local drawTimer
local isDrawing
local sound

function drawHitMarker()
	dxDrawImage(screenX-16, screenY-16, 32, 32, "hitmarker.png")
	
end

function fireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if getElementData(localPlayer, "hitmarker") then
	if hitElement then
			if getElementType(hitElement)=="player" then
		screenX, screenY = getScreenFromWorldPosition(hitX, hitY, hitZ)
		if not screenX then return end 
		if isDrawing then return end 
		isDrawing = true
		
		local sound = playSound("hitmarker-sound.wav")
		setSoundVolume( sound , 1)
	
	
		addEventHandler("onClientRender", root, drawHitMarker) 
		if drawTimer and isTimer(drawTimer) then
			killTimer(drawTimer)
		end
		
		
		drawTimer = setTimer(function() 
			isDrawing = false
			removeEventHandler("onClientRender", root, drawHitMarker) 
		end, 500, 1)
	end
	end
end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, fireFunc)

function get_hit()
	if getElementData(getLocalPlayer(), "hitmarker") then
	local hit_sound=playSound("hitmarker-sound.wav")
	setSoundVolume(hit_sound,0.5)
    end
end
addEventHandler("onClientPlayerDamage",getLocalPlayer(),get_hit)