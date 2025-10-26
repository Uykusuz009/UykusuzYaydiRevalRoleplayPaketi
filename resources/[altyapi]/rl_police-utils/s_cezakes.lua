function cezaKes(thePlayer, commandName, amount, ...)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 3) then
		amount = tonumber(amount)
		if amount then
			if (...) then
				if amount > 0 then
					local plate = table.concat({...}, " ")
					local foundVehicle = nil
					
					for k, v in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
						if plate == getElementData(v, "plate") then
							foundVehicle = v
						end
					end
					
					if foundVehicle ~= nil then
						local px, py, pz = getElementPosition(thePlayer)
						local vx, vy, vz = getElementPosition(foundVehicle)
						local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
						if distance <= 10 then
							local dbid = getElementData(foundVehicle, "dbid")
							if dbid and dbid > 0 then
								local punishment = getElementData(foundVehicle, "punishment") or 0
								dbExec(mysql:getConnection(), "UPDATE vehicles SET punishment = " .. punishment + amount .. " WHERE id = " .. dbid)
								setElementData(foundVehicle, "enginebroke", 1)
								setElementData(foundVehicle, "punishment", punishment + amount)
								exports.rl_global:sendLocalMeAction(thePlayer, "ceza makbuzunu aracın camı ile sileceğin arasına sıkıştırır.")
							else
								outputChatBox("[!]#FFFFFF Bu araca ceza kesemezsiniz.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF '" .. getElementData(foundVehicle, "plate") .. "' plakalı araca yeterince yakın değilsiniz.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu plakalı araç bulunamadı.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Lütfen geçerli bir ceza tutarı giriniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Ceza Tutarı] [Plaka]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Ceza Tutarı] [Plaka]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("cezakes", cezaKes, false, false)



















local radarObjectID = 1918
local speedLimit = 150 -- km/h
local fineAmount = 2000
local detectionRadius = 20 -- metre
local checkInterval = 1000 -- ms
local cooldownTime = 2 * 60 * 1000 -- 2 dakika

local radarZones = {}
local playerCooldowns = {}

-- Radarları yükle
addEventHandler("onResourceStart", resourceRoot, function()
    for _, obj in ipairs(getElementsByType("object")) do
        if getElementModel(obj) == radarObjectID then
            local x, y, z = getElementPosition(obj)
            table.insert(radarZones, {x = x, y = y, z = z})
            outputDebugString("Radar yuklendi x="..x..", y="..y)
        end
    end
end)

local function issueFine(player, speed)
    local faction = getElementData(player, "faction")
    if faction == 1 or tostring(faction) == "1" then
       -- outputDebugString("[Radar] Oyuncu faction 1'de, ceza uygulanmadı: " .. getPlayerName(player))
        return
    end

    local veh = getPedOccupiedVehicle(player)
    if not veh then return end

    local oldTax = getElementData(veh, "toplamvergi") or 0
    setElementData(veh, "toplamvergi", oldTax + fineAmount)

    triggerClientEvent(player, "playRadarFineSound", resourceRoot)
    playerCooldowns[player] = getTickCount()
end



-- Radar kontrolü
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        local veh = getPedOccupiedVehicle(player)
        if veh and getVehicleController(veh) == player then
            local px, py, pz = getElementPosition(veh)
            local vx, vy, vz = getElementVelocity(veh)
            local speed = math.sqrt(vx^2 + vy^2 + vz^2) * 180 -- km/h

            for _, radar in ipairs(radarZones) do
                local dist = getDistanceBetweenPoints3D(px, py, pz, radar.x, radar.y, radar.z)
                if dist <= detectionRadius and speed > speedLimit then
                    local lastFineTime = playerCooldowns[player] or 0
                    if getTickCount() - lastFineTime >= cooldownTime then
                        issueFine(player, speed)
                    end
                    break -- aynı anda birden fazla radardan ceza yemesin
                end
            end
        end
    end
end, checkInterval, 0)

-- Oyuncu çıkarsa cooldown temizlenir
addEventHandler("onPlayerQuit", root, function()
    playerCooldowns[source] = nil
end)
