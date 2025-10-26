local containerSize = {
    x = 700,
    y = 500
}

local syncedSettings = {}
local requestedEntities = {}

function renderSettings()
	if not isTimer(renderTimer) then
		showCursor(true)
		renderTimer = setTimer(function()
			local window = exports.rl_ui:drawWindow({
                position = {
                    x = 0,
                    y = 0,
                },
                size = containerSize,

                centered = true,

                header = {
                    title = "Ayarlar",
                    close = true
                },

                postGUI = false
            })

            if window.clickedClose then
                showCursor(false)
                killTimer(renderTimer)
            end
			
			local tabPanel = exports.rl_ui:drawTabPanel({
				position = {
					x = window.x,
					y = window.y
				},
				size = {
					x = containerSize.x - 20,
					y = containerSize.y - 60
				},
				padding = 10,

				name = "settings_tabs",

				placement = "horizontal",
				tabs = map(categories, function(_, category)
					return exports.rl_ui:drawTab({ name = category })
				end),

				variant = "soft",
				color = "gray",
				radius = 8,

				activeTab = 1,
				disabled = false,
			})

			local items = filter(GLOBAL_SETTINGS, function(_, setting)
				return setting.category == tabPanel.selected
			end)

			local counter = 0
			each(items, function(key, item)
				local checkbox = exports.rl_ui:drawCheckbox({
					position = {
						x = tabPanel.position.x,
						y = tabPanel.position.y + (counter * 30)
					},
					size = 24,

					name = "setting_" .. key,
					disabled = false,
					text = item.name,
					helperText = {
						text = "",
						color = theme.GRAY[200],
					},

					variant = "soft",
					color = item.check() and "green" or "gray",

					checked = item.check(),
				})
				if checkbox.pressed then
					item:toggle()
					saveSettings(true)
					triggerEvent("settings.change", localPlayer, key, cachedSettings[key])
				end

				counter = counter + 1
			end)
		end, 0, 0)
	else
		killTimer(renderTimer)
	    showCursor(false)
	end
end

addCommandHandler("settings", renderSettings)

addEvent("settings", true)
addEventHandler("settings", root, function()

	renderSettings()

end)

function initializeSettings()
    local localSettings = exports.rl_json:jsonGet("game_settings", true) or initialSettings

    for key, value in pairs(GLOBAL_SETTINGS) do
        if localSettings[key] == nil then
            localSettings[key] = value.defaultValue
        end
    end
    cachedSettings = localSettings

    triggerServerEvent("settings.sync", resourceRoot, cachedSettings, true)
end

function saveSettings(syncOthers)
    exports.rl_json:jsonSave("game_settings", cachedSettings, true)
    if syncOthers then
        triggerServerEvent("settings.sync", resourceRoot, cachedSettings)
    end
end

function getPlayerSetting(player, key)
    if (player ~= localPlayer and not syncedSettings[player]) and not requestedEntities[player] then
        triggerServerEvent("settings.wantSync", resourceRoot, player)
        requestedEntities[player] = true
    end
    return player == localPlayer and cachedSettings[key] or syncedSettings[player] and syncedSettings[player][key] or false
end

function setPlayerSetting(player, key, value)
    if player == localPlayer and cachedSettings[key] then
        cachedSettings[key] = value
    elseif syncedSettings[player] then
        syncedSettings[player][key] = value
    end
    triggerEvent("settings.change", player, key, player == localPlayer and cachedSettings[key] or syncedSettings[player][key])
end

addEvent("settings.sync", true)
addEventHandler("settings.sync", resourceRoot, function(player, settings)
    syncedSettings[player] = settings
end)

addEvent("settings.patch", true)
addEventHandler("settings.patch", localPlayer, function(key, value, noSync)
    cachedSettings[key] = value
    saveSettings(not noSync)
end)

addEvent("settings.change", true)

addEventHandler("onClientResourceStart", resourceRoot, function()
    initializeSettings()
end)