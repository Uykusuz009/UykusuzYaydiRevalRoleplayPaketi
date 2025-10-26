mysql = exports.rl_mysql
function cumartesiBonus()
    for _, player in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 then
			local paraBonusu = 10000
			--local expBonusu = 4
			--local exp = getElementData(player, "exp") or 0
			--local exprange = getElementData(player, "exprange") or 8
			--local level = getElementData(player, "level") or 1
			exports.rl_global:giveMoney(player, paraBonusu)
			--mysql:query_free("UPDATE characters SET exp = "..tonumber(exp+expBonusu).." WHERE id = " .. mysql:escape_string(getElementData( player, "dbid" )) )
			--setElementData(player, "exp", exp+expBonusu)
			outputChatBox("[!] #FFFFFFReval Roleplay tarafından, ".. paraBonusu .." ₺ para bonusu aldınız!", player, 0, 255, 0, true)
		end
    end
end
--setTimer(cumartesiBonus, 10000, 0)
addCommandHandler("paradagit",
	function (thePlayer)
		if getElementData(thePlayer, "account:username") == "y7celhan" or getElementData(thePlayer, "account:username") == "LargeS" or getElementData(thePlayer, "account:username") == "LargeS" then
			cumartesiBonus()
			--outputChatBox("#cc0000[!] #FFFFFF"..getPlayerName(thePlayer), thePlayer, 0, 255, 0, true)
		else
			outputChatBox("#cc0000[!] #FFFFFFBu komutu kullanmaya yetkiniz yok.", thePlayer, 0, 255, 0, true)
		end
	end
)