local staffTitles = {
	[1] = {
		[0] = "Oyuncu",
		[1] = "Deneme Yetkili",
		[2] = "Yetkili I",
		[3] = "Yetkili II",
		[4] = "Yetkili III",
		[5] = "Tecrübeli Yetkili",
		[6] = "Lider Yetkili",
		[7] = "Alt Yönetim",
		[8] = "Üst Yönetim Kurulu",
		[9] = "Sunucu Yöneticis",
		[10] = "Sunucu Sorumlusu",
		[11] = "Sunucu Sahibi"
	},

	[2] = {
		[0] = "Oyuncu",
		[1] = "Üst Yönetim Kurulu Üyesi"
	},
}

function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end

function getAdminTitles()
	return staffTitles[1]
end

function getAdminTitle(rankID)
	return staffTitles[1][tonumber(rankID)] or "Oyuncu"
end

function getPlayerAdminTitle(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0 
	return staffTitles[1][adminLevel] or "Oyuncu"
end

function isPlayerServerOwner(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 11)
end

function isPlayerDeveloper(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 10)
end

function isPlayerServerAdministrator(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 9)
end

function isPlayerServerManager(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 8)
end

function isPlayerGeneralAdmin(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 7)
end

function isPlayerLeaderAdmin(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 6)
end

function isPlayerSeniorAdmin(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 5)
end

function isPlayerAdmin3(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 4)
end

function isPlayerAdmin2(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 3)
end

function isPlayerAdmin1(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 2)
end

function isPlayerTrialAdmin(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local adminLevel = getElementData(thePlayer, "admin_level") or 0
	return (adminLevel >= 1)
end

function isPlayerManager(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local managerLevel = getElementData(thePlayer, "manager_level") or 0
	return (managerLevel >= 1)
end

-- Additional functions needed by reports system
function isPlayerScripter(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local scripterLevel = getElementData(thePlayer, "scripter_level") or 0
	return (scripterLevel >= 1)
end

function isPlayerVCTMember(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local vctLevel = getElementData(thePlayer, "vct_level") or 0
	return (vctLevel >= 1)
end

function isPlayerVehicleConsultant(thePlayer)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "thePlayer" then
		return false
	end
	local consultantLevel = getElementData(thePlayer, "vehicle_consultant") or 0
	return (consultantLevel >= 1)
end

function getAdminStaffNumbers()
	return {1, 2} -- Admin team numbers
end

function getAuxiliaryStaffNumbers()
	return {3, 4} -- Auxiliary staff team numbers
end

function getSupporterNumber()
	return 5 -- Supporter team number
end