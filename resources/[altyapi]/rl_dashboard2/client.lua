screen = Vector2(guiGetScreenSize())

sx,sy = guiGetScreenSize()
panelWidth, panelHeight = 1920, 1080
scaleX, scaleY = sx/panelWidth, sy/panelHeight

local showdashboard = false
local fonst1 = exports.kaisen_fonts:getFont("Roboto", 13.5*scaleX)
local fonst2 = exports.kaisen_fonts:getFont("AwesomeFont", 20*scaleX)
local fonst3 = exports.kaisen_fonts:getFont("Bebas", 20*scaleX)
local fonst4 = exports.kaisen_fonts:getFont("Bebas", 20*scaleX)
local ramofont = exports.kaisen_fonts:getFont("Bebas", 30*scaleX)
local ramofont2 = exports.kaisen_fonts:getFont("Bebas", 27*scaleX)

local texts = { 
	{icerik = "ANASAFYA",xOffset = -585, yOffset = -260, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont , deger = 1} ,
	-- {icerik = "ANASAFYA",xOffset = -470, yOffset = -260, width = 50, height = 50, color = tocolor(0, 182, 148, 255), fontname = ramofont , deger = 1} ,
	{icerik = "MARKET",xOffset = -565, yOffset = -190, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "BİRLİK",xOffset = -565, yOffset = 260, width = 55, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "RevalPASS",xOffset = -240, yOffset = -190, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "KARAKTER",xOffset = -240, yOffset = -15, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "NAMETAG",xOffset = 90, yOffset = -15, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "RAPOR",xOffset = 395, yOffset = -15, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "SUNUCUDAN ÇIK",xOffset = 395, yOffset = 175, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "HUD",xOffset = 88, yOffset = -190, width = 50, height = 50, color = tocolor(255, 255, 255, 255), fontname = ramofont2 , deger = 1} ,
	{icerik = "Bu menüden donate mağazaya erişip \nkendinize özel şeyler satın alabilirsiniz.",xOffset = -563, yOffset = -150, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Çok yakında sizlerle...",xOffset = -563, yOffset = 300, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Çok yakında sizlerle...",xOffset = -238, yOffset = -150, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Çok yakında sizlerle...",xOffset = -238, yOffset = 25, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Bu menüden nametagınızı \nözelleştirebilirsiniz.",xOffset = 92, yOffset = 25, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Bu menüden yetkililer ile \niletişim kurabilirsiniz.",xOffset = 397, yOffset = 25, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Buraya tıklayarak sunucudan \nayrılabilirsiniz.",xOffset = 397, yOffset = 215, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
	{icerik = "Bu menüden hud arayüzüne erişebilirsiniz.",xOffset = 90, yOffset = -150, width = 50, height = 50, color = tocolor(200, 200, 200, 255), fontname = fonst1 , deger = 1} ,
}
local rectangles = {
	{xOffset = -590, yOffset = 250, width = 650, height = 100, color = tocolor(33, 33, 33, 100), eventName = "" , rgb = {255,127,0} }, --- birlik
	
	{xOffset = 70, yOffset = -200, width = 610, height = 170, color = tocolor(33, 33, 33, 100), eventName = "hudacdayi" , rgb = {0,127,255}  }, ---- envanter
	{xOffset = 70, yOffset = -20, width = 300, height = 370, color = tocolor(33, 33, 33, 100), eventName = "nametagacdayi"  , rgb = {255,127,0}  },  -- nametag 
	
	{xOffset = 380, yOffset = -20, width = 300, height = 180, color = tocolor(33, 33, 33, 100), eventName = "reportacdayi" ,  rgb = {255,255,0} }, --- rapor panel 
	{xOffset = 380, yOffset = 170, width = 300, height = 180, color = tocolor(33, 33, 33, 100), eventName = "oyundanayrilbroc" ,  rgb = {255,0,0} }, --- sunucudan çık 
	
	{xOffset = -590, yOffset = -200, width = 320, height = 440, color = tocolor(33, 33, 33, 100), eventName = "marketacdayi" , rgb = {0,182,148} },  ---- ooc market 
	{xOffset = -260, yOffset = -20, width = 320, height = 260, color = tocolor(33, 33, 33, 100), eventName = "" ,  rgb = {255,255,0}   }, --- Karakters
	{xOffset = -260, yOffset = -200, width = 320, height = 170, color = tocolor(33, 33, 33, 100), eventName = "" , rgb = {102,0,153}  },  --- gamepass
}

local images = {
	{xOffset = -590, yOffset = -150, width = 320, height = 390, imagename = "assets/market.png" },
	{xOffset = -100, yOffset = -200, width = 170, height = 170, imagename = "assets/pass.png" },
	{xOffset = 400, yOffset = -198, width = 150, height = 170, imagename = "assets/profile.png" },
	{xOffset = -240, yOffset = 252, width = 300, height = 100, imagename = "assets/faction.png" },
	{xOffset = 280, yOffset = -20, width = 400, height = 180, imagename = "assets/report.png" },
	{xOffset = -260, yOffset = -20, width = 320, height = 260, imagename = "assets/character.png" },
	{xOffset = 70, yOffset = -20, width = 300, height = 370, imagename = "assets/gamepass.png" },
	{xOffset = 270, yOffset = 190, width = 400, height = 160, imagename = "assets/settings.png" },
}

local scale = 1.2 * scaleX

function dashboard()
    local screenW, screenH = guiGetScreenSize()
    local rectW, rectH = 100, 100
    local startX, startY = (screenW - rectW) / 2 - 500, (screenH - rectH) / 2 - 150 
    local rectX, rectY = (screenW - rectW) / 2, (screenH - rectH) / 2
	exports.kaisen_blur:bluredRectangle(0, 0, sx, sy, tocolor(255, 255, 255, 255))
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(31, 31, 31, 200))
	
	-- dxDrawImage(0,0,sx,sy,"assets/siyah.png",0,0,0,tocolor(0,0,0,175),false)
	-- dxDrawImage(0,0,sx,sy,"assets/starisbg.png",0,0,0,tocolor(255,255,255,120),false)


	
	dxDrawText("Kapat", 255 * scaleX , 115 * scaleY, nil, nil, tocolor(200,200,200,255), 1, exports.kaisen_fonts:getFont("sf-medium",12 * scaleX), "left", "top", true, true, true, true)
	dxDrawImage(210 * scaleX ,111 * scaleY, 40 * scaleX, 30 * scaleY,"dosyalar/esc.png",0,0,0,tocolor(255,255,255,255),false)
	-- dxDrawText("DAVET: #00b694"..(tonumber(getElementData(getLocalPlayer(),"oyuncuKod")) or 0).."", 600 * scaleX , 195 * scaleY, nil, nil, tocolor(200,200,200,255), 1, exports.kaisen_fonts:getFont("Bebas",18* scaleX), "left", "top", true, true, true, true)
	
    function dxDrawRoundedRectangle(x, y, width, height, radius, color)
        dxDrawRectangle(x + radius, y, width - 2 * radius, height, color)
        dxDrawRectangle(x, y + radius, radius, height - 2 * radius, color)
        dxDrawRectangle(x + width - radius, y + radius, radius, height - 2 * radius, color)
    
        dxDrawCircle(x + radius, y + radius, radius, 180, 270, color, color)
        dxDrawCircle(x + width - radius, y + radius, radius, 270, 360, color, color)
        dxDrawCircle(x + radius, y + height - radius, radius, 90, 180, color, color)
        dxDrawCircle(x + width - radius, y + height - radius, radius, 0, 90, color, color)
    end

    sx,sy = guiGetScreenSize()
    panelWidth, panelHeight = 1920, 1080
    scaleX, scaleY = sx/panelWidth, sy/panelHeight
    
    local plrmoney = getElementData(localPlayer,"money")

    local plrbalance = getElementData(localPlayer,"balance")

    local plrlvl = getElementData(localPlayer,"level")
    
    dxDrawRoundedRectangle((1520)*scaleX,(165)*scaleY,40*scaleX,40*scaleY, 12, tocolor(50,50,50,200))
    dxDrawImage((1530)*scaleX,(175)*scaleY,20*scaleX,20*scaleY,"dosyalar/dollar.png",0,0,0,tocolor(255,255,255,255))
    dxDrawText(plrmoney.." #00b695₺",(1510)*scaleX,(175)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top",true,true,true,true,true)

    dxDrawRoundedRectangle((1320)*scaleX,(165)*scaleY,40*scaleX,40*scaleY, 12, tocolor(50,50,50,200))
    dxDrawImage((1330)*scaleX,(175)*scaleY,20*scaleX,20*scaleY,"dosyalar/dollar2.png",0,0,0,tocolor(255,255,255,255))
    dxDrawText(plrbalance.." #00b695GC",(1310)*scaleX,(175)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top",true,true,true,true,true)

    dxDrawText(localPlayer.name:gsub("_"," "),(1715)*scaleX,(160)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top")
    dxDrawText(plrlvl.."#00b695/#ACACACLvl",(1715)*scaleX,(180)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top",true,true,true,true,true)

    for _, rect in ipairs(rectangles) do
        local posX = rectX + (rect.xOffset * scale)
        local posY = rectY + (rect.yOffset * scale)
        local width = rect.width * scale
        local height = rect.height * scale

		local currentAlpha = updateHoverAnimation(_, mousePos(posX, posY, width, height) and 150 or 0)

		if not mousePos(posX, posY, width, height) then
            rectangle(posX, posY, width, height, tocolor(90, 90, 90, 120), {0.03, 0.03, 0.03, 0.03})
        else
            if isClicked() then 
                close()
                triggerEvent(rect.eventName, localPlayer)
            end 

		drawRoundedGradientRectangle(posX, posY, width, height, {
        radius = 7,
        offset = {x = 0, y = 100},
        color  = {
        color1 = {unpack(rect.rgb)}, 
        color2 = {0,0,0},   
        },
        rotation = 40,
        }, currentAlpha, 0.8, "right-to-left", 10000, false) 


            rectangle(posX, posY, width, height, tocolor(90, 90, 90, 120), {0.05, 0.05, 0.05, 0.05})
        end 
    end 

    for _, imagespanel in ipairs(images) do
        local posX = rectX + (imagespanel.xOffset * scale)
        local posY = rectY + (imagespanel.yOffset * scale)
        local width = imagespanel.width * scale
        local height = imagespanel.height * scale

        dxDrawImage(posX, posY, width, height, imagespanel.imagename, 0, 0, 0, tocolor(255, 255, 255, 255))
    end

    for _, textsss in ipairs(texts) do
        local posX = rectX + (textsss.xOffset * scale)
        local posY = rectY + (textsss.yOffset * scale)
        
        dxDrawText(textsss.icerik, posX, posY, nil, nil, textsss.color, textsss.deger, textsss.fontname, "left", "top", true, true, true, true)
    end 
end

local hoverAnimations = {}

function updateHoverAnimation(key, targetAlpha)
    hoverAnimations[key] = hoverAnimations[key] or 200
    local diff = targetAlpha - hoverAnimations[key]
    hoverAnimations[key] = math.abs(diff) < 5 and targetAlpha or hoverAnimations[key] + diff * 0.02
    return hoverAnimations[key]
end



bindKey("F1", "down", function()
	if not showdashboard then 
		open()
	else
		close()
	end 
end)

-- bindKey("mouse2", "down", function()
-- 	if showdashboard then
-- 		close()
-- 	end
-- end)

addEventHandler("onClientKey", root,
function(button, press)
    if button == "escape" and press then
        if showdashboard then
            close()
        end
    end
end)

function open()
	if not showdashboard then 
		showdashboard = true
		showCursor(true)
		showChat(false)
		setElementData(localPlayer, "hudkapa", true)
		addEventHandler("onClientRender", root, dashboard, false, "low-99999")
	end 
end 

function close()
	if showdashboard then
		hoverAnimations["dashboardstaris"] = 0
		showdashboard = false
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, "hudkapa", false)
		removeEventHandler("onClientRender", root, dashboard)
	end
end 

local tick = getTickCount()
function isClicked()
  if getKeyState("mouse1") and tick < getTickCount() then 
      tick = getTickCount()+500 
      return true
    end
  return false
end


function mousePos ( x, y, width, height )
    if ( not isCursorShowing( ) ) then
        return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end


local gradients = {}
function rgbToString(color)
    return table.concat({color[1], color[2], color[3]}, ",")
end
function drawRoundedGradientRectangle(x, y, w, h, array, alpha, startOpacity, direction, fadeLength, postgui)
    local alpha = alpha or 255
    local startOpacity = startOpacity or 1  
    local direction = direction or "left-to-right"  
    local fadeLength = fadeLength or 100 

    local x1, y1, x2, y2 = "0%", "0%", "100%", "0%"  
    if direction == "right-to-left" then
        x1, y1, x2, y2 = "100%", "0%", "0%", "0%"
    elseif direction == "top-to-bottom" then
        x1, y1, x2, y2 = "0%", "0%", "0%", "100%"
    elseif direction == "bottom-to-top" then
        x1, y1, x2, y2 = "0%", "100%", "0%", "0%"
    end

    local key = string.format("%d%d%d%d%d%d%s%s%d%f%s%d", w, h, array.radius, array.radius, array.offset.x, array.offset.y, rgbToString(array.color.color1), rgbToString(array.color.color2), array.rotation, startOpacity, direction, fadeLength)
    if not gradients[key] then
        local svgData = string.format([[
            <svg width="%d" height="%d" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <linearGradient id="grad1" x1="%s" y1="%s" x2="%s" y2="%s" gradientTransform="rotate(%d)">
                        <stop offset="0%%" stop-color="rgb(%s)" stop-opacity="%f" />
                        <stop offset="%d%%" stop-color="rgb(%s)" stop-opacity="0" />
                    </linearGradient>
                </defs>
                <rect width="%d" height="%d" rx="%d" ry="%d" fill="url(#grad1)" />
            </svg>
        ]], w, h, x1, y1, x2, y2, array.rotation, rgbToString(array.color.color1), startOpacity, fadeLength, rgbToString(array.color.color2), w, h, array.radius, array.radius)
        
        gradients[key] = svgCreate(w, h, svgData)
    end
    return dxDrawImage(x, y, w, h, gradients[key], 0, 0, 0, tocolor(255, 255, 255, alpha), postgui or false)
end

function drawRoundedGradientRectangle2(x, y, w, h, array, alpha)
    local key = table.concat({w, h, array.radius, table.concat(array.color.color1, ","), table.concat(array.color.color2, ","), array.direction or "up"}, "_")
    if not gradients[key] then
        local gradientDirection = array.direction == "down" and "x1='0%' y1='0%' x2='0%' y2='100%'" or
                                  array.direction == "left" and "x1='100%' y1='0%' x2='0%' y2='0%'" or
                                  "x1='0%' y1='100%' x2='0%' y2='0%'"
        local svgData = string.format([[<svg width="%d" height="%d" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="grad1" %s><stop offset="0%%" stop-color="rgb(%s)" stop-opacity="0.7" /><stop offset="50%%" stop-color="rgb(%s)" stop-opacity="0.3" /><stop offset="100%%" stop-color="rgb(%s)" stop-opacity="0" /></linearGradient></defs><rect width="%d" height="%d" rx="%d" ry="%d" fill="rgb(%s)" /><rect width="%d" height="%d" rx="%d" ry="%d" fill="url(#grad1)" /></svg>]], w, h, gradientDirection, table.concat(array.color.color2, ","), table.concat(array.color.color2, ","), table.concat(array.color.color2, ","), w, h, array.radius, array.radius, table.concat(array.color.color1, ","), w, h, array.radius, array.radius)
        gradients[key] = svgCreate(w, h, svgData)
    end
    dxDrawImage(x, y, w, h, gradients[key], 0, 0, 0, tocolor(255, 255, 255, alpha or 255))
end