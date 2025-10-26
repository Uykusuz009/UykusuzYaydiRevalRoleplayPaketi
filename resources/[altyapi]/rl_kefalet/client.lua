local sx,sy = guiGetScreenSize()
local x,y = 450,200
local ox,oy = (sx-x)/2, (sy-y)/2
local font = exports.rl_fonts:getFont("RobotoB",16)
local font1 = exports.rl_fonts:getFont("Roboto",11)
panel = false

btncolor = tocolor(10,10,10,255)
btncolor1 = tocolor(10,10,10,255)

function kefalet()
	local jailTime = getElementData(localPlayer,"hapis_sure")
	if jailTime and (tonumber(jailTime) and tonumber(jailTime) > 0) or jailTime == "permanently" then
		if panel == true then
			currentSecs = tonumber(jailTime) and jailTime * 60 or jailTime
			CustomRectangle(ox, oy, x, y, tocolor(25,25,25,250), { 0.2, 0.2,0.2, 0.2 })
			dxDrawText("Kefalet Ödeme Arayüzü",ox+450,oy+60,ox,oy,tocolor(255,255,255,255),1,font,"center","center")
			
			dxDrawText(""..tonumber(currentSecs) and formatSeconds(currentSecs) or jailtime.."",ox+320,oy+150,ox,oy,tocolor(235,235,235,255),1,font1,"center","center")
			ucret = currentSecs * 100
			dxDrawText(""..exports.rl_global:formatMoney(ucret).."₺ Ödeme yaparak cezadan kurtulabilirsin.",ox+395,oy+190,ox,oy,tocolor(235,235,235,255),1,font1,"center","center")
			text = "Ödeme Yap"
			text2 = "üstünde yok mu? bankadan öde"
			x1 = dxGetTextWidth(text,1,font)
			w = x1/7
			CustomRectangle(ox+150, oy+130, x1+35, 35, btncolor, { 0.5, 0.5,0.5, 0.5 })
			CustomRectangle(ox+399, oy+10, x1-75, 40, tocolor(15,15,15,250), { 0.3, 0.3,0.3, 0.3 })
			dxDrawText(text,ox+175+w,oy+137,ox,oy,tocolor(235,235,235,255),1,font1)
			dxDrawText(text2,ox+127+w,oy+167,ox,oy,tocolor(235,235,235,255),0.8,font1)
			dxDrawText("X",ox+840,oy+60,ox,oy,tocolor(235,235,235,255),0.9,font,"center","center")
		end
	end
end

function colorchange()
	if panel == true then
		if mousepos(ox+150, oy+130, x1+35, 35) then
			btncolor = tocolor(5,5,5,255)
		else
			btncolor = tocolor(15,15,15,250)
		end
		
		if mousepos(ox+390, oy+10, x1-75, 40) then
			btncolor1 = tocolor(5,5,5,255)
		else
			btncolor1 = tocolor(15,15,15,250)
		end	
	end
end

function panelver()
	if not isTimer(paneltimer) then
		panel = true
		paneltimer = setTimer(kefalet,5,0)
		colortimer = setTimer(colorchange,5,0)
	else
		killTimer(paneltimer)
		killTimer(colortimer)
		panel = false
	end
end
addCommandHandler("kefalet",panelver)

addEventHandler("onClientClick", root, function(button, state)
if panel == true then
    if (button == "left") and (state == "up") then
		if mousepos(ox+150, oy+130, x1+35, 35) then
			triggerServerEvent("kefalet",localPlayer,localPlayer,"uzerinden",ucret)
			killTimer(paneltimer)
			killTimer(colortimer)
			panel = false
		elseif mousepos(ox+127+w,oy+167,ox,oy) then
			triggerServerEvent("kefalet",localPlayer,localPlayer,"bankadan",ucret)
			killTimer(paneltimer)
			killTimer(colortimer)
			panel = false
		end
	end
end
end)


addEventHandler("onClientKey",root,function(button,state)
	if panel == true then
    if (button == "left") and (state == "up") then
		elseif mousepos(ox+390, oy+10, x1-75, 40) then
				killTimer(paneltimer)
				killTimer(colortimer)
				panel = false
			end
		end
end)

function mousepos ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function formatSeconds(seconds)
	if type( seconds ) ~= "number" then
		return seconds
	end
	
	if seconds <= 0 then
		return "Şimdi"
	end
	
	if seconds < 60 then
		return formatTimeString( seconds, " Saniyelik Cezanız Bulunmaktadır." )
	end
	
	local minutes = math.floor( seconds / 60 )
	if minutes < 60 then
		return formatTimeString( minutes, " Dakikalık Cezanız Bulunmaktadır." )
	end
	
	local hours = math.floor( minutes / 60 )
	if hours < 48 then
		return formatTimeString( hours, " Saatlik Cezanız Bulunmaktadır." )
		
	end
	
	local days = math.floor( hours / 24 )
	return formatTimeString( days, " Gün" )
end

function formatTimeString( time, unit )
	if time == 0 then
		return ""
	end
	if unit == "day" or unit == "hour" or unit == "minute" or unit == "second" then
		return time .. " " .. unit .. ( time ~= 1 and "s" or "" )
	else
		return time .. "" .. unit
	end
end

function roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end