weapons = {}
ammopacks = {}

local function getItems(player)
	return exports["rl_items"]:getItems(player)
end

function refreshWeaponsAndAmmoTables(player)
	weapons[player] = { [0] = { [0] = { id = 0, slot = 0, name = 'Fist' } } }
	ammopacks[player] = {}
	for inv_slot, itemCheck in ipairs(getItems(player)) do
		if itemCheck[1] == 115 then
			local dbid = tonumber(itemCheck[3])
			local gunDetails = exports.rl_global:explode(':', itemCheck[2])
			local id = tonumber(gunDetails[1])
			local slot = getSlotFromWeapon(id)
			local loaded_ammo = tonumber(gunDetails[4] and gunDetails[4] or 0) or 0
			local serial = gunDetails[2]
			local serialNumberCheck = exports.rl_global:retrieveWeaponDetails(serial)
			local duty = tonumber(serialNumberCheck[2]) == 2
			if not weapons[player][slot] then weapons[player][slot] = {} end
			weapons[player][slot][dbid] = { dbid = dbid, id = id, slot = slot, name = gunDetails[3], serial = serial, loaded_ammo = loaded_ammo, inv_slot = inv_slot, duty = duty, itemValue = itemCheck[2] }
		elseif itemCheck[1] == 116 then
			local gunDetails = exports.rl_global:explode(':', itemCheck[2])
			local ammo = tonumber(gunDetails[2])
			local id = tonumber(gunDetails[1])
			if not ammopacks[player][id] and ammo > 0 then
				ammopacks[player][id] = { ammo = ammo, inv_slot = inv_slot, id = id, itemValue = itemCheck[2] }
			end
		end
	end
end

function updateLocalGuns(player, delay)
	player = player or source
	if not player or not getElementData(player, "logged") then
		return
	end
	refreshWeaponsAndAmmoTables(player)

	local given = {}
	for slot, weap in pairs(weapons[player]) do
		for dbid, w in pairs(weap) do
			if weapons[player][slot][dbid] then
				if weapon_infinite_ammo[weapons[player][slot][dbid].id] then
					weapons[player][slot][dbid].loaded_ammo = 9998
				end
				weapons[player][slot][dbid].loaded_ammo = weapons[player][slot][dbid].loaded_ammo or 0
				given[slot] = dbid
				break
			end
		end
	end
	
	if delay and tonumber(delay) then
		setTimer(triggerClientEvent, delay, 1, player, 'weapon:updateUsingGun', resourceRoot, given)
	else
		triggerClientEvent(player, 'weapon:updateUsingGun', resourceRoot, given)
	end
end
addEvent("updateLocalGuns", true)
addEventHandler("updateLocalGuns", root, updateLocalGuns)

addEventHandler('onResourceStart', resourceRoot, function()
	for _, player in pairs(exports.rl_pool:getPoolElementsByType('player')) do
		updateLocalGuns(player, 3000)
	end
end)

addEvent("weapon:switch_weapon_in_same_slot", true)
addEventHandler("weapon:switch_weapon_in_same_slot", root, function (dbid, slot)
	local done
	refreshWeaponsAndAmmoTables(source)
	local weap = getPlayerWeaponFromDbid(source, dbid)
	if weap then
		local loaded_ammo = weapons[source][weap.slot][dbid].loaded_ammo or 0
		giveWeapon(source, weap.id, loaded_ammo + 1, false)
		done = { slot = weap.slot, dbid = dbid }
	end
	triggerClientEvent(source, 'weapon:weaponSwitch_callback', source, done)
end)

function syncAmmo(queue)
	for dbid_, ammo in pairs(queue) do
		local weap = getPlayerWeaponFromDbid(client, dbid_)
		if weap then
			local slot = weap.slot
			if weapons[client][slot] then
				local dbid = weap.dbid
				if weapons[client][slot][dbid] then
					weapons[client][slot][dbid].loaded_ammo = ammo >= 0 and ammo or 0
					for inv_slot, item in ipairs(getItems(client)) do
						if item[1] == 115 and item[3] == dbid then
							local id = weap.id
							if weapon_ammoless[id] then
							else
							end
							break
						end
					end
				end
			end
		end
	end
end
addEvent("weapon:syncAmmo", true)
addEventHandler("weapon:syncAmmo", resourceRoot, syncAmmo)