local loaded = {}
local streaming = {}

local players = {}

local accessoires = { watchcro = true, neckcross = true, earing = true, glasses = true, specsm = true }
local function getPrimaryTextureName(model)
	for k, v in ipairs(engineGetModelTextureNames(model)) do
		if not accessoires[v] then
			return v
		end
	end
end

local function getPath(clothing)
	return "@cache/" .. tostring(clothing) .. ".tex"
end

function addClothing(player, clothing)
	removeClothing(player)

	local texName = getPrimaryTextureName(getElementModel(player))

	local L = loaded[clothing]
	if L then
		players[player] = { id = clothing, texName = texName }
		engineApplyShaderToWorldTexture(L.shader, texName, player)
	else
		local path = getPath(clothing)
		if fileExists(path) then
			local texture = dxCreateTexture(path)
			if texture then
				local shader, t = dxCreateShader("public/shaders/tex.fx", 0, 0, true, "ped")
				if shader then
					dxSetShaderValue(shader, "tex", texture)

					local texName = getPrimaryTextureName(getElementModel(player))
					engineApplyShaderToWorldTexture(shader, texName, player)

					loaded[clothing] = { texture = texture, shader = shader }
					players[player] = { id = clothing, texName = texName }
				else
					outputDebugString("Creating shader for player " .. getPlayerName(player) .. " failed.", 2)
					destroyElement(texture)
				end
			else
				outputDebugString("Creating texture for player " .. getPlayerName(player) .. " failed", 2)
			end
		else
			if streaming[clothing] then
				table.insert(streaming[clothing], player)
			else
				streaming[clothing] = { player }
				triggerServerEvent("clothing:stream", resourceRoot, clothing)
			end
			players[player] = { id = clothing, texName = texName, pending = true }
		end
	end
end

function removeClothing(player)
	local clothes = players[player]
	if clothes and loaded[clothes.id] and isElement(loaded[clothes.id].shader) then
		local stillUsed = false
		for p, data in pairs(players) do
			if p ~= player and data.id == clothes.id then
				stillUsed = true
				break
			end
		end

		if stillUsed then
			if not clothes.pending then
				engineRemoveShaderFromWorldTexture(loaded[clothes.id].shader, clothes.texName, player)
			end
		else
			local L = loaded[clothes.id]
			if L then
				destroyElement(L.texture)
				destroyElement(L.shader)

				loaded[clothes.id] = nil
			end
		end
		players[player] = nil
	end
end

addEvent("clothing:file", true)
addEventHandler("clothing:file", resourceRoot, function(id, content, size)
	local file = fileCreate(getPath(id))
	local written = fileWrite(file, content)
	fileClose(file)

	if written ~= size then
		fileDelete(getPath(id))
	else
		for _, player in ipairs(streaming[id]) do
			addClothing(player, id)
		end

		streaming[id] = nil
	end
end, false)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, name in ipairs({"player", "ped"}) do
		for _, p in ipairs(getElementsByType(name)) do
			if isElementStreamedIn(p) then
				local clothing = getElementData(p, "clothing_id")
				if clothing then
					addClothing(p, clothing)
				end
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "player" or getElementType(source) == "ped" then
		local clothing = getElementData(source, "clothing_id")
		if clothing then
			addClothing(source, clothing)
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "player" or getElementType(source) == "ped" then
		removeClothing(source)
	end
end)

addEventHandler("onClientPlayerQuit", root, function()
	removeClothing(source)
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "ped" then
		removeClothing(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(name)
	if (getElementType(source) == "player" or getElementType(source) == "ped") and isElementStreamedIn(source) and name == "clothing_id" then
		removeClothing(source)
		if getElementData(source, "clothing_id") then
			addClothing(source, getElementData(source, "clothing_id"))
		end
	end
end)