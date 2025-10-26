local sx,sy = guiGetScreenSize()
local w,h = 65,65
local nx, ny = (sx-w)/2, (sy-h)/1.2

local sfbolds = exports.s_assets:getFont("in-bold",13)



addEvent("medkitbasiyor", true)
addEventHandler("medkitbasiyor", getRootElement(), function(thePlayer)
local tabOpenTick,rainbowTick = getTickCount(),getTickCount()
	if not isTimer(medkit) then
		zirh = 0
		setTimer(function() zirh = zirh + 1 end,25,100)
		medkit = setTimer(function()
			local dolCircle = interpolateBetween(0,0,0,360,0,0,(getTickCount()-tabOpenTick)/3000,"Linear")
			dxDrawCircle(nx+35, ny, w, h, tocolor(16,16,16, 255),360, 360, 50, false) 
			dxDrawCircle(nx+35, ny, w, h, tocolor(91,32,0, 255),30, dolCircle, 3, false) 
			dxDrawText("%"..zirh,nx+35,ny-10,nil,nil,tocolor(255,255,255,255),1,sfbolds,"center","top")
			dxDrawText("medkit kullanılıyor",nx+35,ny+35,nil,nil,tocolor(255,255,255,255),1,sfbolds,"center","top")
		end,0,0)
		if isTimer(medkit) then
			setTimer(function()
				killTimer(medkit)
			end,3000,1)
		end
	end
end)

