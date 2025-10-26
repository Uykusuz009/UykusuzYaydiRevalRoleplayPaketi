local screenSize = Vector2(guiGetScreenSize())
local screenWidth, screenHeight = screenSize.x, screenSize.y

local ui = exports.rl_ui or exports.rl_ui
local fonts = exports.kaisen_fonts or exports.kaisen_fonts
local json = exports.rl_json or exports.rl_json

local theme = {
    GREEN = { [500] = {0, 255, 170}, [800] = {0, 200, 130} },
    RED = { [600] = {255, 95, 95}, [700] = {220, 80, 80} },
    GRAY = { [500] = {180, 180, 180}, [600] = {75, 76, 76}, [800] = {59, 60, 60} },
    WHITE = {255, 255, 255},
}

local function rgba(color, alpha)
    return tocolor(color[1], color[2], color[3], (alpha or 1) * 255)
end

local function drawRoundedRectangle(data)
    ui:drawRoundedRectangle({
        position = data.position,
        size = data.size,
        color = data.color or "#4b4c4c",
        alpha = data.alpha or 1,
        radius = data.radius or 5,
    })
end

local loadedFonts = {
    regular = fonts:getFont("sf-regular", 11),
    bold = fonts:getFont("sf-bold", 11),
    title = fonts:getFont("sf-bold", 24),
    icon = fonts:getFont("FontAwesome", 16),
}

local isEditorOpen = false
local container = {
    pos = { x = screenWidth / 2 - 400, y = screenHeight / 2 - 200 },
    size = { x = 800, y = 400 },
    columnSize = 180,
    columnGap = 20,
    rowSize = 300,
    maxColumns = 4,
    gridItems = {
        { key = "hud", name = "Hud" },
        { key = "speedo", name = "Araç Göstergesi" },
        { key = "radar", name = "Harita" },
        { key = "nametag", name = "İsim Etiketi" },
    },
}

local modules = {
    hud = {
        [1] = { options = { name = "Trilogy" } },
        [2] = { options = { name = "Purple" } },
        [3] = { options = { name = "Gradient" } },
        [4] = { options = { name = "Neo" } },
        [5] = { options = { name = "Native" } },
    },
    speedo = {
        [1] = { options = { name = "Trilogy" } },
        [2] = { options = { name = "Native" } },
        [3] = { options = { name = "Circular" } },
        [4] = { options = { name = "Purple" } },
        [5] = { options = { name = "Neo" } },
    },
    radar = {
        [1] = { options = { name = "Native" } },
        [2] = { options = { name = "Rectangle" } },
    },
    nametag = {
        type = {
            title = "Bar Gösterimi",
            options = {
                [1] = { name = "Bar" },
                [2] = { name = "Yazı" },
                [3] = { name = "Kapalı" },
            },
        },
        font = {
            title = "Font",
            options = {
                [1] = { name = "Modern" },
                [2] = { name = "Modern B" },
                [3] = { name = "Native" },
            },
        },
        placement = {
            title = "Yazı Yerleştirmesi",
            options = {
                [1] = { name = "Statik" },
                [2] = { name = "Dinamik" },
            },
        },
        border = {
            title = "Yazı Kenarlığı",
            options = {
                [1] = { name = "İnce" },
                [2] = { name = "Kalın" },
            },
        },
        id = {
            title = "ID Gösterimi",
            options = {
                [1] = { name = "Göster" },
                [2] = { name = "Gizle" },
            },
        },
        country = {
            title = "Ülke Yeri",
            options = {
                [2] = { name = "İsmin Yanı" },
                [3] = { name = "Gizle" },
            },
        },
    },
}

function renderEditor()
    if not isEditorOpen then return end

    dxDrawImage(0, 0, screenWidth, screenHeight, "public/bg.png")

    dxDrawText("Görünüşü Ayarla", container.pos.x - 1, container.pos.y - 119, nil, nil, rgba(theme.GREEN[800], 1), 1, loadedFonts.title)
    dxDrawText("Görünüşü Ayarla", container.pos.x, container.pos.y - 120, nil, nil, rgba(theme.GREEN[500], 1), 1, loadedFonts.title)

    local closeBtn = { x = container.pos.x + container.size.x - 40, y = container.pos.y - 110, w = 30, h = 30 }
    local isCloseHovered = ui:inArea(closeBtn.x, closeBtn.y, closeBtn.w, closeBtn.h)
    dxDrawText("×", closeBtn.x, closeBtn.y, closeBtn.x + closeBtn.w, closeBtn.y + closeBtn.h, isCloseHovered and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, loadedFonts.title, "center", "center")

    if isCloseHovered and ui:isMouseClicked() then
        isEditorOpen = false
        showCursor(false)
        removeEventHandler("onClientRender", root, renderEditor)
    end

    for i = 1, container.maxColumns do
        local item = container.gridItems[i]
        if item then
            local x = container.pos.x + (container.columnSize + container.columnGap) * (i - 1)
            local y = container.pos.y
            dxDrawText(item.name, x + 5, y - 25, nil, nil, rgba(theme.GRAY[500], 1), 0.7, loadedFonts.bold)
            dxDrawText(item.name, x + 6, y - 24, nil, nil, rgba(theme.WHITE, 1), 0.7, loadedFonts.bold)

            local data = modules[item.key]
            if data then
                local lineOffset = 0
                if item.key == "nametag" then
                    for _, settingKey in ipairs({ "type", "font", "placement", "border", "id", "country" }) do
                        local setting = data[settingKey]
                        dxDrawText(setting.title, x + 6, y + lineOffset, nil, nil, rgba(theme.WHITE, 1), 0.7, loadedFonts.bold)
                        local yStart = lineOffset + 30
                        local xOffset = 0
                        for optKey, option in pairs(setting.options) do
                            local textWidth = dxGetTextWidth(option.name, 0.8, loadedFonts.regular) + 20
                            local optX = x + 5 + xOffset
                            local optY = y + yStart
                            local isHovered = ui:inArea(optX, optY, textWidth, 30)
                            local dataTable = getElementData(localPlayer, "nametag_settings") or {}
                            local isSelected = dataTable[settingKey] == optKey

                            drawRoundedRectangle({
                                position = { x = optX, y = optY },
                                size = { x = textWidth, y = 30 },
                                color = isSelected and "#00ffa0" or "#4b4c4c",
                                alpha = isHovered and 0.8 or 0.5,
                                radius = 5
                            })

                            if isHovered and ui:isMouseClicked() then
                                dataTable[settingKey] = optKey
                                triggerServerEvent("nametag.saveSettings", localPlayer, dataTable)
                                json:jsonSave("nametag_settings", dataTable)
                            end

                            local textColor = isSelected and theme.GREEN[500] or theme.WHITE
                            dxDrawText(option.name, optX + 10, optY, optX + textWidth - 10, optY + 30, rgba(textColor, 1), 0.8, loadedFonts.regular, "center", "center")
                            xOffset = xOffset + textWidth + 5
                        end
                        lineOffset = yStart + 40
                    end
                else
                    for optKey, entry in pairs(data) do
                        if entry.options then
                            local btnX = x + 5
                            local btnY = y + 10 + lineOffset * 35
                            local btnW = container.columnSize - 10
                            local isHovered = ui:inArea(btnX, btnY, btnW, 30)
                            local settings = getElementData(localPlayer, "hud_settings") or {}
                            local isSelected = settings[item.key] == optKey

                            drawRoundedRectangle({
                                position = { x = btnX, y = btnY },
                                size = { x = btnW, y = 30 },
                                color = isSelected and "#00ffa0" or "#4b4c4c",
                                alpha = isHovered and 0.8 or 0.5,
                                radius = 5
                            })

                            if isHovered and ui:isMouseClicked() then
                                settings[item.key] = tonumber(optKey)
                                triggerServerEvent("hud.saveSettings", localPlayer, settings)
								json:jsonSave("hud_settings", settings)
                            end

                            dxDrawText(entry.options.name, btnX + 10, btnY, btnX + btnW, btnY + 30, rgba(theme.WHITE, 1), 0.8, loadedFonts.regular, "left", "center")
                            lineOffset = lineOffset + 1
                        end
                    end
                end
            end
        end
    end
end

addCommandHandler("hud", function()
    if getElementData(localPlayer, "logged") then
        isEditorOpen = not isEditorOpen
        showCursor(isEditorOpen)
        if isEditorOpen then
            addEventHandler("onClientRender", root, renderEditor)
        else
            removeEventHandler("onClientRender", root, renderEditor)
        end
    end
end)

addCommandHandler("nametag", function()
    executeCommandHandler("hud")
end)

function loadSettings()
	local data, status = exports.rl_json:jsonGet("hud_settings")
	
	triggerServerEvent("hud.saveSettings", localPlayer, {
		hud = (data.hud or 1),
		speedo = (data.speedo or 1),
		radar = (data.radar or 1),
		killMessage = (data.killMessage or 1)
	})
	
	return true
end
addEvent("hud.loadSettings", true)
addEventHandler("hud.loadSettings", root, loadSettings)
