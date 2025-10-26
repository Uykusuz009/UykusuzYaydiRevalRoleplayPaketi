screenSize = Vector2(guiGetScreenSize())

streamingQueue = nil

_voiceStatus = VoiceStatus.DISABLED

local function checkAndStartTimers()
    if _voiceStatus ~= VoiceStatus.DISABLED then
        if not isTimer(renderStreamTimer) then
            renderStreamTimer = setTimer(renderStreams, 0, 0)
        end

        if not isTimer(renderStreamUITimer) then
            renderStreamUITimer = setTimer(renderStreamUI, 0, 0)
        end
    end
end

local function setAllPlayersVolume(volume)
    local allPlayers = getElementsByType("player")
    for _, player in ipairs(allPlayers) do
        setSoundVolume(player, volume)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    _voiceStatus = 2
    checkAndStartTimers()
    setAllPlayersVolume(0)
	setEntityChannel(VoiceChannel.NEAR)
end)