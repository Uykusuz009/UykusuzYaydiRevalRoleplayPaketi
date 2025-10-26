local savedClothing = {}

addEventHandler("onResourceStart", resourceRoot, function()
	local count = 0
	dbQuery(function(queryHandle)
		local result, numRows = dbPoll(queryHandle, 0)
		if result then
			for _, row in ipairs(result) do
				row.id = tonumber(row.id)
				row.skin = tonumber(row.skin)
				row.owner = tonumber(row.owner)

				savedClothing[row.id] = row
				count = count + 1
			end

			outputDebugString("Loaded " .. count .. " clothing items")
		else
			outputDebugString("Failed to load clothing items", 1)
		end
	end, exports.rl_mysql:getConnection(), "SELECT * FROM clothing")
end)

function getPath(clothing)
	return "cache/" .. tostring(clothing) .. ".tex"
end

function loadFromURL(url, id)
	fetchRemote(url, function(responseData, errorCode)
		if responseData ~= "ERROR" then
			local file = fileCreate(getPath(id))
			fileWrite(file, responseData)
			fileClose(file)

			local data = savedClothing[id]
			if data and data.pending then
				triggerLatentClientEvent(data.pending, "clothing:file", resourceRoot, id, responseData, #responseData)
				data.pending = nil
			end
		end
	end)
end

function addClothing(id, skin, url, owner)
    id = tonumber(id)
    skin = tonumber(skin)
    owner = tonumber(owner)

    if not id or not skin or not url or not owner then
        return false
    end

    if savedClothing[id] then
        return false
    end

    savedClothing[id] = {
        id = id,
        skin = skin,
        url = url,
		owner = owner
    }
	
	dbExec(exports.rl_mysql:getConnection(), "INSERT INTO clothing (skin, url, owner) VALUES (?, ?, ?)", skin, url, owner)
	
    return true
end

addEvent("clothing:stream", true)
addEventHandler("clothing:stream", resourceRoot, function(id)
	local id = tonumber(id)
	if type(id) == "number" then
		local data = savedClothing[id]
		if data then
			local path = getPath(id)
			if fileExists(path) then
				local file = fileOpen(path, true)
				if file then
					local size = fileGetSize(file)
					local content = fileRead(file, size)

					if #content == size then
						triggerLatentClientEvent(client, "clothing:file", resourceRoot, id, content, size)
					else
						outputDebugString("clothing:stream - file " .. path .. " read " .. #content .. " bytes, but is " .. size .. " bytes long")
					end
					fileClose(file)
				else
					outputDebugString("clothing:stream - file " .. path .. " existed but could not be opened?")
				end
			else
				if data.pending then
					table.insert(data.pending, client)
				else
					data.pending = { client }
					loadFromURL(data.url, id)
				end
			end
		else
			outputDebugString("clothing:stream - clothes #" .. id .. " do not exist.")
		end
	end
end, false)