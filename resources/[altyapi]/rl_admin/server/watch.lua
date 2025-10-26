local watcher = {}
local watched = {}
local watchTimers = {}

function takeScreen()
	for i, k in pairs(watched) do
		if isElement(i) then
			takePlayerScreenShot(i, 200, 200, getPlayerName(i), 50, 1000000)
		end
	end
end
setTimer(takeScreen, 50, 0)

addEventHandler("onPlayerScreenShot", root, function(theResource, status, imageData, timestamp, tag)
	if status == "ok" then
		if watched[source] then
			for i, k in pairs(watched[source]) do
				if not isElement(k) then
					watched[source][i] = nil
					watcher[k] = nil
					if watchTimers[k] then
						killTimer(watchTimers[k])
					end
				else
					triggerClientEvent(k, "updateScreen", k, imageData, source)
				end
			end
		end
	end
end)

function setWatch(thePlayer, targetPlayer)
	if watcher[thePlayer] then
		if watched[watcher[thePlayer]] then
			for i, k in pairs(watched[watcher[thePlayer]]) do
				if k == thePlayer then
					watched[watcher[thePlayer]][i] = nil
				end
			end
		end
	end
	watcher[thePlayer] = targetPlayer
	if not watched[targetPlayer] then
		watched[targetPlayer] = {}
	end
	table.insert(watched[targetPlayer], thePlayer)
end

function updateAutoWatch(thePlayer)
	local nextIncrement = 0
	for index, targetPlayer in ipairs(getElementsByType("thePlayer")) do
		if nextIncrement == 1 then
			setWatch(thePlayer, targetPlayer)
			return
		elseif watcher[thePlayer] == targetPlayer then
			nextIncrement = 1
		end
	end
	setWatch(thePlayer, getElementsByType("thePlayer")[1])
end

function stopWatch(thePlayer, commandName)
	if watcher[thePlayer] and watched[watcher[thePlayer]] then
		for i, k in pairs(watched[watcher[thePlayer]]) do
			if k == thePlayer then
				watched[watcher[thePlayer]][i] = nil
			end
		end
		watcher[thePlayer] = nil
		killTimer(watchTimers[thePlayer])
		outputChatBox("[!]#FFFFFF Artık kimseyi izlemiyorsunuz.", thePlayer, 255, 0, 0, true)
	end
	triggerClientEvent(thePlayer, "stopScreen", thePlayer)
end
addCommandHandler("stopwatch", stopWatch, false, false)

function watchPlayer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if watcher[thePlayer] and watched[watcher[thePlayer]] then
					for i, k in pairs(watched[watcher[thePlayer]]) do
						if k == thePlayer then
							watched[watcher[thePlayer]][i] = nil
						end
					end
				end
				watcher[thePlayer] = targetPlayer
				if not watched[targetPlayer] then
					watched[targetPlayer] = {}
				end
				table.insert(watched[targetPlayer], thePlayer)
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuyu izliyorsunuz.", thePlayer, 0, 255, 0, true)
				exports.rl_logs:addLog("watch", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu izlemeye başladı.")
			end
		else
			if watcher[thePlayer] and watched[watcher[thePlayer]] then
				for i, k in pairs(watched[watcher[thePlayer]]) do
					if k == thePlayer then
						watched[watcher[thePlayer]][i] = nil
					end
				end
				watcher[thePlayer] = nil
				triggerClientEvent(thePlayer, "stopScreen", thePlayer)
				outputChatBox("[!]#FFFFFF Artık kimseyi izlemiyorsunuz.", thePlayer, 255, 0, 0, true)
				exports.rl_logs:addLog("watch", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili izlemeyi bıraktı.")
			else
				triggerClientEvent(thePlayer, "stopScreen", thePlayer)
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("watch", watchPlayer, false, false)

addEventHandler("onPlayerQuit", root, function()
	watcher[source] = nil
	for i, k in pairs(watched) do
		for l, m in pairs(k) do
			if source == m then
				watched[i][l] = nil
			end
		end
	end
	watched[source] = nil
end)