local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 1380, 125
local screenX, screenY = (screenSize.x) / 2, (screenSize.y) / 2

local theme = exports.rl_ui:useTheme()
local fonts = {
    titleIcon = exports.rl_fonts:getFont("FontAwesome", 23),
    title = exports.rl_fonts:getFont("sf-medium", 12),
    description = exports.rl_fonts:getFont("sf-regular", 11)
}

function dxDrawRoundedRectangle(x, y, width, height, radius, color)
    dxDrawRectangle(x + radius, y, width - 2 * radius, height, color)
    dxDrawRectangle(x, y + radius, radius, height - 2 * radius, color)
    dxDrawRectangle(x + width - radius, y + radius, radius, height - 2 * radius, color)

    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color, color)
    dxDrawCircle(x + width - radius, y + radius, radius, 270, 360, color, color)
    dxDrawCircle(x + radius, y + height - radius, radius, 90, 180, color, color)
    dxDrawCircle(x + width - radius, y + height - radius, radius, 0, 90, color, color)
end

local panel = false

function renderReports()
    if not panel then return end
    if not getElementData(localPlayer, "logged") then return end

    showCursor(true)
    showChat(false)
    guiSetInputMode("no_binds_when_editing")

	    exports.kaisen_blur:bluredRectangle(0, 0, 1920, 1080, tocolor(255, 255, 255, 255))
        dxDrawRectangle(0, 0, 1920, 1080, tocolor(31, 31, 31, 200))
        dxDrawRoundedRectangle(screenX - 700, screenY - 300, sizeX, sizeY, 12, tocolor(31, 31, 31, 200))
        -- dxDrawRoundedRectangle(screenX - 700, screenY - 100, sizeX, sizeY, 12, tocolor(31, 31, 31, 200))
        dxDrawRoundedRectangle(screenX - 670, screenY - 290, sizeX - 1300, sizeY - 20, 12, tocolor(27, 27, 27, 210))
        dxDrawText("", screenX - 650, screenY - 255, 40, 40, tocolor(200, 200, 200, 200), 1, fonts.titleIcon)
        dxDrawText("Rapor Arayüzü", screenX - 565, screenY - 265, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.title)
        dxDrawText("yaşadığınız sorunları aşağıya yazın ve yetkili ekibimize gönderin.", screenX - 565, screenY - 235, sizeX, sizeY, tocolor(255, 255, 255, 150), 1, fonts.description)

        local aktifstaf = 0

        for k , value in ipairs(getElementsByType("player")) do 
            if getElementData(value, "duty_admin") then
               aktifstaf = aktifstaf + 1
            end		
        end
            
        dxDrawText(""..aktifstaf.." Aktif Yetkili", screenX + 450, screenY - 250, sizeX, sizeY, tocolor(255, 255, 255, 150), 1, fonts.title)

        sx,sy = guiGetScreenSize()
        panelWidth, panelHeight = 1920, 1080
        scaleX, scaleY = sx/panelWidth, sy/panelHeight
        
        local plrmoney = getElementData(localPlayer,"money")

        local plrbalance = getElementData(localPlayer,"balance")

        local plrlvl = getElementData(localPlayer,"level")
        
        -- dxDrawImage((150)*scaleX,(95)*scaleY,25*scaleX,25*scaleY,"files/esc.png",0,0,0,tocolor(255,255,255,255))
        -- dxDrawText("Geri Dön",(375)*scaleX,(560)*scaleY,nil,nil,tocolor(175,175,175,175),1,exports.kaisen_fonts:getFont("RobotoB",10),"left","top")

        dxDrawRoundedRectangle((1420)*scaleX,(155)*scaleY,40*scaleX,40*scaleY, 12, tocolor(50,50,50,200))
        dxDrawImage((1430)*scaleX,(165)*scaleY,20*scaleX,20*scaleY,"dosyalar/dollar.png",0,0,0,tocolor(255,255,255,255))
        dxDrawText(plrmoney.." #00b695₺",(1410)*scaleX,(165)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top",true,true,true,true,true)

        dxDrawRoundedRectangle((1220)*scaleX,(155)*scaleY,40*scaleX,40*scaleY, 12, tocolor(50,50,50,200))
        dxDrawImage((1230)*scaleX,(165)*scaleY,20*scaleX,20*scaleY,"dosyalar/dollar2.png",0,0,0,tocolor(255,255,255,255))
        dxDrawText(plrbalance.." #00b695GC",(1210)*scaleX,(165)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top",true,true,true,true,true)

        dxDrawText(localPlayer.name:gsub("_"," "),(1615)*scaleX,(150)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top")
        dxDrawText(plrlvl.."#00b695/#ACACACLvl",(1615)*scaleX,(170)*scaleY,nil,nil,tocolor(220,220,220,220),1,exports.kaisen_fonts:getFont("RobotoB",13),"right","top",true,true,true,true,true)

        local contentInput = exports.rl_ui:drawInput({
            position = {
                x = screenX - 700,
                y = screenY - 125
            },
            size = {
                x = sizeX,
                y = sizeY - 10
            },

            radius = 12,
            padding = 10,

            maxLines = 3,
            name = "report_textarea",
            value = "",
            placeholder = currentReport and "" or "Sorununuzu açıklayıcı bir dille tanımlayın.",
            disabled = currentReport,

            startIcon = "",

            variant = "rounded",
            color = "gray",
			
			colorTheme = theme.WHITE[900],
			
			alpha = 600,

            disabled = false,
        })
        
        local sendButton = exports.rl_ui:drawButton({
            position = {
                x = screenX + 580,
                y = screenY + 10
            },
            size = {
                x = 90,
                y = 30
            },
            radius = DEFAULT_RADIUS,
            variant = "rounded",
            alpha = 300,

            color = currentReport and "red" or "green",
            disabled = false,

            text = currentReport and "Kapat" or "Gönder",
            icon = "",

            postGUI = false
        })

        local closeButton = exports.rl_ui:drawButton({
            position = {
                x = screenX - 700,
                y = screenY + 10
            },
            size = {
                x = 90,
                y = 30
            },
            radius = DEFAULT_RADIUS,
            variant = "rounded",
            alpha = 300,

            color = "red",
            disabled = false,

            text = "Kapat",
            icon = "",

            postGUI = false
        })
        
        if sendButton.pressed then
            if currentReport then
                triggerServerEvent("reports.close", localPlayer, currentReport)
                return
            end

            if isTimer(spamTimer) then
                exports.rl_infobox:addBox("error", "Rapor gönderme kısıtlaması yaşıyorsunuz, 15 saniye içerisinde tekrar deneyin.")
                return
            end

            spamTimer = setTimer(function()
            end, 1000 * 15, 1)

            if string.len(contentInput.value) <= 3 or string.len(contentInput.value) >= 60 then
                exports.rl_infobox:addBox("error", "Raporunuz en az 3 en fazla 60 karakterden oluşmalıdır.")
                return
            end

            if isTimer(blockTimer) then
                exports.rl_infobox:addBox("error", "Rapor kısıtlaması yaşıyorsunuz, 3 dakika içerisinde tekrar deneyin.")
                return
            end

            return triggerServerEvent("reports.send", localPlayer, contentInput.value)
        end

        if closeButton.pressed then

		panel = not panel
        showCursor(false)
		showChat(not panel)

        end
end

addEventHandler("onClientRender", root, renderReports, false, "low-99999")

addCommandHandler("reportspanels", function()
    panel = not panel
    showCursor(panel)
    showChat(not panel)
end)

bindKey("F2", "down", function()
    panel = not panel
    showCursor(panel)
    showChat(not panel)
end)

-- bindKey("F2", "down", function()
-- 	if getElementData(localPlayer, "logged") then
-- 	    if not isTimer(renderTimer) then
-- 	        showCursor(true)
-- 			showChat(false)
-- 			guiSetInputMode("no_binds_when_editing")
-- 	        renderTimer = setTimer(function()
-- 				exports.kaisen_blur:bluredRectangle(0, 0, 1920, 1080, tocolor(255, 255, 255, 255))
-- 				dxDrawRectangle(0, 0, 1920, 1080, tocolor(31, 31, 31, 200))
-- 				dxDrawRoundedRectangle(screenX, screenY, sizeX, sizeY, 12, tocolor(31, 31, 31, 200))
-- 				dxDrawText("", screenX + 25, screenY + 21, 30, 30, tocolor(200, 200, 200, 200), 1, fonts.titleIcon)
-- 	            dxDrawText("Rapor Arayüzü", screenX + 75, screenY + 16, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.title)
-- 	            dxDrawText("yaşadığınız sorunları aşağıya yazın ve yetkili ekibimize gönderin.", screenX + 75, screenY + 43, sizeX, sizeY, tocolor(255, 255, 255, 150), 1, fonts.description)
				
-- 				local contentInput = exports.rl_ui:drawTextArea({
-- 					position = {
-- 						x = screenX + 20,
-- 						y = screenY + 75
-- 					},
-- 					size = {
-- 					 x = sizeX - 40,
-- 					 y = 200
-- 					},
-- 					maxLines = 3,
-- 					name = "report_textarea",
-- 					value = "",
-- 					placeholder = currentReport and "" or "Sorununuzu açıklayıcı bir dille tanımlayın.",
-- 					disabled = currentReport,
-- 					alpha = 0.9
-- 				})
				
-- 				local sendButton = exports.rl_ui:drawButton({
-- 					position = {
-- 					 x = screenX + 330,
-- 					 y = screenY + 290
-- 					},
-- 					size = {
-- 						x = 300,
-- 					 y = 40
-- 					},
-- 					radius = DEFAULT_RADIUS,
-- 					variant = "rounded",
-- 					alpha = 300,

-- 					color = currentReport and "red" or "green",
-- 					disabled = false,

-- 					text = currentReport and "Kapat" or "Gönder",
-- 					icon = "",

-- 					postGUI = false
-- 				})

-- 				local closeButton = exports.rl_ui:drawButton({
-- 					position = {
-- 						x = screenX + 20,
-- 						y = screenY + 290
-- 					},
-- 				.size = {
-- 						x = 300,
-- 					 y = 40
-- 					},
-- 					radius = DEFAULT_RADIUS,
-- 					variant = "rounded",
-- 					alpha = 300,

-- 					color = "red",
-- 					disabled = false,

-- 					text = "Kapat",
-- 					icon = "",

-- 					postGUI = false
-- 				})
				
-- 				if sendButton.pressed then
-- 					if currentReport then
-- 						triggerServerEvent("reports.close", localPlayer, currentReport)
-- 						return
-- 					end

-- 					if isTimer(spamTimer) then
-- 						exports.rl_infobox:addBox("error", "Rapor gönderme kısıtlaması yaşıyorsunuz, 15 saniye içerisinde tekrar deneyin.")
-- 						return
-- 					end

-- 					spamTimer = setTimer(function()
-- 					end, 1000 * 15, 1)

-- 					if string.len(contentInput.value) <= 3 or string.len(contentInput.value) >= 60 then
-- 						exports.rl_infobox:addBox("error", "Raporunuz en az 3 en fazla 60 karakterden oluşmalıdır.")
-- 						return
-- 					end

-- 					if isTimer(blockTimer) then
-- 						exports.rl_infobox:addBox("error", "Rapor kısıtlaması yaşıyorsunuz, 3 dakika içerisinde tekrar deneyin.")
-- 						return
-- 					end

-- 					return triggerServerEvent("reports.send", localPlayer, contentInput.value)
-- 				end

-- 				if closeButton.pressed then

-- 					killTimer(renderTimer)
-- 					showCursor(false)

-- 				end

-- 	        end, 0, 0)
-- 	    else
-- 	        killTimer(renderTimer)
-- 	        showCursor(false)
-- 			showChat(true)
-- 	    end
-- 	end
-- end)

-- Rounded rectangle SVG cache ve fonksiyonu
local rounded = {}
function roundedDraw(id, x, y, w, h, radius, color, post)
    if not rounded[id] then
        rounded[id] = {}
    end
    if not rounded[id][w] then
        rounded[id][w] = {}
    end
    if not rounded[id][w][h] then
        local path = string.format([[<svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg"><rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/></svg>]], w, h, w, h, w, h, radius)
        rounded[id][w][h] = svgCreate(w, h, path)
    end
    if rounded[id][w][h] then
        dxDrawImage(x, y, w, h, rounded[id][w][h], 0, 0, 0, color, (post or false))
    end
end

-- Admin rapor paneli değişkenleri
local adminReportPanel = false
local adminReportScroll = 0
local adminReportMaxScroll = 0
local adminReportList = {}
local adminReportUpdateTimer

-- Sunucudan raporları almak için event
addEvent("admin.reports.list", true)
addEventHandler("admin.reports.list", root, function(list)
    adminReportList = list or {}
    adminReportMaxScroll = math.max(0, #adminReportList - 7)
end)

-- /rapormod komutu (sadece client kontrolü)
addCommandHandler("rapormod", function()
    local adminLevel = tonumber(getElementData(localPlayer, "admin_level")) or 0
    if adminLevel < 1 then
        exports.rl_infobox:addBox("error", "Bu komut sadece adminler içindir.")
        return
    end
    adminReportPanel = not adminReportPanel
    if adminReportPanel then
        triggerServerEvent("admin.reports.request", localPlayer)
        if isTimer(adminReportUpdateTimer) then killTimer(adminReportUpdateTimer) end
        adminReportUpdateTimer = setTimer(function()
            if adminReportPanel then
                triggerServerEvent("admin.reports.request", localPlayer)
            end
        end, 1200, 0)
    else
        if isTimer(adminReportUpdateTimer) then killTimer(adminReportUpdateTimer) end
    end
end)

-- Yeni rapor geldiğinde admin paneli açıksa güncelle
addEvent("reports.show.ui", true)
addEventHandler("reports.show.ui", root, function()
    if adminReportPanel then
        triggerServerEvent("admin.reports.request", localPlayer)
    end
end)

-- Mouse wheel ile scroll
addEventHandler("onClientKey", root, function(btn, press)
    if not adminReportPanel or not press then return end
    if btn == "mouse_wheel_up" then
        adminReportScroll = math.max(0, adminReportScroll - 1)
    elseif btn == "mouse_wheel_down" then
        adminReportScroll = math.min(adminReportMaxScroll, adminReportScroll + 1)
    end
end)

-- Admin rapor paneli çizimi
addEventHandler("onClientRender", root, function()
    if not adminReportPanel or not getElementData(localPlayer, "admin_level") then return end

    local sx, sy = guiGetScreenSize()
    local boxW, boxH = 340, 320
    local boxX, boxY = sx - boxW - 40, sy/2 - boxH/2
    local radius = 14

    -- Arka plan kutusu
    roundedDraw("admin_report_bg", boxX, boxY, boxW, boxH, radius, tocolor(30,30,30,200))

    -- Başlık (daha küçük font)
    dxDrawText("- RAPOR PANEL -", boxX + 98, boxY + 8, boxX + boxW, boxY + 32, tocolor(255,255,255,220), 0.9, fonts.title, "left", "top")

    -- İnce ayraç çizgisi (başlığın hemen altına)
    dxDrawRectangle(boxX + 14, boxY + 34, boxW - 28, 1, tocolor(40,40,40,220))

    -- Scrollbar
    local visibleCount = 6
    local rowH = 38
    local scrollH = math.max(30, (boxH-54) * math.min(1, visibleCount / math.max(1, #adminReportList)))
    local scrollY = boxY + 38 + ((boxH-54-scrollH) * (adminReportScroll / math.max(1, adminReportMaxScroll)))
    dxDrawRectangle(boxX + boxW - 10, boxY + 38, 6, boxH - 54, tocolor(60,60,60,180))
    dxDrawRectangle(boxX + boxW - 10, scrollY, 6, scrollH, tocolor(0,180,120,220))

    -- Raporlar listesi veya "Rapor Yookk" yazısı
    if #adminReportList == 0 then
        dxDrawText(
            "Rapor Yok",
            boxX, boxY + boxH/2 - 20, boxX + boxW, boxY + boxH/2 + 20,
            tocolor(200,200,200,200), 1, fonts.description, "center", "center"
        )
    else
        local start = adminReportScroll + 1
        local finish = math.min(#adminReportList, start + visibleCount - 1)
        for i = start, finish do
            local report = adminReportList[i]
            local y = boxY + 38 + (i - start) * rowH
            roundedDraw("admin_report_row"..i, boxX + 7, y, boxW - 22, rowH - 2, 7, tocolor(40,40,40,220))
            -- Rapor ID, oyuncu adı ve koyu ID datası
            local playerIdText = tostring(report.playerId)
            if playerIdText == "nil" or playerIdText == "" or playerIdText == "-" then
                playerIdText = tostring(getElementData(getPlayerFromName(report.playerName), "id") or "-")
            end
            local playerText = string.format(
                "#00b695#%s #ffffff%s #bfbfbf(ID: #ffffff%s#bfbfbf)",
                tostring(report.id or "-"),
                report.playerName or "-",
                playerIdText
            )
            dxDrawText(playerText, boxX + 18, y + 4, boxX + boxW - 30, y + 18, tocolor(255,255,255,230), 0.9, fonts.description, "left", "top", false, false, false, true)
            -- Sebep (daha küçük font)
            dxDrawText(report.reason or "-", boxX + 18, y + 20, boxX + boxW - 30, y + rowH, tocolor(200,200,200,200), 0.8, fonts.description, "left", "top", false, false, false, true)
        end
    end
end)

-- Sunucudan rapor listesi isteği
addEvent("onClientResourceStart", true)
addEventHandler("onClientResourceStart", resourceRoot, function()
    if adminReportPanel then
        triggerServerEvent("admin.reports.request", localPlayer)
    end
end)

function renderReportsDetails()
    if not currentReport then
        killTimer(detailsTimer)
        return false
    end
	
    local containerSize = {
        x = 450,
        y = 70
    }

    local reportsCloseWindow = exports.rl_ui:drawWindow({
        position = {
            x = screenSize.x / 2 - containerSize.x / 2,
            y = screenSize.y - containerSize.y - 20,
        },
        size = containerSize,

        centered = false,
        radius = 12,
        padding = 20,
        alpha = 1,
        color = theme.GRAY[900],

        header = {
            title = "Aktif bir raporunuz var. #" .. currentReport,
            description = "Raporunuz geçerli değilse çarpı butonuyla raporunuzu kapatabilirsiniz.",
            icon = "",
            close = true
        }
    })
	
    if reportsCloseWindow.clickedClose then
        triggerServerEvent("reports.close", localPlayer, currentReport)
    end
end

addEvent("reports.show.ui", true)
addEventHandler("reports.show.ui", root, function(reportID)
    if isTimer(detailsTimer) then
        killTimer(detailsTimer)
    end
	detailsTimer = setTimer(renderReportsDetails, 0, 0)
    currentReport = reportID
end)

addEvent("reports.hide.ui", true)
addEventHandler("reports.hide.ui", root, function()
    currentReport = nil
    if isTimer(detailsTimer) then
        killTimer(detailsTimer)
    end
end)

addEvent("reports.block", true)
addEventHandler("reports.block", root, function()
    if isTimer(blockTimerRef) then
        killTimer(blockTimerRef)
    end
    blockTimerRef = setTimer(function()
    end, 1000 * 60 * 3, 1)
end)