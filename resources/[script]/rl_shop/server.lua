local mysql = exports.rl_mysql
local shop = new("shops")

function shop.prototype.____constructor(self)
    self._function = {
        load = function(...) self:load(...) end, 
        load_all = function(...) self:load_all(...) end, 
        create = function(...) self:create(...) end, 
        nearbys = function(...) self:nearbys(...) end, 
        delete = function(...) self:delete(...) end, 
        teleport = function(...) self:teleport(...) end, 
        buy = function(...) self:buy(...) end, 
    }

    self._shop, self._count, self._npc = {}, 0, 0
    setTimer(self._function.load_all, 1000, 1)
    
    addCommandHandler("makeshop", self._function.create, false, false)
    addCommandHandler("nearbyshops", self._function.nearbys, false, false)
    addCommandHandler("delshop", self._function.delete, false, false)
    addCommandHandler("gotoshop", self._function.teleport, false, false)

    addEvent("shop.buy", true)
    addEventHandler("shop.buy", root, self._function.buy)
end

function shop.prototype.buy(self, shopID, itemID, quantity)
    if client ~= source then
        exports.rl_ac:banForEventAbuse(client, eventName)
        return
    end

	quantity = math.floor(tonumber(quantity) or 1) or 1

    if shopID and itemID and tonumber(shopID) and tonumber(itemID) and quantity then
        -- Special case: Shop type 9 = Sell 368 for money
        if tonumber(shopID) == 9 then
            if exports.rl_global:hasItem(client, 368) then
                exports.rl_global:takeItem(client, 368, 1)
                exports.rl_global:giveMoney(client, 2000)
                outputChatBox("[!]#FFFFFF Envanterinizden 1 adet kenevir satıldı. 2,000$ kazandınız.", client, 0, 255, 0, true)
                exports.rl_logs:addLog("shop", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu kenevir satarak $2,000 kazandı.")
            else
                outputChatBox("[!]#FFFFFF Envanterinizde Paketlenmiş Kenevir Yok.", client, 255, 0, 0, true)
                playSoundFrontEnd(client, 4)
            end
            return
        end
        if quantity >= 1 and quantity <= 10 then
            local item = shopItems[shopID][itemID]
            if item[1] and item[2] and item[3] then
                local totalPrice = item[2] * quantity
                if exports.rl_global:hasMoney(client, totalPrice) then
                    local hasSpace = true
                    for i = 1, quantity do
                        if not exports.rl_items:hasSpaceForItem(client, item[1], item[3]) then
                            hasSpace = false
                            outputChatBox("[!]#FFFFFF Bu ürünü taşımak için yeterli alanınız yok.", client, 255, 0, 0, true)
                            playSoundFrontEnd(client, 4)
                            break
                        end
                    end

                    if hasSpace then
                        exports.rl_global:takeMoney(client, totalPrice)

						if item[1] ~= 115 and item[1] ~= 116 then
							for i = 1, quantity do
								exports.rl_items:giveItem(client, item[1], item[3])
							end
						end

                        if item[1] == 56 then 
                            outputChatBox("[!]#FFFFFF Başarıyla $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet Maske aldınız.", client, 0, 255, 0, true)
                            exports.rl_logs:addLog("shop", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet Maske aldı.")
                        elseif item[1] == 115 then
                            for i = 1, quantity do
                                local weaponSerial = exports.rl_global:createWeaponSerial(1, tonumber(getElementData(client, "dbid")), tonumber(getElementData(client, "dbid")))
                                local itemValue = item[3] .. ":" .. weaponSerial .. ":" .. getWeaponNameFromID(item[3]) .. "::"
                                exports.rl_items:giveItem(client, item[1], itemValue)
                            end
                            outputChatBox("[!]#FFFFFF Başarıyla $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet " .. getWeaponNameFromID(item[3]) .. " aldınız.", client, 0, 255, 0, true)
                            exports.rl_logs:addLog("shop", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet " .. getWeaponNameFromID(item[3]) .. " aldı.")
                        elseif item[1] == 116 then
                            for i = 1, quantity do
                                local itemValue = item[3] .. ":" .. item[4] .. ":" .. getWeaponNameFromID(item[3]) .. " Mermisi"
                                exports.rl_items:giveItem(client, item[1], itemValue)
                            end
                            outputChatBox("[!]#FFFFFF Başarıyla $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet şarjör aldınız.", client, 0, 255, 0, true)
                        else
                            outputChatBox("[!]#FFFFFF Başarıyla $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet " .. exports.rl_items:getItemName(item[1]) .. " aldınız.", client, 0, 255, 0, true)
                            exports.rl_logs:addLog("shop", getPlayerName(client):gsub("_", " ") .. " isimli oyuncu $" .. exports.rl_global:formatMoney(totalPrice) .. " karşılığında " .. quantity .. " adet " .. exports.rl_items:getItemName(item[1]) .. " aldı.")
                        end
                    end
                else
                    outputChatBox("[!]#FFFFFF " .. (item[1] == 115 and getWeaponNameFromID(item[3]) or exports.rl_items:getItemName(item[1])) .. " isimli eşyayı satın almak için yeterli paranız yok.", client, 255, 0, 0, true)
                    playSoundFrontEnd(client, 4)
                end
            end
        else
            outputChatBox("[!]#FFFFFF Minimum 1, maksimum 10 adet ürün satın alabilirsiniz.", client, 255, 0, 0, true)
			playSoundFrontEnd(client, 4)
        end
    end
end

function shop.prototype.create(self, thePlayer, commandName, type, skin, name)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then
        -- make skin/name optional: default -1 for random
        if skin == nil or skin == "" then skin = -1 end
        if name == nil or name == "" then name = -1 end
        local maxType = 9
        if not tonumber(type) or not tonumber(skin) or not name or tonumber(type) > maxType or tonumber(type) < 0 then
            outputChatBox("KULLANIM: /" .. commandName .. " [Tür] [Skin | -1 = Random] [Karakter Adı | -1 = Random]", thePlayer, 255, 194, 14)
		    outputChatBox("[!]#FFFFFF Tür: 1 = Genel Mağaza", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 2 = Yemek Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 3 = Elektronik Mağaza", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 4 = Spor Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 5 = Silah Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 6 = Mermi Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 7 = Sağlık Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 8 = Özel Satış (369)", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tür: 9 = Özel Satış (368)", thePlayer, 0, 0, 255, true)
        else
			local randomGender = math.random(0, 1)
			
			if tonumber(skin) == -1 then
				skin = exports.rl_global:getRandomSkin(randomGender)
			end
			
			if tonumber(name) == -1 then
				name = exports.rl_global:getRandomName("full", randomGender)
				name = string.gsub(name, " ", "_")
			end
			
            dbQuery(function(qh)
                local result = dbPoll(qh, 0)
                if result and #result > 0 then 
                    outputChatBox("[!]#FFFFFF Bu isimde bir NPC mağazası zaten mevcut.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                else 
                    local type = math.floor(tonumber(type))
                    local x, y, z = getElementPosition(thePlayer)
                    local _, _, rot = getElementRotation(thePlayer)
                    local interior, dimension = getElementInterior(thePlayer), getElementDimension(thePlayer)
                    local names = types[type]
                    dbQuery(function(qh)
                        local result, _, id = dbPoll(qh, 0)
                        if id then
                            self._function.load(id)
                            outputChatBox("[!]#FFFFFF Yeni NPC mağazası (ID: " .. id .. " - " .. names .. ") oluşturdunuz.", thePlayer, 0, 255, 0, true)
                        else 
                            outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
                        end
                    end, mysql:getConnection(), "INSERT INTO shops SET skin = ?, x = ?, y = ?, z = ?, rotation = ?, dimension = ?, interior = ?, shoptype = ?, pedName = ?", skin, x, y, z, rot, dimension, interior, type, tostring(name))
                end
            end, mysql:getConnection(), "SELECT * FROM shops WHERE pedName = ?", name)
        end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.nearbys(self, thePlayer, commandName)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then
        local px, py, pz = getElementPosition(thePlayer)
        for k, v in pairs(getElementsByType("ped", resourceRoot, true)) do 
            if getElementData(v, "shop.type") or false then 
                local x, y, z = getElementPosition(v)
                local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
                if distance <= 20 then 
                    outputChatBox("[!]#FFFFFF ID: " .. getElementData(v, "shop.id") .. " - Tür: (#" .. getElementData(v, "shop.type") .. ") - Mesafe: " .. math.ceil(distance) .. " m.", thePlayer, 0, 0, 255, true)
                    self._npc = self._npc + 1
                end
            end
        end
		
        if self._npc == 0 then 
            outputChatBox("[!]#FFFFFF Size yakın NPC mağazası yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
                end
            else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.delete(self, thePlayer, commandName, id)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then 
        if not id or not tonumber(id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
			return
		end
		
        local id = math.floor(tonumber(id))
        if self._shop[id] then
            local ped = self._shop[id]
            if isElement(ped) then
                destroyElement(ped)
            end
            dbExec(mysql:getConnection(), "DELETE FROM shops WHERE id = ?", id)
            outputChatBox("[!]#FFFFFF Başarıyla [" .. id .. "] ID'li NPC mağazayı sildiniz.", thePlayer, 0, 255, 0, true)
        else
            outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li bir NPC mağazası yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.teleport(self, thePlayer, commandName, id)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then 
        if not id or not tonumber(id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
			return
		end
		
        local id = math.floor(tonumber(id))
        if self._shop[id] then 
            local ped = self._shop[id]
            if isElement(ped) then 
                local x, y, z = getElementPosition(ped)
                local rot = getElementRotation(ped)
                local dim = getElementDimension(ped)
                local int = getElementInterior(ped)
                if not isPedInVehicle(thePlayer) then
                    setElementPosition(thePlayer, x, y, z)
                    setElementInterior(thePlayer, int)
                    setElementDimension(thePlayer, dim)
                    outputChatBox("[!]#FFFFFF Başarıyla [" .. id .. "] ID'li NPC mağazaya ışınlandınız.", thePlayer, 0, 255, 0, true)
                else
                    outputChatBox("[!]#FFFFFF Araçtayken bu işlemi gerçekleştiremezsiniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                end                   
            end
        else
            outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li bir NPC mağazası yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.load(self, id)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if #result > 0 then 
            for k, v in pairs(result) do 
                local ped = createPed(v.skin, v.x, v.y, v.z, v.rotation, false)
                setElementDimension(ped, v.dimension)
                setElementInterior(ped, v.interior)
                setElementFrozen(ped, true)
                setElementData(ped, "talk", 1)
                setElementData(ped, "shop.id", v.id)
                setElementData(ped, "shop.type", v.shoptype)
                setElementData(ped, "name", v.pedName)
                self._shop[v.id] = ped
				setPedWalkingStyle(self._shop[v.id], 118)
            end
        end
    end, mysql:getConnection(), "SELECT * FROM shops WHERE id = ? AND deletedBy = 0", id)
end

function shop.prototype.load_all(self)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if #result > 0 then 
            for k, v in pairs(result) do 
                self._function.load(v.id)
                self._count = self._count + 1
            end
        end
    end, mysql:getConnection(), "SELECT id FROM shops")
end

function generateUniquePhoneNumber()
    local attempts = 0
    while true do
        attempts = attempts + 1
        local itemValue = math.random(311111, attempts < 20 and 899999 or 8999999)
        
        local query = dbQuery(mysql:getConnection(), "SELECT `phonenumber` FROM `phones` WHERE `phonenumber` = ?", itemValue)
        local result = dbPoll(query, -1)

        if result and #result == 0 then
            return itemValue
        end
    end
end

addEvent("shop:storeKeeperSay", true)
addEventHandler("shop:storeKeeperSay", root, function(thePlayer, content, pedName)
	if client ~= source then
		return
	end
	
	pedName = string.gsub(pedName, "_" , " ")
	exports.rl_global:sendLocalText(thePlayer, tostring(pedName) .. ": " .. content, 255, 255, 255, 30, {}, true)
end)

load(shop)