local secretHandle = 'some_shit_that_is_really_secured'

function changeProtectedElementData(thePlayer, index, newvalue)
	setElementData(thePlayer, index, newvalue)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		setElementData(thePlayer, index, newvalue)
		return true
	end
	return false
end


armoredCars = { [567]=true, [580]=true, [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [490]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar

local btrdiscountratio = 1.2

-- Full Service
function serviceVehicle(veh)
	if (veh) then
		local mechcost = 110
		if tonumber(getElementData(source, "job")) == 7 then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.rl_global:takeMoney(source, mechcost) then
			outputChatBox("Bu araca bakım yapacak parçaları almaya gücünüz yetmez.", source, 255, 0, 0)
		else
			local health = getElementHealth(veh)
			if (health <= 850) then
				health = health + 150
			else
				health = 1000
			end
			
			fixVehicle(veh)
			setElementHealth(veh, health)
			if not getElementData(veh, "Impounded") or getElementData(veh, "Impounded") == 0 then
				--exports.rl_anticheat:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
				if armoredCars[ getElementModel( veh ) ] then
					setVehicleDamageProof(veh, true)
				else
					setVehicleDamageProof(veh, false)
				end
			end
			exports.rl_global:sendLocalMeAction(source, "araca bakım yapıyor, biraz yama yapıyor.")
			--exports.logs:dbLog(source, 31, {  veh }, "REPAIR QUICK-SERVICE")
		end
	else
		outputChatBox("Servis yapmak istediğiniz araçta olmanız gerekmektedir.", source, 255, 0, 0)
	end
end
addEvent("serviceVehicle", true)
addEventHandler("serviceVehicle", getRootElement(), serviceVehicle)

function changeTyre( veh, wheelNumber )
	if (veh) then
		local mechcost = 10
		if tonumber(getElementData(source, "job")) == 7 then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.rl_global:takeMoney(source, mechcost) then
			outputChatBox("YBu aracın lastiklerini değiştirecek parçaları almaya paranız yetmez.", source, 255, 0, 0)
		else
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates( veh )

			if (wheelNumber==1) then -- front left
				outputDebugString("Lastik 1 değişti.")
				setVehicleWheelStates ( veh, 0, wheel2, wheel3, wheel4 )
			elseif (wheelNumber==2) then -- back left
				outputDebugString("Lastik 2 değişti.")
				setVehicleWheelStates ( veh, wheel1, wheel2, 0, wheel4 )
			elseif (wheelNumber==3) then -- front right
				outputDebugString("Lastik 3 değişti.")
				setVehicleWheelStates ( veh, wheel1, 0, wheel2, wheel4 )
			elseif (wheelNumber==4) then -- back right
				outputDebugString("Lastik 4 değişti.")
				setVehicleWheelStates ( veh, wheel1, wheel2, wheel3, 0 )
			end
			
			--exports.logs:dbLog(source, 31, {  veh }, "REPAIR TIRESWAP")
			exports.rl_global:sendLocalMeAction(source, "aracın lastiğini değiştirir.")
		end
	end
end
addEvent("tyreChange", true)
addEventHandler("tyreChange", getRootElement(), changeTyre)

function changePaintjob( veh, paintjob )
	if (veh) then
		local mechcost = 4000
		if tonumber(getElementData(source, "job")) == 7 then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.rl_global:takeMoney(source, mechcost) then
			outputChatBox("Bu aracı yeniden boyamaya gücünüz yetmez.", source, 255, 0, 0)
		else
			triggerEvent( "paintjobEndPreview", source, veh )
			if setVehiclePaintjob( veh, paintjob ) then
				local col1, col2 = getVehicleColor( veh )
				if col1 == 0 or col2 == 0 then
					setVehicleColor( veh, 1, 1, 1, 1 )
				end
				--exports.logs:logMessage("[/changePaintJob] " .. getPlayerName(source) .." / ".. getPlayerIP(source)  .." OR " .. getPlayerName(client)  .." / ".. getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " their colors to " .. col1 .. "-" .. col2, 29)
				exports.rl_global:sendLocalMeAction(source, "repaints the vehicle.")
				--exports.logs:dbLog(source, 6, {  veh }, "MODDING PAINTJOB ".. paintjob)
				--exports['save']:saveVehicleMods(veh)
			else
				outputChatBox("Bu arabanın zaten bu boyası var.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("paintjobChange", true)
addEventHandler("paintjobChange", getRootElement(), changePaintjob)

function editVehicleHeadlights(veh, color1, color2, color3)
    if (veh) then
        local mechcost = 5000
        if tonumber(getElementData(source, "job")) == 7 then
            mechcost = mechcost / btrdiscountratio
        end
        if not exports.rl_global:takeMoney(source, mechcost) then
            outputChatBox("Bu aracı modifiye etmeye gücünüz yetmez.", source, 255, 0, 0)
        else
            triggerEvent("headlightEndPreview", source, veh)
            if setVehicleHeadLightColor(veh, color1, color2, color3) then
                -- Farları değiştirme işlemi başarılıysa veritabanına kaydetme
                local vehID = getElementData(veh, "dbid")
                local headlightColor = toJSON({color1, color2, color3})  -- Veritabanına kaydetmek için JSON formatına dönüştürülüyor

                -- Veritabanı işlemi
                local conn = exports.rl_mysql:getConn()
                local query = dbExec(conn, "UPDATE vehicles SET headlights = '" .. headlightColor .. "' WHERE id='" .. vehID .. "'")

                if query then
                    outputChatBox("Araç farlarının rengini değiştirdiniz ve veritabanına kaydettiniz.", source)
                    exports.rl_global:sendLocalMeAction(source, "Araç farlarının yerini alır.")
                else
                    outputChatBox("Far rengini kaydederken bir hata oluştu. Lütfen tekrar deneyin.", source, 255, 0, 0)
                end

                -- Logs: İsteğe bağlı olarak loglama işlemi eklenebilir
                -- exports.logs:logMessage("[/changeHeadlights] " .. getPlayerName(source) .." / ".. getPlayerIP(source)  .." changed vehicle " .. getElementData(veh, "dbid") .. " headlights to " .. headlightColor, 29)
            else
                outputChatBox("Bu arabada zaten bu farlar var.", source, 255, 0, 0)
            end
        end
    end
end
addEvent("editVehicleHeadlights", true)
addEventHandler("editVehicleHeadlights", getRootElement(), editVehicleHeadlights)


 -- 

function changeVehicleUpgrade( veh, upgrade )
	if (veh) then
		local item = false
		local u = upgrades[upgrade - 999]
		if not u then
			outputDebugString( getPlayerName( source ) .. " geçersiz yükseltme eklemeye çalıştım #" .. upgrade )
			return
		end
		name = u[1]
		local mechcost = u[2]
		if tonumber(getElementData(source, "job")) == 7 then
			mechcost = mechcost / btrdiscountratio
		end
		if exports.rl_global:hasItem( source, 114, upgrade ) then
			mechcost = 0
			item = true
		end
		
		if not item and not exports.rl_global:hasMoney( source, mechcost ) then
			outputChatBox("Eklemeye gücünüz yetmez " .. name .. " bu araca.", source, 255, 0, 0)
		else
			for i = 0, 16 do
				if upgrade == getVehicleUpgradeOnSlot( veh, i ) then
					outputChatBox("Bu arabada zaten bu yükseltme var.", source, 255, 0, 0)
					return
				end
			end
			if addVehicleUpgrade( veh, upgrade ) then
				if item then
					exports.rl_global:takeItem(source, 114, upgrade)
				else
					exports.rl_global:takeMoney(source, mechcost)
				end
				--exports.logs:logMessage("[changeVehicleUpgrade] " .. getPlayerName(source) .."/ " .. getPlayerIP(source)  .. " OR " .. getPlayerName(client)  .."/ " .. getPlayerIP(client)  .. "  changed vehicle " .. getElementData(veh, "dbid") .. ": added " .. name .. " to the vehicle.", 29)
				exports.rl_global:sendLocalMeAction(source, "katma " .. name .. " araca.")
				--exports['save']:saveVehicleMods(veh)
				--exports.logs:dbLog(source, 6, {  veh }, "MODDING ADDUPGRADE "..name)
			else
				outputChatBox("Araç yükseltmesi uygulanamadı.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("changeVehicleUpgrade", true)
addEventHandler("changeVehicleUpgrade", getRootElement(), changeVehicleUpgrade)

function changeVehicleColour(veh, col1, col2, col3, col4)
    if (veh) then
        local mechcost = 100
        if tonumber(getElementData(source, "job")) == 7 then
            mechcost = mechcost / btrdiscountratio
        end
        if not exports.rl_global:takeMoney(source, mechcost) then
            outputChatBox("Bu aracı yeniden boyamaya gücünüz yetmez.", source, 255, 0, 0)
        else
            col = { getVehicleColor(veh, true) }

            -- Renkler belirleniyor
            local color1 = col1 or { col[1], col[2], col[3] }
            local color2 = col2 or { col[4], col[5], col[6] }
            local color3 = col3 or { col[7], col[8], col[9] }
            local color4 = col4 or { col[10], col[11], col[12] }

            -- Aracın rengini güncelle
            if setVehicleColor(veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3]) then
                -- Veritabanına renkleri JSON formatında kaydetme
                local vehID = getElementData(veh, "dbid")

                -- Renkleri JSON formatına dönüştürme
                local jsonColor1 = toJSON(color1)
                local jsonColor2 = toJSON(color2)
                local jsonColor3 = toJSON(color3)
                local jsonColor4 = toJSON(color4)

                -- MySQL bağlantısı
                local conn = exports.rl_mysql:getConn()

                -- Veritabanına kaydetme
                local query = dbExec(conn, "UPDATE vehicles SET color1 = ?, color2 = ?, color3 = ?, color4 = ? WHERE id = ?", 
                    jsonColor1, jsonColor2, jsonColor3, jsonColor4, vehID)

                -- Sorgunun başarılı olup olmadığını kontrol etme
                if query then
                    exports.rl_global:sendLocalMeAction(source, "aracı yeniden boyar.")
                    outputChatBox("Araç başarıyla yeniden boyandı.", source)
                else
                    outputChatBox("Araç boyama sırasında bir hata oluştu. Lütfen tekrar deneyin.", source, 255, 0, 0)
                end
            end
        end
    end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", getRootElement(), changeVehicleColour)



-- Installing and Removing vehicle tinted windows
function changeVehicleTint(veh, stat)
    if veh and stat then
        if stat == 1 then
            local mechcost = 10000
            if tonumber(getElementData(source, "job")) == 7 then
            end
            if not exports.rl_global:takeMoney(source, mechcost) then
                outputChatBox("Bu araca Tint eklemeye gücünüz yetmez.", source, 255, 0, 0)
            else
                local vehID = getElementData(veh, "dbid")
                exports.rl_global:sendLocalMeAction(source, "camlara renk tonu yerleştirmeye başlar.")
                
                -- MySQL bağlantısını doğru kullanma
                local conn = exports.rl_mysql:getConn()
                
                -- Veritabanı sorgusu
                local query = dbExec(conn, "UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. (vehID) .. "'")
                if query then
                    for i = 0, getVehicleMaxPassengers(veh) do
                        local player = getVehicleOccupant(veh, i)
                        if player then
                            triggerEvent("setTintName", veh, player)
                        end
                    end
                    setElementData(veh, "tinted", true, true)
                    triggerClientEvent("tintWindows", veh)
                    outputChatBox("Araç camlarına renk tonu eklediniz.", source)
                    exports.rl_global:sendLocalMeAction(source, "pencerelere renk katar.")
                else
                    outputChatBox("Renk tonu eklenirken bir sorun oluştu. Lütfen larges hakkında rapor verin.", source, 255, 0, 0)
                end
            end
        elseif stat == 2 then
            local mechcost = 2000
            if tonumber(getElementData(source, "job")) == 7 then
            end
            if not exports.rl_global:takeMoney(source, mechcost) then
                outputChatBox("Bu araca renk eklemeye gücünüz yetmez.", source, 255, 0, 0)
            else
                local vehID = getElementData(veh, "dbid")
                exports.rl_global:sendLocalMeAction(source, "camlardaki renk tonunu kaldırmaya başlar.")
                
                -- MySQL bağlantısını doğru kullanma
                local conn = exports.rl_mysql:getConn()
                
                -- Veritabanı sorgusu
                local query = dbExec(conn, "UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. (vehID) .. "'")
                if query then
                    for i = 0, getVehicleMaxPassengers(veh) do
                        local player = getVehicleOccupant(veh, i)
                        if player then
                            triggerEvent("resetTintName", veh, player)
                        end
                    end
                    triggerClientEvent("removeTintWindows", veh)
                    outputChatBox("Aracın camlarındaki rengi temizlediniz.", source)
                    exports.rl_global:sendLocalMeAction(source, "pencerelerden renk tonu kaldırıldı.")
                else
                    outputChatBox("Renk tonu kaldırılırken bir sorun oluştu. Lütfen larges hakkında rapor verin.", source, 255, 0, 0)
                end
            end
        end
    end
end

addEvent("tintedWindows", true)
addEventHandler("tintedWindows", getRootElement(), changeVehicleTint)
