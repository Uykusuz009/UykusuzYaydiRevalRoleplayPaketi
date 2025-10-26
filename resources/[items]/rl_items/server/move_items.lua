local function canAccessElement(player, element)
	if getElementData(player, "dead") then
		return false
	end
	  
	  if getElementType( element ) == "player" then
    return end
	
	if getElementType(element) == "vehicle" then
		if not isVehicleLocked(element) then
			return true
		else
			local veh = getPedOccupiedVehicle(player)
			local inVehicle = getElementData(player, "realinvehicle")
			
			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString("canAcccessElement failed (hack?): " .. getPlayerName(player) .. " on Vehicle " .. getElementData(element, "dbid"))
				return false
			else
				outputDebugString("canAcccessElement failed (locked): " .. getPlayerName(player) .. " on Vehicle " .. getElementData(element, "dbid"))
				return false
			end
		end
	else
		return true
	end
end

local function openInventory( element, ax, ay )
    if canAccessElement( source, element ) then
        if getElementType( element ) == "player" then
            outputChatBox("çen büyü dünde inventory açıp eşyamı çalıcan lan - Jilet Roleplay", source, 255, 0, 0)
           return
        end
        triggerEvent( "subscribeToInventoryChanges", source, element )
        triggerClientEvent( source, "openElementInventory", element, ax, ay )
    end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

local function closeInventory(element)
	triggerEvent("unsubscribeFromInventoryChanges", source, element)
end
addEvent("closeFreakinInventory", true)
addEventHandler("closeFreakinInventory", root, closeInventory)

local function output(from, to, itemID, itemValue, evenIfSamePlayer)
	if from == to and not evenIfSamePlayer then
		return false
	end
	
	if getElementType(from) == "player" and getElementType(to) == "player" then
		local name = getName(to)
		if itemID == 115 or itemID == 116 then
			exports.rl_global:sendLocalText(from, "* " .. getPlayerName(from):gsub("_", " ") .. " " .. getPlayerName(to):gsub("_", " ") .. " kişisine #0cc6f5" .. getItemName(itemID, itemValue) .. " #dfaeffverir.", 223, 174, 255, 30)
			exports.rl_logs:addLog("item", getPlayerName(from):gsub("_", " ") .. " isimli oyuncu " .. getPlayerName(to):gsub("_", " ") .. " isimli oyuncuya (" .. getItemName(itemID, itemValue) .. ") verdi.")
			triggerEvent("updateLocalGuns", from)
            triggerEvent("updateLocalGuns", to)
		else
			exports.rl_global:sendLocalMeAction(from, "elinde bulunan " .. getItemName(itemID, itemValue) .. " isimli öğeyi " .. getPlayerName(to):gsub("_", " ") .. " kişisine verir.")
			exports.rl_logs:addLog("item", getPlayerName(from):gsub("_", " ") .. " isimli oyuncu " .. getPlayerName(to):gsub("_", " ") .. " isimli oyuncuya (" .. getItemName(itemID, itemValue) .. ") verdi.")
			triggerEvent("updateLocalGuns", from)
            triggerEvent("updateLocalGuns", to)
		end
	elseif getElementType(from) == "player" then
		local name = getName(to)
		if itemID == 115 or itemID == 116 then
			exports.rl_global:sendLocalText(from, "* " .. getPlayerName(from):gsub("_", " ") .. " " .. name .. " içine #0cc6f5" .. getItemName(itemID, itemValue) .. " #dfaeffkoyar.", 223, 174, 255, 30)
			exports.rl_logs:addLog("item", getPlayerName(from):gsub("_", " ") .. " isimli oyuncu " .. name .. " içerisine (" .. getItemName(itemID, itemValue) .. ") koydu.")
			triggerEvent("updateLocalGuns", from)
		else
			exports.rl_global:sendLocalMeAction(from, name .. " içine " .. getItemName(itemID, itemValue) .. " koyar.")
			exports.rl_logs:addLog("item", getPlayerName(from):gsub("_", " ") .. " isimli oyuncu " .. name .. " içerisine (" .. getItemName(itemID, itemValue) .. ") koydu.")
			triggerEvent("updateLocalGuns", from)
		end
	elseif getElementType(to) == "player" then
		local name = getName(from)
		if itemID == 115 or itemID == 116 then
			exports.rl_global:sendLocalText(to, "* " .. getPlayerName(to):gsub("_", " ") .. " " .. name .. " içinden #0cc6f5" .. getItemName(itemID, itemValue) .. " #dfaeffalır.", 223, 174, 255, 30)
			exports.rl_logs:addLog("item", getPlayerName(to):gsub("_", " ") .. " isimli oyuncu " .. name .. " içerisinden (" .. getItemName(itemID, itemValue) .. ") aldı.")
		else
			triggerEvent("sendAme", to, name .. " içinden " .. getItemName(itemID, itemValue) .. " alır.")
			exports.rl_logs:addLog("item", getPlayerName(to):gsub("_", " ") .. " isimli oyuncu " .. name .. " içerisinden (" .. getItemName(itemID, itemValue) .. ") aldı.")
		end
	end
	return true
end

function x_output_wrapper(...) return output(...) end

local function moveToElement(element, slot, ammo, event) 
	if client ~= source then
		return
	end
	
	-- if not canAccessElement(source, element) then
		-- outputChatBox("[!]#FFFFFF Bunu yapmaya yetkili değilsiniz.", source, 255, 0, 0, true)
		-- playSoundFrontEnd(source, 4)
		-- triggerClientEvent(source, event or "finishItemMove", source)
		-- return
	-- end 
	
	local name = getName(element)
	if not ammo then  
		local item = getItems(source)[slot]
		if item then
			if (getElementType(element) == "ped") and getElementData(element, "shopkeeper") then
				if getElementData(element, "customshop") then
					if item[1] == 134 then
						triggerClientEvent(source, event or "finishItemMove", source)
						return false
					end
					triggerEvent("shop:addItemToCustomShop", source, element, slot, event)
					return true
				end
				triggerClientEvent(source, event or "finishItemMove", source)
				return false
			end
			
			if not (getElementModel(element) == 2942) and not hasSpaceForItem(element, item[1], item[2]) then
				outputChatBox("[!]#FFFFFF Envanter dolu.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
			else
				if (item[1] == 115) then
					local itemCheckExplode = exports.rl_global:explode(":", item[2])
					local checkString = string.sub(itemCheckExplode[3], -4)
                    if (checkString == " (D)") then
						outputChatBox("[!]#FFFFFF Sunucumuzun politikaları gereğince bu işlem yasaklıdır.", source, 255, 0, 0, true)
						playSoundFrontEnd(source, 4)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				elseif (item[1] == 116) then
					local ammoDetails = exports.rl_global:explode(":", item[2])
					local checkString = string.sub(ammoDetails[3], -4)
					if (checkString == " (D)")  then
						outputChatBox("[!]#FFFFFF Sunucumuzun politikaları gereğince bu işlem yasaklıdır.", source, 255, 0, 0, true)
						playSoundFrontEnd(source, 4)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				elseif (item[1] == 179 and getElementType(element) == "vehicle") then
					local vehID = getElementData(element, "dbid")
					local veh = element
					if (exports.rl_global:isStaffOnDuty(source) or exports.rl_integration:isPlayerScripter(source) or exports.rl_global:hasItem(source, 3, tonumber(vehID)) or (getElementData(veh, "faction") > 0 and exports.rl_faction:isPlayerInFaction(source, getElementData(veh, "faction")))) then
						local itemExploded = exports.rl_global:explode(";", item[2])
						local url = itemExploded[1]
						local texName = itemExploded[2]
						if url and texName then
							local res = exports["rl_item-texture"]:addVehicleTexture(source, veh, texName, url)
							if res then
								takeItemFromSlot(source, slot)
								outputChatBox("success", source)
							end
							triggerClientEvent(source, event or "finishItemMove", source)
							return
						end
					end
				elseif (item[1] == 112) then
					outputChatBox("[!]#FFFFFF Sunucumuzun politikaları gereğince bu işlem yasaklıdır.", source, 255, 0, 0, true)
					playSoundFrontEnd(source, 4)
					triggerClientEvent(source, event or "finishItemMove", source)
					return
				end
				
				if (item[1] == 137) then
					outputChatBox("You cannot move this item.", source, 255, 0, 0)
					triggerClientEvent(source, event or "finishItemMove", source)
					return		
				elseif item[1] == 138 then
					if not exports.rl_integration:isPlayerAdmin1(source) then
						outputChatBox("It requires an admin to move this item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				elseif item[1] == 139 then
					if not exports.rl_integration:isPlayerTrialAdmin(source) then
						outputChatBox("It requires a trial administrator to move this item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				end

				if (item[1] == 134) then
					if not exports.rl_global:isStaffOnDuty(source) and not exports.rl_global:isStaffOnDuty(element) then
						local hoursPlayedFrom = getElementData(source, "hoursplayed") or 99
						local hoursPlayedTo = getElementData(element, "hoursplayed") or 99
						if (getElementType(element) == "player") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 or hoursPlayedTo < 10 then
								outputChatBox("You require 10 hours of playing time to give money to another player.", source, 255, 0, 0)
								outputChatBox(exports.rl_global:getPlayerName(source) .. " requires 10 hours of playing time to give money to you.", element, 255, 0, 0)
								triggerClientEvent(source, event or "finishItemMove", source)

								outputChatBox("You require 10 hours of playing time to receive money from another player.", element, 255, 0, 0)
								outputChatBox(exports.rl_global:getPlayerName(element) .. " requires 10 hours of playing time to receive money from you.", source, 255, 0, 0)
								triggerClientEvent(source, event or "finishItemMove", source)
								return false
							end
						elseif (getElementType(element) == "vehicle") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("You require 10 hours of playing time to store money in a vehicle.", source, 255, 0, 0)
								triggerClientEvent(source, event or "finishItemMove", source)
								return false
							end
						elseif (getElementType(element) == "object") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("You require 10 hours of playing time to store money in that.", source, 255, 0, 0)
								triggerClientEvent(source, event or "finishItemMove", source)
								return false
							end
						end
					end
					
					if exports.rl_global:takeMoney(source, tonumber(item[2])) then
						if getElementType(element) == "player" then
							if exports.rl_global:giveMoney(element, tonumber(item[2])) then
								triggerEvent('sendAme', source, "gives $" .. exports.rl_global:formatMoney(item[2]) .. " to " ..  exports.rl_global:getPlayerName(element)  .. ".") 
							end
						else
							if exports.rl_global:giveItem(element, 134, tonumber(item[2])) then
								triggerEvent('sendAme', source, "puts $" .. exports.rl_global:formatMoney(item[2]) .. " inside the " ..   name  .. ".") 
							end
						end
					end
				else
					if getElementType(element) == "object" then
						local elementModel = getElementModel(element)
						local elementItemID = getElementData(element, "itemID")
						if elementItemID then
							if elementItemID == 166 then
								if item[1] ~= 165 then
									triggerClientEvent(source, event or "finishItemMove", source)
									return									
								end
							end
						end
						if (getElementDimension(element) < 19000 and (item[1] == 4 or item[1] == 5) and getElementDimension(element) == item[2]) or (getElementDimension(element) >= 20000 and item[1] == 3 and getElementDimension(element) - 20000 == item[2]) then -- keys to that safe as well
							if countItems(source, item[1], item[2]) < 2 then
								outputChatBox("You can't place your only key to that safe in the safe.", source, 255, 0, 0)
								triggerClientEvent(source, event or "finishItemMove", source)
								return
							end
						end
					end
					
					local success, reason = moveItem(source, element, slot)
					if not success then
						if not elementItemID then elementItemID = getElementData(element, "itemID") end
						local fakeReturned = false
						if elementItemID then
							if elementItemID == 166 then
								fakeReturned = true
							end
						end
						
						if not fakeReturned then
							if getElementModel(element) == 2942 then
							end
						end
						outputDebugString("Item Moving failed: " .. tostring(reason))
					else
						if getElementModel(element) == 2942 then
							exports.rl_bank:playAtmInsert(element)
						elseif item[1] == 165 then
							if exports.rl_clubtec:isVideoPlayer(element) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementDimension(value)==getElementDimension(element) then
										triggerEvent("fakevideo:loadDimension", value)
									end
								end
							end
						end
						
						doItemGiveawayChecks(source, item[1])
						output(source, element, item[1], item[2])
					end
				end
			end
		end
	else
		if not ((slot == -100 and hasSpaceForItem(element, slot)) or (slot > 0 and hasSpaceForItem(element, -slot))) then
			outputChatBox("The Inventory is full.", source, 255, 0, 0)
		else
			if tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("You can't put your weapons in a " .. name .. " while being on duty.", source, 255, 0, 0)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("You can't put this spray can into a " .. name .. ".", source, 255, 0, 0)
			else
				if slot == -100 then 	
					local ammo = math.ceil(getPedArmor(source))
					if ammo > 0 then
						setPedArmor(source, 0)
						giveItem(element, slot, ammo)
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.rl_global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.rl_global:sendMessageToAdmins("[items\moveToElement] Possible duplication of gun from '" .. getPlayerName(source) .. "' // " .. getItemName(-slot))
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
					
					exports.rl_global:takeWeapon(source, slot)
					
					if ammo > 0 then
						giveItem(element, -slot, ammo)
						output(source, element, -slot)
					end
				end
			end
		end
	end
	triggerClientEvent(source, event or "finishItemMove", source)
end
addEvent("moveToElement", true)
addEventHandler("moveToElement", root, moveToElement)

local function moveWorldItemToElement(item, element)
	if not isElement(item) or not isElement(element) or not canAccessElement(source, element) then
		return
	end
	
	local id = tonumber(getElementData(item, "id"))
	if not id then 
		outputChatBox("Error: No world item ID. Notify a scripter. (s_move_items)", source, 255, 0, 0)
		destroyElement(element)
		return
	end
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue") or 1
	local name = getName(element)
	
	if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
		outputChatBox(getItemName(itemID) .. " can only moved directly from your inventory to this " .. name .. ".", source, 255, 0, 0)
		return false
	end
	
	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		return false
	end
	
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	if itemID == 138 then
		if not exports.rl_integration:isPlayerTrialAdmin(source) then
			outputChatBox("Only a full admin can move this item.", source, 255, 0, 0)
			return
		end
	end

	if itemID == 169 then
		return
	end

	if giveItem(element, itemID, itemValue) then
		output(source, element, itemID, itemValue, true)
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id = ?", id)
		
		while #getItems(item) > 0 do
			moveItem(item, element, 1)
		end
		destroyElement(item)
	else
		outputChatBox("[!]#FFFFFF Envanter doludur.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
	end
end
addEvent("moveWorldItemToElement", true)
addEventHandler("moveWorldItemToElement", root, moveWorldItemToElement)

local function moveFromElement(element, slot, ammo, index)
	if false then
		return outputDebugString("[ITEM] moveFromElement / Disabled ")
	end
	
	if not canAccessElement(source, element) then
		return false
	end
	local item = getItems(element)[slot]
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return 
	end
	
	local name = getName(element)
	
	if item and item[3] == index then
		if ((item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
			local hoursPlayedTo = nil
			
			if isElement(source) and getElementType(source) == "player" then
				hoursPlayedTo = getElementData(source, "hours_played") 
			end
			
			if not exports.rl_global:isAdminOnDuty(source) and not exports.rl_global:isAdminOnDuty(element) then
				if hoursPlayedTo < 10 then
					outputChatBox("You require 10 hours of playing time to receive a " .. getItemName(item[1]) .. " from a " .. name .. ".", source, 255, 0, 0)
					triggerClientEvent(source, "forceElementMoveUpdate", source)
					triggerClientEvent(source, "finishItemMove", source)
					return false
				end
			end
		end

		if not hasSpaceForItem(source, item[1], item[2]) then
			outputChatBox("The inventory is full.", source, 255, 0, 0)
		else
		if not exports.rl_integration:isPlayerTrialAdmin(source) and getElementType(element) == "vehicle" and (item[1] == 61 or item[1] == 85  or item[1] == 117 or item[1] == 140) then
			outputChatBox("Please contact an admin via F2 to move this item.", source, 255, 0, 0)
		elseif not exports.rl_integration:isPlayerTrialAdmin(source) and (item[1] == 138) then
			outputChatBox("This item requires a regular admin to be moved.", source, 255, 0, 0)
		elseif not exports.rl_integration:isPlayerTrialAdmin(source) and (item[1] == 139) then
			outputChatBox("This item requires an admin to be moved.", source, 255, 0, 0)
		elseif item[1] > 0 then			
			if moveItem(element, source, slot) then
				output(element, source, item[1], item[2])
				doItemGivenChecks(source, tonumber(item[1]))
			end
		elseif item[1] == -100 then
			local armor = math.max(0, ((getElementData(source, "faction") == 1 or (getElementData(source, "faction") == 3 and (getElementData(source, "factionrank") == 4 or getElementData(source, "factionrank") == 5 or getElementData(source, "factionrank") == 13))) and 100 or 50) - math.ceil(getPedArmor(source)))
			
			if armor == 0 then
				outputChatBox("You can't wear any more armor.", source, 255, 0, 0)
			else
				output(element, source, item[1])
				takeItemFromSlot(element, slot)
				
				local leftover = math.max(0, item[2] - armor)
				if leftover > 0 then
					giveItem(element, item[1], leftover)
				end
				
				setPedArmor(source, math.ceil(getPedArmor(source) + math.min(item[2], armor)))
			end
			triggerClientEvent(source, "forceElementMoveUpdate", source)
		else
			takeItemFromSlot(element, slot)
			output(element, source, item[1])
			if ammo < item[2] then
				exports.rl_global:giveWeapon(source, -item[1], ammo)
				giveItem(element, item[1], item[2] - ammo)
			else
				exports.rl_global:giveWeapon(source, -item[1], item[2])
			end
			triggerClientEvent(source, "forceElementMoveUpdate", source)
		end
	end
	elseif item then
		outputDebugString("Index mismatch: " .. tostring(item[3]) .. " " .. tostring(index))
	end
	outputDebugString("moveFromElement")
	triggerClientEvent(source, "finishItemMove", source)
end
addEvent("moveFromElement", true)
addEventHandler("moveFromElement", root, moveFromElement)

function getName(element)
	if getElementModel(element) == 2942 then
		return "ATM Machine"
	elseif getElementModel(element) == 2147 then
		return "fridge" 
	elseif getElementModel(source) == 3761 then
		return "shelf"
	end

	if getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("rl_item-world")) then
		local itemID = tonumber(getElementData(element, "itemID")) or 0
		if itemID == 166 then
			return "video player"
		end
	end

	if getElementType(element) == "vehicle" then
		return exports.rl_global:getVehicleName(element)
	end

	if getElementType(element) == "interior" then
		return getElementData(element, "name") .. "'s Mailbox"
	end
	
	if getElementType(element) == "player" then
		return "player" 
	end
	
	return "safe"
end