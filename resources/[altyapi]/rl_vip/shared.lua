function SmallestID()
	local result = dbQuery(exports.rl_mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vips AS e1 LEFT JOIN vips AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result2 = dbPoll(result, -1)
	if result2 then
		local id = tonumber(result2[1]["nextID"]) or 1
		return id
	end
	return false
end

function isPlayerVIP(charID)
	return vips[charID] and true or false
end