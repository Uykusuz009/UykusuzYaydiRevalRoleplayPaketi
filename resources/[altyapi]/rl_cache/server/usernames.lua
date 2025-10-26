local mysql = exports.rl_mysql
local refreshCacheRate = 10
local usernameCache = {}
local searched = {}

function getUsername(clue)
	if not clue or string.len(clue) < 1 then
		return false
	end
	
	for _, username in pairs(usernameCache) do
		if username and string.lower(username) == string.lower(clue) then
			return username
		end
	end
	
	for _, player in pairs(exports.rl_pool:getPoolElementsByType("player")) do
		local username = getElementData(player, "account_username")
		if username and string.lower(username) == string.lower(clue) then
			usernameCache[getElementData(player, "account_id")] = username
			return username
		end
	end
	
	if not searched[clue] then
		dbQuery(function(qh)
			local result = dbPoll(qh, 0)
			if result and #result > 0 then
				local row = result[1]
				local username = row["username"]
				local id = tonumber(row["id"])
				if username then
					usernameCache[id] = username
					for _, player in pairs(getElementsByType("player")) do
						triggerClientEvent(player, "retrieveUsernameCacheFromServer", resourceRoot, username, clue)
					end
				end
			end
		end, mysql:getConnection(), "SELECT `username`, `id` FROM `accounts` WHERE `username` = ? LIMIT 1", clue)

		searched[clue] = true
		setTimer(function()
			searched[clue] = nil
		end, refreshCacheRate * 1000 * 60, 1)
	end
	return false
end

function checkUsernameExistance(clue)
	if not clue or string.len(clue) < 1 then
		return false, "Please enter account name."
	end
	local found = getUsername(clue)
	if found then
		return true, "Account name '" .. found .. "' is existed and valid!"
	else
		return false, "Account name '" .. clue .. "' does not exist."
	end
end

function requestUsernameCacheFromServer(clue)
	local found = getUsername(clue)
	triggerClientEvent(client, "retrieveUsernameCacheFromServer", source, found)
end
addEvent("requestUsernameCacheFromServer", true)
addEventHandler("requestUsernameCacheFromServer", root, requestUsernameCacheFromServer)

function getUsernameFromId(id)
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if usernameCache[id] then
		return usernameCache[id]
	end
	
	for _, player in pairs(exports.rl_pool:getPoolElementsByType("player")) do
		if id == getElementData(player, "account_id") then
			usernameCache[id] = getElementData(player, "account_username")
			return usernameCache[id]
		end
	end
	
	if searched[id] then
		return false
	end
	searched[id] = true

	dbQuery(function(qh)
		local result = dbPoll(qh, 0)
		if result and #result > 0 then
			local row = result[1]
			local username = row["username"]
			if username then
				usernameCache[id] = username
				for _, player in pairs(getElementsByType("player")) do
					triggerClientEvent(player, "retrieveUsernameCacheFromServer", resourceRoot, username, id)
				end
			end
		end
	end, mysql:getConnection(), "SELECT `username`, `id` FROM `accounts` WHERE `id` = ? LIMIT 1", id)

	setTimer(function()
		searched[id] = nil
	end, refreshCacheRate * 1000 * 60, 1)

	return false
end

local accountCache = {}
local accountCacheSearched = {}

function getAccountFromCharacterId(id)
	if id and tonumber(id) then
		id = tonumber(id)
	else
		return false
	end
	
	if accountCache[id] then
		return accountCache[id]
	end
	
	for _, player in pairs(getElementsByType("player")) do
		if getElementData(player, "dbid") == id then
			accountCache[id] = {id = getElementData(player, "account_id"), username = getElementData(player, "account_username")}
			return accountCache[id]
		end
	end

	if accountCacheSearched[id] then
		return false
	end
	accountCacheSearched[id] = true

	dbQuery(function(qh)
		local result = dbPoll(qh, 0)
		if result and #result > 0 then
			local row = result[1]
			local accountId = tonumber(row["id"])
			local username = row["username"]
			if accountId and username then
				accountCache[id] = {id = accountId, username = username}
				for _, player in pairs(getElementsByType("player")) do
					triggerClientEvent(player, "retrieveAccountCacheFromServer", resourceRoot, accountCache[id], id)
				end
			end
		end
	end, mysql:getConnection(), "SELECT a.id AS id, username FROM accounts a LEFT JOIN characters c ON a.id = c.account WHERE c.id = ? LIMIT 1", id)

	setTimer(function()
		accountCacheSearched[id] = nil
	end, refreshCacheRate * 1000 * 60, 1)

	return false
end