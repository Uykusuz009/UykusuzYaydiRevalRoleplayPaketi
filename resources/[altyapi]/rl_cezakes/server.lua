mysql = exports.rl_mysql

local smallRadius = 5

function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)	
	if getElementData(thePlayer, "logged") then		
		if getElementData(thePlayer, "faction") == 1 then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [ID/Karakter Adı] [Miktar] [Neden]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						amount = tonumber(amount)
						local reason = table.concat({...}, " ")
						
						local money = exports.rl_global:getMoney(targetPlayer)
						local bankmoney = getElementData(targetPlayer, "bank_money")
						
						local takeFromCash = math.min( money, amount )
						local takeFromBank = amount - takeFromCash
						exports.rl_global:takeMoney(targetPlayer, takeFromCash)
							
						local tax = exports.rl_global:getTaxAmount()
								
						exports.rl_global:giveMoney( theTeam, math.ceil((1-tax)*amount) )
						exports.rl_global:giveMoney( getTeamFromName("İstanbul Emniyet Müdürlüğü"), math.ceil(tax*amount) )
						
						outputChatBox(" " .. targetPlayerName .. " isimli oyuncudan " .. exports.rl_global:formatMoney(amount) .. " tl ceza kestin. Açıklama: " .. reason .. ".", thePlayer, 6, 143, 0)
						outputChatBox(" " .. getPlayerName(thePlayer) .. " isimli polis senden " .. exports.rl_global:formatMoney(amount) .. " tl para cezası kesti. Açıklama: " .. reason .. ".", targetPlayer, 247, 168, 9)
						if takeFromBank > 0 then
							outputChatBox("Üzerinizde yeterli para olmadığı için ödenilmeyen kalan tutar olan $" .. exports.rl_global:formatMoney(takeFromBank) .. " dolar banka hesabınızdan kesilmiştir.", targetPlayer)
						end
						exports.rl_logs:addLog("[PD/Ceza] " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a ticket. Amount: $".. exports.rl_global:formatMoney(amount).. " Reason: "..reason , 30)
					else
						outputChatBox(targetPlayerName .. " adlı kullanıcıya çok uzaktasın!", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("cezakes", ticketPlayer, false, false)