function uyari(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.rl_integration:isPlayerAdminIII(thePlayer))  then
		if not (...) then
			outputChatBox("[!]#FFFFFFKullanım: /" .. commandName .. " [Yazı]", thePlayer, 0, 0, 255, true)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.rl_pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
			local account = getPlayerAccount(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local dude = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")

				if(exports.rl_integration:isPlayerTrialAdmin(arrayPlayer)) or exports.rl_integration:isPlayerSupporter(arrayPlayer) and (logged==1) then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox(" ", arrayPlayer)
					outputChatBox("[ÖNEMLİ] " .. username:gsub("_", " ") .. " (" .. dude .. "): " .. message, arrayPlayer, 255, 0, 0)
					outputChatBox(" ", arrayPlayer)
					triggerClientEvent(thePlayer,"cagri",thePlayer)
					triggerClientEvent(arrayPlayer,"cagri",arrayPlayer)
				end
			end
			--exports.rl_logs:dbLog(thePlayer, 3, affectedElements, message)
		end
	end
end
addCommandHandler("wrn", uyari, false, false)

function gelistirici(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and getElementData(thePlayer, "account:username") == "LargeS" or getElementData(thePlayer, "account:username") == "y7celhan" or getElementData(thePlayer, "account:username") == "" then
		if not (...) then
			outputChatBox("[!]#FFFFFFKullanım: /" .. commandName .. " [Yazı]", thePlayer, 0, 0, 255, true)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.rl_pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
			local account = getPlayerAccount(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local dude = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")

				if getElementData(arrayPlayer, "account:username") == "LargeS" or getElementData(arrayPlayer, "account:username") == "y7celhan" or getElementData(arrayPlayer, "account:username") == "" and (logged==1) then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("#e4c000[SCRIPTER] " .. username:gsub("_", " ") .. " (" .. dude .. "): " .. message, arrayPlayer, 96, 125, 139, true)
				end
			end
			--exports.rl_logs:dbLog(thePlayer, 3, affectedElements, message)
		end
	end
end
addCommandHandler("sc", gelistirici, false, false)
