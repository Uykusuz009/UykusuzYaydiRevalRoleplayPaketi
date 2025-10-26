function getInteriorsOwnedByCharacter(thePlayer)
	if thePlayer and isElement(thePlayer) then
		local dbid = tonumber(getElementData(thePlayer, "dbid"))
		local interiors = {}

		for key, value in ipairs(getElementsByType("interior")) do
			local owner = tonumber(getElementData(value, "status")[4])
			if (owner) and (owner == dbid) then
				local id = getElementData(value, "dbid")
				interiors[#interiors + 1] = id
			end
		end
		return #interiors, interiors
	end
	return false
end

function canPlayerBuyInterior(thePlayer)
	if thePlayer and isElement(thePlayer) then
		if getElementData(thePlayer, "logged") then
			local maxInteriors = getElementData(thePlayer, "max_interiors") or 0
			local noInteriors, intArray = getInteriorsOwnedByCharacter(thePlayer)
			if (noInteriors < maxInteriors) then
				return true
			end
			return false, "Too much interiors" 
			
		end
		return false, "Player not logged in"
	end
	return false, "Element not found"
end

function getInteriorsOwnByFaction(theFaction)
	local interiors = {}
	local factionId = getElementData(theFaction, "id")
	local possibleInteriors = exports.rl_pool:getPoolElementsByType("interior")
	for key, interior in pairs(possibleInteriors) do
		if getElementData(interior, "status")[7] == factionId then
			table.insert(interiors, interior)
		end
	end
	return interiors
end

function canPlayerFactionBuyInterior(thePlayer, cost)
	local factionId = getElementData(thePlayer, "faction")
	local theFaction = exports.rl_pool:getElement("team", factionId)

	local can, reason = canFactionBuyInterior(theFaction, cost)
	if not can then
		return can, reason
	end

	local hasSpace = hasSpaceForItem(thePlayer, 4 or 5, 1)
	if not hasSpace then
		return false, "You do not have the space for the keys"
	end
	return theFaction
end

function canFactionBuyInterior(theFaction, cost)
	if not theFaction then
		return false, "Faction not found"
	end

	local maxInteriors = getElementData(theFaction, "max_interiors") or 15
	local cur = #getInteriorsOwnByFaction(theFaction)
	
	if cur >= maxInteriors then
		return false, getTeamName(theFaction) .. " has already reached the maximum number of interiors (" .. cur .. "/" .. maxInteriors .. ")"
	end

	if cost and tonumber(cost) then
		local hasMoney = hasMoney(theFaction, cost)
		if not hasMoney then
			return hasMoney, getTeamName(theFaction) .. " lacks of money to buy this property."
		end
	end
	return theFaction
end