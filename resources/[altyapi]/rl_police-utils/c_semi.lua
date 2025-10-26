local shotsFired = 0
local test = false

function firemode_switchFireMode()
	local mode = getElementData(localPlayer, "firemode")
	local weapon, totalAmmo = getPedWeapon(localPlayer), getPedTotalAmmo(localPlayer)
	if weapon == 31 or weapon == 30 or weapon == 29 or weapon == 28 or weapon == 32 and totalAmmo > 0 then
		local beanbagInfo
		if mode == 0 then
			beanbagInfo = 'Silahınızı yarı otomatik moda geçirdiniz.'
			triggerServerEvent("firemode", localPlayer, 1)
		elseif mode == 1 then
			beanbagInfo = 'Silahınızı otomatik moda geçirdiniz.'
			triggerServerEvent("firemode", localPlayer, 0)
		end
		outputChatBox("[!]#FFFFFF " .. beanbagInfo, 0, 255, 0, true)
		exports.rl_global:sendLocalMeAction(thePlayer, "silahin kullanim şeklini değiştirir.", false, true)
	end
end

function firemode_bindKeys()
    bindKey('n', 'down', firemode_switchFireMode)
    bindKey('lctrl', 'up', firemode_resetShotsFired)
    bindKey('mouse1', 'up', firemode_resetShotsFired)
    toggleControl('fire', true)
end

function firemode_resetShotsFired()
    shotsFired = 0
    toggleControl('fire', true)
end

function firemode_handleWeaponFire(weapon, mode)
	local weapon = getPedWeapon(localPlayer)
	local mode = getElementData(localPlayer, "firemode")
	if mode == 0 then 
		if weapon == 31 or weapon == 30 or weapon == 29 or weapon == 28 or weapon == 32 then
		return
		end
    elseif mode == 1 then
	if shotsFired < 1 and weapon == 31 or weapon == 30 or weapon == 29 or weapon == 28 or weapon == 32 then
        toggleControl('fire', false)
        shotsFired = 1
		end
    end
end

addEventHandler('onClientPlayerWeaponFire', root, firemode_handleWeaponFire)
addEventHandler('onClientResourceStart', resourceRoot, firemode_bindKeys)