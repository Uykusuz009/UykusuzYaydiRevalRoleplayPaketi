function now()
	local timePassed = math.floor((getRealTime().timestamp - lastTime))
	return serverCurrentTimeSec + timePassed
end

function formatTimeInterval(timeInseconds)
	if type(timeInseconds) ~= "number" then
		return timeInseconds, 0
	end
	
	local seconds = now() - timeInseconds
	if seconds < 1 then
		return "Şimdi", 0
	end
	
	if seconds < 60 then
		return formatTimeString(seconds, "saniye") .. " önce", seconds
	end
	
	local minutes = math.floor(seconds / 60)
	if minutes < 60 then
		return formatTimeString(minutes, "dakika") .. " " .. formatTimeString(seconds - minutes * 60, "saniye") .. " önce" , seconds
	end
	
	local hours = math.floor(minutes / 60)
	if hours < 48 then
		return formatTimeString(hours, "saat") .. " " .. formatTimeString(minutes - hours * 60, "dakika") .. " önce", seconds
	end
	
	local days = math.floor(hours / 24)
	return formatTimeString(days, "gün") .. " önce", seconds
end

function formatFutureTimeInterval(timeInseconds)
	if type(timeInseconds) ~= "number" then
		return timeInseconds, 0
	end
	
	local seconds = timeInseconds-now()
	if seconds < 0 then
		return "0 saniye", 0
	end
	
	if seconds < 60 then
		return formatTimeString(seconds, "saniye"), seconds
	end
	
	local minutes = math.floor(seconds / 60)
	if minutes < 60 then
		return formatTimeString(minutes, "dakika") .. " " .. formatTimeString(seconds - minutes * 60, "saniye"), seconds
	end
	
	local hours = math.floor(minutes / 60)
	if hours < 48 then
		return formatTimeString(hours, "saat") .. " " .. formatTimeString(minutes - hours * 60, "dakika"), seconds
	end
	
	local days = math.floor(hours / 24)
	return formatTimeString(days, "gün"), seconds
end

function formatTimeString(time, unit)
	if time == 0 then
		return ""
	end
	if unit == "gün" or unit == "saat" or unit == "dakika" or unit == "saniye" then
		return time .. " " .. unit .. (time ~= 1 and "saniye" or "")
	else
		return time .. "" .. unit
	end
end

function minutesToDays(minutes) 
	local oneDay = minutes * 60 * 24
	return math.floor(minutes/oneDay)
end	

function formatSeconds(seconds)
	if type(seconds) ~= "number" then
		return seconds
	end
	
	if seconds <= 0 then
		return "Şimdi"
	end
	
	if seconds < 60 then
		return formatTimeString(seconds, " saniye")
	end
	
	local minutes = math.floor(seconds / 60)
	if minutes < 60 then
		return formatTimeString(minutes, " dakika") .. " " .. formatTimeString(seconds - minutes * 60, " saniye")
	end
	
	local hours = math.floor(minutes / 60)
	if hours < 48 then
		return formatTimeString(hours, " saat") .. " " .. formatTimeString(minutes - hours * 60, " dakika")
	end
	
	local days = math.floor(hours / 24)
	return formatTimeString(days, " gün")
end

function isLeapYear(year)
	return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
	local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
	local timestamp = 0
	local datetime = getRealTime()
	year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
	hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second

	for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
	for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
	timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second

	timestamp = timestamp - 3600
	if datetime.isdst then timestamp = timestamp - 3600 end

	return timestamp
end

function datetimeToTimestamp(datetime)
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local year, month, day, hour, minute, seconds = datetime:match(pattern)
	return getTimestamp(year, month, day, hour, minute, seconds)
end

function getNowTimestamp()
    local realTime = getRealTime()
    local hours = realTime.hour
    local minutes = realTime.minute
    local seconds = realTime.second
    local day = realTime.monthday
    local month = realTime.month + 1
    local year = realTime.year + 1900
    return string.format("%02d/%02d/%02d", day, month, year) .. " " .. string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function secondsToTimeDesc(seconds)
    if seconds then
        local results = {}
        local sec = (seconds % 60)
        local min = math.floor((seconds % 3600) / 60)
        local hou = math.floor((seconds % 86400) / 3600)
        local day = math.floor(seconds / 86400)

        if day > 0 then
            table.insert(results, day .. (day == 1 and " gün" or " gün"))
        end
        if hou > 0 then
            table.insert(results, hou .. (hou == 1 and " saat" or " saat"))
        end
        if min > 0 then
            table.insert(results, min .. (min == 1 and " dakika" or " dakika"))
        end
        if sec > 0 then
            table.insert(results, math.floor(sec) .. (sec == 1 and " saniye" or " saniye"))
        end

        return string.reverse(table.concat(results, ", "):reverse():gsub(" ,", " ev ", 1))
    end
    return ""
end