local zoneCache = {}
local _getElementZoneName = getElementZoneName

function getElementZoneName(theElement)
	if not theElement or not isElement(theElement) then
		return "Bilinmiyor"
	end

	local interior = getElementInterior(theElement)
	local dimension = getElementDimension(theElement)

	if interior == 0 and dimension == 0 then
		if getElementType(theElement) == "interior" then
			local text = getElementData(theElement, "name") .. ", " .. _getElementZoneName(theElement) .. ", " .. _getElementZoneName(theElement, true)
			zoneCache[dimension] = text
			return zoneCache[dimension]
		else
			local text = _getElementZoneName(theElement) .. ", " .. _getElementZoneName(theElement, true)
			zoneCache[dimension] = text
			return zoneCache[dimension]
		end
	else
		local dimension, entrance, exit, interiorType, interiorElement = exports.rl_interior:findProperty(theElement)
		if interiorElement then
			return getElementZoneName(interiorElement) 
		else
			zoneCache[dimension] = "Bilinmiyor"
			return zoneCache[dimension] 
		end
	end
end