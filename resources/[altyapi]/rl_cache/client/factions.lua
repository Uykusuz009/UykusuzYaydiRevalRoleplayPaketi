local factionNameCache = {}
local searched = {}
local refreshCacheRate = 10

function getFactionNameFromId(id)
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if factionNameCache[id] then
		return factionNameCache[id]
	end
	
	local faction = exports.rl_faction.getTeamFromFactionID(id)
	if faction then
		factionNameCache[id] = getTeamName(faction)
		return factionNameCache[id]
	end
	
	if searched[id] then
		return false
	end
	searched[id] = true
	
	triggerServerEvent("requestFactionNameCacheFromServer", localPlayer, id)
	
	setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate * 1000 * 60, 1)

	return "Loading..."
end

function retrieveFactionNameCacheFromServer(factionName, id)
	if factionName and id then
		factionNameCache[id] = factionName
	end
end
addEvent("retrieveFactionNameCacheFromServer", true)
addEventHandler("retrieveFactionNameCacheFromServer", root, retrieveFactionNameCacheFromServer)