local mysql = exports.rl_mysql

local charCache = {}
local singleCharCache = {}
local cacheUsed = 0

local function secondArg(a, b)
	return b
end

local function makeName(a, b)
	local ax, ay = a:sub(1, a:find("_") - 1), a:sub(secondArg(a:find("_")) + 1)
	local bx, by = b:sub(1, b:find("_") - 1), b:sub(secondArg(b:find("_")) + 1)
	
	if ay == by then
		return ax .. " & " .. bx .. " " .. by
	else
		return a .. " & " .. b
	end
end

function stats()
	return cacheUsed
end

function getCharacterName(id, singleName)
	if not charCache[id] then
		id = tonumber(id)
		if not (id < 1) then
			dbQuery(function(qh)
				local result = dbPoll(qh, 0)
				if result and #result > 0 then
					local row = result[1]
					local name = row["name"]
					local gender = tonumber(row["gender"])
					local married = tonumber(row["married"])
					
					if name then
						singleCharCache[id] = name:gsub("_", " ")
						if married and married > 0 then
							dbQuery(function(marriedqh)
								local marriedResult = dbPoll(marriedqh, 0)
								if marriedResult and #marriedResult > 0 then
									local marriedRow = marriedResult[1]
									local name2 = marriedRow["name"]
									local gender2 = tonumber(marriedRow["gender"])
									singleCharCache[married] = name2:gsub("_", " ")
									if name2 ~= nil then
										if gender == gender2 then
											if name < name2 then
												name = makeName(name, name2)
											else
												name = makeName(name2, name)
											end
										elseif gender == 1 then
											name = makeName(name, name2)
										else
											name = makeName(name2, name)
										end
									end
									charCache[id] = name:gsub("_", " ")
									for _, player in pairs(getElementsByType("player")) do
										triggerClientEvent(player, "retrieveCharacterNameCacheFromServer", resourceRoot, charCache[id], id)
									end
								end
							end, mysql:getConnection(), "SELECT name, gender FROM characters WHERE id = ? LIMIT 1", married)
						else
							charCache[id] = name:gsub("_", " ")
							for _, player in pairs(getElementsByType("player")) do
								triggerClientEvent(player, "retrieveCharacterNameCacheFromServer", resourceRoot, charCache[id], id)
							end
						end
					end
				end
			end, mysql:getConnection(), "SELECT name, gender, married FROM characters WHERE id = ? LIMIT 1", id)
		else
			charCache[id] = false
			singleCharCache[id] = false
		end
	else
		cacheUsed = cacheUsed + 1
	end
	return singleName and singleCharCache[id] or charCache[id]
end

function requestCharacterNameCacheFromServer(id, singleName)
	local found = getCharacterName(id, singleName)
	if found then
		triggerClientEvent(client, "retrieveCharacterNameCacheFromServer", client, found, id)
	end
end
addEvent("requestCharacterNameCacheFromServer", true)
addEventHandler("requestCharacterNameCacheFromServer", root, requestCharacterNameCacheFromServer)

function clearCharacterName(id)
	charCache[id] = nil
	singleCharCache[id] = nil
end

function clearCharacterCache()
	charCache = {}
	singleCharCache = {}
end