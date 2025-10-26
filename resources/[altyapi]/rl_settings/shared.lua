categories = {
    "Genel Ayarlar",
    "Ses Ayarları",
    "Grafik Ayarları"
}

initialSettings = {}
cachedSettings = {}

GLOBAL_SETTINGS = {
    ["head_turning"] = {
        name = "Kafa Çevirme",
        category = 1,
        defaultValue = true,
        toggle = function()
            cachedSettings["head_turning"] = not cachedSettings["head_turning"]
        end,
        check = function()
            return cachedSettings["head_turning"] or defaultValue
        end,
        hideIn = {}
    },
	
    ["play_hourly_bonus_sound"] = {
        name = "Saatlik Bonus Sesi",
        category = 2,
        defaultValue = true,
        toggle = function()
            cachedSettings["play_hourly_bonus_sound"] = not cachedSettings["play_hourly_bonus_sound"]
        end,
        check = function()
            return cachedSettings["play_hourly_bonus_sound"] or defaultValue
        end,
        hideIn = {}
    },
	
    ["player_names_visible"] = {
        name = "Oyuncu Adları Görünürlüğü",
        category = 3,
        key = "player_names_visible",
        defaultValue = true,
        toggle = function()
            cachedSettings["player_names_visible"] = not cachedSettings["player_names_visible"]
        end,
        check = function()
            return cachedSettings["player_names_visible"] or defaultValue
        end,
        hideIn = {}
    },
	-- ["voice_channels_visible"] = {
    --     name = "Ses Kanalları Görünürlüğü",
    --     category = 3,
    --     key = "voice_channels_visible",
    --     defaultValue = true,
    --     toggle = function()
    --         cachedSettings["voice_channels_visible"] = not cachedSettings["voice_channels_visible"]
    --     end,
    --     check = function()
    --         return cachedSettings["voice_channels_visible"] or defaultValue
    --     end,
    --     hideIn = {}
    -- },
	["game_mods"] = {
        name = "Oyun Modları",
        category = 3,
        key = "game_mods",
        defaultValue = true,
        toggle = function()
            cachedSettings["game_mods"] = not cachedSettings["game_mods"]
            if cachedSettings["game_mods"] then
                exports.rl_modloader:loadAllModels()
            else
                exports.rl_modloader:unloadAllModels()
            end
        end,
        check = function()
            return cachedSettings["game_mods"] or defaultValue
        end,
        hideIn = {}
    },
	["finance_update_visible"] = {
        name = "Finans Güncellemesi Görünürlüğü",
        category = 3,
        key = "finance_update_visible",
        defaultValue = true,
        toggle = function()
            cachedSettings["finance_update_visible"] = not cachedSettings["finance_update_visible"]
        end,
        check = function()
            return cachedSettings["finance_update_visible"] or defaultValue
        end,
        hideIn = {}
    },
	["weapon_interface_visible"] = {
        name = "Silah Arayüzü Görünürlüğü",
        category = 3,
        key = "weapon_interface_visible",
        defaultValue = true,
        toggle = function()
            cachedSettings["weapon_interface_visible"] = not cachedSettings["weapon_interface_visible"]
        end,
        check = function()
            return cachedSettings["weapon_interface_visible"] or defaultValue
        end,
        hideIn = {}
    },
	["damage_indicator_visible"] = {
        name = "Hasar Gösterge Görünürlüğü",
        category = 3,
        key = "damage_indicator_visible",
        defaultValue = true,
        toggle = function()
            cachedSettings["damage_indicator_visible"] = not cachedSettings["damage_indicator_visible"]
        end,
        check = function()
            return cachedSettings["damage_indicator_visible"] or defaultValue
        end,
        hideIn = {}
    },
}

for key, value in pairs(GLOBAL_SETTINGS) do
    initialSettings[key] = value.defaultValue
end

cachedSettings = initialSettings