function etiketVer(thePlayer, commandName, targetPlayer, level)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer and level then
            level = tonumber(level)
			if fileExists("public/images/tags/" .. level .. ".png") then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "logged") then
						local tags = getElementData(targetPlayer, "tags") or {}
						local foundIndex = false
						
						for index, value in pairs(tags) do
							if value == level then
								foundIndex = index
							end
						end
						
						if foundIndex then
							table.remove(tags, foundIndex)
							setElementData(targetPlayer, "tags", tags)
							dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
							
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun [" .. level .. "] ID'li etiketi alındı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin [" .. level .. "] ID'li etiketizi aldı.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun [" .. level .. "] ID'li etiketini aldı.")
						else
							if #tags >= 0 and #tags < 5 then
								table.insert(tags, level)
								setElementData(targetPlayer, "tags", tags)
								dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
								
								outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li etiket verildi.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. level .. "] ID'li etiket verdi.", targetPlayer, 0, 0, 255, true)
								exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li etiketi verdi.")
							else
								outputChatBox("[!]#FFFFFF Maksimum 5 tane etiket verebilirsiniz.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Bu sayıya ait bir etiket bulunmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Etiket ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("etiketver", etiketVer, false, false)

function etiketAl(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					setElementData(targetPlayer, "tags", {})
					dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON({}), getElementData(targetPlayer, "dbid"))
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun etiketleri alındı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili etiketlerinizi aldı.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun etiketlerini aldı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("etiketal", etiketAl, false, false)

function donaterVer(thePlayer, commandName, targetPlayer, level)
	if exports.rl_integration:isPlayerServerOwner(thePlayer) then
		if targetPlayer then
            level = tonumber(level)
			if level then
				if (level == 0) or (fileExists("public/images/donater/" .. level .. ".png")) then
					local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "logged") then
							setElementData(targetPlayer, "donater", level)
							dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET donater = ? WHERE id = ?", level, getElementData(targetPlayer, "account_id"))
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li donater etiketi verildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. level .. "] ID'li donater etiketi verdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li donater etiketi verdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Bu sayıya ait bir donater etiketi bulunmuyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-5]", thePlayer, 255, 194, 14)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-5]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("donaterver", donaterVer, false, false)

function youtuberVer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					if getElementData(targetPlayer, "youtuber") then
						setElementData(targetPlayer, "youtuber", false)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET youtuber = 0 WHERE id = ?", getElementData(targetPlayer, "account_id"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun YouTuber etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin YouTuber etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun YouTuber etiketini aldı.")
					else
						setElementData(targetPlayer, "youtuber", true)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET youtuber = 1 WHERE id = ?", getElementData(targetPlayer, "account_id"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya YouTuber etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size YouTuber etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya YouTuber etiketi verdi.")
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ytver", youtuberVer, false, false)
addCommandHandler("youtuberver", youtuberVer, false, false)

function dmPlusVer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					if getElementData(targetPlayer, "dm_plus") then
						setElementData(targetPlayer, "dm_plus", false)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET dm_plus = 0 WHERE id = ?", getElementData(targetPlayer, "account_id"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun RP+ etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin RP+ etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun RP+ etiketini aldı.")
					else
						setElementData(targetPlayer, "dm_plus", true)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET dm_plus = 1 WHERE id = ?", getElementData(targetPlayer, "account_id"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya RP+ etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size RP+ etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya RP+ etiketi verdi.")
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("rpver", dmPlusVer, false, false)
addCommandHandler("rpplusver", dmPlusVer, false, false)

function boosterVer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					if getElementData(targetPlayer, "booster") then
						setElementData(targetPlayer, "booster", false)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET booster = 0 WHERE id = ?", getElementData(targetPlayer, "account_id"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun Booster etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin Booster etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun Booster etiketini aldı.")
					else
						setElementData(targetPlayer, "booster", true)
						dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET booster = 1 WHERE id = ?", getElementData(targetPlayer, "account_id"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya Booster etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size Booster etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("etiket", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya Booster etiketi verdi.")
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("boosterver", boosterVer, false, false)

-- Kurdele sistemi komutları
function kurdeleVer(thePlayer, commandName, targetPlayer, ribbonId)
	outputChatBox("[DEBUG] Kurdele ver komutu çalıştı. Parametreler: targetPlayer=" .. tostring(targetPlayer) .. ", ribbonId=" .. tostring(ribbonId), thePlayer, 255, 255, 0)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer and ribbonId then
			outputChatBox("[DEBUG] targetPlayer ve ribbonId mevcut", thePlayer, 255, 255, 0)
            ribbonId = tonumber(ribbonId)
            outputChatBox("[DEBUG] ribbonId tonumber sonrası: " .. tostring(ribbonId), thePlayer, 255, 255, 0)
			if ribbonId and ribbonId > 0 then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "logged") then
						local ribbons = getElementData(targetPlayer, "ribbons") or {}
						local foundIndex = false
						
						-- Kurdele zaten var mı kontrol et
						for index, value in pairs(ribbons) do
							if value == ribbonId then
								foundIndex = index
								break
							end
						end
						
						if foundIndex then
							-- Kurdele zaten varsa kaldır
							outputChatBox("[DEBUG] Kurdele kaldırılıyor. Index: " .. tostring(foundIndex), thePlayer, 255, 255, 0)
							table.remove(ribbons, foundIndex)
							outputChatBox("[DEBUG] Kaldırıldıktan sonra ribbons: " .. toJSON(ribbons), thePlayer, 255, 255, 0)
							setElementData(targetPlayer, "ribbons", ribbons)
							local accountId = getElementData(targetPlayer, "account_id")
							outputChatBox("[DEBUG] Account ID: " .. tostring(accountId), thePlayer, 255, 255, 0)
							
							-- Veritabanı bağlantısını kontrol et
							local connection = exports.rl_mysql:getConnection()
							if connection then
								outputChatBox("[DEBUG] MySQL bağlantısı başarılı", thePlayer, 255, 255, 0)
								
								-- SQL sorgusunu hazırla
								local sql = "UPDATE accounts SET ribbons = '" .. toJSON(ribbons) .. "' WHERE id = " .. accountId
								outputChatBox("[DEBUG] SQL Sorgusu: " .. sql, thePlayer, 255, 255, 0)
								
								-- Sorguyu çalıştır - dbExec ile dene
								local result = dbExec(connection, "UPDATE accounts SET ribbons = ? WHERE id = ?", toJSON(ribbons), accountId)
								if result then
									outputChatBox("[DEBUG] dbExec ile güncelleme başarılı", thePlayer, 0, 255, 0)
								else
									outputChatBox("[DEBUG] dbExec ile güncelleme başarısız, dbQuery ile deniyorum", thePlayer, 255, 255, 0)
									
									-- Alternatif olarak dbQuery kullan
									local query = dbQuery(connection, "UPDATE accounts SET ribbons = ? WHERE id = ?", toJSON(ribbons), accountId)
									if query then
										outputChatBox("[DEBUG] dbQuery ile güncelleme başarılı", thePlayer, 0, 255, 0)
									else
										outputChatBox("[DEBUG] dbQuery ile de güncelleme başarısız", thePlayer, 255, 0, 0)
									end
								end
							else
								outputChatBox("[DEBUG] MySQL bağlantısı başarısız", thePlayer, 255, 0, 0)
							end
							
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun [" .. ribbonId .. "] ID'li kurdelesi alındı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin [" .. ribbonId .. "] ID'li kurdelenizi aldı.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("kurdele", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun [" .. ribbonId .. "] ID'li kurdelini aldı.")
						else
							-- Maksimum 1 kurdele limiti
							if #ribbons < 1 then
								outputChatBox("[DEBUG] Kurdele ekleniyor. Mevcut ribbons: " .. toJSON(ribbons), thePlayer, 255, 255, 0)
								table.insert(ribbons, ribbonId)
								outputChatBox("[DEBUG] Yeni ribbons: " .. toJSON(ribbons), thePlayer, 255, 255, 0)
								setElementData(targetPlayer, "ribbons", ribbons)
								local accountId = getElementData(targetPlayer, "account_id")
								outputChatBox("[DEBUG] Account ID: " .. tostring(accountId), thePlayer, 255, 255, 0)
								
								-- Veritabanı bağlantısını kontrol et
								local connection = exports.rl_mysql:getConnection()
								if connection then
									outputChatBox("[DEBUG] MySQL bağlantısı başarılı", thePlayer, 255, 255, 0)
									
									-- SQL sorgusunu hazırla
									local sql = "UPDATE accounts SET ribbons = '" .. toJSON(ribbons) .. "' WHERE id = " .. accountId
									outputChatBox("[DEBUG] SQL Sorgusu: " .. sql, thePlayer, 255, 255, 0)
									
																	-- Sorguyu çalıştır - dbExec ile dene
								local result = dbExec(connection, "UPDATE accounts SET ribbons = ? WHERE id = ?", toJSON(ribbons), accountId)
								if result then
									outputChatBox("[DEBUG] dbExec ile güncelleme başarılı", thePlayer, 0, 255, 0)
								else
									outputChatBox("[DEBUG] dbExec ile güncelleme başarısız, dbQuery ile deniyorum", thePlayer, 255, 255, 0)
									
									-- Alternatif olarak dbQuery kullan
									local query = dbQuery(connection, "UPDATE accounts SET ribbons = ? WHERE id = ?", toJSON(ribbons), accountId)
									if query then
										outputChatBox("[DEBUG] dbQuery ile güncelleme başarılı", thePlayer, 0, 255, 0)
									else
										outputChatBox("[DEBUG] dbQuery ile de güncelleme başarısız", thePlayer, 255, 0, 0)
									end
								end
								else
									outputChatBox("[DEBUG] MySQL bağlantısı başarısız", thePlayer, 255, 0, 0)
								end
								
								outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya [" .. ribbonId .. "] ID'li kurdele verildi.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. ribbonId .. "] ID'li kurdele verdi.", targetPlayer, 0, 0, 255, true)
								exports.rl_logs:addLog("kurdele", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. ribbonId .. "] ID'li kurdele verdi.")
							else
								outputChatBox("[!]#FFFFFF Oyuncunun zaten bir kurdelesi var. Sadece bir kurdeleye sahip olabilir.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz kurdele ID'si.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Kurdele ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("kurdelever", kurdeleVer, false, false)

function kurdeleAl(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					outputChatBox("[DEBUG] Kurdele al komutu çalışıyor", thePlayer, 255, 255, 0)
					setElementData(targetPlayer, "ribbons", {})
					
					local accountId = getElementData(targetPlayer, "account_id")
					outputChatBox("[DEBUG] Account ID: " .. tostring(accountId), thePlayer, 255, 255, 0)
					
					local connection = exports.rl_mysql:getConnection()
					if connection then
						outputChatBox("[DEBUG] MySQL bağlantısı başarılı", thePlayer, 255, 255, 0)
						
						-- dbExec ile dene
						local result = dbExec(connection, "UPDATE accounts SET ribbons = ? WHERE id = ?", toJSON({}), accountId)
						if result then
							outputChatBox("[DEBUG] dbExec ile güncelleme başarılı", thePlayer, 0, 255, 0)
						else
							outputChatBox("[DEBUG] dbExec ile güncelleme başarısız, dbQuery ile deniyorum", thePlayer, 255, 255, 0)
							
							-- Alternatif olarak dbQuery kullan
							local query = dbQuery(connection, "UPDATE accounts SET ribbons = ? WHERE id = ?", toJSON({}), accountId)
							if query then
								outputChatBox("[DEBUG] dbQuery ile güncelleme başarılı", thePlayer, 0, 255, 0)
							else
								outputChatBox("[DEBUG] dbQuery ile de güncelleme başarısız", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox("[DEBUG] MySQL bağlantısı başarısız", thePlayer, 255, 0, 0)
					end
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun kurdeleleri alındı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili kurdelelerinizi aldı.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("kurdele", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun kurdelelerini aldı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("kurdeleal", kurdeleAl, false, false)

function kurdeleListesi(thePlayer, commandName)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		outputChatBox("[!]#FFFFFF Kurdele ID'leri:", thePlayer, 255, 194, 14)
		outputChatBox("#FFFFFF1 - Başarı Kurdele", thePlayer, 255, 255, 255)
		outputChatBox("#FFFFFF2 - Onur Kurdele", thePlayer, 255, 255, 255)
		outputChatBox("#FFFFFF3 - Cesaret Kurdele", thePlayer, 255, 255, 255)
		outputChatBox("#FFFFFF4 - Sadakat Kurdele", thePlayer, 255, 255, 255)
		outputChatBox("#FFFFFF5 - Özel Kurdele", thePlayer, 255, 255, 255)
		outputChatBox("#FFFFFF6 - VIP Kurdele", thePlayer, 255, 255, 255)
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("kurdeleliste", kurdeleListesi, false, false)

-- Test komutu - veritabanı bağlantısını ve ribbons sütununu test et
function testRibbonsDB(thePlayer, commandName)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		outputChatBox("[DEBUG] Ribbons veritabanı testi başlıyor", thePlayer, 255, 255, 0)
		
		-- MySQL bağlantısını test et
		local connection = exports.rl_mysql:getConnection()
		if connection then
			outputChatBox("[DEBUG] MySQL bağlantısı başarılı", thePlayer, 0, 255, 0)
			
			-- Ribbons sütununun varlığını kontrol et
			local query = dbQuery(connection, "DESCRIBE accounts")
			if query then
				outputChatBox("[DEBUG] DESCRIBE accounts sorgusu başarılı", thePlayer, 0, 255, 0)
				
				-- Test verisi ekle
				local testResult = dbExec(connection, "UPDATE accounts SET ribbons = '[]' WHERE id = 1")
				if testResult then
					outputChatBox("[DEBUG] Test güncelleme başarılı", thePlayer, 0, 255, 0)
				else
					outputChatBox("[DEBUG] Test güncelleme başarısız", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("[DEBUG] DESCRIBE accounts sorgusu başarısız", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("[DEBUG] MySQL bağlantısı başarısız", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("testribbons", testRibbonsDB, false, false)