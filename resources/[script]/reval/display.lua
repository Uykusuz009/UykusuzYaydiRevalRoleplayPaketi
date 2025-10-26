local discord = createClass()

function discord:rpc(self)
self.app = '1337001390714654762'
if setDiscordApplicationID(self.app) then
    setDiscordRichPresenceState('Reval Roleplay V3')
    setDiscordRichPresenceAsset('letacode', 'leta:code')
	setDiscordRichPresenceButton(1, 'Sunucuya Katıl', 'mtasa://185.136.206.41:22003')
    setDiscordRichPresenceButton(2, 'Discord', 'https://discord.gg/revalroleplay')
	setDiscordRichPresenceButton(3, 'Site', 'https://www.revalroleplay.com/')
        setTimer(function()
                setDiscordRichPresenceDetails(localPlayer:getName())
        end,5000,0)
    end
end

function discord:loadassets()
    self._function = {}
    self._function.rpc = function(...) self:rpc(self) end
    addEventHandler('onClientResourceStart', getRootElement(), self._function.rpc)
end

local loadui = discord.new()
loadui:loadassets()