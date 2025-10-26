local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local answeredReports = {}
local unansweredReports = {}

local reportText = ""

local regular = exports.rl_fonts:getFont('Roboto', 10)

function getAdminTitle(thePlayer)
    return ""..exports.rl_global:getPlayerAdminTitle(thePlayer).." "..getElementData(thePlayer, 'account_username')..""
end

function drawText()
    if not getElementData(localPlayer, "logged") then return end
    if getElementData(localPlayer, "hudkapa") == true then return end
    if exports.rl_global:isAdminOnDuty(localPlayer) then

        local reportText = unansweredReports
        if type(reportText) == "table" and #unansweredReports > 0 then
            reportText = "#" .. table.concat(unansweredReports, " #")
        end

        adminCount = 0
        totalAdminCount = 0
        managerCount = 0
        totalManagerCount = 0
        player1 = 0

        for index, value in ipairs(getElementsByType('player')) do
            player1 = player1 + 1
            if getElementData(value, 'logged') then
                if getElementData(value, 'admin_level') > 0 and not exports.rl_integration:isPlayerManager(value) then
                    totalAdminCount = totalAdminCount + 1
                end
                if getElementData(value, 'admin_level') > 0 and exports.rl_global:isAdminOnDuty(value) and not exports.rl_integration:isPlayerManager(value) then
                    adminCount = adminCount + 1
                end
                if getElementData(value, 'admin_level') > 0 and exports.rl_integration:isPlayerManager(value) then
                    totalManagerCount = totalManagerCount + 1
                end
                if getElementData(value, 'admin_level') > 0 and exports.rl_global:isAdminOnDuty(value) and exports.rl_integration:isPlayerManager(value) then
                    managerCount = managerCount + 1
                end
            end
        end

        -- Ekran oranlı koordinatlar
        local textX = sx * 0.3646
        local textY = sy - (sy * 0.0296)
        local imageX = sx * 0.3515
        local imageY = sy - (sy * 0.0305)
        local imageW = sx * 0.0120
        local imageH = sy * 0.0204

        if type(reportText) ~= "table" then
            dxDrawText("| "..getAdminTitle(localPlayer).." - Raporlar: "..reportText.." - Aktif Yetkili: "..adminCount.."/"..totalAdminCount.." - Aktif Yönetim: "..managerCount.."/"..totalManagerCount.." ❱ Reval Roleplay "..player1.." ➜ "..(player1).."", textX, textY, sx, sy, tocolor(255, 255, 255, 255), 1, regular)
        else
            dxDrawText("| "..getAdminTitle(localPlayer).." - Raporlar: - Aktif Yetkili: "..adminCount.."/"..totalAdminCount.." - Aktif Yönetim: "..managerCount.."/"..totalManagerCount.." ❱ RL - "..player1.." ➜ "..(player1).."", textX, textY, sx, sy, tocolor(255, 255, 255, 255), 1, regular)
        end

        dxDrawImage(imageX, imageY, imageW, imageH, ':rl_nametag/public/images/duty/'..exports.rl_global:getPlayerAdminLevel(localPlayer)..'.png')
    end
end
addEventHandler("onClientRender", getRootElement(), drawText)

addEventHandler("onClientRender",getRootElement(), drawText)


addEvent("updateReportsCount", true )
addEventHandler("updateReportsCount", localPlayer,
    function(answered, unanswered)
        answeredReports = answered
        unansweredReports = unanswered
    end, false
)