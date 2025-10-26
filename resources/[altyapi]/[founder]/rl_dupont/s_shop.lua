addEvent('clothing:list', true)
addEventHandler('clothing:list', resourceRoot,
	function()
		if type(savedClothing) == 'table' then
			triggerLatentClientEvent(client, 'clothing:list', resourceRoot, savedClothing)
		else
			outputChatBox('[!] #FFFFFFKıyafetler şuanda yüklenemiyor.', client, 255, 0, 0, true)
		end
	end, false)

-- buying stuff
addEvent('clothing:buy', true)
addEventHandler('clothing:buy', resourceRoot,
	function(id)
		local clothing = savedClothing[id]
		if clothing and (canBuySkin(client, clothing) or canEdit(client)) then
			-- enough money to steal?
			if clothing.price == 0 or exports.rl_global:hasMoney(client, clothing.price) then
				-- enough backpack space?
				if exports.rl_global:giveItem(client, 16, clothing.skin .. ':' .. clothing.id) then
					outputChatBox('[!] $' .. exports.rl_global:formatMoney(clothing.price) .. ' karşılığında bir kıyafet satın aldın.', client, 0, 255, 0, true)

					-- take & give some money
					if clothing.price > 0 then
						exports.rl_global:takeMoney(client, clothing.price)

						local dimension = getElementDimension(client)
						if dimension > 0 then
							exports.rl_global:giveMoney(exports.rl_faction:getTeamFromFactionID(55), clothing.price)
						end
					end
				else
					outputChatBox('[!] #FFFFFFEnvanterinizde yeterli yer bulunmamaktadır.', client, 255, 0, 0, true)
				end
			else
				outputChatBox('[!] #FFFFFFBu eşyayı satın almak için $' .. exports.rl_global:formatMoney(clothing.price) .. ' paraya ihtiyacın var.', client, 255, 0, 0, true)
			end
		end
	end, false)

-- saving new or old clothes
addEvent('clothing:save', true)
addEventHandler('clothing:save', resourceRoot,
	function(values)
		if canEdit(client) then
			if not values.id then
				-- new clothing stuff
				dbExec(mysql:getConnection(), "INSERT INTO clothing (skin, url, description, price) VALUES (" .. tonumber(values.skin) .. ", '" .. (values.url) .. "', '" .. (values.description) .. "', " .. tonumber(values.price) .. ")")
				dbQuery(
					function(qh, client)
						local res, rows, err = dbPoll(qh, 0)
						local values = res[1]	
						if values.id then
							savedClothing[values.id] = values
							outputChatBox('[!] #FFFFFFKıyafet eklendi.', client, 0, 255, 0, true)
						else
							outputChatBox('[!] #FFFFFFYüklenirken beklenmedik bir hata oluştu.', client, 255, 0, 0, true)
						end
					end,
				{client}, mysql:getConnection(), "SELECT * FROM clothing WHERE id = LAST_INSERT_ID()")
			else
				-- old clothing stuff
				local existing = savedClothing[values.id]
				if existing then
					if dbExec(mysql:getConnection(), 'UPDATE clothing SET skin = ' .. tonumber(values.skin) .. ', description = "' .. (values.description) .. '", price = ' .. tonumber(values.price) .. ' WHERE id = ' .. tonumber(values.id)) then
						--url = "' .. (values.url) .. '",
						outputChatBox('[!] #FFFFFFKıyafet kaydedildi.', client, 0, 255, 0, true)

						existing.skin = tonumber(values.skin)
						--existing.url = tostring(values.url)
						existing.description = tostring(values.description)
						existing.price = tonumber(values.price)
					else
						outputChatBox('[!] #FFFFFFKıyafet kaydedilemedi.', client, 255, 0, 0, true)
					end
				else
					outputChatBox('[!] #FFFFFFKıyafet bulunamadı.', client, 255, 0, 0, true)
				end
			end
		end
	end, false)

addEvent('clothing:delete', true)
addEventHandler('clothing:delete', resourceRoot,
	function(id)
		if canEdit(client) and type(id) == 'number' and savedClothing[id] then
			dbExec(mysql:getConnection(), 'DELETE FROM clothing WHERE id = ' .. tonumber(id))
			savedClothing[id] = nil

			local path = getPath(id)
			if fileExists(path) then
				fileDelete(path)
			end

			outputChatBox('[!] #FFFFFFKıyafet başarıyla silindi.', client, 0, 255, 0, true)
		end
	end, false)
