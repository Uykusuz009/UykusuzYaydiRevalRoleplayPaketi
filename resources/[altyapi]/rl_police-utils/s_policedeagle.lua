function tazerFired(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<20) then
		if (isElement(target) and getElementType(target)=="player") then
			for key, value in ipairs(exports.rl_global:getNearbyElements(target, "player", 20)) do
				if (value~=source) then
					triggerClientEvent(value, "showTazerEffect", value, x, y, z) -- show the sparks
				end
			end
			
			setElementData(target, "tazed", true, false)
			toggleAllControls(target, false, true, false)
			triggerClientEvent(target, "onClientPlayerWeaponCheck", target)
			exports.rl_global:applyAnimation(target, "ped", "FLOOR_hit_f", 0, false, true, true, true, true)
			--setElementData(target, "tazed", true)
			setTimer(removeAnimation, 300000, 1, target)
		end
	end
end
addEvent("tazerFired", true)
addEventHandler("tazerFired", getRootElement(), tazerFired)

addCommandHandler("tazerkaldir", 
	function(thePlayer, cmd, targetPlayer)
		local theTeam = getPlayerTeam(thePlayer)
		if getElementData(theTeam, "type") == 2 or exports.rl_integration:isPlayerAdmin1(thePlayer) then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if getElementData(targetPlayer, "tazed") then
					outputChatBox("[!]#FFFFFF Oyuncunun tazer etkisi kaldırıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " tarafından kaldırıldınız.", targetPlayer, 0, 255, 0, true)
					removeAnimation(targetPlayer)
					
				else
					outputChatBox("[!]#FFFFFF Kişi tazerlanmamış.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF /" .. cmd .. " [oyuncu ID]", thePlayer, 255, 0, 0, true)
			end
		end
	end
)

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		exports.rl_global:applyAnimation(target, "ped", "FLOOR_hit_f", -1, false, true, true, true, true)
		exports.rl_global:removeAnimation(thePlayer, true)
		toggleAllControls(thePlayer, true, true, true)
		triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
	end
end

function updateDeagleMode(mode)
	if (tonumber(mode) and (tonumber(mode) >= 0 and tonumber(mode) <= 2)) then
		setElementData(client, "deaglemode", mode, true)
	end
end
addEvent("deaglemode", true)
addEventHandler("deaglemode", getRootElement(), updateDeagleMode)