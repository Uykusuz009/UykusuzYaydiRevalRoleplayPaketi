addEvent("market.buyCharacterNameChange", true)
addEventHandler("market.buyCharacterNameChange", root, function(name, price)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local status, error = exports.rl_account:checkCharacterName(name)
			if status then
				name = string.gsub(tostring(name), " ", "_")
				dbQuery(function(qh, client)
					local res, rows, err = dbPoll(qh, 0)
					if (rows > 0) and (res[1] ~= nil) then
						exports.rl_infobox:addBox(client, "error", "Böyle bir karakter adı bulunuyor.")
					else
						setElementData(client, "legal_name_change", true)
						if setPlayerName(client, name) then
							local dbid = getElementData(client, "dbid")
							exports.rl_cache:clearCharacterName(dbid)
							dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET name = ? WHERE id = ?", name, dbid)
							takeBalance(client, price)
							exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında İsim Değişikliği satın aldınız.")
							exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında İsim Değişikliği satın aldı.")
							exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında İsim Değişikliği satın aldı.")
							marketAddLog(client,"Karakter Isim",price)
						else
							exports.rl_infobox:addBox(client, "error", "Bir sorun oluştu.")
						end
						setElementData(client, "legal_name_change", false)
					end
				end, {client}, exports.rl_mysql:getConnection(), "SELECT name FROM characters WHERE name = ?", name)
			else
				exports.rl_infobox:addBox(client, "error", error)
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyTag", true)
addEventHandler("market.buyTag", root, function(tagLevel)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end

	price = 100	
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local tags = getElementData(client, "tags") or {}
			local foundIndex = false
			
			for index, value in pairs(tags) do
				if value == tagLevel then
					foundIndex = index
				end
			end
			if foundIndex then exports.rl_infobox:addBox(client, "error", "Zaten bu etikete sahipsiniz.") return end
				if #tags >= 0 and #tags < 6 then
					table.insert(tags, tagLevel)
					setElementData(client, "tags", tags)
					dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(client, "dbid"))		
					takeBalance(client, price)
					exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında bir etiket satın aldınız.")
					exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında bir etiket satın aldı.")
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında bir etiket satın aldı.")
				else
					exports.rl_infobox:addBox(client, "error", "Etiket sınırına ulaştığınız için daha fazla etiket alamazsınız.")	
				end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyInventory", true)
addEventHandler("market.buyInventory", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end

	price = 250	
	if price > 0 then
		if (getElementData(client, "kaisen:inventory") or 0) == 1 then exports.rl_infobox:addBox(client, "error", "Zaten bu özelliğe sahipsiniz.") return end
		setElementData(client, "kaisen:inventory", 1)
		dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET kaisen_inventory = ? WHERE id = ?", 1, getElementData(client, "dbid"))		
		takeBalance(client, price)
		exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında envanter arttırıcı satın aldınız.")
		exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında envanter arttırıcı satın aldı.")
		exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında envanter arttırıcı satın aldı.")
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyBook", true)
addEventHandler("market.buyBook", root, function(r0_26)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end

  local price = FIGHT_BOOK[r0_26][3]
  if price <= getElementData(client, "balance") then
    if exports.rl_items:hasSpaceForItem(client, FIGHT_BOOK[r0_26][1], 1) then
      exports.rl_global:giveItem(client, FIGHT_BOOK[r0_26][1], 1)
      takeBalance(client, price)
      exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. FIGHT_BOOK[r0_26][2] .. " satın aldınız.")
      exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. FIGHT_BOOK[r0_26][2] .. " satın aldı.")
      exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. FIGHT_BOOK[r0_26][2] .. " satın aldı.")
      marketAddLog(client, "" .. FIGHT_BOOK[r0_26][2] .. " Alimi", price)
    else
      exports.rl_infobox:addBox(client, "error", "Envanteriniz dolu.")
    end
  else
    exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
  end
end)

-- addEvent("market.buyBook", true)
-- addEventHandler("market.buyBook", root, function()
-- 	if client ~= source then
-- 		exports.rl_ac:banForEventAbuse(client, eventName)
-- 		return
-- 	end

-- 	price = 150
-- 	if price > 0 then
-- 		takeBalance(client, price)
-- 		for i = 0, 5, 1 do
-- 			exports.rl_items:giveItem(client, 20 + i, 1)
-- 		end
-- 		exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında tüm dövüş kitaplarını satın aldınız.")
-- 		exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında tüm dövüş kitaplarını satın aldı.")
-- 		exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında tüm dövüş kitaplarını satın aldı.")
-- 	else
-- 		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
-- 	end
-- end)

addEvent("market.buyAccountNameChange", true)
addEventHandler("market.buyAccountNameChange", root, function(username, price)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local status, error = exports.rl_account:checkAccountUsername(username)
			if status then
				dbQuery(function(qh, client)
					local res, rows, err = dbPoll(qh, 0)
					if (rows > 0) and (res[1] ~= nil) then
						exports.rl_infobox:addBox(client, "error", "Böyle bir kullanıcı adı bulunuyor.")
					else
						setElementData(client, "account_username", username)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET username = ? WHERE id = ?", username, getElementData(client, "account_id"))
						takeBalance(client, price)
						exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Kullanıcı Adı Değişikliği satın aldınız.")
						exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Kullanıcı Adı Değişikliği satın aldı.")
					marketAddLog(client,"Kullanıcı adı değiştirme",price)
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Kullanıcı Adı Değişikliği satın aldı.")
					end
				end, {client}, exports.rl_mysql:getConnection(), "SELECT username FROM accounts WHERE username = ?", username)
			else
				exports.rl_infobox:addBox(client, "error", error)
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyStarterPackage", true)
addEventHandler("market.buyStarterPackage", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end

	if getElementData(client, "baslangicpack") == true then
		exports.rl_infobox:addBox(client, "error", "Daha önce aldığınız için bu paketi tekrar satın alamazsınız")
		return false
    end

  if getElementData(client, "hours_played") > 10 then
    exports.rl_infobox:addBox(client, "error", "Sunucuda 10 saatten fazla süre geçirdiğiniz için bu paketi satın alamazsınız")
    return false
  end

  price = 99
  if price <= getElementData(client, "balance") then
    for starterPackPrizes, starterPackPrizes in ipairs(starterPackPrizes) do
      if string.find(starterPackPrizes[1], "Para") then
        exports.rl_global:giveMoney(client, tonumber(starterPackPrizes[2]))
      elseif string.find(starterPackPrizes[1], "VIP") then
        charID = tonumber(getElementData(client, "dbid"))
        if exports.rl_vip:isPlayerVIP(charID) then
        --   exports.rl_vip:removeVIP(charID)
        end
        exports.rl_vip:addVIP(client, starterPackPrizes[3], starterPackPrizes[2])
      end
      if starterPackPrizes[4] and type(starterPackPrizes[4]) == "string" and starterPackPrizes[4] == "vehicle" then
        model = starterPackPrizes[2]
        id = starterPackPrizes[3]
        local r5_10 = getElementData(client, "dbid")
        local r6_10 = getPedRotation(client)
        local r7_10, r8_10, r9_10 = getElementPosition(client)
        r7_10 = r7_10 + math.cos(math.rad(r6_10)) * 5
        r8_10 = r8_10 + math.sin(math.rad(r6_10)) * 5
        local r10_10 = createVehicle(model, r7_10, r8_10, r9_10)
        setVehicleColor(r10_10, 255, 255, 255)
        local r11_10, r12_10, r13_10 = getElementRotation(r10_10)
        local r14_10, r15_10 = exports.rl_vehicle:getRandomVariant(model)
        local r16_10 = exports.rl_global:generatePlate()
        local r17_10 = toJSON({
          255,
          255,
          255
        })
        local r18_10 = toJSON({
          0,
          0,
          0
        })
        local r19_10 = toJSON({
          0,
          0,
          0
        })
        local r20_10 = toJSON({
          0,
          0,
          0
        })
        local r21_10 = getElementInterior(client)
        local r22_10 = getElementDimension(client)
        local r25_10 = SmallestID()
        if dbExec(exports.rl_mysql:getConnection(), "\t\t\t\tINSERT INTO vehicles \n\t\t\t\tSET model=?, x=?, y=?, z=?, rotx=0, roty=0, rotz=?, \n\t\t\t\t\tcolor1=?, color2=?, color3=?, color4=?, \n\t\t\t\t\tfaction=?, owner=?, plate=?, currx=?, curry=?, \n\t\t\t\t\tcurrz=?, currrx=0, currry=0, currrz=?, locked=1, \n\t\t\t\t\tinterior=?, currinterior=?, dimension=?, \n\t\t\t\t\tcurrdimension=?, tintedwindows=?, variant1=?, \n\t\t\t\t\tvariant2=?, creationDate=NOW(), createdBy=-1, \n\t\t\t\t\tvehicle_shop_id=?\n\t\t\t", model, r7_10, r8_10, r9_10, r6_10, r17_10, r18_10, r19_10, r20_10, -1, r5_10, r16_10, r7_10, r8_10, r9_10, r6_10, r21_10, r21_10, r22_10, r22_10, 0, r14_10, r15_10, id) then
          dbQuery(function(r0_11, r1_11, r2_11)
            local r3_11, r4_11, r5_11 = dbPoll(r0_11, 0)
            if r4_11 > 0 then
              local r6_11 = r3_11[1].id
              call(getResourceFromName("rl_items"), "deleteAll", 3, r6_11)
              exports.rl_global:giveItem(r1_11, 3, r6_11)
              destroyElement(r2_11)
              exports.rl_vehicle:reloadVehicle(r6_11)
            end
          end, {
            client,
            r10_10
          }, exports.rl_mysql:getConnection(), "SELECT id FROM vehicles WHERE id = LAST_INSERT_ID() LIMIT 1")
        end
      end
    end
    takeBalance(client, price)
	setElementData(client, "baslangicpack", true)
    exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Başlangıç Paketi satın aldınız.")
    exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Başlangıç Paketi satın aldı.")
    exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Başlangıç Paketi satın aldı.")
    marketAddLog(client, "Baslangic Paketi", price)
  else
    exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
  end
end)

addEvent("market.buyVIP", true)
addEventHandler("market.buyVIP", root, function(vip, day, price)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	print("1",getElementData(client, "balance"))
	print("2",price)
	if getElementData(client, "balance") >= price then
		if day >= 7 then
			if price > 0 then
				if not (getElementData(client, "vip") > 0) then
					exports.rl_vip:addVIP(client, vip, day)
					takeBalance(client, price)
					exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. day .. " günlük VIP " .. vip .. " satın aldınız.")
					exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. day .. " günlük VIP " .. vip .. " satın aldı.")
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. day .. " günlük VIP " .. vip .. " satın aldı.")
			marketAddLog(client,"VIP",price)
			else
					exports.rl_infobox:addBox(client, "error", "Zaten VIP üyeliğiniz var.")
				end
			end
		else
			exports.rl_infobox:addBox(client, "error", "Minimum 7 günlük VIP üyelik satın alabilirsiniz.")
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyCharacterSlot", true)
addEventHandler("market.buyCharacterSlot", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 25
	if getElementData(client, "balance") >= price then
		if price > 0 then
			setElementData(client, "max_characters", getElementData(client, "max_characters") + 1)
			dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET max_characters = max_characters + 1 WHERE id = ?", getElementData(client, "account_id"))
			takeBalance(client, price)
			exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Karakter Slotu satın aldınız.")
			exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Karakter Slotu satın aldı.")
			exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Karakter Slotu satın aldı.")
			marketAddLog(client,"Karakter Slotu",price)
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleSlot", true)
addEventHandler("market.buyVehicleSlot", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 25
	if getElementData(client, "balance") >= price then
		if price > 0 then
			setElementData(client, "max_vehicles", getElementData(client, "max_vehicles") + 1)
			dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET max_vehicles = max_vehicles + 1 WHERE id = ?", getElementData(client, "dbid"))
			takeBalance(client, price)
			exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Araç Slotu satın aldınız.")
			exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Araç Slotu satın aldı.")
		marketAddLog(client,"Araç Slotu",price)
		exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Araç Slotu satın aldı.")
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyPropertySlot", true)
addEventHandler("market.buyPropertySlot", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 25
	if getElementData(client, "balance") >= price then
		if price > 0 then
			setElementData(client, "max_interiors", getElementData(client, "max_interiors") + 1)
			dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET max_interiors = max_interiors + 1 WHERE id = ?", getElementData(client, "dbid"))
			takeBalance(client, price)
			exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Mülk Slotu satın aldınız.")
			exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Mülk Slotu satın aldı.")
			marketAddLog(client,"Mulk slotu",price)
			exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Mülk Slotu satın aldı.")
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyRemoveHistory", true)
addEventHandler("market.buyRemoveHistory", root, function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 5
	if getElementData(client, "balance") >= price then
		if price > 0 then
			dbQuery(function(qh, client)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						dbExec(exports.rl_mysql:getConnection(), "DELETE FROM admin_history WHERE id = ?", value.id)
						takeBalance(client, price)
						exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Tarihçe Sildirme satın aldınız.")
						exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Tarihçe Sildirme satın aldı.")
						marketAddLog(client,"History silme",price)
						exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Tarihçe Sildirme satın aldı.")
					end
				else
					exports.rl_infobox:addBox(client, "error", "Hiçbir tarihçeniz yok.")
				end
			end, {client}, exports.rl_mysql:getConnection(), "SELECT id, action FROM admin_history WHERE user = ? ORDER BY date DESC LIMIT 1", getElementData(client, "account_id"))
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyLuckBox", true)
addEventHandler("market.buyLuckBox", root, function(id, quantity, price)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if id == 1 then id = 351
	elseif id == 2 then id = 352
	elseif id == 3 then id = 353
	elseif id == 4 then id = 354 end
	if getElementData(client, "balance") >= price then
		if price > 0 then
			if quantity <= 10 then
				if exports.rl_items:hasSpaceForItem(client, id, 1) then
					for i = 1, quantity do
						exports.rl_global:giveItem(client, id, 1)
					end
					takeBalance(client, price)
					exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. quantity .. " adet şans kutusu satın aldınız.")
					exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. quantity .. " adet şans kutusu satın aldı.")
					marketAddLog(client,"Sans kutusu",price)
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. quantity .. " adet şans kutusu satın aldı.")
				else
					exports.rl_infobox:addBox(client, "error", "Envanteriniz dolu.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Maksimum 10 adet şans kutusu satın alabilirsiniz.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyDupont", true)
addEventHandler("market.buyDupont", root, function(skinId, url, price)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if getElementData(client, "balance") >= price then
		if price > 0 then
			if skinId and url then
				url = (url):gsub("\n", "")
				if (string.find(url, "https://") and (string.find(url, "i.imgur.com")) and (string.find(url, "png") or string.find(url, "jpg") or string.find(url, "jpeg"))) then
					local smallestID = getSmallestID("clothing")
					local itemValue = skinId .. ":" .. smallestID
					
					if exports.rl_items:hasSpaceForItem(client, 16, itemValue) then
						exports.rl_global:giveItem(client, 16, itemValue)
						exports.rl_clothing:addClothing(smallestID, skinId, url, getElementData(client, "dbid"))
						takeBalance(client, price)
						exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Dupont satın aldınız.")
						exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Dupont satın aldı.")
						marketAddLog(client,"Dupont Alımı",price)
						exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Dupont satın aldı.")
					else
						exports.rl_infobox:addBox(client, "error", "Envanteriniz dolu.")
					end
				else
					exports.rl_infobox:addBox(client, "error", "Geçersiz bir URL girdiniz veya girdiğiniz site sunucuyu desteklemiyor.")
					exports.rl_infobox:addBox(client, "error", "Desteklenen resim yükleme sunucuları: i.imgur.com")
				end
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyvehHand", true)
addEventHandler("market.buyvehHand", root, function(id, name, price)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	if getElementData(client, "balance") >= price then
		if price > 0 then
			if getPedOccupiedVehicle(client) then
				local theVehicle = getPedOccupiedVehicle(client)
				if theVehicle then
					if getElementData(client, "dbid") == getElementData(theVehicle, "owner") then
						dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET hand = ? WHERE id = ?", id, getElementData(theVehicle, "dbid"))
						takeBalance(client, price)
						exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında #"..id.." numaralı araca "..name.." aldınız.")
						exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında #"..id.." numaralı araca "..name.." aldı.")
						marketAddLog(client,name.." Alımı",price)
						exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında #"..id.." numaralı araca "..name.." aldı.")
					else
						exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
					end
				else
					exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Bu ürünü satın almak için araçta olmalısın.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyRenameFaction", true)
addEventHandler("market.buyRenameFaction", root, function(r0_12, r1_12)
  if client ~= source then
    return 
  end
  price = 40
  if price <= getElementData(client, "balance") then
    local r2_12 = getElementData(client, "faction")
    local r3_12 = exports.rl_pool:getElement("team", r2_12)
    if r3_12 then
      exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Birlik Adı Değişikliği satın aldınız.")
      exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Birlik Adı Değişikliği satın aldı.")
      exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Birlik Adı Değişikliği satın aldı.")
      marketAddLog(client, "Birlik Adı Değişikliği", price)
      takeBalance(client, price)
      dbExec(exports.rl_mysql:getConnection(), "UPDATE factions SET name=\'" .. r0_12 .. "\', type=\'" .. r1_12 .. "\' WHERE id=\'" .. r2_12 .. "\'")
      setElementData(r3_12, "name", r0_12)
      setTeamName(r3_12, r0_12)
      setElementData(r3_12, "type", r1_12)
    end
  else
    exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
  end
end)

addEvent("market.buyVehiclePlate", true)
addEventHandler("market.buyVehiclePlate", root, function(id, plate)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 30
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.rl_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(client, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh, client)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 and res[1].no == 0 then
							if getVehiclePlateText(theVehicle) ~= plate then
								dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET plate = ? WHERE id = ?", plate, id)
								setElementData(theVehicle, "plate", plate)
								setVehiclePlateText(theVehicle, plate)
								takeBalance(client, price)
								exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Plaka Değişikliği satın aldınız.")
								exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Plaka Değişikliği satın aldı.")
								marketAddLog(client,"Araç Plaka",price)
								exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Plaka Değişikliği satın aldı.")
							else
								exports.rl_infobox:addBox(client, "error", "Araç plakaları aynıdır.")
							end
						else
							exports.rl_infobox:addBox(client, "error", "Böyle bir plaka var.")
						end
					end, {client}, exports.rl_mysql:getConnection(), "SELECT COUNT(*) as no FROM vehicles WHERE plate = ?", plate)
				else
					exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleTintWindows", true)
addEventHandler("market.buyVehicleTintWindows", root, function(id)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 40
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.rl_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(client, "dbid") == getElementData(theVehicle, "owner") then
					dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET tintedwindows = 1 WHERE id = ?", getElementData(theVehicle, "dbid"))
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerEvent("setTintName", theVehicle, player)
						end
					end
					
					setElementData(theVehicle, "tinted", true)
					triggerClientEvent(root, "tintWindows", theVehicle)
					takeBalance(client, price)
					exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Cam Filmi satın aldınız.")
					exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Cam Filmi satın aldı.")
					marketAddLog(client,"Cam Filmi",price)
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Cam Filmi satın aldı.")
				else
					exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyShield", true)
addEventHandler("market.buyShield", root, function(id)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 100
	if getElementData(client, "balance") >= price then
		if price > 0 then
			exports.rl_global:giveItem(client, 61)
			takeBalance(client, price)
			exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Araç Çakarı satın aldınız.")
			exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Araç Çakarı satın aldı.")
			marketAddLog(client,"Araç Çakarı",price)
			exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Araç Çakarı satın aldı.")
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleNeon", true)
addEventHandler("market.buyVehicleNeon", root, function(id, neonIndex)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 60
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.rl_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(client, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh, client)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET neon = ? WHERE id = ?", neonIndex, id)
							setElementData(theVehicle, "tuning.neon", neonIndex)
							takeBalance(client, price)
							exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Neon Sistemi satın aldınız.")
							exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Neon Sistemi satın aldı.")
							marketAddLog(client,"Araç Neon",price)
							exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Neon Sistemi satın aldı.")
						end
					end, {client}, exports.rl_mysql:getConnection(), "SELECT id FROM vehicles WHERE id = ?", id)
				else
					exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleTexture", true)
addEventHandler("market.buyVehicleTexture", root, function(vehicleID, textureData, textureName)
    if client ~= source then return end

    local price = 50
    local vehicle = exports.rl_pool:getElement("vehicle", vehicleID)

    if vehicle and isElement(vehicle) then
        local vehicleDBID = getElementData(vehicle, "dbid")
        local playerDBID = getElementData(client, "dbid")

        if getElementData(vehicle, "owner") == playerDBID then
            if tonumber(getElementData(client, "balance")) < price then
                exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
                return
            end

            setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
            takeBalance(client, price)
            local formattedPrice = exports.rl_global:formatMoney(price)
            exports.rl_infobox:addBox(client, "success", "Başarıyla " .. formattedPrice .. " TL karşılığında Araç Kaplaması satın aldınız.")
            exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. formattedPrice .. " TL karşılığında Araç Kaplaması satın aldı.")
            exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. formattedPrice .. " TL karşılığında Araç Kaplaması satın aldı.")
            triggerEvent("vehtex:addTexture", client, vehicle, textureName, textureData)
            exports.rl_save:saveVehicle(vehicle)
            marketAddLog(client, "Araç Kaplama Alımı (#" .. tostring(vehicle) .. ")", price)
        else
            exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
        end
    else
        exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
    end
end)

addEvent("market.buyVehicleButterflyDoor", true)
addEventHandler("market.buyVehicleButterflyDoor", root, function(id)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 35
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.rl_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(client, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles_custom SET doortype = 2 WHERE id = ?", getElementData(theVehicle, "dbid"))
							setTimer(function() exports["rl_vehicle-manager"]:loadCustomVehProperties(tonumber(id), theVehicle) end, 5000, 1)
						else
							dbQuery(function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									row = res[1]
									dbExec(exports.rl_mysql:getConnection(), "INSERT INTO vehicles_custom SET id = ?, doortype = 2, brand = ?, model = ?, year = ?", getElementData(theVehicle, "dbid"), row.vehbrand, row.vehmodel, row.vehyear)
									setTimer(function() exports["rl_vehicle-manager"]:loadCustomVehProperties(tonumber(id), theVehicle) end, 5000, 1)
								end
							end, exports.rl_mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE id = ?", getElementData(theVehicle, "vehicle_shop_id"))
						end
					end, exports.rl_mysql:getConnection(), "SELECT id FROM vehicles_custom WHERE id = ?", getElementData(theVehicle, "dbid"))
					
					takeBalance(client, price)
					exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Kelebek Kapı satın aldınız.")
					exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Kelebek Kapı satın aldı.")
					marketAddLog(client,"Kelebek Kapı",price)
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Kelebek Kapı satın aldı.")
				else
					exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleDesignPlate", true)
addEventHandler("market.buyVehicleDesignPlate", root, function(id, plateDesignIndex)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	price = 30
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.rl_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(client, "dbid") == getElementData(theVehicle, "owner") then
					dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET plate_design = ? WHERE id = ?", plateDesignIndex, id)
					setElementData(theVehicle, "plate_design", plateDesignIndex)
					takeBalance(client, price)
					exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Plaka Tasarımı satın aldınız.")
					exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Plaka Tasarımı satın aldı.")
					marketAddLog(client,"Plaka Tasarımı",price)
					exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında Plaka Tasarımı satın aldı.")
				else
					exports.rl_infobox:addBox(client, "error", "Bu araç size ait değil.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Böyle bir araç bulunamadı.")
			end
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

function SmallestID()
	local result = dbPoll(dbQuery(exports.rl_mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

-- addEvent("market.buyPrivateVehicle", true)
-- addEventHandler("market.buyPrivateVehicle", root, function(model, id, name, price)
-- 	if client ~= source then
-- 		exports.rl_ac:banForEventAbuse(client, eventName)
-- 		return
-- 	end
-- 	id = tonumber(id)
-- 	if getElementData(client, "balance") >= price then
-- 		if price > 0 then
-- 			local dbid = getElementData(client, "dbid")
-- 			local rotation = getPedRotation(client)
-- 			local x, y, z = getElementPosition(client)
-- 			x = x + ((math.cos(math.rad(rotation))) * 5)
-- 			y = y + ((math.sin(math.rad(rotation))) * 5)
			
-- 			local theVehicle = createVehicle(model, x, y, z)
-- 			setVehicleColor(theVehicle, 255, 255, 255)
			
-- 			local rx, ry, rz = getElementRotation(theVehicle)
-- 			local var1, var2 = exports.rl_vehicle:getRandomVariant(model)
-- 			local plate = exports.rl_global:generatePlate()
-- 			local color1 = toJSON({255, 255, 255})
-- 			local color2 = toJSON({0, 0, 0})
-- 			local color3 = toJSON({0, 0, 0})
-- 			local color4 = toJSON({0, 0, 0})
-- 			local interior, dimension = getElementInterior(client), getElementDimension(client)
-- 			local tint = 0
-- 			local factionVehicle = -1
			
-- 			local smallestID = getSmallestID("vehicles")
-- 			local query = [[
-- 				INSERT INTO vehicles 
-- 				SET model=?, x=?, y=?, z=?, rotx=0, roty=0, rotz=?, 
-- 					color1=?, color2=?, color3=?, color4=?, 
-- 					faction=?, owner=?, plate=?, currx=?, curry=?, 
-- 					currz=?, currrx=0, currry=0, currrz=?, locked=1, 
-- 					interior=?, currinterior=?, dimension=?, 
-- 					currdimension=?, tintedwindows=?, variant1=?, 
-- 					variant2=?, creationDate=NOW(), createdBy=-1, 
-- 					vehicle_shop_id=?
-- 			]]

-- 			local inserted = dbExec(exports.rl_mysql:getConnection(), query, 
-- 				model, x, y, z, rotation, color1, color2, color3, color4, 
-- 				factionVehicle, dbid, plate, x, y, z, rotation, 
-- 				interior, interior, dimension, dimension, tint, var1, var2, id
-- 			)
			
-- 			if inserted then
-- 				dbQuery(function(qh, client, theVehicle)
-- 					local res, rows, err = dbPoll(qh, 0)
-- 					if rows > 0 then
-- 						local insertid = res[1].id
-- 						if not insertid then
-- 							giveBalance(client, balance)
-- 							exports.rl_infobox:addBox(client, "warning", "Aldığın araç veritabanına işlenemediği için bakiyeniz iade edildi.")
-- 							exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı ama veritabanına işlenemediği için bakiyesi iade edildi.")
-- 							exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı ama veritabanına işlenemediği için bakiyesi iade edildi.")
-- 							return false
-- 						end
						
-- 						call(getResourceFromName("rl_items"), "deleteAll", 3, insertid)
-- 						exports.rl_global:giveItem(client, 3, insertid)
-- 						destroyElement(theVehicle)
-- 						exports.rl_vehicle:reloadVehicle(insertid)
-- 						marketAddLog(client,"Donate Araç",price)
-- 						takeBalance(client, price)
-- 						exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " markalı araç satın aldınız.")
-- 						exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı.")
-- 						exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı.")
-- 					end
-- 				end, {client, theVehicle}, exports.rl_mysql:getConnection(), "SELECT id FROM vehicles WHERE id = LAST_INSERT_ID() LIMIT 1")
-- 			end
-- 		end
-- 	else
-- 		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
-- 	end
-- end)

addEvent("market.buyPrivateVehicle", true)
addEventHandler("market.buyPrivateVehicle", root, function(r0_36, r1_36)
  if client ~= source then
    return 
  end
  model = tonumber(PRIVATE_VEHICLES[r0_36][2])
  id = tonumber(PRIVATE_VEHICLES[r0_36][3])
  name = PRIVATE_VEHICLES[r0_36][1]
  local r2_36 = PRIVATE_VEHICLES[r0_36][4].discountPrice

  if not r2_36 then
    r2_36 = tonumber(PRIVATE_VEHICLES[r0_36][4].price) or tonumber(PRIVATE_VEHICLES[r0_36][4].discountPrice)
  end

  price = r2_36
  if r1_36.vehiclePlate then
    price = price + EXTRA_VEHICLE_PLATE
  end
  if r1_36.windowTint then
    price = price + EXTRA_VEHICLE_WINDOW_TINT
  end
  if price <= getElementData(client, "balance") then
    if price > 0 then
      r2_36 = getElementData(client, "dbid")
      local r3_36 = getPedRotation(client)
      local r4_36, r5_36, r6_36 = getElementPosition(client)
      r4_36 = r4_36 + math.cos(math.rad(r3_36)) * 5
      r5_36 = r5_36 + math.sin(math.rad(r3_36)) * 5
      local r7_36 = createVehicle(model, r4_36, r5_36, r6_36)
      setVehicleColor(r7_36, 255, 255, 255)
      local r8_36, r9_36, r10_36 = getElementRotation(r7_36)
      local r11_36, r12_36 = exports.rl_vehicle:getRandomVariant(model)
      local r13_36 = exports.rl_global:generatePlate()
      local r14_36 = toJSON({
        255,
        255,
        255
      })
      local r15_36 = toJSON({
        0,
        0,
        0
      })
      local r16_36 = toJSON({
        0,
        0,
        0
      })
      local r17_36 = toJSON({
        0,
        0,
        0
      })
      local r18_36 = getElementInterior(client)
      local r19_36 = getElementDimension(client)
      local r22_36 = SmallestID()
      if dbExec(exports.rl_mysql:getConnection(), "\t\t\t\tINSERT INTO vehicles \n\t\t\t\tSET model=?, x=?, y=?, z=?, rotx=0, roty=0, rotz=?, \n\t\t\t\t\tcolor1=?, color2=?, color3=?, color4=?, \n\t\t\t\t\tfaction=?, owner=?, plate=?, currx=?, curry=?, \n\t\t\t\t\tcurrz=?, currrx=0, currry=0, currrz=?, locked=1, \n\t\t\t\t\tinterior=?, currinterior=?, dimension=?, \n\t\t\t\t\tcurrdimension=?, tintedwindows=?, variant1=?, \n\t\t\t\t\tvariant2=?, creationDate=NOW(), createdBy=-1, \n\t\t\t\t\tvehicle_shop_id=?\n\t\t\t", model, r4_36, r5_36, r6_36, r3_36, r14_36, r15_36, r16_36, r17_36, -1, r2_36, r13_36, r4_36, r5_36, r6_36, r3_36, r18_36, r18_36, r19_36, r19_36, 0, r11_36, r12_36, id) then
        dbQuery(function(r0_37, r1_37, r2_37)
          local r3_37, r4_37, r5_37 = dbPoll(r0_37, 0)
          if r4_37 > 0 then
            local r6_37 = r3_37[1].id
            if not r6_37 then
              giveBalance(r1_37, balance)
              exports.rl_infobox:addBox(r1_37, "warning", "Aldığın araç veritabanına işlenemediği için bakiyeniz iade edildi.")
              exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(r1_37):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı ama veritabanına işlenemediği için bakiyesi iade edildi.")
              exports.rl_logs:addLog("market", getPlayerName(r1_37):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı ama veritabanına işlenemediği için bakiyesi iade edildi.")
              return false
            end
            call(getResourceFromName("rl_items"), "deleteAll", 3, r6_37)
            if r1_36.windowTint then
              dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET tintedwindows = 1 WHERE id = ?", r6_37)
              setElementData(r2_37, "tinted", true)
              exports.rl_save:saveVehicle(r2_37)
              triggerClientEvent(root, "tintWindows", r2_37)
            end
            if r1_36.vehiclePlate then
              dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET plate = ? WHERE id = ?", r1_36.plateText, r6_37)
              setElementData(r2_37, "plate", r1_36.plateText)
              setVehiclePlateText(r2_37, r1_36.plateText)
              exports.rl_save:saveVehicle(r2_37)
            end
            exports.rl_global:giveItem(r1_37, 3, r6_37)
            destroyElement(r2_37)
            exports.rl_vehicle:reloadVehicle(r6_37)
            takeBalance(r1_37, price)
            exports.rl_infobox:addBox(r1_37, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " markalı araç satın aldınız.")
            exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(r1_37):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı.")
            exports.rl_logs:addLog("market", getPlayerName(r1_37):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı.")
            marketAddLog(r1_37, "Ozel Arac (#" .. r6_37 .. " - " .. name .. " (" .. getVehicleNameFromModel(model) .. "))", price)
          end
        end, {
          client,
          r7_36
        }, exports.rl_mysql:getConnection(), "SELECT id FROM vehicles WHERE id = LAST_INSERT_ID() LIMIT 1")
      end
    end
  else
    exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
  end
end)

addEvent("market.buyPrivateWeapon", true)
addEventHandler("market.buyPrivateWeapon", root, function(r0_38)
  if client ~= source then
    return 
  end
  model = PRIVATE_WEAPONS[r0_38][3]
  local r1_38 = PRIVATE_WEAPONS[r0_38][4].discountPrice
  if not r1_38 then
    r1_38 = tonumber(PRIVATE_WEAPONS[r0_38][4].price) or tonumber(PRIVATE_WEAPONS[r0_38][4].discountPrice)
  end
  price = r1_38
  if price <= getElementData(client, "balance") then
    if price > 0 then
      local r3_38 = exports.rl_global:createWeaponSerial(1, tonumber(getElementData(client, "dbid")), tonumber(getElementData(client, "dbid")))
      if exports.rl_items:hasSpaceForItem(client, 115, model .. ":" .. r3_38 .. ":" .. getWeaponNameFromID(model) .. "::") then
        exports.rl_global:giveItem(client, 115, model .. ":" .. r3_38 .. ":" .. getWeaponNameFromID(model) .. "::")
        takeBalance(client, price)
        exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldınız.")
        exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldı.")
        exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldı.")
        marketAddLog(client, "Ozel Silah (" .. getWeaponNameFromID(model) .. ")", price)
      else
        exports.rl_infobox:addBox(client, "error", "Envanteriniz dolu.")
      end
    end
  else
    exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
  end
end)

-- addEvent("market.buyPrivateWeapon", true)
-- addEventHandler("market.buyPrivateWeapon", root, function(model, price)
-- 	if client ~= source then
-- 		exports.rl_ac:banForEventAbuse(client, eventName)
-- 		return
-- 	end
	
-- 	if getElementData(client, "balance") >= price then
-- 		if price > 0 then
-- 			local serial1 = tonumber(getElementData(client, "dbid"))
-- 			local serial2 = tonumber(getElementData(client, "dbid"))
-- 			local mySerial = exports.rl_global:createWeaponSerial(1, serial1, serial2)
			
-- 			if exports.rl_items:hasSpaceForItem(client, 115, model .. ":" .. mySerial .. ":" .. getWeaponNameFromID(model) .. "::") then
-- 				exports.rl_global:giveItem(client, 115, model .. ":" .. mySerial .. ":" .. getWeaponNameFromID(model) .. "::")
-- 				takeBalance(client, price)
-- 				exports.rl_infobox:addBox(client, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldınız.")
-- 				marketAddLog(client,"Donate Silah",price)
-- 				exports.rl_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldı.")
-- 				exports.rl_logs:addLog("market", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.rl_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldı.")
-- 			else
-- 				exports.rl_infobox:addBox(client, "error", "Envanteriniz dolu.")
-- 			end
-- 		end
-- 	else
-- 		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
-- 	end
-- end)

function giveBalance(thePlayer, amount)
	amount = math.floor(tonumber(amount))
	setElementData(thePlayer, "balance", getElementData(thePlayer, "balance") + amount)
	dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance"), getElementData(thePlayer, "account_id"))
end

function takeBalance(thePlayer, amount)
	amount = math.floor(tonumber(amount))
	setElementData(thePlayer, "balance", getElementData(thePlayer, "balance") - amount)
	dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance"), getElementData(thePlayer, "account_id"))
end

function setBalance(thePlayer, amount)
	amount = math.floor(tonumber(amount))
	setElementData(thePlayer, "balance", amount)
	dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance"), getElementData(thePlayer, "account_id"))
end

function getSmallestID(tableName)
	local query = dbQuery(exports.rl_mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM " .. tableName .. " AS e1 LEFT JOIN " .. tableName .. " AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end


addEvent("market.bakiyegecmisver",true)
addEventHandler("market.bakiyegecmisver",root,function(pl)
	dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then 
                for _, row in ipairs(res) do
					triggerClientEvent(pl,"market.loadBalanceHistory",pl,res)
                end
            end
        end,
        exports.rl_mysql:getConnection(),
        "SELECT created_on, amount, payment_platform FROM bakiyelog WHERE id = ?", getElementData(pl, "account_id")
	)
end)

addEvent("market.gecmisver",true)
addEventHandler("market.gecmisver",root,function(pl)
	dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then 
                for _, row in ipairs(res) do
					triggerClientEvent(pl,"market.loadMarketHistory",pl,res)
                end
            end
        end,
        exports.rl_mysql:getConnection(),
        "SELECT product_name, price, buying_date FROM marketlog WHERE id = ?", getElementData(pl, "account_id")
	)
end)

addEvent("market.paraCevir",true)
addEventHandler("market.paraCevir",root,function(pl,price,verilcek)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	if getElementData(pl, "balance") >= price then
		if price > 0 then
			exports.rl_global:giveMoney(pl,verilcek)
			takeBalance(pl, price)
			exports.rl_infobox:addBox(pl, "success", "Başarıyla " .. exports.rl_global:formatMoney(price) .. " TL bakiyeyi paraya çevirdiniz.")
			triggerClientEvent(pl,"market.donmeSil",pl)
			marketAddLog(pl,"Para Çevirme",price)

		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)

function marketAddLog(thePlayer,urunadi,fiyat)
	-- iprint(thePlayer,urunadi,fiyat)
	local time = getRealTime()
	local timestamp = string.format("%04d-%02d-%02d %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
	dbExec(exports.rl_mysql:getConnection(),  "INSERT INTO `marketlog` SET `id` = '"..getElementData(thePlayer,"account_id").."', `product_name` = '"..urunadi.."', `price` = '"..fiyat.."', `buying_date` = '"..timestamp.."'")
end

addEvent("market.buyUnjail",true)
addEventHandler("market.buyUnjail",root,function()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	local price = getJailPrice(client)
	if getElementData(client, "balance") >= price then
		if price > 0 then
			local accountID = getElementData(client, "account_id")
			local spawnPosition = exports.rl_global:getServerSettings().spawnPosition
			dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET adminjail_time = '0', adminjail = '0' WHERE id = ?", accountID)

			if isTimer(jailed) then
				killTimer(jailed)
			end

			setElementData(client, "jail_timer", false)
			setElementData(client, "adminjailed", false)
			setElementData(client, "jailreason", false)
			setElementData(client, "jail_time", false)
			setElementData(client, "jailadmin", false)
   			spawnPosition = exports.rl_global:getServerSettings().spawnPosition
    		setElementPosition(client, spawnPosition.x, spawnPosition.y, spawnPosition.z)
    		setPedRotation(client, 303)
			setElementDimension(client, 0)
			setElementInterior(client, 0)
			setCameraInterior(client, 0)
			takeBalance(client, tonumber(price))
			outputChatBox("[!]#FFFFFF Hapis süreniz bitti.", client, 0, 255, 0, true)
			marketAddLog(client, "Jail Açtırma", price)
		end
	else
		exports.rl_infobox:addBox(client, "error", "Yeterli bakiyeniz yok.")
	end
end)