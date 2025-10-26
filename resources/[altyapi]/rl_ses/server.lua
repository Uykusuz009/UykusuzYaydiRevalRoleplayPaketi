local source = source 

local char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

local urlencode = function (url)
  	if url == nil then
		return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	return url
end

local getMusicArtist = function  (data, startS, player)
	if not data then 

		triggerClientEvent(player, 'error.music', player)
	return end

	if data then
		local _, pos_e = utf8.find( data, '<a href="', startS )


		local _, pos_start  = utf8.find( data, '">', pos_e )
		local pos_end  = utf8.find( data, '</a>', pos_start )
		
		local text_artist = utf8.sub( data, pos_start + 1, pos_end -1 )
		
		local pos_start, pos_e = utf8.find( data, '<span class="tt">', pos_end )
		local pos_end  = utf8.find( data, "</span>", pos_e )
		
		if not pos_e then
			triggerClientEvent(player, 'error.music', player)
		return end
			--triggerClientEvent(player, 'error.music', player)
		local text_music = utf8.sub( data, pos_e + 1, pos_end - 1)

		return text_artist, text_music
	else
		triggerClientEvent(player, 'error.music', player)
	end
end


local getMusicURL = function  ( data, startS )
    local _, pos_e = utf8.find( data, '<a class="dwnld fa fa-download"', startS )
	local _, pos_start  = utf8.find( data, 'href="h', pos_e )
	local _, pos_e  = utf8.find( data, '.mp3', pos_start )
	
	local url = utf8.sub( data, pos_start, pos_e )

	return url
end


readMusicData = function (data, err, player)
	local music = {}
	local lastPos = 0
	local lastPos2 = 0
	
	if data == "ERROR" then return end
	
	local _, s = utf8.find(data, '<div class="result">')
	
	local data = utf8.sub (data, s + 1, utf8.len(data))
	lastPos = s
	
	for i = 1, 50 do
		local startSUrls = utf8.find( data, '<span class="com">', lastPos )
				
		local _, startSUrl = utf8.find( data, 'href="h', startSUrls )
		local _, endSUrl = utf8.find( data, '.mp3', startSUrl )
		
		local url = utf8.sub( data, startSUrl, endSUrl )
		
		
		-- Артист
		local startS = utf8.find( data, '<span class="title">', lastPos )
		local _, endS = utf8.find( data, '</span>', startS )
	
		local artist, musicName = getMusicArtist ( data, startS, player)
		
		if artist and musicName then
		    table.insert( music, { artist, musicName, url} )
		end
		
	    lastPos = endS
	end
	
	triggerClientEvent(player, "returnMusicSearch", player, music)
end

addEvent("onPlayerSearchMusic", true)
addEventHandler("onPlayerSearchMusic", root, function (text)
	fetchRemote("https://hotplayer.ru/?s="..urlencode(text), readMusicData, "", false, client)
end)

addEvent("onPlayerSelectMusic", true)
addEventHandler("onPlayerSelectMusic", resourceRoot, function(url, vehicle, player)
	if isElement(vehicle) then
		triggerClientEvent("updateVehicleMusic", resourceRoot, url, vehicle)
		setElementData(vehicle, "vehicle:music", url)
	end 
end)

convertURL = function(data, err, vehicle, player)
	if vehicle and isElement(vehicle) then
		if not data then return end
	    local pos_start, pos_e = utf8.find( data, "\"url\":\"" ) 
		local pos_end = utf8.find( data, "\"}", pos_e )
		if not pos_e or not pos_end then return end
		local url = utf8.sub( data, pos_e, pos_end )
		url = utf8.gsub( url, "\"", "")

		triggerClientEvent("updateVehicleMusic", resourceRoot, url, vehicle)
		setElementData(vehicle, "vehicle:music", url)
	end
end

addEvent("stopVehicleMusic", true)
addEventHandler("stopVehicleMusic", resourceRoot, function (vehicle)
	triggerClientEvent("stopVehicleMusic", resourceRoot, vehicle)
end)

addEvent("selectVehicleMusicLink", true)
addEventHandler("selectVehicleMusicLink", resourceRoot, function (url, vehicle)
	if vehicle and isElement(vehicle) and url then
		triggerClientEvent("updateVehicleMusic", resourceRoot, url, vehicle)
		setElementData(vehicle, "vehicle:music", url)
	end
end)
