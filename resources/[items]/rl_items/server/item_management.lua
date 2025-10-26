mysql = exports.rl_mysql
Async:setPriority("high")
Async:setDebug(true)

local drugList = {[30]=" gram(s)", [31]=" gram(s)", [32]=" gram(s)", [33]=" gram(s)", [34]=" gram(s)", [35]=" ml(s)", [36]=" tablet(s)", [37]=" gram(s)", [38]=" gram(s)", [39]=" gram(s)", [40]=" ml(s)", [41]=" tab(s)", [42]=" shroom(s)", [43]=" tablet(s)"}

local saveditems = {}
local subscribers = {}

local fixInventoryTimer = {}

local function itemconv(arr)
	if not arr then
		return false
	end
	local brr = {}
	for k, v in ipairs(arr) do
		brr[k] = {v[1], tostring(v[2]), tostring(v[3]), tonumber(v[4])}
	end
	return toJSON(brr)
end

local function sendItems(element, to, noload)
	if not noload then
		loadItems(element)
	end
	triggerClientEvent(to, "recieveItems", element, itemconv(saveditems[element]))
end

local function notify(element, noload)
	if subscribers[element] then
		for subscriber in pairs(subscribers[element]) do
			sendItems(element, subscriber, noload)
		end
	end
end

function updateProtection(item, faction, slot, element)
	local success, error = loadItems(element)
	if success then
		if saveditems[element][slot] then
			saveditems[element][slot][4] = faction
			notify(element)
		end
	end
end

local function destroyInventory()
	saveditems[source] = nil
	notify(source)
	
	for key, value in pairs(subscribers) do
		if value[source] then
			value[source] = nil
		end
	end
	
	subscribers[source] = nil
end

addEventHandler("onElementDestroy", root, destroyInventory)
addEventHandler("onPlayerQuit", root, destroyInventory)
addEventHandler("savePlayer", root, function(reason)
	if reason == "Change Character" then
		destroyInventory()
	end
end)

local function subscribeChanges(element)
	sendItems(element, source)
	subscribers[element][source] = true
end
addEvent("subscribeToInventoryChanges", true)
addEventHandler("subscribeToInventoryChanges", root, subscribeChanges)

local function sendCurrentInventory(element)
	sendItems(element, source)
end
addEvent("sendCurrentInventory", true)
addEventHandler("sendCurrentInventory", root, sendCurrentInventory)

local function unsubscribeChanges(element)
	subscribers[element][source] = nil
	triggerClientEvent(source, "recieveItems", element)
end
addEvent("unsubscribeFromInventoryChanges", true)
addEventHandler("unsubscribeFromInventoryChanges", root, subscribeChanges)

local function getID(element)
	if getElementType(element) == "player" then -- Player
		return getElementData(element, "dbid")
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return getElementData(element, "dbid")
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("rl_item-world")) then -- World Item
		return getElementData(element, "id")
	elseif getElementType(element) == "object" then -- Safe
		return getElementDimension(element)
	elseif getElementType(element) == "ped" then -- Ped
		return getElementData(element, "dbid")
	else
		return 0
	end
end

function getElementID(element)
	return getID(element)
end

local function getType(element)
	if getElementType(element) == "player" then -- Player
		return 1
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return 2
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("rl_item-world")) then -- World Item
		return 3
	elseif getElementType(element) == "object" then -- Safe
		return 4
	elseif getElementType(element) == "ped" then -- Ped
		return 5
	else
		return 255
	end
end

function loadItems(element, force)
	if not isElement(element) then
		return false, "No element"
	elseif not getID(element) then
		return false, "Invalid Element ID"
	elseif force or not saveditems[element] then
		saveditems[element] = {}

		local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM items WHERE type = " .. getType(element) .. " AND owner = " .. getID(element) .. " ORDER BY `index` ASC"), -1)

		for index, row in ipairs(result) do
			if saveditems then 
				saveditems[element][#saveditems[element] + 1] = { tonumber(row.itemID) or -1, (tonumber(row.itemValue) or row.itemValue) or 0, tonumber(row.index) or 0, tonumber(row.protected) or 0}
			end
		end
		if not subscribers[element] then
			subscribers[element] = {}
			if getElementType(element) == "player" then
				subscribers[element][element] = true
			end
		end
		notify(element, true)
		if (getElementType(element) == 'player') then
			triggerEvent("updateLocalGuns", element)
		end
		return saveditems, "Success!"
	else
		return true, "Success!"
	end
end

function itemResourceStarted()
	if getID(source) then
		loadItems(source)
	end
end
addEvent("itemResourceStarted", true)
addEventHandler("itemResourceStarted", root, itemResourceStarted)

function clearItems(element, onlyifnosqlones)
	if saveditems[element] then
		if onlyifnosqlones and #saveditems[element] > 0 then
			return false
		else
			while #saveditems[element] > 0 do
				takeItemFromSlot(element, 1)
			end
			
			saveditems[element] = nil
			notify(element, true)

			source = element
			destroyInventory()
			if (getElementType(element) == "player") then
				triggerEvent("updateLocalGuns", element)
			end
		end
	end
	return true
end

function giveItem(element, itemID, itemValue, itemIndex, isThisFromSplittingOrAdminCmd)
    local success, error = loadItems(element)
    if not success then
        outputDebugString("loadItems error: " .. error)
        return false, "loadItems error: " .. error
    end

    if not hasSpaceForItem(element, itemID, itemValue) then
        return false, "Inventory is Full."
    end

    if isThisFromSplittingOrAdminCmd then
        if drugList[itemID] then
            if not tonumber(itemValue) or tonumber(itemValue) < 1 then
                return false, "Drug value must be numeric and meant to be in grams."
            else
                itemValue = tostring(itemValue) .. drugList[itemID]
            end
        end
    end

    if not itemIndex then
        local result = dbExec(mysql:getConnection(), "INSERT INTO items (type, owner, itemID, itemValue) VALUES (" .. getType(element) .. "," .. getID(element) .. "," .. itemID .. ",'" .. itemValue .. "')")
        if not result then
            return false, "Failed to insert item into database."
        end
        
        dbQuery(function(qh, thePlayer, itemID, itemValue, isThisFromSplittingOrAdminCmd)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                itemIndex = res[1]["index"]
                if itemID == 178 then
                    local bInfo = split(tostring(itemValue), ":")
                    local bID = bInfo[3]
                    if not bID then
                        dbExec(mysql:getConnection(), "INSERT INTO books SET `title` = ?, `author` = 'Unknown', `book` = 'The beginning of something great...'", itemValue)
                        dbQuery(function(qh, thePlayer, itemID, itemValue)
                            local res, rows, err = dbPoll(qh, 0)
                            if rows > 0 then
                                local bookIndex = res[1]["index"]
                                itemValue = itemValue .. ":Unknown:" .. tostring(bookIndex)
                                dbExec(mysql:getConnection(), "UPDATE `items` SET `itemValue` = ? WHERE `index` = ?", itemValue, tonumber(itemIndex))
                            end
                        end, {thePlayer, itemID, itemValue}, mysql:getConnection(), "SELECT `index` FROM `books` WHERE `index` = LAST_INSERT_ID()")
                    end
                end

                saveditems[thePlayer] = saveditems[thePlayer] or {}
                table.insert(saveditems[thePlayer], {itemID, itemValue, itemIndex, 0})
                notify(thePlayer, true)
                
                if getElementType(thePlayer) == "player" then
                    if tonumber(itemID) == 115 or tonumber(itemID) == 116 then
                        triggerEvent("updateLocalGuns", thePlayer)
                    end
                    doItemGivenChecks(thePlayer, tonumber(itemID))
                end
            end
        end, {element, itemID, itemValue, isThisFromSplittingOrAdminCmd}, mysql:getConnection(), "SELECT `index` FROM `items` WHERE `index` = LAST_INSERT_ID()")
    else
        saveditems[element] = saveditems[element] or {}
        table.insert(saveditems[element], {itemID, itemValue, itemIndex, 0})
        notify(element, true)

        if getElementType(element) == "player" then
            if tonumber(itemID) == 115 or tonumber(itemID) == 116 then
                triggerEvent("updateLocalGuns", element)
            end
            doItemGivenChecks(element, tonumber(itemID))
        end
    end

    return true
end

function takeItem(element, itemID, itemValue)
	local success, error = loadItems(element)
	if success then
		local success, slot = hasItem(element, itemID, itemValue)
		if success then
			takeItemFromSlot(element, slot)
			if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then
				triggerEvent("updateLocalGuns", element)
			end
			return true
		else
			return false, "Element doesn't have this item"
		end
	else
		return false, "loadItems error: " .. error
	end
end

function takeItemFromSlot(element, slot, nosqlupdate)
	local success, error = loadItems(element)
	if success then
		if saveditems[element][slot] then
			local itemID = saveditems[element][slot][1]
			local itemValue = saveditems[element][slot][2]
			local index = saveditems[element][slot][3]
			
			local success = true
			if not nosqlupdate then
				if index then
					result = dbExec(mysql:getConnection(), "DELETE FROM `items` WHERE `index` = ?", index)
				end
				if not result then
					success = false
				end
			end
			
			if success then
				table.remove(saveditems[element], slot)
				notify(element)
				if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then
					triggerEvent("updateLocalGuns", element)
				end
				return true
			end
			return false, "Slot does not exist."
		end
	else
		return false, "loadItems error: " .. error
	end
end

function updateItemValue(element, slot, itemValue)
	local success, error = loadItems(element)
	if success then
		if saveditems[element][slot] then
			local itemValue = tonumber(itemValue) or tostring(itemValue)
			if itemValue then
				local itemIndex = saveditems[element][slot][3]
				if itemIndex and itemValue then
					result = dbExec(mysql:getConnection(), "UPDATE items SET `itemValue` = '" .. (tostring(itemValue)) .. "' WHERE `index` = " .. itemIndex)
				end
				if result then
					saveditems[element][slot][2] = itemValue
					notify(element)
					return true
				else
					return false, "MySQL-Query failed."
				end
			else
				return false, "Invalid ItemValue"
			end
		else
			return false, "Slot does not exist."
		end
	else
		return false, "loadItems error: " .. error
	end
end
addEvent("updateItemValue", true)
addEventHandler("updateItemValue", root, updateItemValue)

function moveItem2(from, to, slot)
	moveItem(from, to, slot)
end

function moveItem(from, to, slot)
	local success, error = loadItems(from)
	if success then
		local success, error = loadItems(to)
		if success then
			if saveditems[from] and saveditems[from][slot] then
				if hasSpaceForItem(to, saveditems[from][slot][1], saveditems[from][slot][2]) then
					local itemIndex = saveditems[from][slot][3]
					if itemIndex then
						local itemID = saveditems[from][slot][1]
						if itemID == 48 or itemID == 126 or itemID == 60 or itemID == 103 then
							return false, "Bu eşyayı taşıyamazsınız."
						else
							local query = dbExec(mysql:getConnection(), "UPDATE items SET type = " .. getType(to) .. ", owner = " .. getID(to) .. " WHERE `index` = " .. itemIndex)
							if query then
								local itemValue = saveditems[from][slot][2]
								if itemID == 115 then -- guns
									local target = from
									if getElementType(to) == "player" then
										target = to
									end
								end
								
								if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then
									if itemID == 150 then
										if getElementModel(from) == 2942 or getElementModel(to) == 2942 then
											takeItemFromSlot(from, slot, true)
											giveItem(to, itemID, itemValue, itemIndex)
											return true
										end
									end
									
									local hoursPlayedFrom = getElementData(from, "hours_played") or 0
									local hoursPlayedTo = getElementData(to, "hours_played") or 0
									
									if not exports.rl_global:isAdminOnDuty(to) and not exports.rl_global:isAdminOnDuty(from) then
										if hoursPlayedFrom < 0 then
											outputChatBox("[!]#FFFFFF Bunu yapmak için sunucuda 10 saatiniz olması gerekir.", from, 255, 0, 0, true)
											playSoundFrontEnd(from, 4)
											return false, "Item transferi engellendi, < 10 saat"
										end
										
										if hoursPlayedTo < 0 then
											outputChatBox("[!]#FFFFFF Bunu yapmak için sunucuda 10 saatiniz olması gerekir.", to, 255, 0, 0, true)
											playSoundFrontEnd(to, 4)
											return false, "Item transferi engellendi, < 10 saat"
										end
									end
								end
			
								
								if itemID == 134 then -- MONEY
									if takeItemFromSlot(from, slot, true) then
										if exports.rl_global:giveMoney(to, tonumber(itemValue)) then
											return true
										end
									end
								else
									if takeItemFromSlot(from, slot, true) then
										if giveItem(to, itemID, itemValue, itemIndex) then
											return true
										end
									end
								end
							else
								return false, "MySQL-Query failed."
							end
						end
					else
						return false, "Item does not exist."
					end
				else
					return false, "Target does not have Space for Item."
				end
			else
				return false, "Slot does not exist."
			end
		else
			return false, "loadItems(to) error: " .. error
		end
	else
		return false, "loadItems(from) error: " .. error
	end
end

function hasItem(element, itemID, itemValue)
	local success, error = loadItems(element)
	if success then
		for key, value in pairs(saveditems[element]) do
			if value[1] == itemID and (not itemValue or itemValue == value[2]) then
				return true, key, value[2], value[3]
			end
		end
		return false
	else
		return false, "loadItems error: " .. error
	end
end

function hasSpaceForItem(element, itemID, itemValue)
	local success, error = loadItems(element)
	if success then
		local carriedWeight = getCarriedWeight(element) or false
		local itemWeight = getItemWeight(itemID, itemValue or 1) or false
		local maxWeight = getMaxWeight(element) or false
		if carriedWeight and itemWeight and maxWeight then
			return carriedWeight + itemWeight <= maxWeight
		else
			return false, "Can't get carriedWeight or itemWeight or maxWeight"
		end
	else
		return false, "loadItems error: " .. error
	end
end

function countItems(element, itemID, itemValue)
	local success, error = loadItems(element)
	if success then
		local count = 0
		for key, value in pairs(saveditems[element]) do
			if value[1] == itemID and (not itemValue or itemValue == value[2]) then
				count = count + 1
			end
		end
		return count
	else
		return 0, "loadItems error: " .. error
	end
end

function getItems(element)
	if not saveditems[element] then
		loadItems(element)
	end
	return saveditems[element]
end

function getCarriedWeight(element)
	local success, error = getItems(element)
	if success then
		local weight = 0
		for key, value in ipairs(saveditems[element]) do
			weight = weight + getItemWeight(value[1], value[2])
		end
		return weight
	else
		return 1000000, "loadItems error: " .. error
	end
end

local function isTruck(element)
	if getElementType(element) == "Trailer" then
		return true
	end
	local model = getElementModel(element)
	return model == 498 or model == 609 or model == 499 or model == 524 or model == 455 or model == 414 or model == 443 or model == 456
end	
	
local function isSUV(element)
	local model = getElementModel(element)
	return model == 482 or model == 440 or model == 418 or model == 413 or model == 400 or model == 489 or model == 579 or model == 459 or model == 582
end

function getMaxWeight(element)
	if getElementType(element) == "player" then
		return getPlayerMaxCarryWeight(element)
	elseif getElementType(element) == "vehicle" then
		if getID(element) < 0 then
			return -1
		elseif getVehicleType(element) == "BMX" then
			return 1
		elseif getVehicleType(element) == "Bike" then
			return 10
		elseif isSUV(element) then
			return 75
		elseif isTruck(element) then
			return 120
		else
			return 20
		end
	elseif (getElementType(element) == "object") and (getElementModel(element) == 2942) then --ATM machine / Farid
		return 0.1
	elseif (getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("rl_item-world"))) then -- World Item
		local itemID = tonumber(getElementData(element, "itemID")) or 0
		if itemID == 166 then
			return 0.1
		end
		return getElementModel(element) == 2147 and 50 or getElementModel(element) == 3761 and 100 or 10
	else
		return 20
	end
end

function deleteAll(itemID, itemValue)
	if itemID then
		if itemValue then
			dbExec(mysql:getConnection(), "DELETE FROM items WHERE itemID = " .. itemID .. " AND itemValue = '" .. (tostring(itemValue)) .. "'") 
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE itemid = " .. itemID .. " AND itemvalue = '" .. (tostring(itemValue)) .. "'") 
		else
			dbExec(mysql:getConnection(), "DELETE FROM items WHERE itemID = " .. itemID)
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE itemid = " .. itemID)
		end
		
		if saveditems then
			for value in pairs(saveditems) do
				if isElement(value) then
					while exports.rl_global:hasItem(value, itemID, itemValue) do
						exports.rl_global:takeItem(value, itemID, itemValue)
					end
				end
			end
		end

		local objects = getElementsByType('object', getResourceRootElement(getResourceFromName('rl_item-world')))
		if objects then
			Async:foreach(objects, function(v)
				local this = false
				if itemValue then
					this = getElementData(v, 'itemID') == itemID and tostring(getElementData(v, 'itemValue')) == tostring(itemValue)
				else
					this = getElementData(v, 'itemID') == itemID
				end

				if this then
					destroyElement(v)
				end
			end)
		end
		return true
	else
		return false
	end
end

function deleteAllItemsWithinInt(intID , dayOld, CLEANUPINT)
	if not dayOld then dayOld = 0 end
	if intID then
		local row = {}
		local query2 = false
		local success = false
		if CLEANUPINT ~= "CLEANUPINT" then
			dbQuery(function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						Async:foreach(getElementsByType("object", getResourceRootElement(getResourceFromName("rl_item-world"))), function(value)
							if isElement(value) then
								if tonumber(getElementData(value, "id")) == tonumber(row["id"]) then
									destroyElement(value)
								end
							end
						end)
					end
				end
			end, mysql:getConnection(), "SELECT `id` FROM `worlditems` WHERE `dimension` = '" .. (tostring(intID)) .. "' AND DATEDIFF(NOW(), creationdate) >= '" .. (tostring(dayOld))  .. "' AND `itemID` != 81 AND `itemID` != 103 AND protected = 0") 
			if dbExec(mysql:getConnection(),"DELETE FROM `worlditems` WHERE `dimension` = '" .. (tostring(intID)) .. "' AND DATEDIFF(NOW(), creationdate) >= '" .. (tostring(dayOld))  .. "' AND `itemID` != 81 AND `itemID` != 103 AND protected = 0") then
				success = true
			end
		else
			dbQuery(function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						Async:foreach(getElementsByType("object", getResourceRootElement(getResourceFromName("rl_item-world"))), function(value)
							if isElement(value) then
								if tonumber(getElementData(value, "id")) == tonumber(row["id"]) then
									destroyElement(value)
								end
							end
						end)
					end
				end
			end, mysql:getConnection(), "SELECT `id` FROM `worlditems` WHERE `dimension` = '" .. (tostring(intID)) .. "'") 
			if dbExec(mysql:getConnection(),"DELETE FROM `worlditems` WHERE `dimension` = '" .. (tostring(intID)) .. "'") then
				success = true
			end
		end
		
		
		if success then
			return true
		else
			return false
		end
	else
		return false
	end
end

function fixInventory(thePlayer, commandName)
	if not isTimer(fixInventoryTimer[thePlayer]) then
		if (not getElementData(thePlayer, "dead")) and (not getElementData(thePlayer, "spawn_protection")) and (not getElementData(thePlayer, "adminjailed")) then
			triggerEvent("updateLocalGuns", thePlayer)
			outputChatBox("[!]#FFFFFF Envanter başarıyla düzeltildi.", thePlayer, 0, 255, 0, true)
			triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
			fixInventoryTimer[thePlayer] = setTimer(function() end, 1000 * 10, 1)
		else
			outputChatBox("[!]#FFFFFF Bu durumda iken bu komutu kullanamazsınız.", thePlayer, 255, 0, 0, true)
		end
	else
		local timer = getTimerDetails(fixInventoryTimer[thePlayer])
		outputChatBox("[!]#FFFFFF Envanterinizi düzeltmek için " .. math.floor(timer / 1000)  .. " saniye beklemeniz gerekiyor.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("fixinventory", fixInventory, false, false)
addCommandHandler("fixinv", fixInventory, false, false)