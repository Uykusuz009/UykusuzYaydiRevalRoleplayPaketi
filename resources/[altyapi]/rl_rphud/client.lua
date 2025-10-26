local sw,sh = guiGetScreenSize()
rtx,rty = sw-95,20
lbx,lby = 20,sh-50
rw, rh = 100, 100
rx, ry = (sw - rw), (sh - rh)
hudTick = 0
click = 0
local awesomeIcon = exports["kaisen_fonts"]:getFont("FontAwesome",13)
local kaiLeft = exports["kaisen_fonts"]:getFont("UbuntuBold",12)
local kaiTopRight = exports["kaisen_fonts"]:getFont("UbuntuBold",12)
local kaiTopRightB = exports["kaisen_fonts"]:getFont("UbuntuBold",15)
local kaiLocate = exports["kaisen_fonts"]:getFont("UbuntuBold",10)
local speedText = exports["kaisen_fonts"]:getFont("Bebas",22)
local speedText2 = exports["kaisen_fonts"]:getFont("Bebas",8)
local fxText = exports["kaisen_fonts"]:getFont("Bebas",15)
local fxText2 = exports["kaisen_fonts"]:getFont("Bebas",13)
local screenW, screenH = guiGetScreenSize() 
local imageW, imageH = 800, 800 
local posX = (screenW - imageW) / 2
local posY = screenH - imageH

function getFormattedDate()
    local time = getRealTime()
    local day = time.monthday
    local month = time.month + 1
    local year = time.year + 1900
    if day < 10 then day = "0" .. day end
    if month < 10 then month = "0" .. month end
	hour = time.hour
    minute = time.minute
    if hour < 10 then hour = "0" .. hour end
	if minute < 10 then minute = "0" .. minute end
    return day .. "." .. month
end

function kaiHud()
    if getElementData(localPlayer, "hudkapa") == true then return end
	if getElementData(localPlayer, "logged") then
		if getElementData(localPlayer, "hud_settings").hud == 5 then
			local x, y, z = getElementPosition(localPlayer)
			local dateText = getFormattedDate()
			dxDrawImage(rtx-987,rty-555,1920,1080,"shadow.png",0,0,0,tocolor(255,255,255,150))
			dxDrawImage(rtx- 31,rty,100,100,"logo.png",0,0,0,tocolor(255,255,255))
			dxDrawRectangle(rtx-55,rty+22,2,55,tocolor(255,255,255,100))
			dxDrawText(" "..hour..":"..minute,rtx-173,rty+52,nil,nil,tocolor(255,255,255),1,kaiTopRight)
			dxDrawText(dateText.. " |",rtx-235,rty+52,nil,nil,tocolor(255,255,255),1,kaiTopRight)
			dxDrawText("Reval ROLEPLAY",rtx-100,rty+22,nil,nil,tocolor(255,255,255, 200),1,kaiTopRight,"right")
			dxDrawText("ID",rtx-500,rty+22,nil,nil,tocolor(255,255,255,200),1,kaiTopRight,"right")
			dxDrawText((getElementData(localPlayer,"id") or 0),rtx-508,rty+52,nil,nil,tocolor(255,255,255),1,kaiTopRight,"center")
			dxDrawText("KARAKTER ADI",rtx-300,rty+22,nil,nil,tocolor(255,255,255,200),1,kaiTopRight,"right")
			dxDrawText(getPlayerName(localPlayer),rtx-370,rty+52,nil,nil,tocolor(255,255,255),1,kaiTopRight,"center")
			dxDrawText("$"..exports.rl_global:formatMoney((getElementData(localPlayer,"money")or 0)),rtx+75,rty+100,nil,nil,tocolor(255,255,255),1,kaiTopRightB,"right")
			dxDrawText(silahisimDonus(getPedWeapon(localPlayer)),rtx+77,rty+130,nil,nil,tocolor(200,200,200),1,kaiTopRight,"right")
			dxDrawText(getPedAmmoInClip(localPlayer, getPedWeaponSlot(localPlayer)).."  |  "..getPedTotalAmmo(localPlayer),rtx+75,rty+155,nil,nil,tocolor(255,255,255),1,kaiTopRight,"right")
		end
	end
end
addEventHandler("onClientRender",root,kaiHud,true,"low-31")

function mouse( x, y, width, height)
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) ) 
end

function silahisimDonus(silahId)
    if silahId == 0 then
        return "Yumruk"
    elseif silahId == 22 then
        return "Colt-45"
    elseif silahId == 23 then
        return "Silenced"
    elseif silahId == 24 then
        return "Deagle"
    elseif silahId == 25 then
        return "Shotgun"
    elseif silahId == 26 then
        return "Sawed-Off"
    elseif silahId == 27 then
        return "Combat Shotgun"
    elseif silahId == 28 then
        return "Uzi"
    elseif silahId == 29 then
        return "MP5"
    elseif silahId == 30 then
        return "AK"
    elseif silahId == 31 then
        return "M4"
    elseif silahId == 32 then
        return "Tec-9"
    elseif silahId == 33 then
        return "Rifle"
    elseif silahId == 34 then
        return "Sniper"
    elseif silahId == 41 then
        return "Spray"
    elseif silahId == 43 then
        return "Kamera"
    elseif silahId == 44 then
        return "Gece Görüşü"
    elseif silahId == 46 then
        return "Paraşüt"
    elseif silahId == 1 then
        return "Muşta"
    elseif silahId == 2 then
        return "Golf Sopası"
    elseif silahId == 3 then
        return "Jop"
    elseif silahId == 4 then
        return "Bıçak"
    elseif silahId == 5 then
        return "Sopa"
    elseif silahId == 6 then
        return "Kürek"
    elseif silahId == 7 then
        return "Istaka"
    elseif silahId == 8 then
        return "Katana"
    elseif silahId == 9 then
        return "Testere"
    elseif silahId == 14 then
        return "Çiçek"
    else
        return "Bilinmeyen Silah"
    end
end