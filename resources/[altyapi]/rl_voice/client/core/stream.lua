VoiceStreamer = {}
VoiceStreamer.streams = {}
VoiceStreamer.missingStreams = {}

function VoiceStreamer.request()
    if #VoiceStreamer.missingStreams > 0 then
        for _, player in ipairs(VoiceStreamer.missingStreams) do
            VoiceStreamer.streams[player] = {
                player = player,
                loading = true,
            }
        end
        VoiceStreamer.missingStreams = {}

        local newStreams = {}
        for player in pairs(VoiceStreamer.streams) do
            table.insert(newStreams, player)
        end

        triggerServerEvent("voice.stream.update", localPlayer, newStreams)
    end
end

function VoiceStreamer.check()
    if not localPlayer:getData("logged") then
        return
    end

    local nearestPlayers = {}

    local channel = localPlayer:getData("voice_channel") or VoiceChannel.NEAR
    if channel == VoiceChannel.NEAR then
                nearestPlayers = getElementsWithinRange(localPlayer.position, 20, "player", localPlayer.interior, localPlayer.dimension)
	elseif channel == VoiceChannel.SHOUT then
        nearestPlayers = getElementsWithinRange(localPlayer.position, VoiceChannel.SHOUT.distance, "player", localPlayer.interior, localPlayer.dimension)
	elseif channel == VoiceChannel.WHISPER then
        nearestPlayers = getElementsWithinRange(localPlayer.position, VoiceChannel.WHISPER.distance, "player", localPlayer.interior, localPlayer.dimension)
    elseif channel == VoiceChannel.ADMIN then
        nearestPlayers = exports.rl_global:getAdmins()
    elseif channel == VoiceChannel.GLOBAL then
        nearestPlayers = exports.rl_global:getLoggedInPlayers()
    end

    VoiceStreamer.missingStreams = {}
    local nearestPlayersMap = {}
    if #nearestPlayers > 0 then
        for _, player in ipairs(nearestPlayers) do
            if player ~= localPlayer then
                if not VoiceStreamer.streams[player] then
                    table.insert(VoiceStreamer.missingStreams, player)
                end
            end
            nearestPlayersMap[player] = true
        end
    end

    for player in pairs(VoiceStreamer.streams) do
        if not nearestPlayersMap[player] then
            VoiceStreamer.streams[player] = nil
        end
    end

    for player, stream in pairs(VoiceStreamer.streams) do
        if not isElement(player) then
            VoiceStreamer.streams[player] = nil
        end

        if not player:getData("logged") then
            VoiceStreamer.streams[player] = nil
        end

        if not nearestPlayersMap[player] then
            VoiceStreamer.streams[player] = nil
        end
    end

    if #VoiceStreamer.missingStreams > 0 then
        VoiceStreamer.request()
    end
end

function VoiceStreamer.isStreamLoading(player)
    return VoiceStreamer.streams[player] and VoiceStreamer.streams[player].loading
end

function isStreamLoading(player)
    return VoiceStreamer.isStreamLoading(player)
end

addEvent("voice.stream.update.success", true)
addEventHandler("voice.stream.update.success", root, function()
    for player, stream in pairs(VoiceStreamer.streams) do
        if stream.loading then
            stream.loading = false
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(VoiceStreamer.check, 4000, 0)
end)