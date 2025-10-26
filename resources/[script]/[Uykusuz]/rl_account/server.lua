local passwordTimer = {}

addEventHandler("onResourceStart", resourceRoot, function()
	setWaveHeight(0)
	setMapName("Los Santos")
	setRuleValue("Version", "v" .. exports.rl_global:getServerSettings().version)
	setRuleValue("Discord", "https://discord.gg/Kasirgadp")
	setGlitchEnabled("baddrivebyhitbox", false)
end)

addEventHandler("onPlayerJoin", root, function()
	resetPlayer(source)
end)

addEvent("account.requestPlayerInfo", true)
addEventHandler("account.requestPlayerInfo", root, function()
    if client ~= source then
		exports.rl_sac:banForEventAbuse(client, eventName)
		return
	end
	
	resetPlayer(client)
	
	dbQuery(function(qh, client)
        local results, rows = dbPoll(qh, -1)
        if rows > 0 and results[1] then
            local data = results[1]
            local admin = data.admin or "Bilinmiyor"
            local reason = data.reason or "Bilinmiyor"
            local date = data.date or "Bilinmiyor"
            local endTick = tonumber(data.end_tick) or 0
            triggerClientEvent(client, "account.banScreen", client, {admin, reason, date, endTick})
		else
			triggerClientEvent(client, "account.accountScreen", client)
        end
    end, {client}, exports.rl_mysql:getConnection(), "SELECT * FROM bans WHERE serial = ? OR ip = ?", getPlayerSerial(client), getPlayerIP(client))
end)

addEvent("account.requestLogin", true)
addEventHandler("account.requestLogin", root, function(identifier, password)
	if client ~= source then
		exports.rl_sac:banForEventAbuse(client, eventName)
		return
	end
	
	dbQuery(function(qh, client)
        local results, rows = dbPoll(qh, -1)
        if results[1] and rows > 0 then
            local data = results[1]
			local saltedPassword = data.salt .. password
			local hashedPassword = string.lower(hash("sha256", saltedPassword))
			if data.password == hashedPassword then
				if tonumber(data.banned) == 0 then
					if ((tonumber(data.admin_level) > 0) and (data.serial ~= getPlayerSerial(client))) then
						exports.rl_infobox:addBox(client, "error", "Farklı serial'lerden yetkili hesabına giriş yapamazsınız, lütfen yönetim ekibiyle iletişime geçin.")
						triggerClientEvent(client, "account.removeQueryLoading", client)
						return
					end
					
					setElementData(client, "account_logged", true)
					setElementData(client, "account_id", tonumber(data.id))
					setElementData(client, "account_username", data.username)
					setElementData(client, "account_email", data.email)
					
					setElementData(client, "admin_level", tonumber(data.admin_level))
					setElementData(client, "manager_level", tonumber(data.manager_level))
					setElementData(client, "hidden_admin", tonumber(data.hidden_admin) == 1)
					setElementData(client, "admin_reports", tonumber(data.admin_reports))
					
					setElementData(client, "max_characters", tonumber(data.max_characters))
					setElementData(client, "donater", tonumber(data.donater))
					setElementData(client, "youtuber", tonumber(data.youtuber) == 1)
					setElementData(client, "dm_plus", tonumber(data.dm_plus) == 1)
					setElementData(client, "booster", tonumber(data.booster) == 1)
					setElementData(client, "balance", tonumber(data.balance))
					setElementData(client, "avatar", data.avatar)
					setElementData(client, "season_scene", tonumber(data.season_scene) == 1)
					setElementData(client, "promo_used", tonumber(data.promo_used) == 1)
					
					if tonumber(data.adminjail) == 1 then
						setElementData(client, "adminjailed", true)
					else
						setElementData(client, "adminjailed", false)
					end
					setElementData(client, "jailtime", tonumber(data.adminjail_time))
					setElementData(client, "jailadmin", data.adminjail_by)
					setElementData(client, "jailreason", data.adminjail_reason)
					
					triggerClientEvent(client, "hud.loadSettings", client)
					triggerClientEvent(client, "nametag.loadSettings", client)
					triggerClientEvent(root, "scoreboard.loadAvatar", root, client)
					
					local characters = {}
					dbQuery(function(qh, client)
						local results, rows = dbPoll(qh, -1)
						if results[1] and rows > 0 then
							for _, data in ipairs(results) do
								local index = #characters + 1
								if not characters[index] then
									characters[index] = {}
								end
								
								characters[index] = {
									id = data.id,
									name = data.name,
									skin = data.skin,
									kills = data.kills,
									deaths = data.deaths,
									level = data.level
								}
							end
						end
						
						setElementData(client, "characters", characters)
						
						if #characters > 0 then
							triggerClientEvent(client, "account.characterSelection", client, characters)
						else
							triggerClientEvent(client, "account.characterCreation", client)
						end
					end, {client}, exports.rl_mysql:getConnection(), "SELECT * FROM characters WHERE account = ? AND cked = 0", tonumber(data.id))
					
					dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET serial = ?, ip = ?, last_login = NOW() WHERE id = ?", getPlayerSerial(client), getPlayerIP(client), tonumber(data.id))
					triggerClientEvent(client, "account.removeAccount", client)
					triggerClientEvent(client, "account.removeOnboarding", client)
				else
					exports.rl_infobox:addBox(client, "error", "Bu hesap yasaklanmıştır.")
				end
			else
				exports.rl_infobox:addBox(client, "error", identifier .. " isimli kullanıcı için şifreler eşleşmiyor.")
			end
		else
			exports.rl_infobox:addBox(client, "error", identifier .. " isimli kullanıcı veritabanında bulunamadı.")
		end
    end, {client}, exports.rl_mysql:getConnection(), "SELECT * FROM accounts WHERE username = ? OR email = ?", identifier, identifier)
	triggerClientEvent(client, "account.removeQueryLoading", client)
end)

addEvent("account.requestRegister", true)
addEventHandler("account.requestRegister", root, function(username, password, email)
	if client ~= source then
		exports.rl_sac:banForEventAbuse(client, eventName)
		return
	end
	
	dbQuery(function(qh, client)
        local results, rows = dbPoll(qh, -1)
        if rows > 0 then
			for _, data in ipairs(results) do
				if data.username == username then
					exports.rl_infobox:addBox(client, "error", "Bu kullanıcı adı zaten kullanılıyor.")
					triggerClientEvent(client, "account.removeQueryLoading", client)
					return
				elseif data.email == email then
					exports.rl_infobox:addBox(client, "error", "Bu e-posta adresi zaten kullanılıyor.")
					triggerClientEvent(client, "account.removeQueryLoading", client)
					return
				elseif data.serial == getPlayerSerial(client) then
					exports.rl_infobox:addBox(client, "error", data.username .. " isimli hesaba zaten sahipsiniz.")
					triggerClientEvent(client, "account.removeQueryLoading", client)
					return
				end
			end
		else
			local salt = exports.rl_global:generateSalt(16)
			local saltedPassword = salt .. password 
			local hashedPassword = string.lower(hash("sha256", saltedPassword))
	
			if dbExec(exports.rl_mysql:getConnection(), "INSERT INTO accounts SET username = ?, password = ?, salt = ?, email = ?, serial = ?, ip = ?, register_date = NOW()", username, hashedPassword, salt, email, getPlayerSerial(client), getPlayerIP(client)) then
				triggerClientEvent(client, "account.redirectOnboarding", client, username, password)
			else
				exports.rl_infobox:addBox(client, "error", "Bir sorun oluştu.")
			end
		end
    end, {client}, exports.rl_mysql:getConnection(), "SELECT username, email, serial FROM accounts WHERE username = ? OR email = ? OR serial = ?", username, email, getPlayerSerial(client))
	triggerClientEvent(client, "account.removeQueryLoading", client)
end)

addEvent("account.onboardingComplete", true)
addEventHandler("account.onboardingComplete", root, function(promoCode)
	if client ~= source then
		exports.rl_sac:banForEventAbuse(client, eventName)
		return
	end
	
	setElementData(client, "promo_code", promoCode)
	setElementData(client, "promo_used", true)
	dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET promo_used = 1 WHERE id = ?", getElementData(client, "account_id"))
end)

addEvent("account.createCharacter", true)
addEventHandler("account.createCharacter", root, function(packedData)
	if client ~= source then
		exports.rl_sac:banForEventAbuse(client, eventName)
		return
	end
	
	local characters = client:getData("characters") or {}
    local maxCharacterCount = tonumber(client:getData("max_characters") or 1) or 3
    local characterCount = (characters and #characters or 1) - 1

    if characterCount >= maxCharacterCount then
        exports.rl_infobox:addBox(client, "error", "Maksimum karakter sayısına ulaştınız, marketten karakter slotu satın alınız.")
        return
    end
	
	packedData.name = string.gsub(packedData.name, " ", "_")
	
	dbQuery(function(qh, client, packedData)
        local results, rows = dbPoll(qh, -1)
        if results[1] and rows > 0 then
            exports.rl_infobox:addBox(client, "error", "Böyle bir karakter var.")
		else
			local spawnPosition = exports.rl_global:getServerSettings().spawnPosition
			local accountID = getElementData(client, "account_id")

			local fin = string.upper(tostring(hash("sha256", (string.upper(packedData.name) .. accountID .. getPlayerSerial(client)))))
			if #fin > 7 then
				fin = fin:sub(1, 7)
			end
			
			local walkingStyle = 118
			if packedData.gender == 1 then
				walkingStyle = 129
			end
			
			dbExec(exports.rl_mysql:getConnection(), "INSERT INTO characters SET account = ?, name = ?, x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ?, skin = ?, age = ?, gender = ?, height = ?, weight = ?, race = ?, country = ?, fin = ?, walking_style = ?, creation_date = NOW()", accountID, packedData.name, spawnPosition.x + math.random(5), spawnPosition.y + math.random(5), spawnPosition.z, spawnPosition.rotation, 0, 0, packedData.skin, packedData.age, packedData.gender, packedData.height, packedData.weight, packedData.race, packedData.country, fin, walkingStyle)
			
			dbQuery(function(qh, client)
				local results, rows = dbPoll(qh, -1)
				if results[1] and rows > 0 then
					local data = results[1]
					
					local characters = getElementData(client, "characters") or {}
					local index = #characters + 1
					if not characters[index] then
						characters[index] = {}
					end
					
					characters[index] = {
						id = data.id,
						name = data.name,
						skin = data.skin,
						kills = data.kills,
						deaths = data.deaths,
						level = data.level
					}
					
					setElementData(client, "characters", characters)
					joinCharacter(data.id, client, true)
				end
			end, {client}, exports.rl_mysql:getConnection(), "SELECT id FROM characters WHERE id = LAST_INSERT_ID()")
		end
    end, {client, packedData}, exports.rl_mysql:getConnection(), "SELECT name FROM characters WHERE name = ?", packedData.name)
	triggerClientEvent(client, "account.removeQueryLoading", client)
end)

function joinCharacter(characterID, thePlayer, newCharacter, theAdmin, targetUserID)
	if thePlayer then
		client = thePlayer
	end
	
	if not client then
		return false
	end
	
	if not characterID and not tonumber(characterID) then
		return false
	end
	characterID = tonumber(characterID)
	
	triggerEvent("setDrunkness", client, 0)
	setElementData(client, "alcohollevel", 0)

	removeMasksAndBadges(client)
	
	setElementData(client, "pd.jailserved", nil)
	setElementData(client, "pd.jailtime", nil)
	setElementData(client, "pd.jailtimer", nil)
	setElementData(client, "pd.jailstation", nil)
	
	local timer = getElementData(client, "pd.jailtimer")
	if isTimer(timer) then
		killTimer(timer)
	end
	
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	
	local accountID = getElementData(client, "account_id")
	
	if theAdmin then
		accountID = targetUserID
		sqlQuery = "SELECT * FROM `characters` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "'"
	else
		sqlQuery = "SELECT * FROM `characters` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "' AND `cked`=0"
	end
	
	dbQuery(function(qh, client)
        local results, rows = dbPoll(qh, -1)
        if results[1] and rows > 0 then
            local data = results[1]
			
			local playerWithNick = getPlayerFromName(tostring(data.name))
			if isElement(playerWithNick) and (playerWithNick ~= client) then
				triggerEvent("savePlayer", playerWithNick)
				if theAdmin then
					kickPlayer(playerWithNick, client, exports.rl_global:getPlayerFullAdminTitle(theAdmin) .. " isimli yetkili hesabınıza giriş yaptı.")
				else
					kickPlayer(playerWithNick, client, "Başkası senin karakterinde oturum açmış olabilir.")
				end
			end
			
			setElementData(client, "legal_name_change", true)
			setPlayerName(client, data.name)
			setElementData(client, "legal_name_change", false)
			
			setPlayerNametagShowing(client, false)
			setPedGravity(client, 0.008)
			
			setElementData(client, "dbid", tonumber(data.id))
			
			exports.rl_items:loadItems(client, true)
			
			spawnPlayer(client, tonumber(data.x), tonumber(data.y), tonumber(data.z), tonumber(data.rotation), tonumber(data.skin))
			setElementInterior(client, tonumber(data.interior))
			setElementDimension(client, tonumber(data.dimension))
			setCameraInterior(client, tonumber(data.interior))
			setCameraTarget(client, client)
			
			if tonumber(data.health) < 20 then
				setElementHealth(client, 20)
			else
				setElementHealth(client, tonumber(data.health))
			end
			setPedArmor(client, tonumber(data.armor))
			
			setPedStat(client, 70, 999)
			setPedStat(client, 71, 999)
			setPedStat(client, 72, 999)
			setPedStat(client, 74, 999)
			setPedStat(client, 76, 999)
			setPedStat(client, 77, 999)
			setPedStat(client, 78, 999)
			setPedStat(client, 77, 999)
			setPedStat(client, 78, 999)
			toggleAllControls(client, true, true, true)
			setElementAlpha(client, 255)
			setPedWalkingStyle(client, tonumber(data.walking_style))
			setPedFightingStyle(client, tonumber(data.fighting_style))
			
			setElementData(client, "clothing_id", tonumber(data.clothing_id) or nil)
			setElementData(client, "money", tonumber(data.money))
			setElementData(client, "bank_money", tonumber(data.bank_money))
			setElementData(client, "age", tonumber(data.age))
			setElementData(client, "gender", tonumber(data.gender))
			setElementData(client, "height", tonumber(data.height))
			setElementData(client, "weight", tonumber(data.weight))
			setElementData(client, "race", tonumber(data.race))
			setElementData(client, "country", tonumber(data.country))
			setElementData(client, "fin", data.fin)
			setElementData(client, "max_vehicles", tonumber(data.max_vehicles))
			setElementData(client, "max_interiors", tonumber(data.max_interiors))
			setElementData(client, "hunger", tonumber(data.hunger))
			setElementData(client, "thirst", tonumber(data.thirst))
			setElementData(client, "tags", (fromJSON(data.tags or "")))
			
			setElementData(client, "kills", tonumber(data.kills))
			setElementData(client, "deaths", tonumber(data.deaths))
			exports.rl_rank:checkPlayerRank(client, false)
			
			local teamElement = nil
			if (tonumber(data.faction_id) ~= -1) then
				teamElement = exports.rl_pool:getElement("team", tonumber(data.faction_id))
				if not (teamElement) then
					data.faction_id = -1
					dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET faction_id = -1, faction_rank = 1 WHERE id = ? LIMIT 1", tonumber(data.id))
				end
			end
			
			if teamElement then
				setPlayerTeam(client, teamElement)
			else
				setPlayerTeam(client, getTeamFromName("Vatandaş"))
			end
			
			local adminJailed = getElementData(client, "adminjailed")
			local jailTime = getElementData(client, "jailtime")
			local jailAdmin = getElementData(client, "jailadmin")
			local jailReason = getElementData(client, "jailreason")

			if location then
				setElementPosition(client, location[1], location[2], location[3])
				setElementPosition(client, location[4], 0, 0)
			end
			
			if adminJailed then
				setElementDimension(client, 55000 + getElementData(client, "id"))
				setElementInterior(client, 6)
				setCameraInterior(client, 6)
				setElementPosition(client, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(client, 267.438446)
				
				setElementData(client, "adminjailed", true)
				setElementData(client, "jailserved", 0)
				setElementData(client, "jailadmin", jailAdmin)
				setElementData(client, "jailreason", jailReason)
				
				if jailTime < 5000 then
					if not getElementData(client, "jailtimer") then
						setElementData(client, "jailtime", jailTime + 1)
						triggerEvent("admin:timerUnjailPlayer", client, client)
					end
				else
					setElementData(client, "jailtime", "Sınırsız")
					setElementData(client, "jailtimer", true)
				end
				
				setElementInterior(client, 6)
				setCameraInterior(client, 6)
			elseif tonumber(data.pdjail) == 1 then
				setElementData(client, "jailed", 1)
				exports.rl_prison:checkForRelease(client)
			end
			
			setElementData(client, "faction", tonumber(data.faction_id))
			setElementData(client, "factionMenu", 0)
			
			local factionPerks = type(data.faction_perks) == "string" and fromJSON(data.faction_perks) or {}
			setElementData(client, "factionPackages", factionPerks)
			setElementData(client, "factionrank", tonumber(data.faction_rank))
			setElementData(client, "factionphone", tonumber(data.faction_phone))
			setElementData(client, "factionleader", tonumber(data.faction_leader))
			setElementData(client, "custom_duty", tonumber(data.custom_duty))
			
			setElementData(client, "hours_played", tonumber(data.hours_played))
			setElementData(client, "minutes_played", tonumber(data.minutes_played))
			setElementData(client, "level", tonumber(data.level))
			setElementData(client, "box_hours", tonumber(data.box_hours))
			setElementData(client, "box_count", tonumber(data.box_count))
			
			setElementData(client, "vip", 0)
			exports.rl_vip:loadVIP(tonumber(data.id))
			
			setElementData(client, "job", tonumber(data.job) or 0)
			setElementData(client, "jobLevel", tonumber(data.jobLevel) or 0)
			setElementData(client, "jobProgress", tonumber(data.jobProgress) or 0)
			
			setElementData(client, "license.car", tonumber(data.car_license))
			setElementData(client, "license.bike", tonumber(data.bike_license))
			setElementData(client, "license.boat", tonumber(data.boat_license))
			setElementData(client, "license.pilot", tonumber(data.pilot_license))
			setElementData(client, "license.fish", tonumber(data.fish_license))
			setElementData(client, "license.gun", tonumber(data.gun_license))
			setElementData(client, "license.gun2", tonumber(data.gun2_license))
			
			setElementData(client, "mechanic", tonumber(data.mechanic) == 1)
			
			setElementData(client, "pass_type", tonumber(data.pass_type))
			setElementData(client, "pass_level", tonumber(data.pass_level))
			setElementData(client, "pass_xp", tonumber(data.pass_xp))
			
			setElementData(client, "wearable", (fromJSON(data.wearable or "")))
			setElementData(client, "playerWearables", {})
			
			if tonumber(data.job) == 1 then
				if data.jobTruckingRuns then
					setElementData(client, "job-system:truckruns", tonumber(data.jobTruckingRuns))
					dbExec(mysql:getConnection(), "UPDATE `jobs` SET `jobTruckingRuns` = '0' WHERE `jobCharID` = ? AND `jobID` = '1'", data.id)
				end
				triggerClientEvent(client, "restoreTruckerJob", client)
			end
			triggerEvent("restoreJob", client)
			
			setElementData(client, "head_moving", true)

			triggerClientEvent(client, "setPlayerCustomAnimation", client, client, data.custom_animation)
			triggerEvent("realism:applyWalkingStyle", client, tonumber(data.walking_style) or 118, true)
			
			dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET last_login = NOW() WHERE id = ?", tonumber(data.id))

			triggerClientEvent(client, "account.joinCharacterComplete", client)
			setElementData(client, "logged", true)
			exports.rl_global:updateNametagColor(client)
			
			takeAllWeapons(client)
			triggerEvent("updateLocalGuns", client)

			if newCharacter then
				exports.rl_global:giveItem(client, 16, tonumber(data.skin))
				exports.rl_global:giveItem(client, 152, data.name:gsub("_", " ") .. ";" .. (tonumber(data.gender) == 0 and "Erkek" or "Kadın") .. ";" .. tonumber(data.age) .. ";" .. data.fin)
			end
			
			if getElementData(client, "promo_code") then
				if (getElementData(client, "hours_played") == 0) and (getElementData(client, "minutes_played") == 0) then
					exports.rl_promo:giveEntityPromoGift(client, getElementData(client, "promo_code"))
				end
			end
		else
			exports.rl_infobox:addBox(client, "error", "Böyle bir karakter yok.")
		end
    end, {client}, exports.rl_mysql:getConnection(), sqlQuery, characterID, accountID)
	triggerClientEvent(client, "account.removeQueryLoading", client)
end
addEvent("account.joinCharacter", true)
addEventHandler("account.joinCharacter", root, joinCharacter)

addEvent("account.resetPlayerName", true)
addEventHandler("account.resetPlayerName", root, function(oldNick, newNick)
	setElementData(client, "legal_name_change", true)
	setPlayerName(client, oldNick)
	setElementData(client, "legal_name_change", false)
end)

function resetPlayer(thePlayer)
	setElementData(thePlayer, "logged", false)
	
	for data, _ in pairs(getAllElementData(thePlayer)) do
		if data ~= "id" then
			removeElementData(thePlayer, data)
		end
    end

    setElementData(thePlayer, "logged", false)
    setElementData(thePlayer, "account_logged", false)
	
	setElementDimension(thePlayer, 9999)
	setElementInterior(thePlayer, 0)
	exports.rl_global:updateNametagColor(thePlayer)
end

function banPlayerAccount(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		if getElementData(thePlayer, "logged") then
			local accountID = getElementData(thePlayer, "account_id") or 0
			if accountID > 0 then
				dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET banned = 1 WHERE id = ?", accountID)
			end
		end
	end
end

function removeMasksAndBadges(client)
    for k, v in ipairs({exports.rl_items:getMasks(), exports.rl_items:getBadges()}) do
        for kx, vx in pairs(v) do
            if getElementData(client, vx[1]) then
               setElementData(client, vx[1], false)
            end
        end
    end
end

function logInToCharacter(thePlayer, commandName, ...)
    if exports.rl_integration:isPlayerManager(thePlayer) then
        if (...) then
            targetChar = table.concat({...}, "_")
            dbQuery(function(qh, thePlayer)
				local results, rows = dbPoll(qh, -1)
				if rows > 0 and results[1] then
					local data = results[1]
					local targetCharID = tonumber(data.targetCharID) or false
					local targetUserID = tonumber(data.targetUserID) or false
					local targetAdminLevel = tonumber(data.targetAdminLevel) or 0
					local targetUsername = data.targetUsername or false
					local targetCharacterName = data.targetCharacterName or false
					local targetBanned = data.targetBanned or 0
					local theAdminPower = exports.rl_global:getPlayerAdminLevel(thePlayer)
					if targetCharID and targetUserID then
						if targetBanned == 1 then
							outputChatBox("[!]#FFFFFF Bu hesap yasaklanmıştır.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return false
						end
						
						if targetAdminLevel > theAdminPower then
							outputChatBox("[!]#FFFFFF Sizden daha yüksek yetkiye sahip birinin karakterine giremezsiniz.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili yüksek yetkiye sahip birinin karakterine girmeye çalıştı (" .. targetUsername .. ").")
							return false
						end
					   
						outputChatBox("[!]#FFFFFF " .. targetCharacterName:gsub("_", " ") .. " (" .. targetUsername .. ") isimli oyuncunun karakterine girdiniz.", thePlayer, 0, 255, 0, true)
						exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetCharacterName:gsub("_", " ") .. " (" .. targetUsername .. ") isimli oyuncunun karakterine girdi.")
						exports.rl_logs:addLog("loginto", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetCharacterName:gsub("_", " ") .. " (" .. targetUsername .. ") isimli oyuncunun karakterine girdi.")
						
						joinCharacter(targetCharID, thePlayer, false, true, targetUserID)
					end
				else
					outputChatBox("[!]#FFFFFF Böyle bir karakter yok.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end, {thePlayer}, exports.rl_mysql:getConnection(), "SELECT `characters`.`id` AS `targetCharID`, `characters`.`account` AS `targetUserID`, `accounts`.`admin_level` AS `targetAdminLevel`, `accounts`.`username` AS `targetUsername`, `characters`.`name` AS `targetCharacterName`, `accounts`.`banned` AS `targetBanned` FROM `characters` LEFT JOIN `accounts` ON `characters`.`account`=`accounts`.`id` WHERE `name` = ? LIMIT 1", tostring(targetChar))
        else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
		end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("loginto", logInToCharacter, false, false)

function ulkeCommand(thePlayer, commandName, country)
	if country and tonumber(country) then
		country = tonumber(country)
		if country >= 0 and country <= #countries then
			setElementData(thePlayer, "country", country)
			dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET country = ? WHERE id = ?", country, getElementData(thePlayer, "dbid"))
			outputChatBox("[!]#FFFFFF Başarıyla ülkeniz [" .. country .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
		else
			outputChatBox("[!]#FFFFFF Bu sayıya sahip bir ülke yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Ülke ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("ulke", ulkeCommand, false, false)

function changePassword(thePlayer, commandName, password, passwordAgain)
	if password and passwordAgain then
		if string.len(password) >= 6 and string.len(password) <= 32 then
			if password == passwordAgain then
				local serial = getPlayerSerial(thePlayer)
				if not isTimer(passwordTimer[serial]) then
					local accountID = getElementData(thePlayer, "account_id")
					local salt = exports.rl_global:generateSalt(16)
					local saltedPassword = salt .. password 
					local hashedPassword = string.lower(hash("sha256", saltedPassword))
					
					dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET password = ?, salt = ? WHERE id = ? LIMIT 1", hashedPassword, salt, accountID)
					
					outputChatBox("[!]#FFFFFF Hesap şifreniz başarıyla değiştirildi.", thePlayer, 0, 255, 0, true)
					triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
					
					passwordTimer[serial] = setTimer(function() end, 1000 * 60, 1)
				else
					local timer = getTimerDetails(passwordTimer[serial])
					outputChatBox("[!]#FFFFFF Şifrenizi tekrar değiştirmek için " .. math.floor(timer / 1000)  .. " saniye beklemeniz gerekmektedir.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Şifreler uyuşmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Şifre 6 ila 32 karakter arasında olmalıdır.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Yeni Şifreniz] [Yeni Şifreniz Tekrar]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("sifredegistir", changePassword, false, false)