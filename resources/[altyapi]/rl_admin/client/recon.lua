local reconTarget = nil
local reconTargets = {}
local pointer = 0

local function addToReconTable(id)
	for i, existingId in pairs(reconTargets) do
		if existingId == id then
			return false
		end
	end
	table.insert(reconTargets, id)
	return true
end

function toggleRecon(state, targetPlayer)
	if state then
		local cur = exports.rl_data:get("reconCurpos")
		if not cur then
			cur = {}
			cur.x, cur.y, cur.z = getElementPosition(localPlayer)
			cur.rx, cur.ry, cur.rz = getElementRotation(localPlayer)
			cur.dim = getElementDimension(localPlayer)
			cur.int = getElementInterior(localPlayer)
		end
		cur.target = getElementData(targetPlayer, "id")
		reconTarget = targetPlayer
		exports.rl_data:save(cur, "reconCurpos")

		setElementData(localPlayer, "reconx", true , false)
		setElementCollisionsEnabled(localPlayer, false)
		setElementAlpha(localPlayer, 0)
		setPedWeaponSlot(localPlayer, 0)
		
		local t_dim = getElementDimension(targetPlayer)
		local t_int = getElementInterior(targetPlayer)
		setElementDimension(localPlayer, t_dim)
		setElementInterior(localPlayer, t_int)
		setCameraInterior(t_int)

		local x1, y1, z1 = getElementPosition(targetPlayer)
		attachElements(localPlayer, targetPlayer, 0, 0, 5)
		setElementPosition(localPlayer, x1, y1, z1 + 5)
		setCameraTarget(targetPlayer)
	else
		local cur = exports.rl_data:get("reconCurpos")
		if cur then
			detachElements(localPlayer)
			setElementData(localPlayer, "reconx", false , false)

			setElementPosition(localPlayer, cur.x, cur.y, cur.z)
			setElementRotation(localPlayer, cur.rx, cur.ry, cur.rz)

			setElementDimension(localPlayer, cur.dim)
			setElementInterior(localPlayer, cur.int)
			setCameraInterior(cur.int)
			
			setCameraTarget(localPlayer, nil)
			setElementAlpha(localPlayer, 255)
			setElementCollisionsEnabled(localPlayer, true)

			exports.rl_data:save(nil, "reconCurpos")
			reconTarget = nil
		end
	end
end

function reconPlayer(commandName, targetPlayer)
	if source then
		localPlayer = source
	end
	
	if getElementData(localPlayer, "logged") and exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
		local reconx = getElementData(localPlayer, "reconx")
		if not (targetPlayer) then
			if toggleRecon(false) then
				reconTargets = {}
				pointer = 0
			end
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(localPlayer, targetPlayer)
			if not targetPlayer then return end
			
			if not getElementData(targetPlayer, "logged") then
				return
			end
			
			if targetPlayer == localPlayer then
				return
			end

			toggleRecon(true, targetPlayer)
		end
	end
end
addEvent("admin:recon", true)
addEventHandler("admin:recon", root, reconPlayer)
addCommandHandler("recon", reconPlayer)

addEventHandler("onClientElementDataChange", root, function(dataName)
	if getElementType (source) == "player" and dataName == "reconx" then
		if getElementData(source, "reconx") then
			addEventHandler("onClientRender", root, displayReconInfo)
		else
			setElementData(localPlayer, "recon:whereToDisplayY", nil)
			removeEventHandler("onClientRender", root, displayReconInfo)
		end
	end
end)

local function tableToString(table)
	local text = ""
	for i, id in ipairs(table) do
		text = text .. id .. ", "
	end
	return #text > 0 and string.sub(text, 1, #text - 2) or "Hiçbiri"
end

local sw, sh = guiGetScreenSize()
local font = exports.rl_fonts:getFont("sf-regular", 9)

function displayReconInfo()
	if not reconTarget or not isElement(reconTarget) or not getElementData(reconTarget, "logged") then
		setElementData(localPlayer, "recon:whereToDisplayY", nil)
		return removeEventHandler("onClientRender", root, displayReconInfo)
	end

	local w, h = 760, 85
	local x, y = (sw - w) / 2, sh - h - 20
	
	setElementData(localPlayer, "recon:whereToDisplayY", y)
    dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, 200), true)
    
	local ox, oy = 507, 396
	local xo, yo = x - ox, y - oy
	local text = ""
    dxDrawText("HP: " .. math.floor(getElementHealth(reconTarget)), 517 + xo, 423 + yo, 706 + xo, 440 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Oyuncu: " .. exports.rl_global:getPlayerFullAdminTitle(reconTarget), 517 + xo, 406 + yo, 887 + xo, 423 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    
	local weapon = getPedWeapon(reconTarget)
	if weapon then
		weapon = getWeaponNameFromID(weapon)
	else
		weapon = "N/A"
	end
    
	dxDrawText("Silah: " .. weapon, 517 + xo, 440 + yo, 706 + xo, 457 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Zırh: " .. math.floor(getPedArmor(reconTarget)), 706 + xo, 423 + yo, 887 + xo, 440 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Skin: " .. getElementModel(reconTarget), 706 + xo, 440 + yo, 887 + xo, 457 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Cüzdan: $" .. exports.rl_global:formatMoney(getElementData(reconTarget, "money") or 0), 517 + xo, 457 + yo, 706 + xo, 474 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Bankadaki Para: $" .. exports.rl_global:formatMoney(getElementData(reconTarget, "bank_money") or 0), 706 + xo, 457 + yo, 887 + xo, 474 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
	
	text = "Vatandaş"
	
	local fid = getElementData(reconTarget, "faction") or 0
	if fid > 0 then
		local theFaction = getPlayerTeam(reconTarget)
		if theFaction then
			text = getTeamName(theFaction)
			local ranks = getElementData(theFaction, "ranks")
			if ranks then
				local rank = getElementData(reconTarget, "factionrank")
				local fRank = ranks[rank] and ranks[rank] or false
				if fRank then
					text = text .. " (" .. fRank .. ")"
				end
			end
		end
	end
	
	local loc = getZoneName(getElementPosition(reconTarget))
	local int = getElementInterior(reconTarget)
	local dim = getElementDimension(reconTarget)
	
	if dim > 0 then
		loc = "Dahili Interior ID #" .. dim
	end
    
	dxDrawText("Birlik: " .. text, 887 + xo, 406 + yo, 1257 + xo, 423 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Bölge: " .. loc, 887 + xo, 423 + yo, 1257 + xo, 440 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Interior: " .. int, 887 + xo, 440 + yo, 1076 + xo, 457 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Dimension: " .. dim, 1076 + xo, 440 + yo, 1257 + xo, 457 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    
	local hoursPlayed = tonumber(getElementData(reconTarget, "hours_played")) or "Bilinmiyor"
    dxDrawText("Saat: " .. hoursPlayed, 887 + xo, 457 + yo, 1076 + xo, 474 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
    dxDrawText("Ping: " .. getPlayerPing(reconTarget), 1076 + xo, 457 + yo, 1257 + xo, 474 + yo, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
end

local function getTarget(order)
	if #reconTargets < 2 then
		return false, "Aralarında geçiş yapabilmek için lütfen daha fazla oynatıcıyı yeniden yapılandırın."
	end
	if order == "arrow_r" then
		pointer = pointer + 1
		if not reconTargets[pointer] then
			pointer = 1
			local target = exports.rl_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "Bu oyuncu yakın zamanda oyundan ayrıldı."
			else
				return reconTargets[pointer]
			end
		else
			local target = exports.rl_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "Bu oyuncu yakın zamanda oyundan ayrıldı."
			else
				return reconTargets[pointer]
			end
		end
	else
		pointer = pointer - 1
		if not reconTargets[pointer] then
			pointer = #reconTargets
			local target = exports.rl_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "Bu oyuncu yakın zamanda oyundan ayrıldı."
			else
				return reconTargets[pointer]
			end
		else
			local target = exports.rl_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "Bu oyuncu yakın zamanda oyundan ayrıldı."
			else
				return reconTargets[pointer]
			end
		end
	end
end

addEventHandler("onClientKey", root, function(button, press) 
	if getElementData(localPlayer, "reconx") and press then
	    if button == "arrow_l" or button == "arrow_r" then
	    	local target, reason = getTarget(button)
	    	if target then
	    		triggerEvent("admin:recon", localPlayer, nil, target)
	    	else
	    		outputChatBox("[!]#FFFFFF " .. reason, 255, 0, 0, true)
				playSoundFrontEnd(4)
	    	end
	    end
	end
end)