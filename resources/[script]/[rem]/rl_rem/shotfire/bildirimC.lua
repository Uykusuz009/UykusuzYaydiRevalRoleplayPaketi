local shots = 0
local weapons = {
	[22] = "pistol",
	--[23] = "pistol", Disabled cus silenced brah
	[24] = "pistol",
	[25] = "Pompalı Tüfek",
	[26] = "Pompalı Tüfek",
	[27] = "Pompalı Tüfek",
	[28] = "sub-machine gun",
	[29] = "sub-machine gun",
	[32] = "sub-machine gun",
	[30] = "M4-AK47",
	[31] = "M4-AK47",
	[33] = "Sniper",
	[34] = "Sniper",
	[35] = "Bazuka",
}

addEventHandler ( "onClientPlayerWeaponFire", localPlayer,
	function ( weapon )
		if weapons[weapon] then
			if weapon == 24 and getElementData(localPlayer, "deaglemode") == 0 then
				return
			else
				if shots < 1 then
					shots = shots + 1
				elseif shots >= 1 then
					if not isTimer ( shotTimer ) then
						shots = 0
						shotTimer = setTimer ( function ( ) end, 60000, 1 )
						
						triggerServerEvent ( "weaponDistrict:doDistrict", localPlayer, weapons[weapon] )
					end
				end
			end
		end
	end )
	
	