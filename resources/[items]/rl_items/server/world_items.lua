function isProtected(player, item)
	if not isElement(item) then
		if item then
			local team = getPlayerTeam(player)
			if item[4] ~= 0 and (team and getElementData(team, "id") ~= item[4]) then
				return true
			end
			return false
		end
	else
		local protected = getElementData(item, "protected")
		local team = getPlayerTeam(player)
		if not protected or (team and getElementData(team, "id") == protected) then
			return false
		end
		return true
	end
end

function canPickup(player, item)
	if isWatchingTV(player) then
		return false
	elseif isProtected(player, item) then
		if isElement(item) then
			if getElementDimension(item) > 0 and (hasItem(player, 4, getElementDimension(item)) or hasItem(player, 5, getElementDimension(item))) then
				return true
			end
		end
		return false
	else
		if isElement(item) then
			if exports['rl_item-world']:can(player, "pickup", item) then
				return true
			else
				return false
			end
		end
	end
	return true
end

function canMove(player, item)
	if isWatchingTV(player) then
		return false
	elseif isProtected(player, item) then
		if isElement(item) then
			if getElementDimension(item) > 0 and (hasItem(player, 4, getElementDimension(item)) or hasItem(player, 5, getElementDimension(item))) then
				return true
			end
		end
		return false
	else
		if isElement(item) then
			if exports['rl_item-world']:can(player, "move", item) then
				return true
			else
				return false
			end
		end
	end
	return true
end

function protectItem(faction, item, slot)
	if getElementData(source, "itemID") then
		local itemID = getElementData(source, "itemID")
		local index = getElementData(source, "id")
	    if itemID == 169 then
	      	return false
	    end
		
		if type(faction) == "number" and exports.rl_global:isAdminOnDuty(client) then
			local protected = getElementData(source, "protected")
			local out = 0
			if protected then
				setElementData(source, "protected", false)
				outputChatBox("Unset", client, 0, 255, 0)
				out = 0
			else
				setElementData(source, "protected", faction)
				outputChatBox("Set to " .. faction .. " - if you want a different faction, /itemprotect [faction id or -100]", client, 255, 0, 0)
				out = faction
			end
			result = dbExec(mysql:getConnection(), "UPDATE worlditems SET protected = " .. faction .. " WHERE id = " .. index)
		end
	else

		if type(faction) == "number" and exports.rl_global:isAdminOnDuty(client) then
			local protected = item[4]
			if protected ~= 0 and protected ~= nil then
				updateProtection(item, 0, slot, source)
				outputChatBox("Unset", client, 0, 255, 0)
				out = 0
			else
				updateProtection(item, faction, slot, source)
				outputChatBox("Set to " .. faction .. " - if you want a different faction, /itemprotect [faction id or -100]", client, 255, 0, 0)
				out = faction
			end
			result = dbExec(mysql:getConnection(), "UPDATE items SET `protected` = " .. out .. " WHERE `index` = " .. tonumber(item[3]))
		end
	end
end
addEvent("protectItem", true)
addEventHandler("protectItem", root, protectItem)

local badges = getBadges()
local masks = getMasks()

function SmallestID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM worlditems AS e1 LEFT JOIN worlditems AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end
	
disableCanDropPick = true

function dropItem(itemID, x, y, z, ammo, keepammo)
	if disableCanDropPick then
		outputChatBox("[!]#FFFFFF Bu eşyayı yere bırakamazsınız.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
		triggerClientEvent(source, "finishItemDrop", source)
		return
	end

	if isPedDead(source) or getElementData(source, "injuriedanimation") then
		triggerClientEvent(source, "finishItemDrop", source)
		return false
	end
	
	local interior = getElementInterior(source)
	local dimension = getElementDimension(source)
	
	local rz2 = getPedRotation(source)
	
	if not ammo then
		local itemSlot = itemID
		local itemID, itemValue = unpack(getItems(source)[itemSlot])
	
		local weaponBlock = false
		
		if (itemID == 115) then
			local itemCheckExplode = exports.rl_global:explode(":", itemValue)
			local weaponDetails = exports.rl_global:retrieveWeaponDetails(itemCheckExplode[2] )
			if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then
				outputChatBox("[!]#FFFFFF Bu eşyayı yere koyamazsınız.", source, 255, 0, 0, true)
				weaponBlock = true
			end
		elseif (itemID == 116) then
			local ammoDetails = exports.rl_global:explode(":", itemValue )
			local checkString = string.sub(ammoDetails[3], -4)
			if (checkString == " (D)")  then
				outputChatBox("[!]#FFFFFF Bu eşyayı yere koyamazsınız.", source, 255, 0, 0, true)
				weaponBlock = true
			end
		end
	
		if itemID == 60 or itemID == 137 or itemID == 138 or itemID == 134 or itemID == 115 or itemID == 116 or itemID == 175 and not exports.rl_integration:isPlayerAdmin1(source) then
			outputChatBox("[!]#FFFFFF Bu eşyayı yere koyamazsınız.", source, 255, 0, 0, true)
		elseif (itemID == 81 or itemID == 103) and dimension == 0 then
			outputChatBox("You need to drop this item in an interior.", source)
		elseif (weaponBlock) then
		elseif itemID == 139 then
			outputChatBox("[!]#FFFFFF Bu eşyayı yere koyamazsınız.", source, 255, 0, 0, true)
		else
			local keypadDoorInterior = nil
			if itemID == 48 and countItems(source, 48) == 1 then
				if getCarriedWeight(source) > 10 - getItemWeight(48, 1) then
					triggerClientEvent(source, "finishItemDrop", source)
					return
				end
			elseif itemID == 134 then
				outputChatBox("[!]#FFFFFF Bu eşyayı yere koyamazsınız.", source, 255, 0, 0, true)
			elseif (itemID == 147) then
				local dimension = getElementDimension(source)
				if dimension > 0 or (exports.rl_integration:isPlayerSeniorAdmin(source) and exports.rl_global:isAdminOnDuty(source)) or exports.rl_integration:isPlayerDeveloper(source) then
					local split = exports.rl_global:explode(";", itemValue)
					local url = split[1]
					local texture = split[2]
					if url and texture then
						if exports['rl_texture']:newTexture(source, url, texture) then
							takeItem (source, 147, itemValue)
						end
						triggerClientEvent(source, "finishItemDrop", source)
						return
					end
				end
			elseif itemID == 169 then
				local maxRange = 10
				local doorOutside = nil
				local doorInside = nil
				local validInterior = false
				local validDropper = false
				local interiorName = "Bilinmiyor"
				local isIntLocked = true
				
				for key, interior in ipairs(getElementsByType("interior")) do
					if isElement(interior) and getElementData(interior, "dbid") == tonumber(itemValue) then
						validInterior = true
						interiorName = getElementData(interior, "name")
						local status = getElementData(interior, "status")
						isIntLocked = status[3]
						if tonumber(status[4]) == getElementData(source, "dbid") then
							validDropper = true
							doorOutside = getElementData(interior, "entrance")
							doorInside = getElementData(interior, "exit")
							keypadDoorInterior = interior
							break
						end
					end
				end

				if not validInterior then
					triggerClientEvent(source, "finishItemDrop", source)
					return false
				end

				if not validDropper then
					triggerClientEvent(source, "finishItemDrop", source)
					return false
				end

				if isIntLocked then
					triggerClientEvent(source, "finishItemDrop", source)
					return false
				end

				if not doorOutside or not doorInside then
					triggerClientEvent(source, "finishItemDrop", source)
					return false
				end

				if interior == doorOutside[4] and dimension == doorOutside[5] then
					if getDistanceBetweenPoints3D(x,y,z,doorOutside[1], doorOutside[2], doorOutside[3]) > maxRange then
						triggerClientEvent(source, "finishItemDrop", source)
						return false
					end
				elseif interior == doorInside[4] and dimension == tonumber(itemValue) then
					if getDistanceBetweenPoints3D(x,y,z,doorInside[1], doorInside[2], doorInside[3]) > maxRange then
						triggerClientEvent(source, "finishItemDrop", source)
						return false
					end
				else
					triggerClientEvent(source, "finishItemDrop", source)
					return false
				end
			end
			
			local smallestID = SmallestID()
			
			local insert = dbExec(mysql:getConnection(), "INSERT INTO worlditems SET id='" .. tostring(smallestID) .. "', itemid='" .. itemID .. "', itemvalue='" .. ( itemValue) .. "', creationdate = NOW(), x = " .. x .. ", y = " .. y .. ", z= " .. z .. ", dimension = " .. dimension .. ", interior = " .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if insert then
				local id = smallestID
				
				exports.rl_global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
				
				if getPedOccupiedVehicle(source) then
					if getElementModel(getPedOccupiedVehicle(source)) == 490 then
					end
				else
					toggleAllControls(source, true, true, true)
				end
				
				triggerClientEvent(source, "onClientPlayerWeaponCheck", source)
				
				local modelid = getItemModel(tonumber(itemID), itemValue)
				
				if (itemID==80) then
					local text = tostring(itemValue)
					local text2 = tostring(itemValue)
					local pos = text:find(":")
					local pos2 = text:find(":")
					if (pos) then
						text = text:sub(pos+1)
						modelid = text
					end
					if (pos2) then
						name = text2:sub(1, pos-1)
					end
				elseif (itemID==178) then
					local yup = split(itemValue, ":")
					name = ("book titled " ..  yup[1] .. " by " ..  yup[2])
				end
				
				local rx, ry, rz, zoffset = getItemRotInfo(itemID)
				local obj = exports['rl_item-world']:createItem(id, itemID, itemValue, modelid, x, y, z + zoffset - 0.05, rx, ry, rz+rz2)
				exports.rl_pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				if (itemID==76) then
					moveObject(obj, 200, x, y, z + zoffset, 90, 0, 0)
				else
					moveObject(obj, 200, x, y, z + zoffset)
				end

				local objScale = getItemScale(tonumber(itemID))
				if objScale then
					setObjectScale(obj, objScale)
				end
				local objDoubleSided = getItemDoubleSided(tonumber(itemID))
				if objDoubleSided then
					setElementDoubleSided(obj, objDoubleSided)
				end
				local objTexture = getItemTexture(tonumber(itemID), itemValue)
				if objTexture then
					for objTexKey, objTexVal in ipairs(objTexture) do
						exports['rl_item-texture']:addTexture(obj, objTexVal[2], objTexVal[1])
					end
				end
				
				setElementData(obj, "creator", getElementData(source, "dbid"))

				local permissions = { use = 1, move = 1, pickup = 1, useData = {}, moveData = {}, pickupData = {} }
				setElementData(obj, "worlditem.permissions", permissions)
				
				if itemID ~= 134 then
					takeItemFromSlot(source, itemSlot)
				end
				
				doItemGiveawayChecks(source, itemID, itemValue)

				if itemID == 166 then
					for key, value in ipairs(getElementsByType("player")) do
						if getElementDimension(value) == getElementDimension(obj) then
							triggerEvent("fakevideo:loadDimension", value)
						end
					end
				end

				if itemID == 169 then
					triggerEvent("installKeypad", source, obj, keypadDoorInterior)
				end
				
				if itemID == 134 then
					triggerEvent("sendAme", source, "yere $" .. exports.rl_global:formatMoney(itemValue) .. " bırakır.")
				elseif (itemID==80 or itemID==178) and tostring(itemValue):find(":") then
					triggerEvent("sendAme", source, "yere bir " .. name .. " bırakır.")
				else
					triggerEvent("sendAme", source, "yere bir " .. getItemName(itemID, itemValue) .. " bırakır.")
				end
			end
		end
	else
		if getElementData(source, "duty") then
			outputChatBox("You can't drop your weapons while being on duty.", source, 255, 0, 0)
		elseif tonumber(getElementData(source, "job")) == 4 and itemID == 41 then
			outputChatBox("You can't drop this spray can.", source, 255, 0, 0)
		else
			if ammo <= 0 then
				triggerClientEvent(source, "finishItemDrop", source)
				return
			end
			
			outputChatBox("You dropped a " .. (getWeaponNameFromID(itemID) or "Body Armor") .. ".", source, 255, 194, 14)
			
			exports.rl_global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
			
			if getPedOccupiedVehicle(source) then
				if getElementModel(getPedOccupiedVehicle(source)) == 490 then
				end
			else
				toggleAllControls(source, true, true, true)
			end
			
			triggerClientEvent(source, "onClientPlayerWeaponCheck", source)	
			if itemID == 100 then
				z = z + 0.1
				setPedArmor(source, 0)
			end
			
			local smallestID = SmallestID()
			
			local query = dbExec(mysql:getConnection(), "INSERT INTO worlditems SET id='" .. tostring(smallestID) .. "', itemid=" .. -itemID .. ", itemvalue=" .. ammo .. ", creationdate=NOW(), x=" .. x .. ", y=" .. y .. ", z=" .. z+0.1 .. ", dimension=" .. dimension .. ", interior=" .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if query then
				local id = smallestID
				
				exports.rl_global:takeWeapon(source, itemID)
				if keepammo then
					exports.rl_global:giveWeapon(source, itemID, keepammo)
				end
				
				local modelid = 2969
				if (itemID==100) then
					modelid = 1242
				elseif (itemID==42) then
					modelid = 2690
				else
					modelid = weaponmodels[itemID]
				end
				
				local obj = exports['rl_item-world']:createItem(id, -itemID, ammo, modelid, x, y, z - 0.4, 75, -10, rz2)
				exports.rl_pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				moveObject(obj, 200, x, y, z+0.1)
				
				setElementData(obj, "creator", getElementData(source, "dbid"))
				
				triggerEvent("sendAme", source, "dropped a " .. getItemName(-itemID) .. ".")
				
				triggerClientEvent(source, "saveGuns", source, getPlayerName(source))
			end
		end
	end

	triggerClientEvent(source, "finishItemDrop", source)
end
addEvent("dropItem", true)
addEventHandler("dropItem", root, dropItem)

function doItemGiveawayChecks(player, itemID, itemValue)
	local source = player
	local mask = masks[itemID]
	if mask and getElementData(source, mask[1]) and not hasItem(source, itemID) then
		triggerEvent("sendAme", source, mask[3] .. ".")
		setElementData(source, mask[1])
	end

	if itemID == 2 then
		triggerClientEvent(source, "phone:clearAllCaches", source, itemValue)
	end
	
	local requiredClothesValue = getElementModel(source) .. (getElementData(source, 'clothing_id') and (':' .. getElementData(source, 'clothing_id')) or '')
	if itemID == 16 and not hasItem(source, 16, tonumber(requiredClothesValue) or requiredClothesValue) then
		local gender = getElementData(source, "gender")
		local race = getElementData(source, "race")
		
		if (gender==0) then
			if (race==0) then
				setElementModel(source, 80)
			elseif (race==1 or race==2) then
				setElementModel(source, 252)
			end
		elseif (gender==1) then
			if (race==0) then
				setElementModel(source, 139)
			elseif (race==1) then
				setElementModel(source, 138)
			elseif (race==2) then
				setElementModel(source, 140)
			end
		end
		
		setElementData(source, 'clothing_id', nil)
		dbExec(mysql:getConnection(),  "UPDATE characters SET skin = '" .. (getElementModel(source)) .. "', clothing_id = NULL WHERE id = '" .. (getElementData(source, "dbid")) .. "'")
	end
	
	if itemID == 76 and shields[source] and not hasItem(source, 76) then
		destroyElement(shields[source])
		shields[source] = nil
	end
	
	if itemID == 19 and not hasItem(source, itemID) then
		triggerClientEvent(source, "realism:mp3:off", source)
	end
end

function doItemGivenChecks(player, itemID, itemValue)
	if itemID == 2 then --cellphone
		triggerClientEvent(player,"phone:clearAllCaches", player, itemValue)
	elseif itemID == 48 then --backpack
		--triggerEvent("artifacts:add", player, player, "backpack")
	elseif itemID == 162 then --body armour
		--triggerEvent("artifacts:add", player, player, "kevlar")
	elseif itemID == 163 then --duffle bag
		--triggerEvent("artifacts:add", player, player, "dufflebag")
	elseif itemID == 164 then --medical bag
		--triggerEvent("artifacts:add", player, player, "medicbag")
	elseif itemID == 111 then
		setPlayerHudComponentVisible(player, 'radar', true)
	end
end

local function moveItem(item, x, y, z)
	if true then
		return outputDebugString("[ITEM] moveItem / Disabled ")
	end

	if isWatchingTV(source) or isPedDead(source) or getElementData(source, "injuriedanimation") then
		return false
	end

	local itemID = getElementData(item, "itemID")

	if itemID == 169 then
		return false
	end

	if not exports.rl_global:isAdminOnDuty(source) then
		if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
			outputChatBox(getItemName(itemID) .. " can't be moved this way.", source, 255, 0, 0)
			return false
		end
	end
	
	local id = getElementData(item, "id")
	if not (z) then
		destroyElement(item)
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id = " .. (id))
		return
	end
	
	
	if not canMove(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	-- fridges and shelves can't be moved
	if not exports.rl_integration:isPlayerTrialAdmin(source) and (itemID == 81 or itemID == 103) then
		return
	end
	
	if itemID == 138 then
		if not exports.rl_integration:isPlayerTrialAdmin(source) then
			outputChatBox("Only a Lead+ admin can move this item.", source, 255, 0, 0)
			return
		end
	end
	
	if itemID == 139 and not exports.rl_integration:isPlayerTrialAdmin(source) then
		outputChatBox("Only a Super+ admin can move this item.", source, 255, 0, 0)
		return
	end
	
	-- check if no-one is standing on the item (should be cancelled client-side), but just in case
	for key, value in ipairs(getElementsByType("player")) do
		if getPedContactElement(value) == item then
			return
		end
	end
	
	local result = dbExec(mysql:getConnection(), "UPDATE worlditems SET x = " .. x .. ", y = " .. y .. ", z = " .. z .. " WHERE id = " .. getElementData(item, "id"))
	if result then
		if itemID > 0 then
			local rx, ry, rz, zoffset = getItemRotInfo(itemID)
			z = z + zoffset
		elseif itemID == 100 then
			z = z + 0.1
		end
		setElementPosition(item, x, y, z)
	end
end
addEvent("moveItem", true)
addEventHandler("moveItem", root, moveItem)

addEvent('item:move:save', true)
addEventHandler('item:move:save', root,
    function(x, y, z, rx, ry, rz, movedElement)
        -- Güvenlik kontrolü: client parametresi doğru mu
        if not client or client ~= source then
            cancelEvent()
            return
        end
        
        -- Parametre validasyonu
        if not isElement(movedElement) or getElementType(movedElement) ~= "object" then
            outputDebugString("Invalid element in item:move:save", 2)
            return
        end
        
        -- Sayısal parametre kontrolü
        if not tonumber(x) or not tonumber(y) or not tonumber(z) or 
           not tonumber(rx) or not tonumber(ry) or not tonumber(rz) then
            outputDebugString("Invalid coordinates in item:move:save", 2)
            return
        end
        
        local reset = function(element)
            if isElement(element) then
                local oldX, oldY, oldZ = getElementPosition(element)
                local oldRX, oldRY, oldRZ = getElementRotation(element)
                setElementPosition(element, oldX, oldY, oldZ)
                setElementRotation(element, oldRX, oldRY, oldRZ)
            end
        end
        
        -- Yetki kontrolü
        local hasAdminAccess = exports.rl_global:isAdminOnDuty(client)
        local isDeveloper = exports.rl_integration:isPlayerDeveloper(client)
        
        if not hasAdminAccess and not isDeveloper then
            outputChatBox("You don't have permission to move items.", client, 255, 0, 0)
            reset(movedElement)
            return
        end

        -- Erişim kontrolü
        if not canPickup(client, movedElement) then
            outputChatBox("You can not move this item. Contact an admin via F2.", client, 255, 0, 0)
            reset(movedElement)
            return
        end

        local itemID = getElementData(movedElement, "itemID")
        
        -- Özel item kontrolleri
        if itemID == 138 and not isDeveloper then
            outputChatBox("Only a Lead+ admin can move this item.", client, 255, 0, 0)
            reset(movedElement)
            return
        end
        
        if itemID == 139 and not isDeveloper then
            outputChatBox("Only a Super+ admin can move this item.", client, 255, 0, 0)
            reset(movedElement)
            return
        end

        -- SQL Injection koruması ile veritabanı güncelleme
        local db = mysql:getConnection()
        local itemId = getElementData(movedElement, "id")
        
        if not tonumber(itemId) then
            outputChatBox("Invalid item ID.", client, 255, 0, 0)
            reset(movedElement)
            return
        end

        -- Prepared statement kullanımı
        local query = "UPDATE worlditems SET x = ?, y = ?, z = ?, rx = ?, ry = ?, rz = ? WHERE id = ?"
        local result = dbExec(db, query, tonumber(x), tonumber(y), tonumber(z), tonumber(rx), tonumber(ry), tonumber(rz), tonumber(itemId))
        
        if result then
            setElementPosition(movedElement, tonumber(x), tonumber(y), tonumber(z))
            setElementRotation(movedElement, tonumber(rx), tonumber(ry), tonumber(rz))
            outputChatBox('Saved item position for item #' .. itemId .. '.', client, 0, 255, 0)
        else
            outputChatBox('Failed to save item position.', client, 255, 0, 0)
            reset(movedElement)
        end
    end)
	
local function rotateItem(item, rz)
	if not exports.rl_integration:isPlayerTrialAdmin(source) then
		return
	end
	
	local id = getElementData(item, "id")
	if not rz then
		destroyElement(item)
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id = " .. (id))
		return
	end
	
	local rx, ry, rzx = getElementRotation(item)
	rz = rz + rzx
	local result = dbExec(mysql:getConnection(), "UPDATE worlditems SET rz = " .. rz .. " WHERE id = " .. (id))
	if result then
		setElementRotation(item, rx, ry, rz)
	end
end
addEvent("rotateItem", true)
addEventHandler("rotateItem", root, rotateItem)

function pickupItem(object, leftammo)
	if disableCanDropPick then
		outputChatBox("Item picking up is currently disabled. While our scripters are investigating the issue.", source, 255, 0, 0)
		return outputDebugString("[ITEM] pickupItem / disabled ")
	end
	
	if not isElement(object) then
		return outputDebugString("[ITEM] pickupItem / item is not an object.")
	end

	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)
	
	if not (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<10) then
		outputDebugString("Distance between Player and Pickup too large")
		return false
	end

	if getElementData(object, "transfering") then
		return outputDebugString("[ITEM] pickupItem / canceled / item is being transferred.")
	end
	outputDebugString("[ITEM] pickupItem / Running ")
	setElementData(object, "transfering", true)
	--if true then return end
	-- Inventory Tooltip
	if (getResourceFromName("rl_tooltips")) then
		triggerClientEvent(source,"tooltips:showHelp",source,14)
	end
	
	-- Animation
	
	local id = tonumber(getElementData(object, "id"))
	if not id then 
		outputChatBox("Error: No world item ID. Notify a scripter. (s_world_items)",source,255,0,0)
		destroyElement(object)
		return
	end
	
	local itemID = getElementData(object, "itemID")
	if not canPickup(source, object) then
		outputChatBox("[!]#FFFFFF Bu öğeyi alamazsınız. F2 ile bir yetkiliye başvurun.", source, 255, 0, 0, true)
		removeElementData(object, "transfering")
		return
	end
	local itemValue = getElementData(object, "itemValue") or 1

	if ((itemID >= 31) and itemID <= 43) or itemBannedByAltAltChecker[itemID] then
		local hoursPlayedTo = getElementData(source, "hours_played") 
		if hoursPlayedTo and hoursPlayedTo < 10 and not exports.rl_global:isAdminOnDuty(source) then
			outputChatBox("[!]#FFFFFF " .. getItemName(itemID) .. " yerden alabilmek için 10 saat oynaman olmalıdır.", source, 255, 0, 0, true)
			removeElementData(object, "transfering")
			return false
		end
		local creator = getElementData(object, "creator") or 0
		local picker = getElementData(source, "dbid")
		if creator ~= picker then
			local accountCreator = exports.rl_cache:getAccountFromCharacterId(creator)
			if tonumber(accountCreator.id) == getElementData(source, "account_id") then
				outputChatBox("[!]#FFFFFF Varlıkların aynı hesaptaki Karakterleri veya bir oyuncunun sahip olduğu çoklu hesaplar arasında aktarılması kesinlikle yasaktır! ", source, 255, 0, 0, true)
				exports.rl_global:sendMessageToAdmins("[ANTI-ALT->ALT]: Detected illegal assets transferring on account name '" .. getElementData(source, "account_username") .. "'.")
				exports.rl_global:sendMessageToAdmins("[ANTI-ALT->ALT]: Suspect is trying to transfer a " .. getItemName(itemID) .. " between alternatives.")
				removeElementData(object, "transfering")
				return false
			end
		end
	end
	
	if itemID == 115 then
		if isThisGunDuplicated(itemValue, source) then
			destroyElement(object)
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
			outputChatBox("[!]#FFFFFF Silah çoğaltılması tespit edilerek silahınız silindi, üzgünüz.", source, 255,0,0, true)
			return false
		end
	end
	
	if itemID == 138 then
		if not exports.rl_integration:isPlayerTrialAdmin(source) then
			outputChatBox("[!]#FFFFFF Bu öğeyi sadece bir yetkili alabilir.", source, 255, 0, 0, true)
			removeElementData(object, "transfering")
			return false
		end
	end
	
	if itemID == 139 and not exports.rl_integration:isPlayerTrialAdmin(source) then
		outputChatBox("[!]#FFFFFF Bu öğeyi sadece bir yetkili alabilir.", source, 255, 0, 0, true)
		removeElementData(object, "transfering")
		return false
	end
	
	exports.rl_global:applyAnimation(source, "CARRY", "liftup", 600, false, true, true)
	if itemID > 0 then
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
		while #getItems(object) > 0 do -- This one is suspicious / Farid
			moveItem2(object, source, 1)
			outputDebugString("Moved something, atleast trying to")
		end
	else
		if itemID == -100 then
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
			setPedArmor(source, itemValue)
		else
			if leftammo and itemValue > leftammo then
				itemValue = itemValue - leftammo
				setElementData(object, "itemValue", itemValue)
				dbExec(mysql:getConnection(), "UPDATE worlditems SET itemvalue=" .. itemValue .. " WHERE id=" .. id)
				itemValue = leftammo
			else
				dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
			end
			exports.rl_global:giveWeapon(source, -itemID, itemValue, true)
		end
	end

	destroyElement(object)
	
	if itemID == 134 then
		exports.rl_global:giveMoney(source, itemValue)
		outputChatBox(exports.rl_global:formatMoney(itemValue) .. "$ alır.", source, 255, 194, 14)
		triggerEvent("sendAme", source, exports.rl_global:formatMoney(itemValue) .. "$ alır.")
	elseif itemID == 178 then
		local yup = split(itemValue, ":")
		giveItem(source, itemID, itemValue)
		triggerEvent("sendAme", source, getItemDescription(itemID, itemValue) .. " alır.")
	else
		giveItem(source, itemID, itemValue)
		outputChatBox(getItemName(itemID, itemValue) .. " alır.", source, 255, 194, 14)
		triggerEvent("sendAme", source, getItemName(itemID, itemValue) .. " alır.")
	end
	
	doItemGivenChecks(source, itemID, itemValue)
end
addEvent("pickupItem", true)
addEventHandler("pickupItem", root, pickupItem)

function removeItemTransferingState()
	for i, object in pairs(exports.rl_pool:getPoolElementsByType("object")) do
		removeElementData(object, "transfering")
	end
end
addEventHandler("onResourceStop", resourceRoot, removeItemTransferingState)
