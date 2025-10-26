function modifyPlayerItemValues(player, dbid, values, skin_update_localguns)
	local weap, inv_slot = getPlayerWeaponFromDbid(player, dbid, true)
	if weap then
		local finale = nil
		for i, v in pairs(values) do
			finale = modifyWeaponValue(weap[2], i, v)
		end
		if finale then
			local result = exports["rl_items"]:updateItemValue(player, inv_slot, finale)
			if not skin_update_localguns then
				updateLocalGuns(player)
			end
			return result
		end
	end
end

function removeSatchel(targetPlayer, weapon)
	for inv_slot, item in ipairs(exports["rl_items"]:getItems(targetPlayer)) do
		if item[1] == 115 then
			local gunDetails = exports.rl_global:explode(':', item[2])
			if gunDetails[3] == "Satchel" then
				exports["rl_items"]:takeItem(targetPlayer, 115, item[2])
			end
		end
	end
end
addEvent("weapon:removeSatchel", true)
addEventHandler("weapon:removeSatchel", root, removeSatchel)