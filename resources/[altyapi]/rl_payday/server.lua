Async:setPriority("low")

local mysql = exports.rl_mysql
local chars = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local codes = split(chars, ",")
local controlSystem = {}

local colSphere = createColSphere(1292.623046875, -2352.373046875, 13.153707504272, 5)

local levels = {
	-- [level] = {gerekenMin, gerekenMax}
	[1] = {0, 7},
	[2] = {8, 19},
	[3] = {20, 35},
	[4] = {36, 55},
	[5] = {56, 79},
	[6] = {80, 107},
	[7] = {108, 139},
	[8] = {140, 175},
	[9] = {176, 215},
	[10] = {216, 259},
	[11] = {260, 307},
	[12] = {308, 359},
	[13] = {360, 415},
	[14] = {416, 475},
	[15] = {476, 539},
	[16] = {540, 607},
	[17] = {608, 679},
	[18] = {680, 755},
	[19] = {756, 835},
	[20] = {836, 919},
	[21] = {920, 980},
	[22] = {981, 1060},
	[23] = {1061, 1120},
	[24] = {1121, 1180},
	[25] = {1181, 1240},
	[26] = {1241, 1300},
	[27] = {1301, 1350},
	[28] = {1351, 1420},
	[29] = {1421, 1500},
	[30] = {1501, 1600},
	[31] = {1601, 1680},
	[32] = {1681, 1750},
	[33] = {1751, 1850},
	[34] = {1851, 1900},
	[35] = {1901, 2000},
	[36] = {2001, 2100},
	[37] = {2101, 2200},
	[38] = {2201, 2300},
	[39] = {2301, 2400},
	[40] = {2401, 2500},
	[41] = {2600, 2799},
	[42] = {2800, 2899},
	[43] = {2900, 2999},
	[44] = {3000, 3199},
	[45] = {3200, 3299},
	[46] = {3300, 3399},
	[47] = {3400, 3499},
	[48] = {3500, 3600},
	[49] = {3700, 3800},
	[50] = {3800, 4000}
}

function hourlyBox()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "logged") then
			local minutesPlayed = getElementData(player, "minutes_played") or 0
			local temporaryMinutesPlayed = getElementData(player, "temporary_minutes_played") or 0
			
			setElementData(player, "minutes_played", minutesPlayed + 1)
			setElementData(player, "temporary_minutes_played", temporaryMinutesPlayed + 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET minutes_played = ? WHERE id = ?", getElementData(player, "minutes_played"), getElementData(player, "dbid"))
			
			if minutesPlayed >= 60 then
				controlSystem[player] = {}
				controlSystem[player].code = codes[math.random(#codes)] .. codes[math.random(#codes)] .. codes[math.random(#codes)] .. codes[math.random(#codes)]
				
				if exports.rl_settings:getPlayerSetting(player, "play_hourly_bonus_sound") then
					triggerClientEvent(player, "payday.playSound", player)
				end
				
				local boxHours = getElementData(player, "box_hours") or 0
				local hoursPlayed = getElementData(player, "hours_played") or 0
				local temporaryHoursPlayed = getElementData(player, "temporary_hours_played") or 0
				
				setElementData(player, "box_hours", boxHours + 1)
				setElementData(player, "minutes_played", 0)
				setElementData(player, "temporary_minutes_played", 0)
				setElementData(player, "hours_played", hoursPlayed + 1)
				setElementData(player, "temporary_hours_played", temporaryHoursPlayed + 1)
				
				dbExec(mysql:getConnection(), "UPDATE characters SET box_hours = ?, minutes_played = 0, hours_played = ? WHERE id = ?", getElementData(player, "box_hours"), getElementData(player, "hours_played"), getElementData(player, "dbid"))
				
				if getElementData(player, "box_hours") >= 4 then
					local boxCount = getElementData(player, "box_count") or 0
					local level = getPlayerLevel(player) or 1
					
					setElementData(player, "box_hours", 0)
					setElementData(player, "box_count", boxCount + 1)
					setElementData(player, "level", level)
					dbExec(mysql:getConnection(), "UPDATE characters SET box_hours = 0, box_count = ?, level = ? WHERE id = ?", getElementData(player, "box_count"), level, getElementData(player, "dbid"))
					
					outputChatBox("[!]#FFFFFF 4 saat oynadınız ve bir kutu kazandınız.", player, 0, 255, 0, true)
				end
				
				outputChatBox("[!]#FFFFFF Saatlik bonusunuzu 2 dakika içinde [/bonus " .. controlSystem[player].code .. "] yazarak onaylayabilirsiniz.", player, 0, 0, 255, true)

				if player and isElement(player) and controlSystem[player] then
					controlSystem[player].endTimer = setTimer(function(player)
						if isElement(player) then
							if controlSystem[player] then
								outputChatBox("[!]#FFFFFF Onay kodunu girmediğiniz için saatlik bonus almadınız.", player, 255, 0, 0, true)
								playSoundFrontEnd(player, 4)
								controlSystem[player] = nil
							end
						end
					end, 60 * 2000, 1, player)
				end
			end
		end
	end
end
setTimer(hourlyBox, 60 * 1000, 0)

function bonusCommand(thePlayer, commandName, code)
	if code then 
		if controlSystem[thePlayer] then
			if tostring(controlSystem[thePlayer].code) == tostring(code) then
				controlSystem[thePlayer] = nil
				local bankMoney = getElementData(thePlayer, "bank_money") or 0
				
				if getElementData(thePlayer, "vip") == 1 then
					setElementData(thePlayer, "bank_money", bankMoney + 300)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [1] olduğunuz için saatlik bonus olarak $300 kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 2 then
					setElementData(thePlayer, "bank_money", bankMoney + 400)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [2] olduğunuz için saatlik bonus olarak $400 kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 3 then
					setElementData(thePlayer, "bank_money", bankMoney + 500)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [3] olduğunuz için saatlik bonus olarak $500 kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 4 then
					setElementData(thePlayer, "bank_money", bankMoney + 600)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [4] olduğunuz için saatlik bonus olarak $600 kazandınız.", thePlayer, 0, 255, 0, true)
				else
					setElementData(thePlayer, "bank_money", bankMoney + 200)
					outputChatBox("[!]#FFFFFF Tebrikler, saatlik bonus olarak $200 kazandınız.", thePlayer, 0, 255, 0, true)
				end
				
				triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
				dbExec(mysql:getConnection(), "UPDATE characters SET bank_money = ? WHERE id = ?", getElementData(thePlayer, "bank_money"), getElementData(thePlayer, "dbid"))
			else
				outputChatBox("[!]#FFFFFF Hatalı veya eksik kod girdiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end
end
addCommandHandler("bonus", bonusCommand, false, false)

function boxRemaining(source, commandName)
	local minutesPlayed = getElementData(source, "minutes_played") or 0
	local boxHours = getElementData(source, "box_hours") or 0
	local boxCount = getElementData(source, "box_count") or 0
	
	outputChatBox("[!]#FFFFFF Başka bir kutu kazanana kadar kalan süre: " .. (3 - boxHours) .. " saat " .. (60 - minutesPlayed) .. " dakika", source, 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Kutu Süre: " .. boxHours .. "/4 (Tamamladıktan sonra +1 kutu alacaksınız.)", source, 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Kutu Sayısı: " .. boxCount .. " kutunuz var.", source, 0, 255, 0, true)
end
addCommandHandler("kutukalan", boxRemaining, false, false)

function openBox(source, commandName)
	if isElementWithinColShape(source, colSphere) then
		local boxCount = getElementData(source, "box_count") or 0
		if boxCount > 0 then
			local randomMoney = math.random(10000, 100000)
			exports.rl_global:giveMoney(source, randomMoney)
			outputChatBox("[!]#FFFFFF Tebrikler, hediye ağacından $" .. exports.rl_global:formatMoney(randomMoney) .. " kazandınız.", source, 0, 255, 0, true)
			
			setElementData(source, "box_count", boxCount - 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET box_count = ? WHERE id = ?", getElementData(source, "box_count"), getElementData(source, "dbid"))
		else
			outputChatBox("[!]#FFFFFF Hediye kutunuz yok.", source, 255, 0, 0, true)
			playSoundFrontEnd(source, 4)
		end
	end
end
addCommandHandler("hediyeal", openBox, false, false)

function getPlayerLevel(thePlayer)
	if getElementData(thePlayer, "logged") then
		local hoursPlayed = getElementData(thePlayer, "hours_played")
		for index, value in pairs(levels) do
			local minimum, maximum = unpack(value)
			if hoursPlayed >= minimum and hoursPlayed <= maximum then
				return index
			end	
		end
	end
	return false
end

function giveHourCommand(admin, commandName, targetId, hourAmount)
	if not tonumber(targetId) or not tonumber(hourAmount) then
		outputChatBox("[!]#FFFFFF Kullanım: /saatver [id] [verilecek_saat]", admin, 255, 0, 0, true)
		return
	end

	local adminLevel = getElementData(admin, "admin_level") or 0
	if adminLevel < 9 then
		outputChatBox("[!]#FFFFFF Bu komutu kullanmak için yetkiniz yok.", admin, 255, 0, 0, true)
		return
	end

	local targetPlayer = nil
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "id") == tonumber(targetId) then
			targetPlayer = player
			break
		end
	end

	if not targetPlayer then
		outputChatBox("[!]#FFFFFF Belirtilen ID'ye sahip oyuncu bulunamadı.", admin, 255, 0, 0, true)
		return
	end

	local hoursPlayed = getElementData(targetPlayer, "hours_played") or 0
	local newHours = hoursPlayed + tonumber(hourAmount)
	setElementData(targetPlayer, "hours_played", newHours)
	dbExec(mysql:getConnection(), "UPDATE characters SET hours_played = ? WHERE id = ?", newHours, getElementData(targetPlayer, "dbid"))

	outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer) .. " adlı oyuncuya " .. hourAmount .. " saat eklendi. Yeni saat: " .. newHours, admin, 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Yetkili tarafından hesabina " .. hourAmount .. " saat eklendi. Yeni saat: " .. newHours, targetPlayer, 0, 255, 0, true)
end
addCommandHandler("saatver", giveHourCommand, false, false)