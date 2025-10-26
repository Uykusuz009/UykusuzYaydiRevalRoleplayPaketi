local INITIAL_TAB_PANEL_OPTIONS = {
    position = {},
    size = {},
    padding = 10,

    name = "",

    placement = "horizontal",
    tabs = {},

    variant = "soft",
    color = "gray",
    radius = DEFAULT_RADIUS,

    activeTab = 1,
    disabled = false,
}

local HEADER_HEIGHT = 40
local VERTICAL_HEIGHT = HEADER_HEIGHT * 5
local TAB_PADDING = 5

function drawTab(options)
    return {
        name = options.name or "",
        icon = options.icon or "",
        disabled = options.disabled or false,
    }
end

createComponent("tabPanel", INITIAL_TAB_PANEL_OPTIONS, function(options, store)
    local position = options.position or INITIAL_TAB_PANEL_OPTIONS.position
    local size = options.size or INITIAL_TAB_PANEL_OPTIONS.size
    local padding = options.padding or INITIAL_TAB_PANEL_OPTIONS.padding

    local name = options.name
    if not name then
        return
    end

    local placement = options.placement or INITIAL_TAB_PANEL_OPTIONS.placement
    local tabs = options.tabs or INITIAL_TAB_PANEL_OPTIONS.tabs

    local variant = options.variant or INITIAL_TAB_PANEL_OPTIONS.variant
    local color = options.color or INITIAL_TAB_PANEL_OPTIONS.color
    local radius = options.radius or INITIAL_TAB_PANEL_OPTIONS.radius

    local activeTab = options.activeTab or INITIAL_TAB_PANEL_OPTIONS.activeTab
    local disabled = options.disabled or INITIAL_TAB_PANEL_OPTIONS.disabled

    local fonts = useFonts()

    if CurrentTheme == Theme.NATIVE then
        local guis = store.get("guis")

        if not guis then
            guis = {}

            local tabPanel = guiCreateTabPanel(position.x, position.y, size.x, size.y, false)
            guiSetAlpha(tabPanel, 0.8)

            guis.tabPanel = tabPanel
            guis.tabs = {}

            for order, tab in ipairs(tabs) do
                local tab = guiCreateTab(tab.name, tabPanel)
                guiSetAlpha(tab, 0.8)
                tab:setData("order", order)

                table.insert(guis.tabs, tab)
            end

            store.set("guis", guis)
        end

        local tabPanel = guis.tabPanel
        return {
            position = {
                x = position.x + padding,
                y = position.y + padding + 30
            },
            size = size,
            selected = tabPanel.selectedTab:getData("order"),
            guiElement = tabPanel,
            selectedGuiTab = tabPanel.selectedTab,
        }
    end

    local tabPanel = store.get(name)

    if not tabPanel then
        store.set(name, {
            selected = activeTab,
        })
        tabPanel = {
            selected = activeTab,
        }
    end
    local tabWidth = size.x / #tabs
    local tabPanelColor = useTabPanelVariant(variant, color)

    local tabContent = {
        x = position.x + padding,
        y = position.y + HEADER_HEIGHT + padding
    }

    local tabContentSize = {
        x = size.x - padding * 2,
        y = size.y - HEADER_HEIGHT - padding * 2
    }

    local tabSize = {
        x = tabWidth,
        y = HEADER_HEIGHT,
    }

    if placement == "vertical" then
        tabContent = {
            x = position.x + VERTICAL_HEIGHT + padding * 2,
            y = position.y + padding
        }

        tabContentSize = {
            x = size.x - VERTICAL_HEIGHT - padding * 2,
            y = size.y - padding * 2
        }

        tabSize = {
            x = VERTICAL_HEIGHT,
            y = tabSize.y,
        }

        dxDrawRectangle(position.x, position.y, tabSize.x, size.y, rgba(GRAY[700], 1))
    end

    dxDrawRectangle(position.x, position.y, size.x, size.y, rgba(tabPanelColor.background, 0.5))

    local pressed = false
    for index = 1, #tabs do
        local tab = tabs[index]
        if tab then
            local tabPosition = {
                x = position.x + ((index - 1) * tabWidth),
                y = position.y,
            }

            if placement == "vertical" then
                tabPosition = {
                    x = position.x,
                    y = position.y + ((index - 1) * tabSize.y),
                }
            end

            local hover = inArea(tabPosition.x, tabPosition.y, tabSize.x, tabSize.y)

            dxDrawRectangle(tabPosition.x, tabPosition.y, tabSize.x, tabSize.y, rgba(tabPanel.selected == index and tabPanelColor.tab or GRAY[800]))

            if tab.icon ~= "" and tab.icon then
                local textWidth = dxGetTextWidth(tab.name, 1, fonts.h6.regular)
                dxDrawText(tab.icon, tabPosition.x - textWidth / 2 - 15, tabPosition.y, tabPosition.x + tabSize.x - textWidth / 2 - 15, tabPosition.y + tabSize.y, rgba(WHITE), 0.5, fonts.icon, "center", "center", false, false, false, true)
            end
            dxDrawText(tab.name, tabPosition.x, tabPosition.y, tabPosition.x + tabSize.x, tabPosition.y + tabSize.y, rgba(tabPanel.selected == index and GRAY[200] or GRAY[400]), 1, fonts.BebasNeueRegular.h4, "center", "center", false, false, false, true)

            if hover and not disabled then
                exports.rl_cursor:setCursor("all", "pointinghand")
                if isMouseClicked() then
                    tabPanel.selected = index
                    pressed = true
                end
            end
        end
    end

    return {
        selected = tabPanel.selected,
        pressed = pressed,
        position = tabContent,
        size = tabContentSize
    }
end)

function drawTabPanel(options)
    return components.tabPanel.render(options)
end