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
			
			----exports.rl_anticheat:changeProtectedElementDataEx(target, "tazed", true, false)
			toggleAllControls(target, false, true, false)
			triggerClientEvent(target, "onClientPlayerWeaponCheck", target)
			setElementFrozen(target, true)
			exports.rl_global:applyAnimation(target, "ped", "FLOOR_hit_f", 0, false, true, true, true, true)
			--setElementData(target, "tazed", true)
			setTimer(removeAnimation, 300000, 1, target)
		end
	end
end
addEvent("tazerFired", true )
addEventHandler("tazerFired", getRootElement(), tazerFired)

addCommandHandler("tazerkaldir", 
	function(thePlayer, cmd, targetPlayer)
		local theTeam = getPlayerTeam(thePlayer)
		if getElementData(theTeam, "type") == 2 or getElementData(thePlayer,'faction') == 143 or exports.rl_integration:isPlayerAdmin(thePlayer) then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if getElementData(targetPlayer, "tazed") then
					outputChatBox("#575757Reval: #f0f0f0Oyuncunun tazer etkisi kaldırıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("#575757Reval: #f0f0f0" .. getPlayerName(thePlayer) .. " tarafından kaldırıldınız.", targetPlayer, 0, 255, 0, true)
					removeAnimation(targetPlayer)
					
				else
					outputChatBox("#575757Reval: #f0f0f0Kişi tazerlanmamış.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("#575757Reval: #f0f0f0/" .. cmd .. " [oyuncu ID]", thePlayer, 255, 0, 0, true)
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
		setElementFrozen(thePlayer, false)
	end
end

function updateDeagleMode(mode)
	if ( tonumber(mode) and (tonumber(mode) >= 0 and tonumber(mode) <= 2) ) then
		----exports.rl_anticheat:changeProtectedElementDataEx(client, "deaglemode", mode, true)
	end
end
addEvent("deaglemode", true)
addEventHandler("deaglemode", getRootElement(), updateDeagleMode)