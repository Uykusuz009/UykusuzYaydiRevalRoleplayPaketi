local mods = {}

addEventHandler("onResourceStart", resourceRoot, function()
	local meta = xmlLoadFile("meta.xml")
	parseMeta(mods, meta)
end)

addEvent("skins.onLoad", true)
addEventHandler("skins.onLoad", root, function()
	triggerLatentClientEvent(client, "skins.request", client, mods)
end)

function parseMeta(tbl, meta)
	for i, v in ipairs(xmlNodeGetChildren(meta)) do 
		if xmlNodeGetName(v) == "file" then 
			local model = tonumber(xmlNodeGetAttribute(v, "model"))
			local file = xmlNodeGetAttribute(v, "src")
		
			table.insert(tbl, {file = file, model = model})
		end
	end	
end