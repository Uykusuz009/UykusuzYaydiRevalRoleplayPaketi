function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "logged") then
				thePlayer = targetPlayer
			else
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", showPlayer, 255, 0, 0, true)
                playSoundFrontEnd(showPlayer, 4)
				return
			end
		else
			return
		end
	end
	
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	local carids = ""
	local numcars = 0
	local printCar = ""
	for key, value in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))
		if (owner) and (owner == dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
			setElementData(value, "owner_last_login", exports.rl_datetime:now(), true)
		end
	end
	printCar = numcars .. "/" .. getElementData(thePlayer, "max_vehicles")

	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		
		if interiorStatus[4] and interiorStatus[4] == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			setElementData(value, "owner_last_login", exports.rl_datetime:now(), true)
		end
	end

	if (properties == "") then
		properties = "Yok  "
	end
	
	if (carids == "") then
		carids = "Yok  "
	end
	
	local hoursPlayed = getElementData(thePlayer, "hours_played")
	local minutesPlayed = getElementData(thePlayer, "minutes_played") or 0
	minutesPlayed2 = 60 - minutesPlayed
	local info = {}
	info = {
		{"karakter bilgileri"},
		{""},
		{"Araçlar (" .. printCar .. "):\n" .. string.sub(carids, 1, string.len(carids)-2)},
		{""},
		{""},
		{"Mülkler (" .. numproperties .. "/" .. (getElementData(thePlayer, "max_interiors") or 10) .. "):\n" .. string.sub(properties, 1, string.len(properties) - 2)},
		{""},
		{""},
		{"Bu karakterinizde " .. hoursPlayed .. " saat " .. minutesPlayed .. " dakika geçirdiniz."}
	}

	table.insert(info, {""})
	
	local money = getElementData(thePlayer, "money") or 0
	local bankMoney = getElementData(thePlayer, "bank_money") or 0
	local balance = getElementData(thePlayer, "balance") or 0
	
	table.insert(info, {"Cüzdan: $" .. exports.rl_global:formatMoney(money)})
	table.insert(info, {"Banka: $" .. exports.rl_global:formatMoney(bankMoney)})
	table.insert(info, {"Bakiye: " .. exports.rl_global:formatMoney(balance) .. " TL"})
	table.insert(info, {""})
	table.insert(info, {"Taşınan Ağırlık: " .. ("%.2f/%.2f"):format(exports.rl_items:getCarriedWeight(thePlayer), exports.rl_items:getMaxWeight(thePlayer)) .. " kg"})
	
	local charID = getElementData(thePlayer, "dbid")
	if exports.rl_vip:isPlayerVIP(charID) then
		local vip = getElementData(thePlayer, "vip") or 0
		local remainingInfo = exports.rl_vip:getVIPExpireTime(charID) or ""
		
		table.insert(info, {""})
		table.insert(info, {"VIP Seviyeniz: " .. vip})
		table.insert(info, {"Kalan Süre: " .. remainingInfo})
	end
	
	table.insert(info, {""})
	
	triggerClientEvent(showPlayer, "hud.drawOverlayTopRight", showPlayer, info) 
end
addCommandHandler("stats", showStats, false, false)
addCommandHandler("durum", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)