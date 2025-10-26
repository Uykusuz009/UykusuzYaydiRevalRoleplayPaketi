local PADDING = 10

local ITEMS = {
    ["level"] = {
        icon = "",
        color = theme.BLUE[600],
        iconColor = theme.BLUE[400]
    },
    ["health"] = {
        icon = "",
        color = theme.RED[800],
        iconColor = theme.RED[500]
    },
    ["armor"] = {
        icon = "",
        color = theme.GRAY[100],
        iconColor = theme.GRAY[300]
    },
}

local INFORMATION_CARD_ITEMS = {
    { icon = "", prefix = "" },
    { icon = "", prefix = "ID" },
    { icon = "", prefix = "" }
}

local SIZE = 50
local CONTAINER_SIZE = {
    x = SIZE * 4 + (PADDING * 4),
    y = 32
}

setTimer(function()
    if getElementData(localPlayer, "logged") then
	    if getElementData(localPlayer, "hud_settings").hud == 2 then
			local placement = "horizontal"
			local color = "gray"

			local textColor = color == "gray" and theme.GRAY[300] or theme.GRAY[700]

			local circularPosition = {
				x = placement == "horizontal"
					and screenSize.x - (PADDING * 2) - SIZE
					or screenSize.x - SIZE - PADDING * 2,
				y = PADDING * 2
			}

			for key, data in pairs(ITEMS) do
				local value, text = getHudDataValue(key)

				exports.rl_ui:drawRoundedRectangle({
					position = circularPosition,
					size = {
						x = SIZE,
						y = SIZE
					},

					color = theme.GRAY[900],
					alpha = 0.9,
					radius = SIZE / 2,
					section = false
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = circularPosition.x + 1,
						y = circularPosition.y + 1
					},
					size = {
						x = SIZE - 2,
						y = SIZE - 2
					},

					color = data.color,
					alpha = 0.3,
					radius = SIZE / 2,
					section = false
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = circularPosition.x + 1,
						y = circularPosition.y + 1
					},
					size = {
						x = SIZE - 2,
						y = SIZE - 2
					},

					color = data.color,
					alpha = 0.5,
					radius = SIZE / 2,
					section = {
						percentage = value,
						direction = "top"
					}
				})

				dxDrawText(data.icon, circularPosition.x, circularPosition.y, circularPosition.x + SIZE, circularPosition.y + SIZE, exports.rl_ui:rgba(data.iconColor, 1), 0.5, fonts.icon, "center", "center", true, true)
				dxDrawText(text, circularPosition.x, circularPosition.y + SIZE, circularPosition.x + SIZE, circularPosition.y + SIZE + 20, exports.rl_ui:rgba(textColor, 1), 1, fonts.body.regular, "center", "bottom", true, true)

				if placement == "vertical" then
					circularPosition.y = circularPosition.y + (PADDING * 3) + SIZE
				else
					circularPosition.x = circularPosition.x - ((PADDING * 1.2) + SIZE)
				end
			end

			local cardPosition = {
				x = screenSize.x - (PADDING * 2) - CONTAINER_SIZE.x,
				y = screenSize.y - (PADDING * 2) - CONTAINER_SIZE.y
			}

			exports.rl_ui:drawRoundedRectangle({
				position = cardPosition,
				size = CONTAINER_SIZE,

				color = theme.GRAY[900],

				radius = 15,
				alpha = 0.9,

				section = false,
			})

			cardPosition.x = cardPosition.x + 20

			for index, data in ipairs(INFORMATION_CARD_ITEMS) do
				local text = getHudCardItemValue(index) or ""
				local textWidth = dxGetTextWidth(text, 1, fonts.body.regular)

				if data.icon ~= "" then
					dxDrawText(data.icon, cardPosition.x, cardPosition.y, cardPosition.x + CONTAINER_SIZE.x, cardPosition.y + CONTAINER_SIZE.y, exports.rl_ui:rgba(theme.GRAY[300], 1), 0.5, fonts.icon, "left", "center", true, true)
				else
					dxDrawText(data.prefix, cardPosition.x, cardPosition.y, cardPosition.x + CONTAINER_SIZE.x, cardPosition.y + CONTAINER_SIZE.y, exports.rl_ui:rgba(theme.GRAY[300], 1), 1, fonts.body.bold, "left", "center", true, true)
				end

				dxDrawText(text, cardPosition.x + PADDING * 2.5, cardPosition.y, cardPosition.x + CONTAINER_SIZE.x, cardPosition.y + CONTAINER_SIZE.y, exports.rl_ui:rgba(theme.GRAY[300], 1), 1, fonts.body.regular, "left", "center", true, true)

				cardPosition.x = cardPosition.x + textWidth + (PADDING * 5)
			end
		end
	end
end, 0, 0)

function getHudDataValue(key)
    if key == "health" then
        local health = getElementHealth(localPlayer)
        return health, math.floor(health) .. "%"
	elseif key == "armor" then
        local armor = getPedArmor(localPlayer)
        return armor, math.floor(armor) .. "%"
    elseif key == "level" then
        local exp = getElementData(localPlayer, "exp") or 0
        local exprange = getElementData(localPlayer, "exprange") or 0
        local level = getElementData(localPlayer, "level") or 0

        return level + (exp / exprange) * 100, level .. "lvl"
    end

    local value = getElementData(localPlayer, key) or 0
    return value, math.min(value, 100) .. "%"
end

function getHudCardItemValue(index)
    if index == 1 then
        local currentDate = getRealTime()
		local hour = currentDate.hour
		local minute = currentDate.minute
		local timeText = string.format("%02d:%02d", hour, minute)
		return timeText
    elseif index == 2 then
        return getElementData(localPlayer, "id") or 0
    elseif index == 3 then
        local players = getElementsByType("player")
        return string.format("%03d", #players)
    end
    return ""
end