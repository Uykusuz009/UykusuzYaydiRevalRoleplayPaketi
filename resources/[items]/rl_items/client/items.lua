wItems, gWallet, gItems, gKeys, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabWallet, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil

wRightClick = nil
bPickup, bToggle, bPreviousTrack, bNextTrack, bCloseMenu = nil
ax, ay = nil
item = nil
showinvPlayer = nil
setElementData(localPlayer, "exclusiveGUI", false, false)

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true
activeTab = 1

local sx, sy = guiGetScreenSize()
wWait = guiCreateButton((sx - 200) / 2, (sy - 60) / 2, 200, 60, "Yükleniyor...", false)
guiSetEnabled(wWait, false)
guiSetVisible(wWait, false)
guiSetProperty(wWait, "AlwaysOnTop", "True")

local delayedGBUpdate = nil

function showItemMenu()
	if not wRightClick then
		local itemID = getElementData(item, "itemID")
		local itemValue = getElementData(item, "itemValue") or 1
		local itemName = getItemName(itemID, itemValue)
		local text = isYoutubeURL(split(getItemValue(itemID, itemValue), ';')[1]) and "YouTube" or split(getItemValue(itemID, itemValue), ';')[1]
		local currentLink = split(getItemValue(itemID, itemValue), ';')[1] or "YouTube Link"
		if itemID ~= 80 or itemID ~= 214 then
			itemName = itemName .. " (" .. text .. ")"
		end
		wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName, false)
		
		local y = 0.13
		if itemID == 81 or itemID == 103 then
			bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Aç", true, wRightClick)
			addEventHandler("onClientGUIClick", bPickup, function(button)
				if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
					triggerServerEvent("openFreakinInventory", localPlayer, item, ax, ay)
					hideItemMenu()
				end
			end, false)
		else
			bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Yerden Al", true, wRightClick)
			addEventHandler("onClientGUIClick", bPickup, function(button, state) pickupItem(button, state, item) end, false)
		end
		y = y + 0.14
		
		if itemID == 54 then
			bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Prev. Station", true, wRightClick)
			addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)
			
			bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Next Station", true, wRightClick)
			addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)
		
			y = y + 0.18

			local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
			guiSetProperty(sVolume, 'StepSize', '0.1')

			local value = split(tostring(itemValue), ';')
			guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
			addEventHandler('onClientGUIScroll', sVolume, function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(function(val)
					triggerServerEvent("changeGhettoblasterVolume", item, val)
					delayedGBUpdate = nil
				end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
		end

		if itemID == 176 then
			bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Prev. Station", true, wRightClick)
			addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)
			
			bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Next Station", true, wRightClick)
			addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)
		
			y = y + 0.18

			local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
			guiSetProperty(sVolume, 'StepSize', '0.1')

			local value = split(tostring(itemValue), ';')
			guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
			addEventHandler('onClientGUIScroll', sVolume, function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(function(val)
					triggerServerEvent("changeGhettoblasterVolume", item, val)
					delayedGBUpdate = nil
				end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
		end
		
		y = y + 0.14
		bYTEdit = guiCreateEdit(0.05, y, 0.9, 0.1, currentLink, true, wRightClick)
		
		y = y + 0.14
		bYTButton = guiCreateButton(0.05, y, 0.9, 0.1, "Oynat", true, wRightClick)
		addEventHandler("onClientGUIClick", bYTButton, function() 
			local url = guiGetText(bYTEdit)
			if isYoutubeURL(url) then
				triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, url)
			end
		end, false)
		
		y = y + 0.14
		
		bCloseMenu = guiCreateButton(0.05, y, 0.9, 0.1, "Menüyü Kapat", true, wRightClick)
		addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
	end
end

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bToggle)) then
		destroyElement(bToggle)
	end
	bToggle = nil

	if (isElement(bPreviousTrack)) then
		destroyElement(bPreviousTrack)
	end
	bPreviousTrack = nil

	if (isElement(bNextTrack)) then
		destroyElement(bNextTrack)
	end
	bNextTrack = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if delayedGBUpdate then
		killTimer(delayedGBUpdate)
		delayedGBUpdate = nil
	end
	
	ax = nil
	ay = nil

	item = nil

	showCursor(false)
	triggerEvent("cursorHide", localPlayer)
end

function updateMenu(dataname)
	if source == item and dataname == "itemValue" and (getElementData(source, "itemID") == 54 or getElementData(source, "itemID") == 176) then -- update the track while you're in menu
		local text = isYoutubeURL(split(getElementData(source, "itemValue"), ';')[1]) and "YouTube" or split(getElementData(source, "itemValue"), ';')[1]
		guiSetText(wRightClick, "Ghettoblaster (" .. text .. ")")
	end
end
addEventHandler("onClientElementDataChange", root, updateMenu)

function toggleGhettoblaster(button, state, absX, absY, step)
	triggerServerEvent("toggleGhettoblaster", localPlayer, item)
	hideItemMenu()
end

local pickupTimer = nil
function pickupItem(button, state, item)
	if (button=="left") then
		local restrain = getElementData(localPlayer, "restrain")
		
		if (restrain) then
			outputChatBox("[!]#FFFFFF Kelepçeliyken bir eşyayı alamazsınız.", 255, 0, 0, true)
			playSoundFrontEnd(4)
		elseif getElementData(item, "itemID") > 0 and not hasSpaceForItem(localPlayer, getElementData(item, "itemID"), getElementData(item, "itemValue")) then
			outputChatBox("[!]#FFFFFF Envanterinizde çok fazla öğe var.", 255, 0, 0, true)
			playSoundFrontEnd(4)
		elseif isElement(item) then
			if wRightClick then
				showCursor(false)
				triggerEvent("cursorHide", localPlayer)
			end
			
			if getKeyState("p") then
				if exports.rl_global:isAdminOnDuty(localPlayer) then
					triggerServerEvent("protectItem", item, fp)
				end
			elseif getKeyState("n") then
				if exports.rl_global:isAdminOnDuty(localPlayer) then
					triggerEvent("item:move", root, item)
				end
			else
				if getElementData(item, "transfering_c") then
					return outputDebugString("[ITEM] pickupItem / Client / Cancelled by pick up cooldown.")
				else
					setElementData(item, "transfering_c", true)
					outputDebugString("[ITEM] pickupItem / Client / pickupCooldown = true ")
					if pickupTimer and isElement(pickupTimer) then
						killTimer(pickupTimer)
					end
					pickupTimer = setTimer(function() 
						if item and isElement(item) then
							setElementData(item, "transfering_c", nil)
							outputDebugString("[ITEM] pickupItem / Client / pickupCooldown = false ")
						end
					end, 10000, 1)
				end
				triggerServerEvent("pickupItem", localPlayer, item)
			end

			if wRightClick then
				hideItemMenu()
			end
		end
	end
end

addEvent('item:move:protect', true)
addEventHandler('item:move:protect', root, function()
	triggerServerEvent("protectItem", source, fp)
end)

function toggleCategory()
	if (isElement(gWallet)) then
		guiGridListClear(gWallet)
	end
	
	if (isElement(gItems)) then
		guiGridListClear(gItems)
	end
	
	if (isElement(gKeys)) then
		guiGridListClear(gKeys)
	end
	
	if (isElement(gWeapons)) then
		guiGridListClear(gWeapons)
	end
	
	local items = getItems(showinvPlayer)
	
	local tabs = {gWallet, gItems, gKeys, gWeapons}
	for i,v in ipairs(items) do
		local itemid = v[1]
		local itemvalue = v[2]
		local tab = tabs[getItemTab(itemid)]
		local row = guiGridListAddRow(tab)
		guiGridListSetItemText(tab, row, colSlot, tostring(row+1), false, true)
		guiGridListSetItemData(tab, row, colSlot, tostring(i))
		guiGridListSetItemText(tab, row, colName, tostring(getItemName(itemid, itemvalue)), false, false)
		if tab ~= gWeapons then
			guiGridListSetItemText(tab, row, colValue, tostring(getItemValue(itemid, itemvalue)), false, false)
			guiGridListSetItemData(tab, row, colValue, tostring(itemvalue))
		else
			guiGridListSetItemText(tab, row, colValue, tostring(explode(":", itemvalue)[2]), false, false)
			guiGridListSetItemData(tab, row, colValue, tostring(explode(":", itemvalue)[2]))
			
			local silahHak = #tostring(explode(":", itemvalue)[6])>0 and explode(":", itemvalue)[6] or 3
			silahHak = not restrictedWeapons[tonumber(explode(":", itemvalue)[1])] and silahHak or "-"

			local checkString = string.sub(getItemName(itemid, itemvalue), -4)
			if (checkString == " (D)")  then
				silahHak = "-"
			end
			
			silahHak = itemid == 115 and silahHak or "-"
			guiGridListSetItemText(tab, row, 4, silahHak, false, false)
		end
	end
end

function toggleInventory()
	if wItems and guiGetEnabled(wItems) then
		hideInventory()
	end
end
bindKey("i", "down", toggleInventory)

function copyClipboard()
	local row, col = guiGridListGetSelectedItem(source)
	local text = guiGridListGetItemData(source, row, colValue)
	if setClipboard(text) then
		exports.rl_infobox:addBox("success", "Kopyalama", "'" .. text .. "' kopyalandı.")
	else
		exports.rl_infobox:addBox("error", "Kopyalama", "'" .. text .. "' kopyalanamadı.")
	end
end

function showInventory(player)
	if not (wItems) then
		showinvPlayer = player
		if wItems then
			hideInventory()
		end
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end
		setElementData(localPlayer, "exclusiveGUI", true, false)
		local width, height = 600, 500
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		local title = "Envanter"
		if player ~= localPlayer then
			title = getPlayerName(player) .. " isimli oyuncunun " .. title .. "'i"
		end
		wItems = guiCreateWindow(x, y, width, height, title, false)
		guiWindowSetSizable(wItems, false)
		
		tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.7, true, wItems)
		tabWallet = guiCreateTab("Cüzdan", tabPanel)
		tabItems = guiCreateTab("Eşyalar", tabPanel)
		tabKeys = guiCreateTab("Anahtarlar", tabPanel)
		tabWeapons = guiCreateTab("Silahlar", tabPanel)
		
		if activeTab == 1 then
			guiSetSelectedTab(tabPanel, tabWallet)
		elseif activeTab == 2 then
			guiSetSelectedTab(tabPanel, tabItems)
		elseif activeTab == 3 then
			guiSetSelectedTab(tabPanel, tabKeys)
		elseif activeTab == 4 then
			guiSetSelectedTab(tabPanel, tabWeapons)
		end
		
		addEventHandler("onClientGUITabSwitched", tabPanel, function(tab)
			if tab == tabWallet then
				activeTab = 1
			elseif tab == tabItems then
				activeTab = 2
			elseif tab == tabKeys then
				activeTab = 3
			elseif tab == tabWeapons then
				activeTab = 4
			end
		end, false)
		
		gWallet = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWallet)
		addEventHandler("onClientGUIClick", gWallet, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWallet, copyClipboard, false)
		
		colSlot = guiGridListAddColumn(gWallet, "Slot", 0.1)
		colName = guiGridListAddColumn(gWallet, "Adı", 0.225)
		colValue = guiGridListAddColumn(gWallet, "Değeri", 0.625)
		
		gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
		addEventHandler("onClientGUIClick", gItems, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gItems, copyClipboard, false)
		
		colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
		colName = guiGridListAddColumn(gItems, "Adı", 0.225)
		colValue = guiGridListAddColumn(gItems, "Değeri", 0.625)
		
		gKeys = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabKeys)
		addEventHandler("onClientGUIClick", gKeys, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gKeys, copyClipboard, false)
	
		colSlot = guiGridListAddColumn(gKeys, "Slot", 0.1)
		colName = guiGridListAddColumn(gKeys, "Adı", 0.625)
		colValue = guiGridListAddColumn(gKeys, "Değeri", 0.225)

		gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWeapons)
		addEventHandler("onClientGUIClick", gWeapons, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWeapons, copyClipboard, false)
		
		colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
		colWName = guiGridListAddColumn(gWeapons, "Adı", 0.225)
		colWValue = guiGridListAddColumn(gWeapons, "Değeri", 0.325)
		colWSilahHakki = guiGridListAddColumn(gWeapons, "Silah Hakkı", 0.225)
		
		lDescription = guiCreateLabel(0.025, 0.87, 0.95, 0.1, "Açıklamayı görmek için öğeye tıklayın.", true, wItems)
		guiLabelSetHorizontalAlign(lDescription, "center", true)
		guiSetFont(lDescription, "default-bold-small")
		
		bClose = guiCreateButton(0.375, 0.91, 0.2, 0.15, "Kapat", true, wItems)
		addEventHandler("onClientGUIClick", bClose, hideInventory, false)
		
		source = nil
		toggleCategory()
		showCursor(true)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", root, showInventory)

function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil
	
	colWSlot = nil
	colWName = nil
	colWValue = nil
	colWSilahHakki = nil
	
	if wItems then
		destroyElement(wItems)
	end
	wItems = nil
	
	showCursor(false)
	setElementData(localPlayer, "exclusiveGUI", false, false)
	
	hideNewInventory()
end
addEvent("hideInventory", true)
addEventHandler("hideInventory", root, hideInventory)

function showDescription(button, state)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems or guiGetSelectedTab(tabPanel)==tabKeys) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems)
			
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Açıklamayı görmek için öğeye tıklayın.")
			else
				local slot = tonumber(guiGridListGetItemData(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems, row, 1))
				local items = getItems(showinvPlayer)
				if not items[slot] then
					guiSetText(lDescription, "Boş yer.")
				else
					local desc = tostring(getItemDescription(items[slot][1], items[slot][2]))
					local value = items[slot][2]
					
					desc = string.gsub((desc), "#v", tostring(value))
					
					guiSetText(lDescription, desc)
				end
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then
			local row, col = guiGridListGetSelectedItem(gWeapons)
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Açıklamayı görmek için öğeye tıklayın.")
			else
				local name = tostring(guiGridListGetItemText(gWeapons, row, 2))
				local ammo = tostring(guiGridListGetItemText(gWeapons, row, 3))
				local desc = "A " .. name .. " with " .. ammo .. " ammunition."
					
				guiSetText(lDescription, desc)
			end
		end
	end
end

function useItem(itemSlot)
	showinvPlayer = localPlayer
	if getElementHealth(localPlayer) == 0 then return end
	local x, y, z = getElementPosition(localPlayer)
	local groundz = getGroundPosition(x, y, z)
	if itemSlot > 0 then
		local itemID = getItems(showinvPlayer)[itemSlot][1]
		local itemName = getItemName(itemID)
		local itemValue = getItems(showinvPlayer)[itemSlot][2]
		local additional = nil
		
		if (itemID==2) then
			hideInventory()
			executeCommandHandler("phone", player)
			return
		elseif (itemID==6) then
			exports.rl_infobox:addBox("info", "Bu öğeyi kullanmak için Y tuşuna basın. Radyoyu ayarlamak için /tuneradio komutunu da kullanabilirsiniz.", 255, 194, 14)
			return
		elseif (itemID==7) then
			exports.rl_infobox:addBox("info", "Bu öğeyi kullanmak için /phonebook kullanabilirsiniz.", 255, 194, 14)
			return
		elseif (itemID==18) then
			triggerEvent("showCityGuide", localPlayer)
			return
		elseif (itemID==19) then
			exports.rl_carradio:showMP3GUI()
			hideInventory()
			return
		elseif (itemID==27) then
			local x, y, z = getElementPosition(localPlayer)
			local rot = getPedRotation(localPlayer)
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = getGroundPosition(x, y, z + 2)
			additional = { x, y, z }
		elseif (itemID==28 or itemID==54 or itemID==176) then
			local x, y, z = getElementPosition(localPlayer)
			local rot = getPedRotation(localPlayer)
			x = x + math.sin(math.rad(-rot)) * 2
			y = y + math.cos(math.rad(-rot)) * 2
			z = getGroundPosition(x, y, z)
			additional = { x, y, z - 0.5 }
		elseif (itemID==30) or (itemID==31) or (itemID==32) or (itemID==33) then
			exports.rl_infobox:addBox("info", "Bu öğeyi kullanmak için 7/24 mevcut olan bir kimya kitini kullanabilirsiniz.", 255, 0, 0)
			return
		elseif (itemID==44) then
			hideInventory()
			showChemistrySet()
			return
		elseif (itemID==45) or (itemID==46) or (itemID==47) or (itemID==66) then
			exports.rl_infobox:addBox("info", "Bu öğeyi kullanmak için oyuncuya sağ tıklayın.")
			return
		elseif (itemID==50) or (itemID==51) or (itemID==52) then
			hideInventory()
		elseif (itemID==53) then
			exports.rl_infobox:addBox("info", "Bu öğeyi kullanmak için /breathtest komutunu kullanabilirsiniz.")
			return
		elseif (itemID==57) then
			hideInventory()
		elseif (itemID==58) then
			setTimer(function()
				setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.1)
			end, 15000, 1)
		elseif (itemID==61) then
			exports.rl_infobox:addBox("info", "Aracınızın envanterine koyun ve değiştirmek için 'P'ye basın.")
			return
		elseif (itemID==62) then
			setTimer(function()
				setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.3)
			end, 5000, 1)
		elseif (itemID==63) then
			setTimer(function()
				setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.2)
			end, 10000, 1)
		elseif (itemID==67) then
			exports.rl_infobox:addBox("info", "Aracınızın envanterine koyun ve 'F5' tuşuna basın.")
			return
		elseif (itemID==70) then
			exports.rl_infobox:addBox("info", "Dengelemek için baygın oyuncuya sağ tıklayın.")
			return
		elseif (itemID==71) then
			exports.rl_infobox:addBox("info", "Not yazmak için /writenote [text] komutunu kullanın. " .. itemValue .. " sol sayfa.")
			return
		elseif (itemID==72) then
			exports.rl_infobox:addBox("info", "Not: " .. itemValue)
		elseif (itemID==84) then
			exports.rl_infobox:addBox("info", "Araca koyun veya yanınızda götürün, böylece polisin etrafta olduğunu bilirsiniz.")
			return
		elseif (itemID==85) then
			exports.rl_infobox:addBox("info", "Arabanızın envanterine koyun ve değiştirmek için 'N' tuşuna basın.")
			return
		elseif (itemID==91) then
			setTimer(function()
				setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.35)
			end, 15000, 1)
		elseif (itemID==96) then
			hideInventory()
		elseif (itemID==103) then
			exports.rl_infobox:addBox("info", "Bu rafı interiora atın.")
			return
		elseif itemID == 117 then
			exports.rl_infobox:addBox("info", "Lütfen bu öğeyi araca yerleştirin ve ardından aracın sağ tıklama menüsünden çalıştırın.")
			return
		elseif itemID == 174 then
			triggerServerEvent("startFAAmapGUI", localPlayer)
			return
		elseif itemID == 121 then
			exports.rl_infobox:addBox("info", "Malzemelerle dolu ağır bir kutu.")
			return
		elseif (itemID==147) then
			if (itemValue and itemValue ~= 1) then
				local split = exports.rl_global:explode(";", itemValue)
				if (#split > 1) then
					exports.rl_infobox:addBox("info", "'" .. tostring(split[2]) .. "' dokusunu değiştirmek için bunu interiora atın.")
				else
					local url = itemValue
					triggerServerEvent("frames:fetchTexture", localPlayer, itemSlot, url)
				end
				return
			else
				triggerEvent("frames:showFrameGUI", localPlayer, itemSlot)
				return
			end
		elseif (itemID==148) then
			exports.rl_infobox:addBox("info", "OCW izini - " .. itemValue .. ".")
			return
		elseif (itemID==149) then
			exports.rl_infobox:addBox("info", "CCW izini - " .. itemValue .. ".")
			return
		elseif (itemID==152) then
			local itemExploded = explode(";", itemValue)
			local text = "Ad ve Soyad: '" .. itemExploded[1]:gsub("_", " ") .. "', Cinsiyeti: '" .. itemExploded[2] .. "', Yaşı: '" .. itemExploded[3] .. "', FİN: '" .. itemExploded[4] .. "'"
			exports.rl_infobox:addBox("info", text)
			return
		elseif (itemID==177) then
			executeCommandHandler("dispatch")
			hideInventory()
			return
		elseif (itemID==178) then
			local bInfo = split(tostring(itemValue), ':')
			local bID = bInfo[3]
			triggerServerEvent("books:beginBook", localPlayer, bID, itemSlot)
			hideInventory()
			return
		elseif (itemID==211) then
			exports.rl_infobox:addBox("info", "Ne kazanmış olabileceğinizi görmek için Noel Baba'ya bir bilet vermeyi deneyin.")
			return
		elseif (itemID==212) then
			exports.rl_infobox:addBox("info", "Karlı havalarda aracınızdan daha iyi performans almak için aracınıza koyun.")
			return
		end
		
		triggerServerEvent("useItem", localPlayer, itemSlot, additional)
	else
		if itemSlot == -100 then
			exports.rl_infobox:addBox("info", "Vücut zırhı giyiyorsun.")
		else
			setPedWeaponSlot(localPlayer, -itemSlot)
		end
	end
end

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(localPlayer, "gasmask")
	if (weapon==17 or weapon==41) and (gasmask) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, stopGasmaskDamage)

addEventHandler("onClientChangeChar", root, hideInventory)

local function updateInv()
	if wItems and source == showinvPlayer then
		source = nil
		setTimer(toggleCategory, 50, 1)
	end
end
addEventHandler("recieveItems", root, updateInv)

addEvent("finishItemDrop", true)
addEventHandler("finishItemDrop", localPlayer, function()
	if wItems then
		guiSetVisible(wWait, false)
		guiSetEnabled(wItems, true)
	end
end)

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon)
	if weapon == 53 and getElementData(source, "scuba") then
		cancelEvent()
	end
end)

function isWatchingTV()
	return exports["rl_freecam-tv"]:isFreecamEnabled()
end