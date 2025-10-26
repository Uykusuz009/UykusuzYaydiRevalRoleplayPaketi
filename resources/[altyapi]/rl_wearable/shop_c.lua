local sx, sy = guiGetScreenSize()
local font = exports.rl_fonts:getFont("sf-regular", 9)

local categoryIndex = 0
local lastClick = 0
local rotation = 0
local currentRow, maxRow = 1, 12
local selectedWearable = 0

local shownWShop = false
local setPosition = false

local shopPed = createPed(240, 205.9873046875, -45.1005859375, 1001.8046875, 83.642913818359)
shopPed:setData("name", "Aksesuar Mağazası")
shopPed:setData("nametag", true)
shopPed:setData("talk", 1)
shopPed.frozen = true
shopPed.dimension = 100
shopPed.interior = 1

addEvent("onWearableShop", true)
addEventHandler("onWearableShop", root, function()
	if not shownWShop then
		tempObject = createObject(1239, 0, 0, 0)
		tempObject.interior = localPlayer.interior
		tempObject.dimension = localPlayer.dimension
		preview_element = exports['rl_object-preview']:createObjectPreview(tempObject,0,0,0,sx/2-900/2-400,sy/2-900/2,900,900,false,true)
		shownWShop = true
	end
end)

setTimer(function()
	if not shownWShop then return end
	w, h = 530, 395
	x, y = sx/2-w/2, sy/2-h/2

	dxDrawRectangle(x - 250, y, w - 285, h, tocolor(0, 0, 0, 155))

	dxDrawText("Aksesuar Görünümü", x - 775, y + 10, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
	x, y, w, h = x+2, y+2, w-4, h-4
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
	dxDrawRectangle(x, y, w, 25, tocolor(0, 0, 0, 80))
	dxDrawText("Aksesuar Mağazası", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")

	y, h = y+26, h-28
	x, w = x+2, w-4
	x, y, w, h = x+2, y+2, w-4, h-4
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 60))
	
	if preview_element then
		rotation = rotation + 2
		exports['rl_object-preview']:setRotation(preview_element, 0, 0, rotation)
	end
	
	local index = 0
	for i = 1, 13 do
		if i % 2 ~= 0 then
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 160))
		else
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 120))
		end
		if exports.rl_ui:inArea(x, y+(index*25), w, 25) then
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 50))
		end
		index = index + 1
	end
	local index = 0
	
	local latestRow = currentRow + maxRow - 1
	for count, value in pairs(getWearables()) do
		maxRow = 4
		
		if exports.rl_ui:inArea(x, y+(index*25), w, 25) then
			dxDrawText("• " .. value['name'], x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount()
				if categoryIndex ~= count then
					categoryIndex = count
					currentRow = 1
					selectedWearable = 0
				else
					categoryIndex = 0
				end
			end
		else
			dxDrawText("• " .. value['name'], x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(225, 225, 225), 1, font, "left", "center")
		end
		if categoryIndex == count then
			for id, data in ipairs(value['list']) do
				if id >= currentRow and id <= latestRow then
					id = id - currentRow + 1
					index = index + 1
					if exports.rl_ui:inArea(x, y+(index*25), w, 25) then
						dxDrawText("- (" .. id .. ") " .. data['name'] .. " [$" .. data['price'] .. "]", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
						if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
							lastClick = getTickCount()
							if data['allowed_factions'] and (not data['allowed_factions'][getElementData(localPlayer, "faction")]) then
								outputChatBox("[!]#FFFFFF Seçilmeye çalışılan aksesuarı sadece belirli birlikler kullanabilir.", 0, 255, 0, true)
								return false
							end
							selectedWearable = id
							price = data['price']
							tempObject.model = tonumber(data["modelid"])
						end
					else
						if selectedWearable == id  then
							dxDrawText("- (" .. id .. ") " .. data['name'] .. " [$" .. data['price'] .. "]", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
						else
							dxDrawText("- (" .. id .. ") " .. data['name'] .. " [$" .. data['price'] .. "]", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(255, 255, 255), 1, font, "left", "center")
						end
					end
				end
			end
		end
		index = index + 1
	end
	y = y+(13*25)+6
	w = w/2-4
	dxDrawRectangle(x, y, w, 25, tocolor(0, 255, 0, 100))
	dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
	if exports.rl_ui:inArea(x, y, w, 25) then
		dxDrawRectangle(x, y, w, 25, tocolor(0, 255, 0, 50))
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
			lastClick = getTickCount()
			if selectedWearable ~= 0 then
				triggerServerEvent("wearable.buyItem", localPlayer, tempObject.model, price)
				shownWShop = false
				currentRow = 1
				selectedWearable = 0
				categoryIndex = 0
				if preview_element then
					exports['rl_object-preview']:destroyObjectPreview(preview_element)
					destroyElement(tempObject)
				end
			end
		end
	end
	dxDrawText("Aksesuarı Satın Al", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
	
	x = x+w+4
	dxDrawRectangle(x, y, w, 25, tocolor(255, 0, 0, 100))
	dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
	if exports.rl_ui:inArea(x, y, w, 25) then
		dxDrawRectangle(x, y, w, 25, tocolor(255, 0, 0, 50))
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
			lastClick = getTickCount()
			shownWShop = false
			currentRow = 1
			selectedWearable = 0
			categoryIndex = 0
			if preview_element then
				exports['rl_object-preview']:destroyObjectPreview(preview_element)
				destroyElement(tempObject)
			end
			
		end
	end
	dxDrawText("Kapat", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
end, 0, 0)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if preview_element then
		exports['rl_object-preview']:destroyObjectPreview(preview_element)
	end
end)

bindKey("mouse_wheel_down", "down", function()
	if categoryIndex ~= 0 and shownWShop then
		if not getElementData(localPlayer, "logged") then return end

		if currentRow < #getWearables()[categoryIndex]['list'] - (maxRow - 1) then
			currentRow = currentRow + 1
		end
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if categoryIndex ~= 0 and shownWShop then
		if not getElementData(localPlayer, "logged") then return end
		if currentRow > 1 then
			currentRow = currentRow - 1
		end
	end
end)

bindKey("pgdn", "down", function()
	if categoryIndex ~= 0 and shownWShop then
		if not getElementData(localPlayer, "logged") then return end

		if currentRow < #getWearables()[categoryIndex]['list'] - (maxRow - 1) then
			currentRow = currentRow + 1
		end
	end
end)

bindKey("pgup", "down", function()
	if categoryIndex ~= 0 and shownWShop then
		if not getElementData(localPlayer, "logged") then return end
		if currentRow > 1 then
			currentRow = currentRow - 1
		end
	end
end)