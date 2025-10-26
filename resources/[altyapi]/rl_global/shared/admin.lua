function getLoggedInPlayers()
    local players = localPlayer and getElementsByType("player") or exports.rl_pool:getPoolElementsByType("player")

    local loggedInPlayers = {}

    for key, value in ipairs(players) do
        if value:getData("logged") then
            table.insert(loggedInPlayers, value)
        end
    end
    return loggedInPlayers
end

function getAdmins()
    local players = localPlayer and getElementsByType("player") or exports.rl_pool:getPoolElementsByType("player")

    local admins = {}

    for key, value in ipairs(players) do
        if value:getData("logged") and exports.rl_integration:isPlayerTrialAdmin(value) then
            table.insert(admins, value)
        end
    end
    return admins
end

function getAdminTitles()
	return exports.rl_integration:getAdminTitles()
end

function getAdminLevelTitle(number)
    if number and tonumber(number) then
	    return adminTitles[number] or "Oyuncu"
    end
end

function getPlayerAdminLevel(thePlayer)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
	    return getElementData(thePlayer, "admin_level") or 0
    end
end

function getPlayerAdminTitle(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		local adminTitle = getAdminTitles()
		local text = adminTitle[getPlayerAdminLevel(thePlayer)] or "Oyuncu"
		
		local hiddenAdmin = getElementData(thePlayer, "hidden_admin") or false
		if hiddenAdmin then
			text = text .. " (Gizli)"
		end
		
		return text
	end
end

function getPlayerFullAdminTitle(thePlayer)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
	    local text = (getPlayerAdminTitle(thePlayer) .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. getElementData(thePlayer, "account_username") .. ")")
		
		local hiddenAdmin = getElementData(thePlayer, "hidden_admin") or false
		if hiddenAdmin then
			text = "Gizli Yetkili [>" .. (getElementData(thePlayer, "dbid")) .. "]"
		end
		
		return text
    end
end

function isAdminOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.rl_integration:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "duty_admin"))
	end
	return false
end