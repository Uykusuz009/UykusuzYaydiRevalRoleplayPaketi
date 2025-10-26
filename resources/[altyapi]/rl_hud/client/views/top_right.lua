local sx, sy = guiGetScreenSize()
local width, height = 400, 67
local render = false

local theme = exports.rl_ui:useTheme()
local fonts = exports.rl_ui:useFonts()

local content = {}
local timerClose = nil
local cooldownTime = 10
local toBeDrawnWidth = width
local posXOffset, posYOffset = 0, 165

function drawOverlayTopRight(info, widthNew, posXOffsetNew, posYOffsetNew, cooldown)
    if timerClose and isTimer(timerClose) then
        killTimer(timerClose)
        timerClose = nil
    end
    
    if info then
        content = info
        content[1][1] = string.sub(content[1][1], 1, 1) .. string.sub(content[1][1], 2)
    else
        return false
    end
    
    if widthNew then
        toBeDrawnWidth = widthNew
    end
    
    if posXOffsetNew then
        posXOffset = posXOffsetNew
    end
    
    if posYOffsetNew then
        posYOffset = posYOffsetNew
    end
    
    if cooldown then
        cooldownTime = cooldown
    end
    
    if content then
        render = true
    end
	
	toBeDrawnWidth = width
    
    if cooldownTime ~= 0 then
        timerClose = setTimer(function()
            render = false
            setElementData(localPlayer, "hud:overlayTopRight", 0, false)
        end, cooldownTime * 1000, 1)
    end
end
addEvent("hud.drawOverlayTopRight", true)
addEventHandler("hud.drawOverlayTopRight", localPlayer, drawOverlayTopRight)

local rounded = {};
function roundedDraw(id,x, y, w, h, radius, color, post)
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

setTimer(function()
	if render and getElementData(localPlayer, "logged") and not exports.rl_items:isInventoryRender() then
        local y = (sy - 16 * (#content)) / 2
        
        roundedDraw("top_right_bg", sx - toBeDrawnWidth + posXOffset, y, toBeDrawnWidth - 20, 16 * (#content) + 30, 5, exports.rl_ui:rgba(theme.GRAY[900], 0.9))
        
        for i = 1, #content do
            if content[i] then
                if i == 1 or content[i][7] == "title" then
                    dxDrawText(content[i][1] or "", sx - toBeDrawnWidth + 17 + posXOffset, (16 * i) + y + 1, toBeDrawnWidth - 5, 15, tocolor(255, 255, 255, 225), 1, fonts.UbuntuBold.h3)
                else
                    dxDrawText(content[i][1] or "", sx - toBeDrawnWidth + 17 + posXOffset, (16 * i) + y + 4, toBeDrawnWidth - 5, 15, tocolor(content[i][2] or 225, content[i][3] or 225, content[i][4] or 225, content[i][5] or 225), content[i][6] or 1, fonts.UbuntuRegular.body, "left", "top", false, false, false, true)
                end
            end
        end
    end
end, 0, 0)

function isOverlayRender()
    return render
end