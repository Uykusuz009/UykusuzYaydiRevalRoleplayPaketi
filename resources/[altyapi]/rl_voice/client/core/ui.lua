-- local theme = exports.rl_ui:useTheme()
-- local fonts = exports.rl_ui:useFonts()

-- local function renderVoiceTabs()
--     if _voiceStatus == VoiceStatus.DISABLED then
--         return false
--     end

--     if getElementData(localPlayer, "logged") and exports.rl_settings:getPlayerSetting(localPlayer, "voice_channels_visible") then
--         if _voiceStatus == VoiceStatus.ADMIN_ONLY then
--             if not exports.rl_integration:isPlayerTrialAdmin(localPlayer) and not exports.rl_global:isAdminOnDuty(localPlayer) then
--                 return false
--             end
--         end

--         local currentChannel = localPlayer:getData("voice_channel") or VoiceChannel.NEAR

--         local disclosure = exports.rl_ui:useDisclosure("voice_channels", true)

--         local tabSize = {
-- 			x = 0,
--             y = 28,
--         }

--         local tabPosition = {
--             x = 20,
--             y = screenSize.y - tabSize.y - 30,
--         }
		
-- 		if (getElementData(localPlayer, "hud_settings").radar == 1) and (localPlayer.interior == 0) and ((localPlayer.dimension == 0) or (localPlayer.dimension == 1)) then
-- 			tabPosition.x = tabPosition.x + math.floor(exports.rl_ui:resp(385))
-- 		end

--         if disclosure.visible then
--             for i, channel in ipairs(voiceChannels) do
--                 local isActive = currentChannel == i

--                 if channel.canSwitch(localPlayer) then
-- 					tabSize = {
-- 						x = dxGetTextWidth(channel.name, 1, fonts.UbuntuRegular.caption) + 20,
-- 						y = tabSize.y
-- 					}

--                     dxDrawRectangle(
--                         tabPosition.x,
--                         tabPosition.y,
--                         tabSize.x,
--                         tabSize.y,
--                         isActive and exports.rl_ui:rgba(theme.GRAY[800]) or exports.rl_ui:rgba(theme.GRAY[500])
--                     )

--                     dxDrawText(
--                         channel.name,
--                         tabPosition.x,
--                         tabPosition.y,
--                         tabPosition.x + tabSize.x,
--                         tabPosition.y + tabSize.y,
--                         exports.rl_ui:rgba(theme.GRAY[100]),
--                         1,
--                         fonts.UbuntuRegular.caption,
--                         "center",
--                         "center"
--                     )

--                     if exports.rl_ui:inArea(tabPosition.x, tabPosition.y, tabSize.x, tabSize.y) and exports.rl_ui:isMouseClicked() then
--                         setEntityChannel(i)
--                     end

--                     tabPosition.y = tabPosition.y - tabSize.y - 2
--                 end
--             end
--         end
--     end
-- end
-- setTimer(renderVoiceTabs, 0, 0)