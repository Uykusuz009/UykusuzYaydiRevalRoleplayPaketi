function addNotification(accountId, notificationType, notificationMessage)
    dbExec(exports.rl_mysql:getConnection(), "INSERT INTO notifications (account_id, notification_type, notification_message) VALUES (?, ?, ?)", accountId, notificationType, notificationMessage)
end

addEventHandler("onResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "account_logged") then
			dbQuery(function(queryHandle)
				local result = dbPoll(queryHandle, 0)
				if result and #result > 0 then
					triggerClientEvent(player, "notifications.loadDatas", player, result)
				end
			end, exports.rl_mysql:getConnection(), "SELECT * FROM notifications WHERE account_id = ? ORDER BY created_at DESC", getElementData(player, "account_id"))
		end
	end
end)

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if getElementType(source) == "player" and theKey == "account_logged" then
		dbQuery(function(queryHandle, source)
			local result = dbPoll(queryHandle, 0)
			if result and #result > 0 then
				triggerClientEvent(source, "notifications.loadDatas", source, result)
			end
		end, {source}, exports.rl_mysql:getConnection(), "SELECT * FROM notifications WHERE account_id = ? ORDER BY created_at DESC", getElementData(source, "account_id"))
	end
end)