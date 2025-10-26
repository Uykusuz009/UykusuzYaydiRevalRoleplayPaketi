local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }
function isGun(id) return getSlotFromWeapon(id) >= 2 and getSlotFromWeapon(id) <= 7 end

savedAmmo = {}
local handled = true

function weaponAmmo(prevSlot, currSlot)
	cleanupUI()
	triggerEvent("checkReload", source)
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, weaponAmmo)

function disableAutoReload(weapon, ammo, ammoInClip)
	if (ammoInClip==1)  and not getElementData(localPlayer, "deagle:reload") and not getElementData(localPlayer, "scoreboard:reload") then
		--triggerServerEvent("addFakeBullet", localPlayer, weapon, ammo)
		triggerEvent("i:s:w:r", localPlayer)
		triggerEvent("checkReload", source)
	elseif (ammoInClip==0) then
		-- panic?
		--outputChatBox("We never ever should get this, comprende?")
	else
		cleanupUI()
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, disableAutoReload)

function drawText()
	local scrWidth, scrHeight = guiGetScreenSize()
	--dxDrawText("Hit 'R' to Reload!", 0, 0, scrWidth, scrHeight, tocolor(255, 255, 255, 170), 1.02, "pricedown", "center", "bottom")
	--dxDrawText("'R' tuşuna basarak jarjör değiştirebilirsiniz!", 0, 0, scrWidth, scrHeight, tocolor(255, 255, 255, 170), 1, "default-bold", "center", "bottom")
end

function checkReloadStatus ()
	local weaponID = getPedWeapon(localPlayer)
	if  getPedAmmoInClip (localPlayer) == 1 and isGun(weaponID) then -- getElementData(source, "r:cf:" .. tostring(weaponID)) or 
		if not handled then
			addEventHandler("onClientRender", root, drawText)
			handled = true
		end
		--triggerServerEvent("addFakeBullet", localPlayer, weaponID, getPedTotalAmmo(localPlayer))
		--toggleControl ("fire", false)
	else
		cleanupUI(false)
	end
end
addEvent("checkReload", true)
addEventHandler("checkReload", root, checkReloadStatus)
setTimer(checkReloadStatus, 500, 0)

function cleanupUI(bplaySound)
	if (bplaySound) then
		playSound("public/sounds/reload.wav")
		setTimer(playSound, 400, 1, "public/sounds/reload.wav")
	end
	removeEventHandler("onClientRender", root, drawText)
	handled = false
end
addEvent("cleanupUI", true)
addEventHandler("cleanupUI", root, cleanupUI)
