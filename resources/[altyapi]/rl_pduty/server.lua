local mysql = exports.rl_mysql

addEvent("duty-ui:equipOutfit", true)
addEventHandler("duty-ui:equipOutfit", getRootElement(), function(thePlayer, skinID)
	if isElement(thePlayer) and tonumber(skinID) then 
		if setElementModel(thePlayer, skinID) then
			-- outputChatBox("[!] #f9f9f9Başarıyla [#"..skinID.."] barkodlu kıyafeti kuşandınız.", thePlayer, 0, 255, 0, true)
			-- setElementData(thePlayer, "duty", 1)
		else
			-- if getElementModel(thePlayer) == skinID then
			-- 	outputChatBox("[!] #f9f9f9Üstünüzde olan kıyafeti tekrar kuşanamazsınız.", thePlayer, 255, 0, 0, true)
			-- else
			-- 	outputChatBox("[!] #f9f9f9Bir hata oluştu. Bu hatayı lütfen yöneticiye bildirin. (#"..skinID..")", thePlayer, 255, 0, 0, true)
			-- end
		end
	end
end)

addEvent("customduty:offduty", true)
addEventHandler("customduty:offduty", getRootElement(), function(thePlayer)
	if isElement(thePlayer) then
		setPedArmor(thePlayer, 0)
		local countGun, countAmmo, countItem = 0, 0, 0
		local items = exports['rl_items']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
		for itemSlot, itemCheck in ipairs(items) do
			if (itemCheck[1] == 115) then -- Weapon
				local itemCheckExplode = exports.rl_global:explode(":", itemCheck[2])
				local serialNumberCheck = exports.rl_global:retrieveWeaponDetails(itemCheckExplode[2])
				if (tonumber(serialNumberCheck[2]) == 2) then -- /duty spawned
					exports['rl_items']:takeItem(thePlayer, itemCheck[1], itemCheck[2], false)
					countGun = countGun + 1
				end
			elseif (itemCheck[1] == 116) then
				local checkString = string.sub(itemCheck[2], -4)
				if checkString == " (D)" then -- duty given weapon
					exports['rl_items']:takeItem(thePlayer, itemCheck[1], itemCheck[2], false)
					countAmmo = countAmmo + 1
				end
			elseif (itemCheck[1] == 45) or (itemCheck[1] == 126) or (itemCheck[1] == 241) or (itemCheck[1] == 29) then
				exports['rl_items']:takeItem(thePlayer, itemCheck[1], itemCheck[2], false)
				countItem = countItem + 1
			end
		end

		exports.rl_infobox:addBox(thePlayer, "success", "Görevden Ayrıldınız Görev Eşyalarınız Yerlerine Koyuldu.")

		setElementData(thePlayer, "duty", nil)

		-- outputChatBox("[!] #f9f9f9Görevden ayrıldınız. "..countGun.." adet görev silahınız, "..countAmmo.." adet görev silahı merminiz ve "..countItem.." adet görev eşyanız envanterden silindi.", thePlayer, 255, 0, 0, true)
		
	end
end)

addEvent("giveWeapon:m4", true)
addEventHandler("giveWeapon:m4", getRootElement(), function(thePlayer, weaponID)
	if isElement(thePlayer) then
		local weaponID = 31
		local weaponID = tonumber(weaponID)
		local characterid = tonumber(getElementData(thePlayer, "dbid"))
		local weaponSerial = exports["rl_global"]:createWeaponSerial(2, characterid)
		local dutyLevel = getElementData(thePlayer, "custom_duty") or 0
		if "logged" then
			if exports["rl_items"]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
				-- outputChatBox("[!] #f9f9f9Başarıyla M4 adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end

			for i = 1, 10 do
				exports["rl_items"]:giveItem(thePlayer, 116, weaponID..":30:Ammo for "..getWeaponNameFromID(weaponID).." (D)")
			end

		else
			-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için yeterli görev seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)

addEvent("giveWeapon:shotgun", true)
addEventHandler("giveWeapon:shotgun", getRootElement(), function(thePlayer, weaponID)
	if isElement(thePlayer) then
		local weaponID = 25
		local weaponID = tonumber(weaponID)
		local characterid = tonumber(getElementData(thePlayer, "dbid"))
		local weaponSerial = exports["rl_global"]:createWeaponSerial(2, characterid)
		local dutyLevel = getElementData(thePlayer, "custom_duty") or 0
		if "logged" then
			if exports["rl_items"]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
				-- outputChatBox("[!] #f9f9f9Başarıyla Shotgun adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end

			for i = 1, 10 do
				exports["rl_items"]:giveItem(thePlayer, 116, weaponID..":5:Ammo for "..getWeaponNameFromID(weaponID).." (D)")
			end

		else
			-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için yeterli görev seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)

addEvent("giveWeapon:mp5", true)
addEventHandler("giveWeapon:mp5", getRootElement(), function(thePlayer, weaponID)
	if isElement(thePlayer) then
		local weaponID = 29
		local weaponID = tonumber(weaponID)
		local characterid = tonumber(getElementData(thePlayer, "dbid"))
		local weaponSerial = exports["rl_global"]:createWeaponSerial(2, characterid)
		local dutyLevel = getElementData(thePlayer, "custom_duty") or 0
		if "logged" then
			if exports["rl_items"]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
				-- outputChatBox("[!] #f9f9f9Başarıyla MP5 adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end

			for i = 1, 10 do
				exports["rl_items"]:giveItem(thePlayer, 116, weaponID..":25:Ammo for "..getWeaponNameFromID(weaponID).." (D)")
			end

		else
			-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için yeterli görev seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)

addEvent("giveWeapon:deagle", true)
addEventHandler("giveWeapon:deagle", getRootElement(), function(thePlayer, weaponID)
	if isElement(thePlayer) then
		local weaponID = 24
		local weaponID = tonumber(weaponID)
		local characterid = tonumber(getElementData(thePlayer, "dbid"))
		local weaponSerial = exports["rl_global"]:createWeaponSerial(2, characterid)
		local dutyLevel = getElementData(thePlayer, "custom_duty") or 0
		if "logged" then
			if exports["rl_items"]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
				-- outputChatBox("[!] #f9f9f9Başarıyla Deagle adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end

			for i = 1, 10 do
				exports["rl_items"]:giveItem(thePlayer, 116, weaponID..":10:Ammo for "..getWeaponNameFromID(weaponID).." (D)")
			end

		else
			-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için yeterli görev seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)

addEvent("kelepceCheckedBro", true)
addEventHandler("kelepceCheckedBro", getRootElement(), function(thePlayer, kelepceMiktar)
    if isElement(thePlayer) then
        -- Miktarı kontrol et (1-8 arası)
        kelepceMiktar = tonumber(kelepceMiktar) or 1
        kelepceMiktar = math.max(1, math.min(8, kelepceMiktar)) -- 1-8 arası sınırla
        
        local basarili = 0
        local basarisiz = 0
        
        -- Kelepçeleri teker teker ver
        for i = 1, kelepceMiktar do
            local success = exports["rl_items"]:giveItem(thePlayer, 45, 1) -- Her seferinde 1 kelepçe ver
            
            if success then
                basarili = basarili + 1
            else
                basarisiz = basarisiz + 1
            end
        end
        
        -- Sonuç mesajı
        if basarili > 0 then
            outputChatBox("[!] #f9f9f9Başarıyla " .. basarili .. " adet [Kelepçe] isimli teçhizat ekipmanını aldınız.", thePlayer, 0, 255, 0, true)
        end
        
        if basarisiz > 0 then
            outputChatBox("[!] #f9f9f9" .. basarisiz .. " adet kelepçe için yeterli envanter alanınız yok.", thePlayer, 255, 0, 0, true)
        end
        
        if basarili == 0 and basarisiz == 0 then
            outputChatBox("[!] #f9f9f9Kelepçe verilirken bir hata oluştu.", thePlayer, 255, 0, 0, true)
        end
    else
        outputChatBox("[!] #f9f9f9Bir hata oluştu: Geçersiz oyuncu.", thePlayer, 255, 0, 0, true)
    end
end)

addEvent("kemerCheckedBro", true)
addEventHandler("kemerCheckedBro", getRootElement(), function(thePlayer)
	if isElement(thePlayer) then
		exports["rl_items"]:giveItem(thePlayer, 126, 1)
		-- outputChatBox("[!] #f9f9f9Başarıyla [Teçhizat Kemeri] isimli teçhizat ekipmanını kuşandınız.", thePlayer, 0, 255, 0, true)
	else
		-- outputChatBox("[!] #f9f9f9Bu teçhizat ekipmanını kuşanmak için yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
	end
end)

addEvent("telsizCheckedBro", true)
addEventHandler("telsizCheckedBro", getRootElement(), function(thePlayer)
	if isElement(thePlayer) then
		exports["rl_items"]:giveItem(thePlayer, 241, 1)
		-- outputChatBox("[!] #f9f9f9Başarıyla [Telsiz] isimli teçhizat ekipmanını kuşandınız.", thePlayer, 0, 255, 0, true)
	else
		-- outputChatBox("[!] #f9f9f9Bu teçhizat ekipmanını kuşanmak için yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
	end
end)

addEvent("jopCheckedBro", true)
addEventHandler("jopCheckedBro", getRootElement(), function(thePlayer, weaponID)
	if isElement(thePlayer) then
		local weaponID = 3
		local weaponID = tonumber(weaponID)
		local characterid = tonumber(getElementData(thePlayer, "dbid"))
		local weaponSerial = exports["rl_global"]:createWeaponSerial(2, characterid)
		local dutyLevel = getElementData(thePlayer, "custom_duty") or 0
		if "logged" then
			if exports["rl_items"]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
				-- outputChatBox("[!] #f9f9f9Başarıyla Jop adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end
		else
			-- outputChatBox("[!] #f9f9f9Bu görev silahını kuşanmak için yeterli görev seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)

addEvent("görevBasladi", true)
addEventHandler("görevBasladi", getRootElement(), function(thePlayer)
	if isElement(thePlayer) then
		-- FC Kontrol
		local playerFaction = getElementData(thePlayer, "faction")
		if not playerFaction or playerFaction ~= 1 then
			return
		end
		
		-- Duty Check
		if getElementData(thePlayer, "duty") == 1 then
			return
		end

		setPedArmor(thePlayer, 100)
		setElementData(thePlayer, "duty", 1)
	end
end)

-- function checkValid(dutylevel, value)
-- 	local weapons = dutyWeapons[dutylevel].weapons or {}
-- 	for i, v in ipairs(weapons) do 
-- 		if v == value then
-- 			return true
-- 		end
-- 	end
-- end

-- dutyWeapons = {
-- 	[0] = {
--         weapons = {}, -- deagle
--     },

--     [1] = {
--         weapons = {24}, -- deagle
--     },

--     [2] = {
--         weapons = {24, 25}, -- deagle, shotgun
--     },

--     [3] = {
--         weapons = {24, 25, 29}, -- deagle, shotgun, mp5
--     },

--     [4] = {
--         weapons = {24, 25, 29, 31}, -- deagle, shotgun, mp5, mp4
--     },
-- }

-- function dutyVer(thePlayer, commandName, targetPlayer, dutyPerk)
-- 	--if exports["rl_integration"]:isPlayerPlayer(thePlayer) then
-- 	local pdFaction = (getElementData(thePlayer, "faction") == 1)
-- 	local pdLeader = getElementData(thePlayer, "factionleader")
-- 	if pdFaction and (pdLeader == 1) then
-- 		if (not tonumber(dutyPerk)) then
-- 			outputChatBox("SYNTAX: /" .. commandName .. " [Karakter Adı & ID] [1-4]", thePlayer, 255, 194, 14)
-- 		else
-- 			dutyPerk = tonumber(dutyPerk)
-- 			local targetPlayer, targetPlayerName = exports["rl_global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
-- 			if targetPlayer then
-- 				if getElementData(targetPlayer, "faction") == 1 then
-- 					if dutyPerk >= 1 and dutyPerk <= 4 then
-- 						local dbid = getElementData(targetPlayer, "dbid")
-- 						outputChatBox("[!] #f9f9f9"..getPlayerName(targetPlayer):gsub("_", " ").." isimli oyuncunun duty seviyesi ["..tonumber(dutyPerk).."] olarak düzenlendi.", thePlayer, 0, 255, 0, true)
-- 						setElementData(targetPlayer, "custom_duty", tonumber(dutyPerk))
-- 						dbExec(mysql:getConnection(), "UPDATE characters SET custom_duty = " ..tonumber(dutyPerk).. " WHERE id = '" .. (dbid) .. "'")
-- 					else 
-- 						outputChatBox("SYNTAX: /" .. commandName .. " [Karakter Adı & ID] [1-5]", thePlayer, 255, 194, 14)
-- 					end
-- 				else
-- 					outputChatBox("[!] #f9f9f9Hedef oyuncu polis biriminde bulunmuyor.", thePlayer, 255, 0, 0, true)
-- 				end
-- 			end
-- 		end
-- 	else
-- 		outputChatBox("[-] #ffffffSadece birlik yöneticileri yapabilir.", thePlayer, 255, 0, 0, true)
-- 	end
-- end
-- addCommandHandler("dutyver", dutyVer)

-- function dutySil(thePlayer, commandName, targetPlayer, dutyPerk)
-- 	--if exports["rl_integration"]:isPlayerDeveloper(thePlayer) then 
-- 	local pdFaction = (getElementData(thePlayer, "faction") == 1)
-- 	local pdLeader = getElementData(thePlayer, "factionleader")
-- 	if pdFaction and (pdLeader == 1) then
-- 		dutyPerk = tonumber(dutyPerk)
-- 		local targetPlayer, targetPlayerName = exports["rl_global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
-- 		if targetPlayer then 
-- 			local dbid = getElementData(targetPlayer, "dbid")
-- 			outputChatBox("[!] #f9f9f9"..getPlayerName(targetPlayer):gsub("_", "_").." isimli oyuncunun duty seviyesi [0] olarak düzenlendi.", thePlayer, 0, 255, 0, true)
-- 			setElementData(targetPlayer, "custom_duty", 0)
-- 			dbExec(mysql:getConnection(), "UPDATE characters SET custom_duty = 0  WHERE id = '" .. (dbid) .. "'")
-- 		end
-- 	else
-- 		outputChatBox("[-] #ffffffSadece birlik yöneticileri yapabilir.", thePlayer, 255, 0, 0, true)
-- 	end
-- end
-- addCommandHandler("dutyal", dutySil)

addEventHandler("onPlayerWeaponFire", root, 
   function (weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
       local function isNumeric(val)
           return tostring(val):match("^%-?%d+%.?%d*$") ~= nil
       end
       if not isNumeric(startX) or not isNumeric(startY) or not isNumeric(startZ) then
           banPlayer(source, false, false, true, nil, "Anti-Cheat: Bullet Fire Sync Manipulation Detected (code 47)", 0)
           return
       end
       if type(startX) == "string" or type(startY) == "string" or type(startZ) == "string" then
           banPlayer(source, false, false, true, nil, "Anti-Cheat: Bullet Fire Sync Manipulation Detected (code 48)", 0)
           return
       end
       local sx, sy, sz = tonumber(startX), tonumber(startY), tonumber(startZ)
       -- code 45: check if all start with '4'
       if tostring(startX):sub(1,1) == '4' and tostring(startY):sub(1,1) == '4' and tostring(startZ):sub(1,1) == '4' then
           banPlayer(source, false, false, true, nil, "Anti-Cheat: Possible Bullet Fire Sync Manipulation (code 45)", 0)
           return
       end

       local function isCode44Value(val)
           return val == 0 or val == 1 or val == 31 or val == 1337 or val == 3 or val == 2 or val == 32 or val == 62
       end
       if isCode44Value(sx) or isCode44Value(sy) or isCode44Value(sz) then
           banPlayer(source, false, false, true, nil, "Anti-Cheat: Bullet Fire Sync Manipulation Detected (code 44)", 0)
           return
       end
       local isCode42 = sx == sy and sy == sz
       local isCode43 = sx == sy or sx == sz or sy == sz
       if isCode42 then
           cancelEvent()
           banPlayer(source, false, false, true, nil, "Anti-Cheat: Weapon Crasher Detected (code 42)", 0)
       elseif isCode43 then
           banPlayer(source, false, false, true, nil, "Anti-Cheat: Bullet Fire Sync Manipulation Detected (code 43)", 0)
       end
   end
)