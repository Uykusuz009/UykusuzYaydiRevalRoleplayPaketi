local glitches = {"quickreload", "fastmove", "fastfire", "crouchbug"}
local weaponSkills = {"poor", "std", "pro"}
local CBugWeapons = {23, 24, 25, 27, 33, 34}

function setWeaponFlag(weaponID, skill, flag)
	local flags = getWeaponProperty(weaponID, skill, "flags")
	if (not bitTest(flags, flag)) then 
		setWeaponProperty(weaponID, skill, "flags", flag)
		return true
	end
	return false
end

addEventHandler("onResourceStart", resourceRoot, function()
	for i = 1, #CBugWeapons do
		local CBugWeapon = CBugWeapons[i]
		for j = 1, #weaponSkills do 
			local weaponSkill = weaponSkills[j]
			setWeaponFlag(CBugWeapon, weaponSkill, 0x000010)
			setWeaponFlag(CBugWeapon, weaponSkill, 0x000020)
		end
		if (i <= 4) then
			setGlitchEnabled(glitches[i], true)
		end
	end
end)