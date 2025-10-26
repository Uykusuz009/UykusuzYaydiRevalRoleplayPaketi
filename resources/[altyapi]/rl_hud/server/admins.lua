local function sortTable(a, b)
	if b[2] < a[2] then
		return true
	end

	return false
end

function showStaff(thePlayer, commandName)
	if getElementData(thePlayer, "logged") then
		local info = {}
		
		local managers = {}
		local admins = {}
		
		for _, player in ipairs(getElementsByType("player")) do
			if exports.rl_integration:isPlayerManager(player) then
				managers[#managers + 1] = { player, getElementData(player, "admin_level") }
			end
		end
		table.sort(managers, sortTable)
		
		for _, player in ipairs(getElementsByType("player")) do
			if exports.rl_integration:isPlayerTrialAdmin(player) and not exports.rl_integration:isPlayerManager(player) then
				admins[#admins + 1] = { player, getElementData(player, "admin_level") }
			end
		end
		table.sort(admins, sortTable)
		
		table.insert(info, {"yönetim takımı", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})
		
		if #managers > 0 then
			for _, value in ipairs(managers) do
				local player = value[1]
				if (not getElementData(player, "hidden_admin")) or (exports.rl_integration:isPlayerLeaderAdmin(thePlayer)) or (player == thePlayer) then
					if (getElementData(player, "duty_admin")) then
						table.insert(info, {exports.rl_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account_username") .. ")", 87, 255, 111, 200, 1, "default"})
					else
						table.insert(info, {exports.rl_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account_username") .. ")", 88, 88, 88, 200, 1, "default"})
					end
				end
			end
		else
			table.insert(info, {"Aktif yönetim yok.", 88, 88, 88, 200, 1, "default"})
		end
		
		table.insert(info, {""})
		table.insert(info, {"yetkili takımı", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})
		
		if #admins > 0 then
			for _, value in ipairs(admins) do
				local player = value[1]
				if (not getElementData(player, "hidden_admin")) or (exports.rl_integration:isPlayerLeaderAdmin(thePlayer)) or (player == thePlayer) then
					if (getElementData(player, "duty_admin")) then
						table.insert(info, {exports.rl_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account_username") .. ")", 87, 255, 111, 200, 1, "default"})
					else
						table.insert(info, {exports.rl_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account_username") .. ")", 88, 88, 88, 200, 1, "default"})
					end
				end
			end
		else
			table.insert(info, {"Aktif yetkili yok.", 88, 88, 88, 200, 1, "default"})
		end
		
		table.insert(info, {""})

		exports.rl_hud:sendTopRightNotification(thePlayer, info, 350)
	end
end
addCommandHandler("admin", showStaff, false, false)
addCommandHandler("admins", showStaff, false, false)