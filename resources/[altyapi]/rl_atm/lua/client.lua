screen = Vector2(guiGetScreenSize())
w, h = 250, 150
x, y = (screen.x-w)/2, (screen.y-h)/2+20

pw, ph = 250, 125
px, py = (screen.x-pw)/2, (screen.y-ph)/2
sx,sy = guiGetScreenSize()

click = 0

local awesome = dxCreateFont("files/FontAwesomeSolid.ttf",15)
local montB2 = dxCreateFont("files/Roboto.ttf",11)
local montB = dxCreateFont("files/Montserrat-SemiBold.otf",25)

tick = getTickCount()

function bankPanel()

	exports.kaisen_blur:bluredRectangle(0, 0, sx, sy, tocolor(255, 255, 255, 255))

	ikiyuzellibes = interpolateBetween(0,0,255,255,0,0,(getTickCount()-tick)/1000,"Linear") 
	ikiyuzkirk = interpolateBetween(0,0,240,240,0,0,(getTickCount()-tick)/1000,"Linear") 
	ikiyuz = interpolateBetween(0,0,200,200,0,0,(getTickCount()-tick)/1000,"Linear") 
	ikiyuzyirmi = interpolateBetween(0,0,220,220,0,0,(getTickCount()-tick)/1000,"Linear") 
	yuz = interpolateBetween(0,0,100,100,0,0,(getTickCount()-tick)/1000,"Linear") 
	yuzyetmisbes = interpolateBetween(0,0,175,175,0,0,(getTickCount()-tick)/1000,"Linear") 
	dxDrawImage(0,0,sx,sy,"files/particle.png",0,0,0,tocolor(255,255,255,ikiyuzellibes),false)
	dxDrawText("Banka Arayüzü",x-320,y-220,nil,nil,tocolor(240,240,240,ikiyuzkirk),1,montB)
	dxDrawText("ATM üzerindeki tüm işlevleriniz aşağıda yer almaktadır;",x-320,y-175,nil,nil,tocolor(200,200,200,ikiyuz),0.8,montB2)
	if isMousePosition(x+w+280,y-185,40,40) and panelleraktif == false then
		dxDrawText("",x+w+290,y-185,nil,nil,tocolor(255,0,0,yuzyetmisbes),1,awesome)
		-- exports.real_cursor:setPointer("hand")
		if isClicked(x+w+290,y-185,40,40) then
			close()
		end
	else
		dxDrawText("",x+w+290,y-185,nil,nil,tocolor(175,175,175,yuzyetmisbes),1,awesome)
	end
	
	-- Çek
	
	if isMousePosition(x-320,y-125,w+80,h) and panelleraktif == false then
		-- exports.real_cursor:setPointer("hand")
		drawRoundedGradientRectangle(x-320,y-125,w+80,h, {
        radius = 8,
        offset = {x = 50,y = 100},
			color  = {
				color1 = {100, 100, 100, 100},
				color2 = {150,50,50,220},
			},
			rotation = 100,
		},255,false)
		if isClicked(x-320,y-125,w+80,h) then
			addEventHandler("onClientRender",root,paneller,true,"low-999999")
			panelType = "Para Çek"
			panelleraktif = true
			eventIsmi = "bank:giveMoney"
			box = createEditBox(px+10,py+48,0.9,montB2,10,"Miktar Giriniz",200,200,200,ikiyuz,false,false,true)
		end
	end
	
	
	roundedRectangle(x+25,y-125,w-50,h,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x-320,y-125,w+80,h,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x+240,y-125,w+80,h,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x+25,y+45,w+80+215,h+25,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x-320,y+45,w+80,h+25,8,tocolor(100, 100, 100, yuz))
	
	
	roundedRectangle(x-320,y-125,w+80,h,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x-320+40,y-125+148,w,2,2,tocolor(150, 50, 50, ikiyuzyirmi))
	dxDrawText("",x-310,y-110,nil,nil,tocolor(150,50,50,ikiyuzyirmi),1,awesome)
	dxDrawText("Para Çek",x-275,y-107,nil,nil,tocolor(220,220,220,ikiyuzyirmi),0.40,montB)
	dxDrawText("Anında acil nakit ihtiyacınızı karşılamanız\niçin bu seçenekten para çekebilirsiniz, bunun\niçin butonun üstüne basmanız yeterlidir.",x-310,y-75,nil,nil,tocolor(200,200,200,ikiyuz),0.8,montB2)
	-- yat
	
	if isMousePosition(x+25,y-125,w-50,h) and panelleraktif == false then
		-- exports.real_cursor:setPointer("hand")
		drawRoundedGradientRectangle(x+25,y-125,w-50,h, {
        radius = 8,
        offset = {x = 50,y = 100},
			color  = {
				color1 = {100, 100, 100, 100},
				color2 = {50,150,50,220},
			},
			rotation = 100,
		},255,false)
		if isClicked(x+25,y-125,w-50,h) then
			addEventHandler("onClientRender",root,paneller,true,"low-999999")
			panelType = "Para Yatır"
			panelleraktif = true
			box = createEditBox(px+10,py+48,0.9,montB2,10,"Miktar Giriniz",200,200,200,ikiyuz,false,false,true)
			eventIsmi = "bank:takeMoney"
		end
	end
	roundedRectangle(x+25,y-125,w-50,h,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x-25+75,y-125+148,w-100,2,2,tocolor(50, 150, 50, ikiyuzyirmi))
	dxDrawText("",x+35,y-110,nil,nil,tocolor(50,150,50,ikiyuzyirmi),1,awesome)
	dxDrawText("Para Yatır",x+35+35,y-107,nil,nil,tocolor(220,220,220,ikiyuzyirmi),0.40,montB)
	dxDrawText("Üstünüzde bulunan nakit paraları\nbirikim veya\nmarket vb. yerlerde kullanmak için\nbu seçeneğe paranızı atabilirsiniz.",x+35,y-75,nil,nil,tocolor(200,200,200,ikiyuz),0.8,montB2)
	
	-- transfer
	
	if isMousePosition(x+240,y-125,w+80,h) and panelleraktif == false then
		-- exports.real_cursor:setPointer("hand")
		drawRoundedGradientRectangle(x+240,y-125,w+80,h, {
        radius = 8,
        offset = {x = 50,y = 100},
			color  = {
				color1 = {100, 100, 100, 100},
				color2 = {50,50,150,220},
			},
			rotation = 100,
		},255,false)
		if isClicked(x+240,y-125,w+80,h) then
			addEventHandler("onClientRender",root,paneller,true,"low-999999")
			panelType = "Transfer"
			panelleraktif = true
			eventIsmi = "bank:transferMoney"
			box = createEditBox(px+10,py+48,0.9,montB2,9,"Miktar Giriniz",200,200,200,ikiyuz,false,false,true)
			transferbox = createEditBox(px+10+120,py+48,0.9,montB2,3,"ID giriniz",200,200,200,ikiyuz,false,false,true)
		end
	end
	roundedRectangle(x+240,y-125,w+80,h,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x+240+40,y-125+148,w+80-80,2,2,tocolor(50, 50, 150, ikiyuzyirmi))
	dxDrawText("",x+250,y-110,nil,nil,tocolor(50,50,150,ikiyuzyirmi),1,awesome)
	dxDrawText("Para Aktar",x+250+40,y-107,nil,nil,tocolor(220,220,220,ikiyuzyirmi),0.40,montB)
	dxDrawText("Üstünüzde bulunan nakit paraları\nfarklı bi arkadaşınıza aktarmak için gerekli herşeyi\nburadan ulaşabilirsiniz.",x+250,y-75,nil,nil,tocolor(200,200,200,ikiyuz),0.8,montB2)
	
	-- geçmmiş
	
	if isMousePosition(x+25,y+45,w+80+215,h+25) and panelleraktif == false then
		-- exports.real_cursor:setPointer("hand")
		drawRoundedGradientRectangle(x+25,y+45,w+80+215,h+25, {
        radius = 8,
        offset = {x = 50,y = 100},
			color  = {
				color1 = {100, 100, 100, 100},
				color2 = {150,150,50,220},
			},
			rotation = 100,
		},255,false)
	end
	roundedRectangle(x+25,y+45,w+80+215,h+25,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x+25+40,y+218,w+80+215-80,2,2,tocolor(150, 150, 50, ikiyuzyirmi))
	dxDrawText("",x+35,y+55,nil,nil,tocolor(150,150,50,ikiyuzyirmi),1,awesome)
	dxDrawText("Hesap Geçmişi",x+35+35,y+57.5,nil,nil,tocolor(220,220,220,ikiyuzyirmi),0.40,montB)
	dxDrawText(" Ad Soyad                                                           İşlev                                                                    Miktar ",x+35,y+90,nil,nil,tocolor(200,200,200,ikiyuz),0.8,montB2)
	
	addY = 0
	for index,value in ipairs(gecmis) do
		if index < 4 then
			roundedRectangle(x+25+10,y+120+addY,w+80+215-20,25,8,tocolor(150, 150, 150, yuz))
			dxDrawText(value[1],x+25+15,y+125+addY,nil,nil,tocolor(225,225,225,ikiyuzyirmi),0.8,montB2)
			dxDrawText(value[2],x+25+250,y+125+addY,nil,nil,tocolor(225,225,225,ikiyuzyirmi),0.8,montB2)
			dxDrawText(value[3].."₺",x+25+500,y+125+addY,nil,nil,tocolor(225,225,225,ikiyuzyirmi),0.8,montB2)
			addY = addY + 30
		end
	end
	-- hesap
	
	if isMousePosition(x-320,y+45,w+80,h+25) and panelleraktif == false then
		-- exports.real_cursor:setPointer("hand")
		drawRoundedGradientRectangle(x-320,y+45,w+80,h+25, {
        radius = 8,
        offset = {x = 50,y = 100},
			color  = {
				color1 = {100, 100, 100, 100},
				color2 = {50,150,150,220},
			},
			rotation = 100,
		},255,false)
	end
	roundedRectangle(x-320,y+45,w+80,h+25,8,tocolor(100, 100, 100, yuz))
	roundedRectangle(x-320+40,y+45+h+23,w+80-80,2,2,tocolor(50, 150, 150, ikiyuzyirmi))
	dxDrawText("",x-310,y+55,nil,nil,tocolor(50,150,150,ikiyuzyirmi),1,awesome)
	dxDrawText("Hesap",x-310+40,y+57.5,nil,nil,tocolor(220,220,220,ikiyuzyirmi),0.40,montB)
	dxDrawText("Hesabın hakkındaki birçok bilgi\naşağıda yer almaktadır.\n\n\n".."Ad Soyad : "..localPlayer:getName().."\nBank : "..global:formatMoney(localPlayer:getData("bank_money")).."\nNakit : "..global:formatMoney(localPlayer:getData("money")),x-310,y+57.5+35,nil,nil,tocolor(200,200,200,ikiyuz),0.8,montB2)
end

function paneller(targetPlayer) 
	dxDrawRectangle(0,0,sx,sy,tocolor(0,0,0,ikiyuz),false)
	roundedRectangle(px,py,pw,ph,8,tocolor(25,25,25,ikiyuzkirk),true)
	roundedRectangle(px+pw-50-10,py+10,50,25,8,tocolor(150,50,50,ikiyuzkirk),true)
	if isMousePosition(px+pw-50-10,py+10,50,25) then
		-- exports.real_cursor:setPointer("hand")
		if isClicked(px+pw-50-10,py+10,50,25) then
			removeEventHandler("onClientRender",root,paneller)
			panelleraktif = false
			deleteEditBox(box)
			deleteEditBox(transferbox)
		end
	end
	dxDrawText(panelType,px+10,py+7,nil,nil,tocolor(225,225,225,ikiyuzyirmi),0.40,montB)
	dxDrawText("İşlemleri gerçekleştirmek için miktar giriniz.",px+10,py+24,nil,nil,tocolor(175,175,175,yuzyetmisbes),0.55,montB2)
	dxDrawText("",px+pw-40,py+15,nil,nil,tocolor(175,175,175,yuzyetmisbes),0.65,awesome)
	roundedRectangle(px+8.5,py+55,115,25,8,tocolor(50,50,50,ikiyuzkirk),true)
	if panelType == "Transfer" then
		roundedRectangle(px+8.5+120,py+55,115,25,8,tocolor(50,50,50,ikiyuzkirk),true)
		if isMousePosition(px+8.5,py+55,230,25,8) or isMousePosition(px+8.5+120,py+55,115,25,8) then
			-- exports.real_cursor:setPointer("text")
		end
	end
	roundedRectangle(px+8.5,py+90,85,25,8,tocolor(50,150,50,ikiyuzkirk),true)
	if isMousePosition(px+8.5,py+90,85,25) then
		-- exports.real_cursor:setPointer("text")
		if isClicked(px+8.5,py+90,85,25) then
			if panelType == "Transfer" then
				if tonumber(getEditBoxText(box)) > 0 then
					if tonumber(getEditBoxText(transferbox)) ~= localPlayer:getData("playerid") then
						triggerServerEvent(eventIsmi,localPlayer,localPlayer,tonumber(getEditBoxText(box)),tonumber(getEditBoxText(transferbox)))
					end
				end
			else
				if tonumber(getEditBoxText(box)) > 0 then 
					triggerServerEvent(eventIsmi,localPlayer,localPlayer,tonumber(getEditBoxText(box)))
				end
			end
			if panelType == "Para Çek" then
				if tonumber(localPlayer:getData("bank_money")) >= tonumber(getEditBoxText(box))then
					if tonumber(getEditBoxText(box)) > 0 then 
						table.insert(gecmis,1,{localPlayer:getName(),panelType,tonumber(getEditBoxText(box))})
					end
				end
			elseif panelType == "Para Yatır" then
				if global:hasMoney(localPlayer,getEditBoxText(box)) then
					if tonumber(getEditBoxText(box)) > 0 then 
						table.insert(gecmis,1,{localPlayer:getName(),panelType,tonumber(getEditBoxText(box))})
					end
				end
			elseif panelType == "Transfer" then
				local targetPlayer, targetPlayerName = global:findPlayerByPartialNick(localPlayer, tonumber(getEditBoxText(transferbox)))
				if targetPlayer then
					if tonumber(getEditBoxText(transferbox)) > 0 and tonumber(getEditBoxText(box)) > 0 then
						if tonumber(getEditBoxText(transferbox)) ~= localPlayer:getData("playerid") then
							table.insert(gecmis,1,{targetPlayer:getName(),panelType,getEditBoxText(box)})
						end
					end
				end
			end
		end
	end
	dxDrawText(panelType,px+20,py+94,nil,nil,tocolor(245,245,245,ikiyuzkirk),0.40,montB)
end

function open(button, state, _,_,_,_,_, clickedElement)
local tabOpenTick,rainbowTick = getTickCount(),getTickCount()
local posX, posY, posZ = getElementPosition(localPlayer)
	for k, theObject in ipairs(getElementsByType("object", resourceRoot)) do
		local x, y, z = getElementPosition(theObject)
		local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
		if distance<=5 and not panelState then
			if button == 'right' and state == 'down' then 
				if clickedElement then
					if getElementType(clickedElement) == 'object' and getElementModel(clickedElement) == 2942 then
						if not getPedOccupiedVehicle(localPlayer) and click + 600 <= getTickCount() then click = getTickCount()
							addEventHandler("onClientRender",root,bankPanel,true,"low-9999")
							panelState = true
							panelleraktif = false
							gecmis = {}						
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick",root,open)

function close()
	removeEventHandler("onClientRender",root,bankPanel)
	removeEventHandler("onClientRender",root,paneller)
	showCursor(false)
	panelState = false
end

function roundedRectangle(x, y, width, height, radius, color)
    local diameter = radius * 2
    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color)
    dxDrawCircle(x + width - radius, y + radius, radius, 270, 360, color)
    dxDrawCircle(x + radius, y + height - radius, radius, 90, 180, color)
    dxDrawCircle(x + width - radius, y + height - radius, radius, 0, 90, color)
    dxDrawRectangle(x + radius, y, width - diameter, height, color)
    dxDrawRectangle(x, y + radius, radius, height - diameter, color)
    dxDrawRectangle(x + width - radius, y + radius, radius, height - diameter, color)
    dxDrawRectangle(x + radius, y + radius, width - diameter, height - diameter, tocolor(0, 0, 0, 0))
end

local gradients = {}
--
function rgbToString(color)
    return table.concat({color[1], color[2], color[3]}, ",")
end
--
function drawRoundedGradientRectangle(x, y, w, h, array,alpha,postgui)
    local alpha = alpha or 255
    local key = string.format("%d%d%d%d%d%d%s%s%d", w, h, array.radius, array.radius, array.offset.x, array.offset.y, rgbToString(array.color.color1), rgbToString(array.color.color2), array.rotation)
    if not gradients[key] then
        local svgData = string.format([[
            <svg width="%d" height="%d" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <linearGradient id="grad1" x1="0%%" x2="100%%" y1="0%%" y2="0%%" gradientTransform="rotate(%d)">
                        <stop offset="%d%%" stop-color="rgb(%s)" />
                        <stop offset="%d%%" stop-color="rgb(%s)" />
                    </linearGradient>
                </defs>
                <rect width="%d" height="%d" rx="%d" ry="%d" fill="url(#grad1)" />
            </svg>
        ]], w, h, array.rotation, array.offset.x, rgbToString(array.color.color1), array.offset.y, rgbToString(array.color.color2), w, h, array.radius, array.radius)
        
        gradients[key] = svgCreate(w, h, svgData)
    end
    return dxDrawImage(x, y, w, h, gradients[key], 0, 0, 0, tocolor(255, 255, 255, alpha), postgui or false)
end


function isMousePosition( x, y, width, height)
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) ) 
end

function isClicked(x,y,w,h)
	if isMousePosition(x,y,w,h) and getKeyState("mouse1") and click+600 <= getTickCount() then click = getTickCount()
		return true
	end
end