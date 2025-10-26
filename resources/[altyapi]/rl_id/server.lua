local ids = {}

addEventHandler("onPlayerJoin", root, function()
	local _index
	for index = 1, 5000 do
		if (not ids[index]) then
			_index = index
			break
		end
	end
	
	ids[_index] = source
	setElementData(source, "id", _index)
	exports.rl_pool:allocateElement(source, _index)
	setElementData(source, "legal_name_change", true)
	setPlayerName(source, "rl." .. getElementData(source, "id"))
	setElementData(source, "legal_name_change", false)
	exports.rl_logs:addLog("joinquit", getPlayerName(source):gsub("_", " ") .. " sunucuya katıldı.\nIP: " .. getPlayerIP(source) .. "\nSerial: " .. getPlayerSerial(source))
end)

addEventHandler("onPlayerQuit", root, function(reason)
	local slot = getElementData(source, "id")
	if (slot) then
		ids[slot] = nil
	end
	
	exports.rl_logs:addLog("joinquit", getPlayerName(source):gsub("_", " ") .. " sunucudan ayrıldı. (" .. reason .. ")\nIP: " .. getPlayerIP(source) .. "\nSerial: " .. getPlayerSerial(source))
	
	if exports.rl_integration:isPlayerTrialAdmin(source) then
		local temporaryHoursPlayed = getElementData(source, "temporary_hours_played") or 0
		local temporaryMinutesPlayed = getElementData(source, "temporary_minutes_played") or 0
		exports.rl_discord:sendMessage("yetkili-aktiflik", exports.rl_global:getPlayerFullAdminTitle(source) .. " isimli yetkili sunucudan ayrıldı ve " .. temporaryHoursPlayed .. " saat " .. temporaryMinutesPlayed .. " dakikadır sunucudaydı.")
	end
end)

for index, player in ipairs(getElementsByType("player")) do
	ids[index] = player
	setElementData(player, "id", index)
	exports.rl_pool:allocateElement(player, index)
end