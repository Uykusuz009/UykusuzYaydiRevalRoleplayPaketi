VoiceChannel = {
    NEAR = 1,
    SHOUT = 2,
    WHISPER = 3,
    GLOBAL = 4,
    ADMIN = 5,
}

VoiceStatus = {
    DISABLED = 0,
    ADMIN_ONLY = 1,
    ENABLED = 2,
}

INFINITE = -1

voiceChannels = {
    [VoiceChannel.NEAR] = {
        name = "Yakın",
        distance = 20,
        voiceDistance = 14,

        canSwitch = function(player)
            return true
        end,
    },
    [VoiceChannel.SHOUT] = {
        name = "Bağır",
        distance = 55,
        voiceDistance = 21,

        canSwitch = function(player)
            return _voiceStatus == VoiceStatus.ENABLED
        end,
    },
    [VoiceChannel.WHISPER] = {
        name = "Fısılda",
        distance = 5,
        voiceDistance = 3,

        canSwitch = function(player)
            return _voiceStatus == VoiceStatus.ENABLED
        end,
    },
    [VoiceChannel.GLOBAL] = {
        name = "Global (Herkes)",
        distance = INFINITE,
        voiceDistance = INFINITE,

        canSwitch = function(player)
            return exports.rl_integration:isPlayerServerOwner(player)
        end,
        canHear = function(player)
            return player:getData("logged")
        end
    },
    [VoiceChannel.ADMIN] = {
        name = "Yetkili (Herkes)",
        distance = INFINITE,
        voiceDistance = INFINITE,

        canSwitch = function(player)
            return exports.rl_integration:isPlayerManager(player)
        end,
        canHear = function(player)
            return exports.rl_integration:isPlayerTrialAdmin(player) or exports.rl_integration:isPlayerManager(player)
        end
    }
}