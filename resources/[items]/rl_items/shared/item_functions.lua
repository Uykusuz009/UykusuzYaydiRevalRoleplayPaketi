function getItemRotInfo(id)
	if not itemsPackages[id] then
		return 0, 0, 0, 0
	else
		return  itemsPackages[id][5], itemsPackages[id][6], itemsPackages[id][7], itemsPackages[id][8]
	end
end

local _vehicleCache = {}
local function findVehicleName(value)
	if _vehicleCache[value] then
		return _vehicleCache[value]
	end
	
	for _, theVehicle in pairs(getElementsByType("vehicle")) do
		if getElementData(theVehicle, "dbid") == value then
			_vehicleCache[value] = exports.rl_global:getVehicleName(theVehicle)
			return _vehicleCache[value]
		end
	end
	
	return "?"
end

function getItemName(id, value)
	if not id or not tonumber(id) then
		return "Yükleniyor..."
	end
	if id == -100 then
		return "Body Armor"	
	elseif id == -46 then
		return "Parachute"
	elseif id < 0 then
		return getWeaponNameFromID(-id)
	elseif not itemsPackages[id] then
		return "?"
	elseif id == 3 and value then
		return itemsPackages[id][1] .. " (" .. findVehicleName(value) .. ")", findVehicleName(value)
	elseif (id == 4 or id == 5) and value then
		local pickup = exports['rl_interior']:findParent(nil, value)
		local name = isElement(pickup) and getElementData(pickup, "name")
		return itemsPackages[id][1] .. (name and (" (" .. name .. ")") or ""), name
	elseif (id == 80) and value then
		return value
	elseif (id == 214) and value then
		return value
	elseif (id == 90 or id == 171 or id == 172) and value then
		local itemValue = explode(";", value)
		if itemValue[1] and itemValue[2] then
			local customName = tostring(itemValue[1]) .. " helmet"
			return customName
		else
			return itemsPackages[id][1]
		end
	elseif (id == 96) and value and value ~= 1 then
		return value
	elseif (id == 89 or id == 95 or id == 109 or id == 110) and value and value:find(";") ~= nil then
		return value:sub(1, value:find(";") - 1)
	elseif (id == 115 or id == 116) and value then
		local itemExploded = explode(":", value)
		return itemExploded[3] 
	elseif (id == 150) and value then
		local itemExploded = explode(";", value)
		local text = "ATM card"
		if itemExploded and itemExploded[3] then
			if tonumber(itemExploded[3]) == 1 then
				text = text .. " - Basic"
			elseif tonumber(itemExploded[3]) == 2 then
				text = text .. " - Premium"
			elseif tonumber(itemExploded[3]) == 3 then
				text = text .. " - Ultimate"
			end
		end
		return text
	elseif (id == 165) then
		local disc = tonumber(value) or 0
		if disc > 1 then
			local discData = exports.rl_fakevideo:getFakevideoData(disc)
			if discData then
				return 'DVD "' .. tostring(discData.name) .. '"'
			end 
		else
			return "Empty DVD"
		end
		return "DVD"
	elseif (id == 175) then
		if value and not tonumber(value) then
			local itemExploded = explode(";", value)
			local name = tostring(itemExploded[1] .. " Poster")
			return name
		else
			return itemsPackages[id][1]
		end
	elseif (id == 226) then
		if value and not tonumber(value) then
			local itemExploded = explode(";", value)
			local name = tostring(itemExploded[1])
			return name
		else
			return itemsPackages[id][1]
		end
	else
		return itemsPackages[id][1]
	end
end

function getItemValue(id, value)
	if id == 80 then
		return ""
	elseif id == 214 then
		return ""
	elseif id == 10 and tostring(value) == "1" then
		return 6
	elseif (id == 89 or id == 95 or id == 109 or id == 110) and value and value:find(";") ~= nil then
		return value:sub(value:find(";") + 1)
	elseif (id == 115 and value) then
		local weaponName = explode(":", value)[3]
		if weaponName then
			local checkString = string.sub(weaponName, -4)
			if (checkString == " (D)")  then
				return explode(":", value)[2]
			end
			local silahHak = #tostring(explode(":", value)[6])>0 and explode(":", value)[6] or 3
			return explode(":", value)[2] .. "\n Silah Hakkı: " .. silahHak
		end
	elseif id == 116 and value then
		return value:gsub("^(%d+):(%d+):", "%2 ")
	else
		return value
	end
end
	
function getItemDescription(id, value)
	local i = itemsPackages[id]
	if i then
		local desc = i[2]
		if id == 90 or id == 171 or id == 172 then
			local itemValue = explode(";", value)
			if itemValue[3] then
				local helmetDesc = tostring(itemValue[3])
				return helmetDesc
			else
				return desc:gsub("#v", value)
			end
		elseif id == 96 and value ~= 1 then
			return desc:gsub("PDA", "Laptop")
		elseif id == 114 then 
			if tonumber(value) == nil then return nil end
			local v = tonumber(value) - 999
			return desc:gsub("#v", vehicleupgrades[v] or "?")
		elseif id == 150 then
			local itemExploded = explode(";", value)
			if tonumber(itemExploded[2]) > 0 then
				return "Card Number: '" .. itemExploded[1] .. "', Owner: '" .. tostring(exports.rl_cache:getCharacterNameFromID(itemExploded[2])):gsub("_", " ") .. "'"
			else
				return "Card Number: '" .. itemExploded[1] .. "', Owner: '" .. tostring(exports.rl_cache:getBusinessNameFromID(math.abs(itemExploded[2]))) .. "'"
			end
		elseif id == 152 then
			local itemExploded = explode(";", value)
			return "Kimliğinizi doğrulayan bilgilerin yer aldığı kimlik kartı. (( " .. tostring(itemExploded[1]):gsub("_", " ") .. " ))"
		elseif id == 178 then
			local yup = split(value, ":")
            return yup[1]  .. " by " ..  yup[2]
		else
			return desc:gsub("#v", value)
		end
	end
end

function getItemType(id)
	return (itemsPackages[id] or { nil, nil, 4 })[3]
end

function getItemModel(id, value)
	if id == 115 and value then
		local itemExploded = explode(":", value)
		return weaponmodels[tonumber(itemExploded[1])] or 1271
	else
		return (itemsPackages[id] or { nil, nil, nil, 1271 })[4]
	end
end

function explode(div,str)
	if (div=='') then return false end
	local pos,arr = 0,{}
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1))
		pos = sp + 1
	end
	table.insert(arr,string.sub(str,pos))
	return arr
end

function getItemTab(id)
	if getItemType(id) == 2 then
		return 3
	elseif getItemType(id) == 8 or getItemType(id) == 9 then
		return 4
	elseif getItemType(id) == 10 then
		return 1
	else
		return 2
	end
end

function getItemWeight(itemID, itemValue)
	local weight = itemsPackages[itemID] and itemsPackages[itemID].weight
	return type(weight) == "function" and weight(tonumber(itemValue) or itemValue) or weight 
end

function getItemScale(itemID)
	local scale = itemsPackages[itemID] and itemsPackages[itemID].scale
	return scale
end

function getItemDoubleSided(itemID)
	local dblsided = itemsPackages[itemID] and itemsPackages[itemID].doubleSided
	return dblsided
end

function getItemTexture(itemID, itemValue)
	if itemID == 90 or itemID == 171 or itemID == 172 then
		if itemValue then
			local texname = {
				[90] = "helmet",
				[171] = "helmet_b",
				[172] = "helmet_f"
			}
			itemValue = explode(";", itemValue)
			if itemValue[2] then
				local texture = { {tostring(itemValue[2]), texname[itemID]} }
				return texture
			end
		end
	elseif itemID == 167 and itemValue then
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "cj_painting34"} }
			return texture
		end
	elseif itemID == 175 and itemValue then
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "cj_don_post_2"} }
			return texture
		end
	elseif itemID == 226 and itemValue then
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "goflag"} }
			return texture
		end
	end
	local texture = itemsPackages[itemID] and itemsPackages[itemID].texture
	return texture
end

function getItemPreventSpawn(itemID, itemValue)
	local preventSpawn = itemsPackages[itemID] and itemsPackages[itemID].preventSpawn
	return preventSpawn
end

function getItemUseNewPickupMethod(itemID)
	local use = itemsPackages[itemID] and itemsPackages[itemID].newPickupMethod
	return use
end

function getItemHideItemValue(itemID)
	local use = itemsPackages[itemID] and itemsPackages[itemID].hideItemValue
	return use
end

function isItem(id)
	return itemsPackages[tonumber(id)]
end

itemBannedByAltAltChecker = {}

function getPlayerMaxCarryWeight(element)
	local weightCount = 35

	if hasItem(element, 48) then
		weightCount = weightCount + 10
	end
	
	if hasItem(element, 126) then
		weightCount = weightCount + 7.5
	end
	
	if hasItem(element, 160) then
		weightCount = weightCount + 2
	end
	
	if hasItem(element, 163) then
		weightCount = weightCount + 15
	end
	
	if hasItem(element, 164) then
		weightCount = weightCount + 15
	end
	
	return weightCount
end