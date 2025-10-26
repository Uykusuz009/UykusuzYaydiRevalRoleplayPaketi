function isPlayerInFaction(thePlayer, factionID, rank)
	if not thePlayer or not factionID then return false end
	factionID = tonumber(factionID) or -1
	local myFaction = tonumber(getElementData(thePlayer, "faction")) or 0
	if factionID == myFaction then
		local myRank = tonumber(getElementData(thePlayer, "factionrank")) or 0
		local amLeader = tonumber(getElementData(thePlayer, "factionleader")) or 0
		local isLeader = false
		if amLeader == 1 then
			isLeader = true
		end
		if rank then
			rank = tonumber(rank) or -1
			if rank == myRank then
				return true, myRank, isLeader
			end
		else
			return true, myRank, isLeader
		end
	end
	return false, false, false
end

function canAccessFactionManager(thePlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		return true
	end
	return false
end

function getPlayerFactionRank(thePlayer, factionID)
	if not thePlayer or not factionID then return false end
	factionID = tonumber(factionID) or -1
	local myFaction = tonumber(getElementData(thePlayer, "faction")) or 0
	if factionID == myFaction then
		local myRank = tonumber(getElementData(thePlayer, "factionrank")) or 0
		return myRank
	end
	return false
end

function isPlayerFactionLeader(thePlayer, factionID)
	if not thePlayer or not factionID then return false end
	factionID = tonumber(factionID) or -1
	local myFaction = tonumber(getElementData(thePlayer, "faction")) or 0
	if factionID == myFaction then
		local amLeader = tonumber(getElementData(thePlayer, "factionleader")) or 0
		local isLeader = false
		if amLeader == 1 then
			isLeader = true
		end
		return isLeader
	end
	return false
end

function getFactionName(factionID)
	local theTeam = getFactionFromID(factionID)
	if theTeam then
		local name = getTeamName(theTeam)
		if name then
			name = tostring(name)
			return name
		end
	end
	return false
end

function getFactionFromID(factionID)
	if not tonumber(factionID) then
		return false
	end
	if triggerServerEvent then
		for i, team in pairs(getElementsByType("team")) do
			if getElementData(team, "id") == tonumber(factionID) then
				return team
			end
		end
	else
		return exports.rl_pool:getElement("team", tonumber(factionID))
	end
end
