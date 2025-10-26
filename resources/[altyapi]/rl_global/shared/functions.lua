function explode(div,str)
	if (div == "") then return false end
	local pos, arr = 0, {}	
	for st, sp in function() return string.find(str, div, pos, true) end do
		table.insert(arr, string.sub(str, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(str, pos))
	return arr
end

function generateSalt(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local salt = ""
    for i = 1, length do
        local rand = math.random(#chars)
        salt = salt .. chars:sub(rand, rand)
    end
    return salt
end