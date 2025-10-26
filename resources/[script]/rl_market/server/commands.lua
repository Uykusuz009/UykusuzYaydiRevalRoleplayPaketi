function bakiyeVer(thePlayer, commandName, targetPlayer, amount)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer and amount and tonumber(amount) and tonumber(amount) > 0 then
			amount = math.floor(tonumber(amount))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					giveBalance(targetPlayer, amount)
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya " .. exports.rl_global:formatMoney(amount) .. " TL bakiye verildi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size " .. exports.rl_global:formatMoney(amount) .. " TL bakiye verdi.", targetPlayer, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya " .. exports.rl_global:formatMoney(amount) .. " TL bakiye verdi.")
					exports.rl_logs:addLog("bakiyever", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya " .. exports.rl_global:formatMoney(amount) .. " TL bakiye verdi.")
					local time = getRealTime()
					local timestamp = string.format("%04d-%02d-%02d %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
					-- dbExec(exports.rl_mysql:getConnection(), "INSERT INTO bakiyelog (id, created_on, amount, payment_platform) VALUES (?, ?, ?)", ,, , )
					dbExec(exports.rl_mysql:getConnection(),  "INSERT INTO `bakiyelog` SET `id` = '"..getElementData(targetPlayer,"account_id").."', `created_on` = '"..timestamp.."', `amount` = '"..amount.."', `payment_platform` = '".."/bakiyever".."'")

				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("bakiyever", bakiyeVer, false, false)

function bakiyeAl(thePlayer, commandName, targetPlayer, amount)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer and amount and tonumber(amount) and tonumber(amount) > 0 then
			amount = math.floor(tonumber(amount))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					takeBalance(targetPlayer, amount)
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncudan " .. exports.rl_global:formatMoney(amount) .. " TL bakiye alındı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden " .. exports.rl_global:formatMoney(amount) .. " TL bakiye aldı.", targetPlayer, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncudan " .. exports.rl_global:formatMoney(amount) .. " TL bakiye aldı.")
					exports.rl_logs:addLog("bakiyeal", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncudan " .. exports.rl_global:formatMoney(amount) .. " TL bakiye aldı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("bakiyeal", bakiyeAl, false, false)

function setBakiye(thePlayer, commandName, targetPlayer, amount)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer and amount and tonumber(amount) and tonumber(amount) >= 0 then
			amount = math.floor(tonumber(amount))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					setBalance(targetPlayer, amount)
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun bakiyesini " .. exports.rl_global:formatMoney(amount) .. " TL olarak değiştirildi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili bakiyesini " .. exports.rl_global:formatMoney(amount) .. " TL olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun bakiyesini " .. exports.rl_global:formatMoney(amount) .. " TL olarak değiştirdi.")
					exports.rl_logs:addLog("setbakiye", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun bakiyesini " .. exports.rl_global:formatMoney(amount) .. " TL olarak değiştirdi.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setbakiye", setBakiye, false, false)

function bakiyeTransfer(thePlayer, commandName, targetPlayer, amount)
	if targetPlayer and amount and tonumber(amount) and tonumber(amount) > 0 then
		amount = math.floor(tonumber(amount))
		if getElementData(thePlayer, "balance") >= amount then
			if amount > 0 then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if thePlayer ~= targetPlayer then
						if getElementData(targetPlayer, "logged") then
							takeBalance(thePlayer, amount)
							giveBalance(targetPlayer, amount)
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya " .. exports.rl_global:formatMoney(amount) .. " TL bakiyenizi transfer ettiniz.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu size " .. exports.rl_global:formatMoney(amount) .. " TL bakiyesini transfer etti.", targetPlayer, 0, 0, 255, true)
							exports.rl_global:sendMessageToAdmins("[BAKİYE-TRANSFER] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. targetPlayerName .. " isimli oyuncuya " .. exports.rl_global:formatMoney(amount) .. " TL bakiyesini transfer etdi.")
							exports.rl_logs:addLog("bakiyetransfer", getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. targetPlayerName .. " isimli oyuncuya " .. exports.rl_global:formatMoney(amount) .. " TL bakiyesini transfer etdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Kendinize bakiye transfer edemezsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Minimum 1 TL bakiye transfer edebilirsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Yeterli bakiyeniz yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("bakiyetransfer", bakiyeTransfer, false, false)



function bakiyedagit(thePlayer, commandName, amount)
   if getElementData(thePlayer, "account_username") == "hakocxn" then
		if amount and tonumber(amount) and tonumber(amount) > 0 then
			amount = math.floor(amount)
			if amount <= 1000 then
				for _, player in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
					if getElementData(player, "logged") then
						
						local time = getRealTime()

						local timestamp = string.format("%04d-%02d-%02d %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)

						giveBalance(player, amount)
						exports.rl_infobox:addBox(player, "success", "Reval Roleplay'den herkese " .. exports.rl_global:formatMoney(amount) .. "TL bakiye hediye!")
						dbExec(exports.rl_mysql:getConnection(),  "INSERT INTO `bakiyelog` SET `id` = '"..getElementData(player,"account_id").."', `created_on` = '"..timestamp.."', `amount` = '"..amount.."', `payment_platform` = '".."/bakiyedagit".."'")
					end
				end
				exports.rl_logs:addLog("paradagit", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. exports.rl_global:formatMoney(amount) .. "TL bakiye dağıttı.")
			else
				outputChatBox("[!]#FFFFFF Güvenlik sebebiyle en fazla 1000 TL dağıtabilirsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Miktar]", thePlayer, 255, 194, 14)
		end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("bakiyedagit", bakiyedagit, false, false)