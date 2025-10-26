mysql = exports.rl_mysql

local smallRadius = 5 --units
local factionsAll = {
	[1] = true,
	[3] = true,
}

-- /fingerprint
function fingerprintPlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "logged")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						local fingerprint = getElementData(targetPlayer, "fingerprint")
						outputChatBox(targetPlayerName .. "'s Fingerprint: " .. tostring(fingerprint) .. ".", thePlayer, 255, 194, 14)
					else
						outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fingerprint", fingerprintPlayer, false, false)

function output(player)
    local LSPD = 0
    local lscgh = 0
    local fire = 0
    for i, v in ipairs(getElementsByType("player")) do
	    if getElementData(v, "faction") == 1 and (getElementData(v, "logged") == true) then
           LSPD = LSPD + 1		
	    elseif getElementData(v, "faction") == 2 and (getElementData(v, "logged") == true) then
		   lscgh = lscgh + 1
		elseif getElementData(v, "faction") == 3 and (getElementData(v, "logged") == true) then
		   fire = fire + 1
        end
	end
    outputChatBox("[!]#FFFFFF Görevdeki: LASD: " .. fire .. " | LSPD: " .. LSPD .. " | EMS: " .. lscgh .. "", player, 87,52,32,true)
end
addCommandHandler("gorevde", output)

function megafonText(thePlayer, commandName, number)
	if getElementData(thePlayer, "logged") == true then 
		if factionsAll[getElementData(thePlayer, "faction")] then
			if getPedOccupiedVehicle(thePlayer) then
				executeCommandHandler("m", thePlayer, "" .. getTeamName(getPlayerTeam(thePlayer)) .. ", aracınızı lütfen sağ şeride yanaştırın ve motorunuzu kapatın!")
			end
		end
	end 
end
addCommandHandler("m1", megafonText)

function megafonText2(thePlayer, commandName, number)
	if getElementData(thePlayer, "logged") == true then 
		if factionsAll[getElementData(thePlayer, "faction")] then
			if getElementData(thePlayer, "faction") == 1 then 
				text = "LSPD"
			else 
				text = "JGK"
			end
			executeCommandHandler("s", thePlayer, "" .. text .. "! Ellerini kaldır ve olduğun yerde kal, sakın kıpırdama!")
		end
	end 
end
addCommandHandler("m2", megafonText2)

function rozetGoster(thePlayer, commandName, targetPlayer)
	local logged = getElementData(thePlayer, "logged")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionID = getElementData(thePlayer, "faction")
		
		if factionID == 3 or factionID == 1 then
			if not (targetPlayer) then
				outputChatBox("KULLANIM: /" .. commandName .. " [oyuncu id/isim]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance <= 5) then
						local badge = factionID == 3 and "LASD" or "LSPD"

						exports.rl_global:sendLocalMeAction(thePlayer, "" .. getPlayerName(targetPlayer) .. " isimli oyuncuya " .. badge .. " rozetini gösterir.")
					end
				end
			end
		end
	end
end
addCommandHandler("rozetgoster", rozetGoster, false, false)

-- /ticket
function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)
	local logged = getElementData(thePlayer, "logged")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		local factionID = getElementData(theTeam, "id")
		
		if (factionID==1 or factionID==78) then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı] [Amount] [Reason]", thePlayer, 255, 194, 14)
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
						local bankmoney = getElementData(targetPlayer, "bankmoney")
						
						local takeFromCash = math.min(money, amount)
						local takeFromBank = amount - takeFromCash
						exports.rl_global:takeMoney(targetPlayer, takeFromCash)
							
							
						-- Distribute money between the PD and Government
						local tax = exports.rl_global:getTaxAmount()
								
						exports.rl_global:giveMoney(theTeam, math.ceil((1-tax)*amount))
						exports.rl_global:giveMoney(getTeamFromName("Türkiye Cumhurbaşkanlığı"), math.ceil(tax*amount))
						
						outputChatBox("You ticketed " .. targetPlayerName .. " for " .. exports.rl_global:formatMoney(amount) .. ". Reason: " .. reason .. ".", thePlayer)
						outputChatBox("You were ticketed for " .. exports.rl_global:formatMoney(amount) .. " by " .. getPlayerName(thePlayer) .. ". Reason: " .. reason .. ".", targetPlayer)
						if takeFromBank > 0 then
							outputChatBox("Since you don't have enough money with you, $" .. exports.rl_global:formatMoney(takeFromBank) .. " have been taken from your bank account.", targetPlayer)
							setElementData(targetPlayer, "bankmoney", bankmoney - takeFromBank, false)
						end
						exports.rl_logs:logMessage("[PD/TICKET] " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a ticket. Amount: $" ..  exports.rl_global:formatMoney(amount).. " Reason: " .. reason , 30)
					else
						outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("ticket", ticketPlayer, false, false)

function takeLicense(thePlayer, commandName, targetPartialNick, licenseType, hours)

	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "logged")
	
	if (logged==1) then
	
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
	
		if (ftype==2) or exports.rl_integration:isPlayerDenemeYetkili(thePlayer) then
			if not (targetPartialNick) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
			else
				hours = tonumber(hours)
				if not (licenseType) or not (hours) or hours < 0 or (hours > 10 and not exports.rl_integration:isPlayerDenemeYetkili(thePlayer)) then
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
				else
					local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPartialNick)
					if targetPlayer then
						local name = getPlayerName(thePlayer)
						
						if (tonumber(licenseType)==1) then
							if(tonumber(getElementData(targetPlayer, "license.car")) == 1) then
								dbExec(mysql:getConnection(), "UPDATE characters SET car_license='" .. (-hours) .. "' WHERE id=" ..(getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name .. " has revoked your driving license.", targetPlayer, 255, 194, 14)
								outputChatBox("You have revoked " .. targetPlayerName .. "'s driving license.", thePlayer, 255, 194, 14)
								setElementData(targetPlayer, "license.car", -hours, true)
								exports.rl_logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their driving license for  " .. hours .. " hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a driving license.", thePlayer, 255, 0, 0)
							end
						elseif (tonumber(licenseType)==2) then
							if(tonumber(getElementData(targetPlayer, "license.gun")) == 1) then
								dbExec(mysql:getConnection(), "UPDATE characters SET gun_license='" .. (-hours) .. "' WHERE id=" .. (getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name .. " has revoked your weapon license.", targetPlayer, 255, 194, 14)
								outputChatBox("You have revoked " .. targetPlayerName .. "'s weapon license.", thePlayer, 255, 194, 14)
								setElementData(targetPlayer, "license.gun", -hours, true)
								exports.rl_logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their gun license for  " .. hours .. " hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a weapon license.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("License type not recognised.", thePlayer, 255, 194, 14)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("takelicense", takeLicense, false, false)

function tellNearbyPlayersVehicleStrobesOn()
	for _, nearbyPlayer in ipairs(exports.rl_global:getNearbyElements(source, "player", 300)) do
		triggerClientEvent(nearbyPlayer, "forceElementStreamIn", source)
	end
end
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), tellNearbyPlayersVehicleStrobesOn)

















