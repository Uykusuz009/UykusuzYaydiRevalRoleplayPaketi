local screenX, screenY = guiGetScreenSize()
local lastJailtime = nil
local currentSecs = 0
local timer = nil

local theme = exports.rl_ui:useTheme()
local fonts = {
	font1 = exports.rl_fonts:getFont("sf-regular", 11),
	font2 = exports.rl_fonts:getFont("sf-bold", 19)
}

setTimer(function()
	local jailtime = getElementData(localPlayer, "jailtime")
	if jailtime and (tonumber(jailtime) and tonumber(jailtime) > 0) or jailtime == "permanently" then
		if lastJailtime ~= jailtime then
			currentSecs = tonumber(jailtime) and jailtime*60 or jailtime
			lastJailtime = jailtime
			
			if timer and isTimer(timer) then
				killTimer(timer)
				timer = nil
			end
			
			if tonumber(currentSecs) then
				timer = setTimer(function()
					if tonumber(currentSecs) then
						currentSecs = currentSecs - 1
					end
				end, 1000, 59)
			end
		end
		
		local width, height = 360, 75
		local x, y = screenX / 2 - width / 2, 100

		local remaining = tonumber(currentSecs) and exports.rl_datetime:formatSeconds(currentSecs) or jailtime
		local title = ("%s%s #FFFFFFtarafından cezalandırıldınız.\nSebep: %s%s"):format(exports.rl_ui:getServerColor(2), getElementData(localPlayer, "jailadmin") or "", exports.rl_ui:getServerColor(2), getElementData(localPlayer, "jailreason") or "")
		local width = dxGetTextWidth(title:gsub("#%x%x%x%x%x%x", ""), 1, fonts.font1) + 30
		local x = screenX / 2 - width / 2
		
		dxDrawRectangle(x, y, width, height, exports.rl_ui:rgba(theme.GRAY[900], 0.9))
		dxDrawText(title, x, y, width + x, height + y, tocolor(245, 245, 245), 1, fonts.font1, "center", "center", false, false, false, true)

		local y = y + (height + 5)
		local width, height = dxGetTextWidth(remaining, 1, fonts.font2) + 25, 60
		local x, y = screenX / 2 - width / 2, screenY - (height * 2)
		
		dxDrawRectangle(x, y, width, height, exports.rl_ui:rgba(theme.GRAY[900], 0.9))
		dxDrawText(remaining, x, y, width + x, height + y, tocolor(215, 215, 215), 0.8, fonts.font2, "center", "center")
	else
		currentSecs = 0
		lastJailtime = nil
	end
end, 0, 0)