local positions = {

	{x = 1166.1201171875, y = -1394.1728515625, width = 170, depth = 110}, -- Hastane Bölgesi
	
	{x = 513.517578125, y = -1330.0185546875, width = 65, depth = 75}, -- Zengin Galeri
	{x = 2111.4921875, y = -1163.078125, width = 50, depth = 50}, -- Orta Galeri
	{x = 2102.7392578125, y = -2173.4248046875, width = 60, depth = 55}, -- Fakir Galeri

	{x = 345.8515625, y = -2090.7978515625, width = 70, depth = 222}, -- Fishing
	{x = 125.4931640625, y = -1975.44140625, width = 70, depth = 222}, -- İskele

	{x = 1813.5673828125, y = -1355.0517578125, width = 123, depth = 144}, -- Çiçek

	{x = 1694.953125, y = -1946.0634765625, width = 123, depth = 177}, -- Taksi

	{x = 1830.5859375, y = -1803.6142578125, width = 155, depth = 75}, -- İgs

	{x = 2225.34375, y = -1722.958984375, width = 55, depth = 65}, -- Kıyafet

	{x = 1185.69921875, y = -1848.63671875, width = 111, depth = 128}, -- Casino

	{x = 1398.626953125, y = -1863.0751953125, width = 250, depth = 300}, -- Pd

}

-- 1398.626953125, -1863.0751953125, 13.546875

local greenzones = {}
local lastPositions = {}

addEventHandler("onResourceStart", resourceRoot, function()
	if positions and #positions ~= 0 then
		for _, value in ipairs(positions) do
			if value then
				if value.x and value.y and value.width and value.depth then
					local colCuboid = createColCuboid(value.x, value.y, -50, value.width, value.depth, 10000)
					local radarArea = createRadarArea(value.x, value.y, value.width, value.depth, 0, 255, 0, 150)
					setElementParent(radarArea, colCuboid)
					if colCuboid then
						greenzones[colCuboid] = true
						
						for _, player in ipairs(getElementsWithinColShape(colCuboid, "player")) do
							setElementData(player, "greenzone", true)
						end
						
						addEventHandler("onElementDestroy", colCuboid, function()
							if greenzones[source] then
								greenzones[source] = nil
							end
						end)
						
						addEventHandler("onColShapeHit", colCuboid, function(element, dimension)
							if element and dimension and isElement(element) and getElementType(element) == "player" then
								setElementData(element, "greenzone", true)
							end
						end)
						
						addEventHandler("onColShapeLeave", colCuboid, function(element, dimension)
							if element and dimension and isElement(element) and getElementType(element) == "player" then
								removeElementData(element, "greenzone")
							end
						end)
						
						for _, player in ipairs(getElementsByType("player")) do
							local x, y, z = getElementPosition(player)
							lastPositions[player] = {x, y, z}
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if isElement(player) then
			removeElementData(player, "greenzone")
		end
	end
end)

addEventHandler("onPlayerJoin", root, function()
	local x, y, z = getElementPosition(source)
	lastPositions[source] = {x, y, z}
end)

addEventHandler("onPlayerQuit", root, function()
	if lastPositions[source] then
		lastPositions[source] = nil
	end
end)

function interiorAndDimensionChange()
	if getElementType(source) == "player" then
		removeElementData(source, "greenzone")
		
		for colCuboid, _ in pairs(greenzones) do
			for _, player in ipairs(getElementsWithinColShape(colCuboid, "player")) do
				setElementData(player, "greenzone", true)
			end
		end
	end
end
addEventHandler("onElementInteriorChange", root, interiorAndDimensionChange)
addEventHandler("onElementDimensionChange", root, interiorAndDimensionChange)

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		local x, y, z = getElementPosition(player)
		if x ~= lastPositions[player][1] or y ~= lastPositions[player][2] or z ~= lastPositions[player][3] then
			lastPositions[player] = {x, y, z}
			
			removeElementData(player, "greenzone")
			for colCuboid, _ in pairs(greenzones) do
				if isElementWithinColShape(player, colCuboid) then
					setElementData(player, "greenzone", true)
				end
			end
		end
	end
end, 1000, 0)