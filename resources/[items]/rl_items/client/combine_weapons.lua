local WASTED = {}

function traceBullet(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	triggerServerEvent("items.useAmmo", localPlayer, weapon, 1, ammoInClip)
end

function disableGunOnSwitch (prevSlot, newSlot)
	local weaponID = getPedWeapon(localPlayer, newSlot)
	if ((getElementData(source, "cf:" .. tostring(weaponID)) or getElementData(source, "r:cf:" .. tostring(weaponID)) or  getPedAmmoInClip(localPlayer, newSlot) < 2) and not (weaponID==2 or weaponID==3 or weaponID==4 or weaponID==5 or weaponID==6 or weaponID==7 or weaponID==9 or weaponID==15 or weaponID == 0)) then
		toggleControl ("fire", false)
	else 
		toggleControl ("fire", true)
	end
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, disableGunOnSwitch)
addEvent("onClientPlayerWeaponCheck", true)
addEventHandler("onClientPlayerWeaponCheck", localPlayer, disableGunOnSwitch)

function weaponServerSync()
	local logged = getElementData(localPlayer, "logged")
	if (logged) then
		local weaponArr = {}
		for i=0, 12 do
			local weapon = getPedWeapon(localPlayer, i)
			if weapon then
				local ammo = getPedTotalAmmo(localPlayer, i) or 0
				if ammo > 0 then
					weaponArr[#weaponArr + 1]  = { weapon, ammo, getPedAmmoInClip (localPlayer, i) }
				end
			end
		end
		triggerServerEvent("i:s:w", localPlayer, weaponArr)
	end
end
setTimer(weaponServerSync, 30000, 0)
addEvent("i:s:w:r", true)
addEventHandler("i:s:w:r", root, weaponServerSync)

function doReload()
	if getPedWeapon(localPlayer) then
		weaponServerSync()		
		triggerServerEvent("i:s:w:r:do", localPlayer)
	end
end

function bindKeys()
	bindKey("r", "down", doReload)
end
addEventHandler("onClientResourceStart", resourceRoot, bindKeys)