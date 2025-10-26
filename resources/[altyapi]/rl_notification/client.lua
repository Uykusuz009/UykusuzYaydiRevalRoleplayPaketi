local notifications = {}
local loaded = false
local unreadCount = 0
local isNotificationListVisible = false
local bellIconSize = 40
local notificationListWidth = 200
local notificationListHeight = 300

local screenWidth, screenHeight = guiGetScreenSize()
local bellIconX = screenWidth - bellIconSize - 10
local bellIconY = 10

local fonts = exports.rl_ui:useFonts()
local theme = exports.rl_ui:useTheme()

function drawNotificationIcon()
	dxDrawText("", bellIconX, bellIconY, 0, 0, tocolor(255, 255, 255, 255), 0.8, fonts.icon)

    if unreadCount > 0 then
        local text = tostring(unreadCount)
        local textWidth = dxGetTextWidth(text, 1.5, "default-bold")
        local textX = bellIconX + bellIconSize - textWidth / 2
        local textY = bellIconY - 10
        dxDrawText(text, textX, textY, screenWidth, screenHeight, tocolor(255, 0, 0), 1.5, "default-bold")
    end
end

function drawNotificationList()
    if isNotificationListVisible then
        dxDrawRectangle(bellIconX - notificationListWidth + bellIconSize, bellIconY + bellIconSize + 5, notificationListWidth, notificationListHeight, tocolor(0, 0, 0, 150))

        local notificationY = bellIconY + bellIconSize + 10
        for i, notification in ipairs(notifications) do
            local color = notification.is_readed == 0 and tocolor(255, 0, 0) or tocolor(255, 255, 255)
            dxDrawText(notification.notification_message, bellIconX - notificationListWidth + bellIconSize + 5, notificationY, screenWidth, screenHeight, color, 1, "default-bold")
            notificationY = notificationY + 25
        end
    end
end

setTimer(function()
	if not exports.rl_integration:isPlayerDeveloper(localPlayer) then
		return
	end
	
    drawNotificationIcon()
    drawNotificationList()
end, 0, 0)

addEvent("notifications.loadDatas", true)
addEventHandler("notifications.loadDatas", root, function(_notifications)
    if _notifications and type(_notifications) == "table" then
        notifications = _notifications
        loaded = true
		
		for _, notification in ipairs(notifications) do
			if notification.is_readed == 0 then
				unreadCount = unreadCount + 1
			end
		end
    end
end)