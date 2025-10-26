local tick = getTickCount()
local hitMarker = false
local _hitX, _hitY, _hitZ = 0, 0, 0

addEventHandler("onClientPlayerWeaponFire", root, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if hitElement and isElement(hitElement) and source == localPlayer then
		if getElementType(hitElement) == "player" then
			tick = getTickCount()
			
			if not render then
				render = true
			end
		
			_hitX = hitX
			_hitY = hitY
			_hitZ = hitZ
			
			setSoundVolume(playSound("public/sounds/hit.mp3"), 0.1)
		end
	end
end)

addEventHandler("onClientRender", root, function()
	if render then
		local now = getTickCount() - tick
		local sx, sy, _ = getScreenFromWorldPosition(_hitX, _hitY, _hitZ)
		
		if sx and now < 700 then
			dxDrawImage(sx - 12.5, sy - 12.5, 25, 25, "public/images/hit.dds")
		elseif now >= 700 then
			render = false
		end
	end
end)