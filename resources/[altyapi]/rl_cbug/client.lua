local CBugWeapons = {
	[23] = true,
	[24] = true,
	[25] = true,
	[27] = true,
	[33] = true,
	[34] = true
}

addEventHandler("onClientKey", root, function(button, press)
	if (button == "c" and press) then
		if (getKeyState("W") or getKeyState("A") or getKeyState("S") or getKeyState("D")) then
			local currentSlot = getPedWeaponSlot(localPlayer)
			local weaponID = getPedWeapon(localPlayer)
			if (CBugWeapons[weaponID]) then
				setPedWeaponSlot(localPlayer, 0)
				setPedWeaponSlot(localPlayer, currentSlot)
			end
		end
	end
end)