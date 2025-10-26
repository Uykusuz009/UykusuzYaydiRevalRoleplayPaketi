function srl(tp, commandName, rainLevel)
	if exports.rl_integration:isPlayerSeniorAdmin(tp) then
		if not rainLevel or tonumber(rainLevel) > 40 then
		outputChatBox("Invalid level entered.", tp)
		else
		setRainLevel(rainLevel)
		local rank = exports.rl_global:getPlayerAdminTitle(tp)
		local name = getPlayerName(tp):gsub("_"," ")
		exports.rl_global:sendMessageToAdmins("AdmCmd: "..rank.." "..name.." set the rain level to: "..rainLevel)
		outputChatBox("Set rain level to: "..rainLevel, tp)
		end
	end
end
addCommandHandler("srl", srl)

function sw(tp, commandName, weather)
	if exports.rl_integration:isPlayerSeniorAdmin(tp) then
		if not weather then
		outputChatBox("Invalid ID entered.", tp)
		else
			setWeather(tonumber(weather))
			triggerClientEvent("weather:update", getRootElement(), tonumber(weather), false)
			local rank = exports.rl_global:getPlayerAdminTitle(tp)
			local name = getPlayerName(tp):gsub("_"," ")
			exports.rl_global:sendMessageToAdmins("AdmCmd: "..rank.." "..name.." set the weather to ID: "..weather)
			outputChatBox("Weather set to ID: "..weather, tp)
			local weatherID = weather
			local weatherSQLUpdate = dbExec(connection, "UPDATE `settings` SET `value`='" .. weatherID .. "' WHERE `name`='weather'")
			if weatherSQLUpdate then
				outputDebugString("[WEATHER] SQL Settings for weather successfully set to " .. weatherID .. ".")
				--outputDebugString("[WEATHER] / Line 57 / SQL Settings for weather successfully altered.")
			end
			if not weatherSQLUpdate then
				outputDebugString("[WEATHER] / Line 60 / SQL Settings for weather was not changed.")
			end
		end
	end
end
addCommandHandler("sw", sw)

function dalgaBoyuAyarla(tp, commandName, height)
	if exports.rl_integration:isPlayerAdmin(tp) then
		if not height and not height < 40 then
		outputChatBox("#575757Reval: #ffffffGeçersiz sayı.", tp, 255, 0, 0, true)
		else
			setWaveHeight(height)
			local rank = exports.rl_global:getPlayerAdminTitle(tp)
			local name = getPlayerName(tp):gsub("_"," ")
			for i, v in ipairs(getElementsByType("player")) do
				if exports.rl_integration:isPlayerTrialAdmin(v) then
					outputChatBox("#575757Reval: #f0f0f0"..getPlayerName(tp).." İsimli oyuncu dalga boyutunu "..height.." olarak değiştirdi.", v, 0, 0, 255, true)
				end
			end
			outputChatBox("#575757Reval: #ffffffDalga boyutunu "..height.." olarak değiştirdiniz.", tp, 0, 255, 0, true)
		end
	end
end
addCommandHandler("dalgaboyu", dalgaBoyuAyarla)


function etan(tp, command)
	if exports.rl_integration:isPlayerSeniorAdmin(tp) then
		if not exports.rl_integration:isPlayerAdmin(tp) then
			triggerEvent("ia:autosuspend", tp, tp, 5, "Abuse of /" ..command)
		else
			changeWeather()
			local timed = weatherStartTime + currentWeather[2]
			local realtime = getRealTime( timed - 3600  )
			outputChatBox("Time of change: "..realtime.hour .. ":"..realtime.minute, tp)
		end
	end
end
addCommandHandler("etanow", etan)