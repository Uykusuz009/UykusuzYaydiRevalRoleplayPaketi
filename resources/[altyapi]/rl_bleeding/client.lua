addEvent("bleeding:control", true)
addEventHandler("bleeding:control", root, function(deger)
	if deger == "add" then
		if not controltimer then
			controltimer = setTimer(function(oyuncu)
				toggle(false)
			end,1000,0,source)	
		end
	elseif deger == "remove" then
		if isTimer(controltimer) then
			killTimer(controltimer)
			toggle(true)
		end
	end	
end)

function toggle(bool)
	toggleControl("sprint", bool)
end

setTimer(function()
	if getElementData(localPlayer, "injured") == 1 then
		if not getPedOccupiedVehicle(localPlayer) then
			local x, y, z = getElementPosition(localPlayer)
			fxAddBlood(x, y, z+0.5, 0.00000, 0.00000, 0.00000, 0, 1)
		end
	end
end, 100, 0)

local screen = Vector2(guiGetScreenSize())
local w, h = 32, 32
local x, y = (screen.x-w)/2, (screen.y-h)-5

function draw()
	if getElementData(localPlayer, "logged") then
		if getElementData(localPlayer, "injured") == 1 then
			dxDrawImage(x, y, w, h, "injured.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		end
	end
end
addEventHandler("onClientRender", root, draw)