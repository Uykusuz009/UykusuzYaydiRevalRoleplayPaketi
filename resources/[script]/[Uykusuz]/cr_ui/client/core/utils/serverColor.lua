local colors = {
    [1] = tocolor(255, 212, 59, 255),
    [2] = "#FFD43B",
    [3] = "tl:FFFFD43B tr:FFFFD43B bl:FFFFD43B br:FFFFD43B",
	[4] = {255, 212, 59}
}

function getServerColor(type, alpha)
	if type == 1 then
		if alpha and tonumber(alpha) then
			return tocolor(bitExtract(colors[1], 16, 8), bitExtract(colors[1], 8, 8), bitExtract(colors[1], 0, 8), alpha)
		end
		return colors[1]
	elseif type == 2 then
		return colors[2]
	elseif type == 3 then
		return colors[3]
	elseif type == 4 then
		return colors[4]
	else
		if alpha and tonumber(alpha) then
			return tocolor(255, 255, 255, alpha)
		end
		return tocolor(255, 255, 255, 255)
	end
end