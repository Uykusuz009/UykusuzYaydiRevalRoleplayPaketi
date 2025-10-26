vehicles = {}
volume = 100

local screen = Vector2(guiGetScreenSize())
local w, h = 560, 448
local sx, sy = (screen.x-w)/2, (screen.y-h)/2

local current = 1
local maxrow = 7
local latest = 1

musics = {}
saves = {}
lastText = nil

fonts = {
	bold = exports.rl_fonts:getFont('in-bold', 10),
	regular = exports.rl_fonts:getFont('in-regular', 11),
	light = exports.rl_fonts:getFont('in-light', 10),
	medium = exports.rl_fonts:getFont('in-medium', 10),
	bebas  = exports.rl_fonts:getFont('Bebas', 19),
	awesome = exports.rl_fonts:getFont('FontAwesome', 12),
	awesome2 = exports.rl_fonts:getFont('FontAwesome', 14),
	iconFont = exports.rl_fonts:getFont('FontAwesome', 14),
}

local selected = ""
local musicBoxes = {
	["search_bar"] = {"", false},
}

category = {
{1, "Tarayıcı", ""},
{2, "Kaydedilenler", ""}
}

click = 0
alpha = 0
loading = false
function init()
y = 0
newY = 0
x1 = 0
x2 = 0
x3 = 0
dxDrawRectangle(sx, sy, w, h, tocolor(15,15,15,255))
dxDrawText('SES ARAYUZU',sx+15, sy+5, nil, nil, tocolor(255,255,255), 1, fonts.bebas)
if page == 1 then
message = 'açmak istediğiniz şarkının adını aşağıdaki boşluğa yazınız.'
elseif page == 2 then
message = 'kaydedilen şarkılar aşağıda listelendi. ('..#saves..')'
end
dxDrawText(message,sx+15, sy+35, nil, nil, tocolor(70,70,70,255), 1, fonts.light)
for k,v in ipairs(category) do
dxDrawRectangle(sx+75+x1, sy+400, 200, 35, page == v[1] and tocolor(33, 33, 33, 220) or tocolor(22, 22 ,22, 220))
dxDrawText(v[2], sx+200+x2, sy+408, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.bold, "right")
dxDrawText(v[3], sx+140+x3, sy+406, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.awesome, "right")
  if mousePos(sx+75+x1, sy+400, 200, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
  click = getTickCount()
  page = v[1]
  end
  x1 = x1 + 210
  x2 = x2 + 230
  x3 = x3 + 188
end
  if mousePos(sx+505, sy+60, 30, 35) or mousePos(sx+500, sy+10, 35, 35) then
    if alpha < 200 then
		alpha = alpha + 20
    elseif alpha >= 200 then
		alpha = 200
	end
	else
	alpha = 0
  end  
  if isElement(vehicles[getPedOccupiedVehicle(localPlayer)]) then
  dxDrawRectangle(sx+460, sy+10, 35, 35, (mousePos(sx+460, sy+10, 35, 35) and tocolor(66, 102, 245, 255) or tocolor(50, 50, 50, 255)))
  dxDrawText("", sx+470, sy+15, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.awesome2)
   if mousePos(sx+460, sy+10, 35, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
	  click = getTickCount()
	if not getPedOccupiedVehicle(localPlayer) then exports.rl_infobox:addBox("warning", "Bu işlemi gerçekleştirmek için bir araçta olmalısınız!") return end 
	  triggerServerEvent("stopVehicleMusic", resourceRoot, getPedOccupiedVehicle(localPlayer))
   end
 end
  dxDrawRectangle(sx+500, sy+10, 35, 35, (mousePos(sx+500, sy+10, 35, 35) and tocolor(253,59,52,alpha) or tocolor(50, 50, 50, 255)))
  dxDrawText("", sx+510, sy+15, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.awesome2)
  if mousePos(sx+500, sy+10, 35, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
	  click = getTickCount()
	  removeEventHandler("onClientRender", root, init)
	  removeEventHandler("onClientCharacter", root, eventWriteSound)
	  removeEventHandler("onClientKey", root, removeCharacterSound)
	  removeEventHandler("onClientPaste", root, pasteClipboardTextSound)
	  showCursor(false)
	  showChat(true)
	end
if page == 1 then
 dxDrawRectangle(sx+15, sy+60, w-40, 35, tocolor(25, 25, 25, 255))
dxDrawRectangle(sx+505, sy+60, 30, 35, (mousePos(sx+505, sy+60, 30, 35) and tocolor(232,154,29,alpha) or tocolor(50, 50, 50, 255)))
dxDrawText("", sx+510, sy+66, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.awesome)
dxDrawText(musicBoxes["search_bar"][2] == true and musicBoxes["search_bar"][1] or "Arama [şarkı adı]", sx+20, sy+68, nil, nil, selected == "search_bar" and tocolor(211, 211, 211, 255) or tocolor(50,50,50,255), 1, fonts.light)
  if mousePos(sx+15, sy+60, w-90, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
			click = getTickCount()
            selected = "search_bar"
			musicBoxes[selected][1] = ""
			musicBoxes[selected][2] = true
            guiSetInputMode("allow_binds")
	elseif not mousePos(sx+15, sy+60, w-90, 35) and getKeyState("mouse1") and click+500 <= getTickCount() and selected ~= "" then
	selected = ""
   end
   if selected == "search_bar" then
		carretSound(sx+18, sy+73, 200, 30, musicBoxes["search_bar"][1])
   end
   local text = musicBoxes["search_bar"][1]
   if #text > 0 and mousePos(sx+505, sy+60, 30, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
   click = getTickCount()
   if loading == true then exports.rl_infobox:addBox("warning", "Şuanda zaten bir yükleme işlemi yapılıyor") return end
   if #musics > 0 then
   musics = {}
   end
   triggerServerEvent("onPlayerSearchMusic", localPlayer, musicBoxes["search_bar"][1])
   loading = true
   end
   if loading == true then
	 exports.rl_ui:drawSpinner({
			position = {
				x = sx+(w/2)-45,
				y = sy+(h/2)-20
			},
			size = 70,

			speed = 2,
						
			label = "Yükleniyor...",

			variant = "soft",
			color = "gray",
			postGUI = true
		})
   end
	if #musics > 0 then
	latest = current + maxrow - 1
	loading = false
	if loading == false then
	dxDrawText("#", sx+30, sy+98, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
	dxDrawText("Sanatçı", sx+60, sy+98, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
	dxDrawText("Parça", sx+270, sy+98, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
     for k, v in ipairs(musics) do
	  name = v[2]
	  artist = v[1]
	  if k >= current and k <= latest then
	    color = k % 2 == 1 and tocolor(20, 20, 20, 220) or tocolor(33,33,33, 220)
		dxDrawRectangle(sx+15, sy+120+y, w-40, 35, mousePos(sx+15, sy+120+y, w-40, 35) and tocolor(41, 41, 41, 220) or color)
		dxDrawText(k, sx+30, sy+128+y, nil, nil, tocolor(50,50,50,255), 1, fonts.light)
		if mousePos(sx+15, sy+120+y, w-70, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
		click = getTickCount()
		if isElement(vehicles[getPedOccupiedVehicle(localPlayer)]) then exports.rl_infobox:addBox("warning", "Başka bir şarkı açmadan önce şuanda çalanı durdurman gerekiyor!") return end
		if not getPedOccupiedVehicle(localPlayer) then exports.rl_infobox:addBox("warning", "Bu işlemi gerçekleştirmek için bir araçta olmalısınız!") return end
		triggerServerEvent("selectVehicleMusicLink", resourceRoot, v[3], getPedOccupiedVehicle(localPlayer))
		end

		
		dxDrawText(artist, sx+60, sy+128+y, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
		dxDrawText(name, sx+270, sy+128+y, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
		if mousePos(sx+500, sy+126+y, 25, 25) or getMusicByName(v[1], v[2]) then
		font = fonts.iconFont
		icon = ""
		else
		font = fonts.awesome2
		icon = ""
		end
		dxDrawText(icon, sx+500, sy+126+y, nil, nil, tocolor(255, 255, 255, 255), 1, font)
		if mousePos(sx+500, sy+126+y, 25, 25) and getKeyState("mouse1") and click+500 <= getTickCount() then
		click = getTickCount()
		if getMusicByName(v[1], v[2]) then
				 deleteSaveMusic(v[1], v[2])
				 saveSaves()
			else 
				table.insert(saves, {v[1], v[2], v[3]})
				saveSaves()
		   end
		end
		y = y + 40
	  end
	 end
	 end
	end
elseif page == 2 then
if #saves == 0 then

else
	latest = current + maxrow - 1
	loading = false
	if loading == false then
	dxDrawText("#", sx+30, sy+78, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
	dxDrawText("Sanatçı", sx+60, sy+78, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
	dxDrawText("Parça", sx+270, sy+78, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
     for k, v in ipairs(saves) do
	  name = v[2]
	  artist = v[1]
	  if k >= current and k <= latest then
	    color = k % 2 == 1 and tocolor(20, 20, 20, 220) or tocolor(33,33,33, 220)
		dxDrawRectangle(sx+15, sy+100+newY, w-40, 35, mousePos(sx+15, sy+100+newY, w-40, 35) and tocolor(41, 41, 41, 220) or color)
		dxDrawText(k, sx+30, sy+108+newY, nil, nil, tocolor(50,50,50,255), 1, fonts.light)
		if mousePos(sx+15, sy+100+newY, w-70, 35) and getKeyState("mouse1") and click+500 <= getTickCount() then
		click = getTickCount()
		if isElement(vehicles[getPedOccupiedVehicle(localPlayer)]) then exports.rl_infobox:addBox("warning", "Başka bir şarkı açmadan önce şuanda çalanı durdurman gerekiyor!") return end
		if not getPedOccupiedVehicle(localPlayer) then exports.rl_infobox:addBox("warning", "Bu işlemi gerçekleştirmek için bir araçta olmalısınız!") return end
		triggerServerEvent("selectVehicleMusicLink", resourceRoot, v[3], getPedOccupiedVehicle(localPlayer))
		end
		dxDrawText(artist, sx+60, sy+108+newY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
		dxDrawText(name, sx+270, sy+108+newY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.light)
		if mousePos(sx+500, sy+107+newY, 25, 25) then
		font = fonts.iconFont
		icon = ""
		color = tocolor(255, 0, 0)
		else
		font = fonts.iconFont
		icon = ""
		color = tocolor(255, 255, 255)
		end
		dxDrawText(icon, sx+500, sy+107+newY, nil, nil, color, 1, font)
		if mousePos(sx+500, sy+107+newY, 25, 25)  and getKeyState("mouse1") and click+500 <= getTickCount() then
		click = getTickCount()
		table.remove(saves, k)
		saveSaves()
		end
		newY = newY + 40
	   end
	    end
	  end
	end
  end
end

addCommandHandler("ses", function()
	-- if getElementData(localPlayer, 'logged') ~= 1 then return end
    if not isEventHandlerAdded('onClientRender', root, init) then
    addEventHandler('onClientRender', root, init, true, 'low-9999')
	addEventHandler("onClientCharacter", root, eventWriteSound)
	addEventHandler("onClientKey", root, removeCharacterSound)
	addEventHandler("onClientPaste", root, pasteClipboardTextSound)
	showCursor(true)
	page = 1
	showChat(false)
	loadSaves()
	else
	removeEventHandler('onClientRender', root, init)
	showCursor(false)
	showChat(true)
	end
end)


addEvent("returnMusicSearch", true)
addEventHandler("returnMusicSearch", root, function (load)
	if isEventHandlerAdded('onClientRender', root, init) then
		musics = {}
		musics = load
	end
end)

function getMusic(url)
	for i,v in pairs(saves) do
		if v[3] == url then
			return v
		end
	end
	return false
end

function getMusicByName(name, music)
	for i,v in pairs(saves) do
		if v[1] == name and v[2] == music then
			return i
		end
	end
	return false
end

function deleteSaveMusic(name, music)
	for i,v in pairs(saves) do
		if v[1] == name and v[2] == music then
			table.remove(saves, i)
			return i
		end
	end
	return false
end

addEvent("updateVehicleMusic", true)
addEventHandler("updateVehicleMusic", resourceRoot, function (url, vehicle)
	if isElement(vehicle) and isElementStreamedIn(vehicle) then
		applyMusicToVehicle(vehicle, url)
	end
end)

addEvent("stopVehicleMusic", true)
addEventHandler("stopVehicleMusic", resourceRoot, function (vehicle)
	if vehicle and isElement(vehicle) then
		removeMusicFromVehicle(vehicle)
		setElementData(vehicle, "vehicle:music", false)
	end
end)

applyMusicToVehicle = function (vehicle, data)
	removeMusicFromVehicle(vehicle)
	if data:sub(-string.len('mp3')) == 'mp3' and data:find('https://d', 1, #'https://d') then
		data = data .. '?play'
	end
	vehicles[vehicle] = playSound3D(data, 5000, 5000, 5000, true, true)
	if getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicle(localPlayer) == vehicle then
		setSoundVolume(vehicles[vehicle], volume/100)
		setSoundMaxDistance(vehicles[vehicle], map(volume, 0, 100, 20, 50))
	end
	setSoundMinDistance(vehicles[vehicle], 10)
	attachElements(vehicles[vehicle], vehicle)
end

removeMusicFromVehicle = function (vehicle)
	if isElement(vehicles[vehicle]) then
		stopSound(vehicles[vehicle])
		vehicles[vehicle] = nil
	end
end

removeAllMusic = function ()
	for vehicle, sound in pairs(vehicles) do
		stopSound(sound)
		vehicles[vehicle] = nil
	end
end

map = function (value, fromLow, fromHigh, toLow, toHigh)
	return (value-fromLow) * (toHigh-toLow) / (fromHigh-fromLow) + toLow
end


addEventHandler("onClientElementStreamIn", root, function()
	if (getElementType(source) == "vehicle") then
		if getElementData(source, "vehicle:music") then
			removeMusicFromVehicle(source)

			applyMusicToVehicle(source, getElementData(source, "vehicle:music"))
		end
	end
end)

function onCarStreamOut()
	if getElementType(source) == "vehicle" then
		removeMusicFromVehicle(source)
	end
end
addEventHandler("onClientElementStreamOut", root, onCarStreamOut)
addEventHandler("onClientElementDestroy", root, onCarStreamOut)

addEventHandler("onClientResourceStart", resourceRoot, function ()
if getElementData(localPlayer, "logged") then
	showChat(true)
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
	for i,v in pairs(getElementsByType("vehicle")) do
		setElementData(v, "vehicle:music", false)
	end
end)


function loadSaves()
	local data = {}
	if fileExists("@music") then 
		local file = fileOpen("@music", true)
		if (file) then
			data = fromJSON(fileRead(file, fileGetSize(file)))
			fileClose(file)
		end
	end
	saves = data
end

function saveSaves()
	local file = fileCreate("@music")
	if (file) then
		fileWrite(file, toJSON(saves, true))
		fileClose(file)
	end
end

function carretSound(x, y, w, h, text)
        local font = exports.rl_fonts:getFont("in-light", 10)
		local tick = 0
		local text = text or ""
		local textWidth = dxGetTextWidth(text, 1, font, false) or 0;
		local carretAlpha = interpolateBetween(50, 0, 0, 255, 0, 0, (getTickCount()-tick)/1000, "SineCurve");
        local carretSize = dxGetFontHeight(1, font)*1;
        local carretPosX = textWidth > (w-10) and x + w - 10 or x + textWidth + 5
        dxDrawRectangle(carretPosX, y + (carretSize / 2)-11,1, h - carretSize, tocolor(200,200,200, carretAlpha), true);
end


function eventWriteSound(...)
    writeSound(...)
end

function writeSound(char)
	if selected ~= "" and musicBoxes[selected][2] then
		local text = musicBoxes[selected][1]
		if #text <= 50 then
			musicBoxes[selected][1] = musicBoxes[selected][1]..char
			-- playSound(":rl_account/files/key.mp3")
			-- playSound(":rl_account/files/key.mp3")
		end
	end
end

function removeCharacterSound(key, state)
    if key == "backspace" and state then
        if selected ~= "" and musicBoxes[selected][2] then
            local text = musicBoxes[selected][1]
            if #text > 0 then
                musicBoxes[selected][1] = string.sub(text, 1, #text - 1)
				-- playSound(":rl_account/files/key.mp3")
            end
        end
    end
end

function pasteClipboardTextSound(clipboardText)
	if clipboardText then
		if selected ~= "" and musicBoxes[selected][2] then
			local text = musicBoxes[selected][1]
			if #text <= 50 then
				musicBoxes[selected][1] = musicBoxes[selected][1]..clipboardText
				-- playSound(":rl_account/files/key.mp3")
			end
		end
	end
end


function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function mousePos(x, y, width, height)
    if (not isCursorShowing()) then return false end
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy = (cx * sx), (cy * sy)
    return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

-- Oyuncunun müzik sesini kapatıp açmasını sağlayacak değişken
local musicEnabled = true

-- /seskapa komutu
addCommandHandler("seskapa", function()
    musicEnabled = not musicEnabled  -- true ise false, false ise true yap
    
    if musicEnabled then
        exports.rl_infobox:addBox("info", "Araç müzik sesi açıldı.")
        -- Tüm araç müziklerinin sesini tekrar aç
        for vehicle, sound in pairs(vehicles) do
            if isElement(sound) then
                setSoundVolume(sound, volume/100)
            end
        end
    else
        exports.rl_infobox:addBox("info", "Araç müzik sesi kapatıldı.")
        -- Tüm araç müziklerinin sesini kapat
        for vehicle, sound in pairs(vehicles) do
            if isElement(sound) then
                setSoundVolume(sound, 0)
            end
        end
    end
end)

-- Müzik eklendiğinde ses ayarını kontrol et
applyMusicToVehicle = function (vehicle, data)
    removeMusicFromVehicle(vehicle)
    if data:sub(-string.len('mp3')) == 'mp3' and data:find('https://d', 1, #'https://d') then
        data = data .. '?play'
    end
    vehicles[vehicle] = playSound3D(data, 5000, 5000, 5000, true, true)
    if getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicle(localPlayer) == vehicle then
        -- Müzik durumuna göre sesi ayarla
        setSoundVolume(vehicles[vehicle], musicEnabled and (volume/100) or 0)
        setSoundMaxDistance(vehicles[vehicle], map(volume, 0, 100, 20, 50))
    end
    setSoundMinDistance(vehicles[vehicle], 10)
    attachElements(vehicles[vehicle], vehicle)
end