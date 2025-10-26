_streams = {}

local function destroyEntityStream(entity)
    if isElement(entity) then
        setSoundVolume(entity, 0)
    end
    _streams[entity] = nil
end

function renderStreams()
    if _voiceStatus == VoiceStatus.DISABLED or _voiceStatus == VoiceStatus.ADMIN_ONLY then
        return false
    end

    local localPosition = localPlayer.position
    talkingPlayers = {}

    each(_streams, function(entity)
        if not isElement(entity) then
            destroyEntityStream(entity)
            return
        end

        if not entity:getData("logged") then
            destroyEntityStream(entity)
            return
        end

        local channel = entity:getData("voice_channel") or VoiceChannel.NEAR
        local distance = getDistanceBetweenPoints3D(localPosition, entity.position)

        if voiceChannels[channel].distance == INFINITE or distance <= voiceChannels[channel].voiceDistance then
            local text = entity.name:gsub("_", " ") .. " (" .. entity:getData("id") .. ") (" .. math.floor(distance) .. "m)"

            if channel == VoiceChannel.ADMIN then
                if exports.rl_integration:isPlayerTrialAdmin(entity) then
                    text = entity:getData("account_username") .. " tüm yetkililere konuşuyor."
                end
            elseif channel == VoiceChannel.GLOBAL then
                text = entity:getData("account_username") .. " tüm oyunculara konuşuyor."
            elseif entity == localPlayer then
                text = "Sen"
            end

            table.insert(talkingPlayers, {
                entity = entity,
                distance = voiceChannels[channel].distance == INFINITE and 0 or distance,
                text = text,
            })
        end

        if voiceChannels[channel].distance == INFINITE then
            local canHear = voiceChannels[channel].canHear(localPlayer)
            if not canHear then
                destroyEntityStream(entity)
                return
            end

            setSoundVolume(entity, 8)
            return
        end

        local maxDistance = voiceChannels[channel].distance or 10

        local distanceDiff = maxDistance - distance
        local volume = math.exp(-distance * (4 / distanceDiff)) * 8

        if distance > maxDistance and not amICallWithTarget then
            volume = 0
        end

        if getSoundVolume(entity) ~= volume then
            setSoundVolume(entity, volume)
        end

        if getSoundPan(entity) ~= 0 then
            setSoundPan(entity, 0)
        end
    end)

    table.sort(talkingPlayers, function(a, b)
        return a.distance < b.distance
    end)
end

function renderStreamUI()
    if _voiceStatus == VoiceStatus.DISABLED then
        return false
    end
    local fonts = exports.rl_ui:useFonts()
    local theme = exports.rl_ui:useTheme()

    each(talkingPlayers, function(key, data)
        local text = data.text
        local distance = data.distance
        local textWidth = dxGetTextWidth(text, 1, fonts.UbuntuBold.body) + 20

        local color = theme.GRAY[100]
        if distance > 3 and distance < 5 then
            color = theme.GRAY[200]
        elseif distance > 5 and distance < 11 then
            color = theme.GRAY[300]
        elseif distance > 11 and distance < 14 then
            color = theme.GRAY[400]
        elseif distance > 14 and distance < 17 then
            color = theme.GRAY[500]
        elseif distance > 17 and distance < 21 then
            color = theme.GRAY[600]
        elseif distance > 21 and distance < 24 then
            color = theme.GRAY[700]
        elseif distance > 24 then
            color = theme.GRAY[800]
        end
        
        local paddingY = localPlayer:getData("call") and 40 or 0
        paddingY = paddingY + (localPlayer.vehicle and 35 or 0)

        local textPosition = {
            x = screenSize.x - textWidth - 44,
            y = screenSize.y - (50 + paddingY) - (key * 28),
        }

        dxDrawText(
                text,
                textPosition.x + 1,
                textPosition.y + 1,
                textPosition.x + textWidth + 1,
                textPosition.y + 28 + 1,
                exports.rl_ui:rgba(theme.GRAY[900], 1),
                1,
                fonts.UbuntuBold.body,
                "right",
                "top"
        )

        dxDrawText(
                text,
                textPosition.x,
                textPosition.y,
                textPosition.x + textWidth,
                textPosition.y + 28,
                exports.rl_ui:rgba(color, 1),
                1,
                fonts.UbuntuBold.body,
                "right",
                "top"
        )

    end)
end

addEventHandler("onClientPlayerVoiceStart", root, function()
    if _streams[source] then
        return false
    end

    if not source:getData("logged") then
        cancelEvent()
        return false
    end

    if _voiceStatus == VoiceStatus.DISABLED then
        cancelEvent()
        return false
    end

    local channel = source:getData("voice_channel") or VoiceChannel.NEAR

    if _voiceStatus == VoiceStatus.ADMIN then
        if not exports.rl_integration:isPlayerTrialAdmin(source) or not exports.rl_global:isAdminOnDuty(source) then
            cancelEvent()
            return false
        end
    end
	
    setSoundEffectEnabled(source, "reverb", false)

    _streams[source] = true
end, true, "low-5555")

addEventHandler("onClientPlayerVoiceStop", root, function()
    _streams[source] = nil
    destroyEntityStream(source)
end, true, "low-5555")

function isEntityTalking(entity)
    return _streams[entity]
end