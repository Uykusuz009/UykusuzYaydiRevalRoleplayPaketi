local colorsState = {}

function rgbaUnpack(hex, _alpha)
    if not tostring(hex) then
        return hex
    end

    local alpha = _alpha or 1

    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    local a = tonumber(hex:sub(8, 9), 16) or (alpha * 255)

    return r, g, b, a
end

function rgba(hex, _alpha)
    if not tostring(hex) then
        return hex
    end

    local alpha = _alpha or 1
    local colorKey = tostring(hex) .. tostring(alpha)
    if colorsState[colorKey] then
        return colorsState[colorKey]
    end

    local r, g, b, a = rgbaUnpack(hex, alpha)

    colorsState[colorKey] = tocolor(r, g, b, a)
    return colorsState[colorKey]
end

function RGBToHex(red, green, blue, alpha)
	if ((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return "#FFFFFF"
	end

	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end