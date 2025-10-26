local mysql = exports.rl_mysql

local spawnProtectionTimers = {}
local deathAnimations = {
	{"WUZI", "CS_Dead_Guy"},
	{"CRACK", "crckidle1"},
	{"CRACK", "crckidle2"},
	{"CRACK", "crckidle3"}
}

function playerDeath(totalAmmo, killer, killerWeapon)
	if getElementData(source, "dbid") then
		if getElementData(source, "adminjailed") then
			local team = getPlayerTeam(source)
			spawnPlayer(source, 232.3212890625, 160.5693359375, 1003.0234375, 270)
			
			setElementModel(source,getElementModel(source))
			setPlayerTeam(source, team)
			setElementInterior(source, 9)
			setElementDimension(source, 3)
			
			setCameraInterior(source, 9)
			setCameraTarget(source)
			fadeCamera(source, true)
		elseif getElementData(source, "jailed") then
			exports.rl_prison:checkForRelease(source)
		else
			setElementData(source, "seatbelt", false)
			setElementData(source, "dead", true)
			
			local x, y, z = getElementPosition(source)
			local interior = getElementInterior(source)
			local dimension = getElementDimension(source)
			local team = getPlayerTeam(source)
			local rotx, roty, rotz = getElementRotation(source)
			local skin = getElementModel(source)
			local randomAnimation = math.random(1, #deathAnimations)
			
			spawnPlayer(source, x, y, z, rotz, skin, interior, dimension, team)
			
			setElementFrozen(source, true)
			setPedHeadless(source, false)
			setCameraInterior(source, interior)
			setCameraTarget(source, source) 

			setPlayerTeam(source, team)
			setElementInterior(source, interior)
			setElementDimension(source, dimension)
			toggleControl(source, "fire", false)
			toggleControl(source, "jump", false)
			setElementHealth(source, 5)
			setPedAnimation(source, deathAnimations[randomAnimation][1], deathAnimations[randomAnimation][2], -1, true, false, false)
			
			triggerClientEvent(source, "death.renderUI", source)
		end
	end
end
addEventHandler("onPlayerWasted", root, playerDeath)

function playerPressedKey(button, press)
    if (press) then
        if button == "lctrl" or button == "rctrl" or button == "space" then 
            cancelEvent()     
            return true 
        end
    end
end
addEventHandler("onClientKey", root, playerPressedKey)

function changeDeathView(source, victimDropItem)
	if isPedDead(source) then
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		setCameraMatrix(source, x + 6, y + 6, z + 3, x, y, z)
		triggerClientEvent(source, "death.showRespawnButton", source, victimDropItem)
	end
end
addEvent("changeDeathView", true)
addEventHandler("changeDeathView", root, changeDeathView)

function acceptDeath(thePlayer, victimDropItem)
	if getElementData(thePlayer, "dead") then
		fadeCamera(thePlayer, true)
		setElementHealth(thePlayer, 5)
		setElementFrozen(thePlayer, false)
		setElementData(thePlayer, "dead", false)
		exports.rl_global:removeAnimation(thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
		
		disableSpawnProtection(thePlayer)
		setElementData(thePlayer, "spawn_protection", true)
        spawnProtectionTimers[thePlayer] = setTimer(disableSpawnProtection, 5000, 1, thePlayer)
	end
end
addEvent("death.acceptDeath", true)
addEventHandler("death.acceptDeath", root, acceptDeath)

function disableSpawnProtection(thePlayer)
    setElementData(thePlayer, "spawn_protection", false)
    if isTimer(spawnProtectionTimers[thePlayer]) then
        killTimer(spawnProtectionTimers[thePlayer]) 
        spawnProtectionTimers[thePlayer] = nil
    end
end

addEventHandler("onPlayerQuit", root, function()
	disableSpawnProtection(source)
end)

function revivePlayer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "dead") then
					triggerClientEvent(targetPlayer, "death.closeRespawnButton",targetPlayer)
					
					local x, y, z = getElementPosition(targetPlayer)
					local interior = getElementInterior(targetPlayer)
					local dimension = getElementDimension(targetPlayer)
					local skin = getElementModel(targetPlayer)
					local team = getPlayerTeam(targetPlayer)
					
					setPedHeadless(targetPlayer, false)
					setCameraInterior(targetPlayer, interior)
					setCameraTarget(targetPlayer, targetPlayer)
					setElementData(targetPlayer, "dead", false)
					spawnPlayer(targetPlayer, x, y, z, 0)
					
					setElementModel(targetPlayer,skin)
					setPlayerTeam(targetPlayer, team)
					setElementInterior(targetPlayer, interior)
					setElementDimension(targetPlayer, dimension)
					acceptDeath(targetPlayer)
					triggerClientEvent(targetPlayer, "death.revive", targetPlayer)
					triggerEvent("updateLocalGuns", targetPlayer)
					
					disableSpawnProtection(targetPlayer)
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu canlandırıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından canlandırıldınız.", targetPlayer, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu canlandırdı.")
					exports.rl_logs:addLog("revive", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu canlandırdı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu baygın değil.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("revive", revivePlayer, false, false)

function reviveAllPlayers(thePlayer, commandName)
	if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		for _, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "dead") then
				triggerClientEvent(player, "death.closeRespawnButton", player)
				
				local x, y, z = getElementPosition(player)
				local interior = getElementInterior(player)
				local dimension = getElementDimension(player)
				local skin = getElementModel(player)
				local team = getPlayerTeam(player)
				
				setPedHeadless(player, false)
				setCameraInterior(player, interior)
				setCameraTarget(player, player)
				setElementData(player, "dead", false)
				spawnPlayer(player, x, y, z, 0)
				
				setElementModel(player,skin)
				setPlayerTeam(player, team)
				setElementInterior(player, interior)
				setElementDimension(player, dimension)
				acceptDeath(player)
				triggerClientEvent(player, "death.revive", player)
				triggerEvent("updateLocalGuns", player)
			end
			
			setElementHealth(player, 5)
			disableSpawnProtection(player)
			
			exports.rl_infobox:addBox(player, "success", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili herkesi canlandırdı.")
		end
		exports.rl_logs:addLog("revive", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili herkesi canlandırdı.")
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("reviveall", reviveAllPlayers, false, false)