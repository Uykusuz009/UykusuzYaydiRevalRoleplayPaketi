local saveditems = {}

local function recieveItems(items)
	if items then
		local arr = fromJSON(items)
		if arr then
			for k, v in ipairs(arr) do
				arr[k][2] = tonumber(v[2]) or v[2]
				arr[k][3] = tonumber(v[3])
				arr[k][4] = tonumber(v[4])
			end
			saveditems[source] = arr
			return
		end
	end
	saveditems[source] = nil
end
addEvent("recieveItems", true)
addEventHandler("recieveItems", root, recieveItems)

function hasItem(element, itemID, itemValue)
	if not saveditems[element] then
		return false, "Bilinmiyor"
	end
	
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and (not itemValue or itemValue == value[2]) then
			return true, key, value[2], value[3]
		end
	end
	return false
end

function hasSpaceForItem(element, itemID, itemValue)
	return getCarriedWeight(element) + getItemWeight(itemID, itemValue or 1) <= getMaxWeight(element)
end

function countItems(element, itemID, itemValue)
	if not saveditems[element] then
		return 0
	end
	
	local count = 0
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and (not itemValue or itemValue == value[2]) then
			count = count + 1
		end
	end
	return count
end

function getItems(element)
	if not saveditems[element] then
		return {}, "Bilinmiyor"
	end

	return saveditems[element]
end

function getCarriedWeight(element)
	if not saveditems[element] then
		return 1000000, "Bilinmiyor"
	end
	
	local weight = 0
	for key, value in ipairs(saveditems[element]) do
		weight = weight + getItemWeight(value[1], value[2])
	end
	return weight
end

local function isTruck(element)
	if getElementType(element) == "" or getElementType(element) == "Trailer" then
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
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("rl_item-world")) then -- World Item
		return getElementModel(element) == 2147 and 50 or getElementModel(element) == 3761 and 100 or 10
	else
		return 20
	end
end

function updateItemValue(element, slot, itemValue)
	triggerServerEvent("updateItemValue", localPlayer, element, slot, itemValue)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("itemResourceStarted", localPlayer)
end)