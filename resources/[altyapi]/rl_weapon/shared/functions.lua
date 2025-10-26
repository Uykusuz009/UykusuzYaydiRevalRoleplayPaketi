weapon_fire_disabled = {
	[14] = 'Flowers',
}

weapon_ammoless = {
	[0] = 'Fist',
	[1] = 'Brass Knuckles',
	[2] = 'Golf Club',
	[3] = 'Nightstick',
	[4] = 'Knife',
	[5] = 'Baseball Bat',
	[6] = 'Shovel',
	[7] = 'Pool Cue',
	[8] = 'Katana',
	[9] = 'Chainsaw',
	[43] = 'Camera',
	[10] = 'Long Purple Dildo',
	[11] = 'Short tan Dildo',
	[12] = 'Vibrator',
	[15] = 'Cane',
	[14] = 'Flowers',
	[44] = 'Night-Vision Goggles',
	[45] = 'Infrared Goggles',
	[46] = 'Parachute',
	[16] = 'Grenade',
	[17] = 'Tear Gas',
	[18] = 'Molotov Cocktails',
	[37] = 'Flamethrower',
	[39] = 'Satchel',
	[40] = 'Satchel Remote',
	[41] = 'Spraycan',
	[42] = 'Fire Extinguisher',
}

function isWeapAmmoless(weap_id)
	return weapon_ammoless[weap_id]
end

weapon_infinite_ammo = {
	[37] = 'Flamethrower',
	[43] = 'Camera',
	[46] = 'Parachute',
	[41] = 'Spraycan',
	[42] = 'Fire Extinguisher',
}

function isQueueEmpty(q)
	for i, k in pairs(q) do
		return false
	end
	return true
end


function canRetrieve(player, itemId, itemValue)
	local gun = exports.rl_global:explode(':', itemValue)
	local serial = gun[itemId == 115 and 2 or 3]
	local serial_info = serial and exports.rl_global:retrieveWeaponDetails(serial)
	if serial_info and serial_info[2] and tonumber(serial_info[2]) then
		local gun_source = tonumber(serial_info[2])
		local gun_creator = tonumber(serial_info[3])
		if gun_source == 2 then
			return false , "This " .. (itemId==115 and gun[3] or 'ammopack') .. " is a duty weapon. You are not allowed to retrieve it."
		elseif gun_source == 3 and gun_creator ~= getElementData(player, 'dbid') and (not exports.rl_integration:isPlayerAdmin1(player)) then
			return false, "This " .. (itemId==115 and gun[3] or 'ammopack') .. " is authorized under " .. (exports.rl_cache:getCharacterNameFromID(gun_creator) or "someone") .. "'s firearm license act. You are not allowed to retrieve it."
		end
	end
	return true
end

function isWeaponCCWP(player, itemId, itemValue) 
	local gun = exports.rl_global:explode(':', itemValue)
	local serial = gun[itemId == 115 and 2 or 3]
	local serial_info = serial and exports.rl_global:retrieveWeaponDetails(serial)
	if serial_info and serial_info[2] and tonumber(serial_info[2]) then
		local gun_source = tonumber(serial_info[2])
		if gun_source == 3 then
			return true
		end
	end
	return false
end

function getPlayerWeaponFromDbid(player, dbid, check_inv)
	if triggerServerEvent then
		check_inv = true
	end

	if check_inv then
		for inv_slot, itemCheck in ipairs(exports.rl_items:getItems(player)) do
			if (itemCheck[1] == 115 or itemCheck[1] == 116) and tonumber(itemCheck[3]) == dbid then
				return itemCheck, inv_slot
			end
		end
	else
		if weapons[player] then
			for slot, weap in pairs(weapons[player]) do
				for dbid_, w in pairs(weap) do
					if dbid_ == dbid then
						return w
					end
				end
			end
		end
	end
end

function modifyWeaponValue(itemValue, index, value)
	local values = exports.rl_global:explode(':', itemValue)
	for i=1, index do
		if values[i] == nil then
			values[i] = ''
		end
	end
	values[index] = value
	return exports.rl_global:implode(':', values)
end