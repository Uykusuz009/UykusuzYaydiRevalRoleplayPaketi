local hood = class('hood')
-- panel boyutunu cart curt ayarlayabilirsiniz
function hood:init()
    self.screen = Vector2(guiGetScreenSize())
    self.w, self.h = 335, 60
    self.x, self.y = (self.screen.x - self.w) / 2, (self.screen.y - self.h) / 2
	self.screenX, self.screenY = guiGetScreenSize()
	self.delete = 315
	self.sy = self.screenY+5-self.delete
    self.click = 0
    self.fonts = {
        bigIcon = exports.kaisen_fonts:getFont("FontAwesome", 22),
        text = exports.kaisen_fonts:getFont("in-bold", 11),
        text2 = exports.kaisen_fonts:getFont("in-medium", 11),
    }

    self.cols = {
        {"Lider Baron Mekanı", 703.2587890625, -1241.7548828125, 13.623910903931, 130, hood}, -- x, y, z en son kısımda genişlik yani nereye kadar gitmesini istiyorsanız öyle yapın

    }

    for index, value in ipairs(self.cols) do 
        value[6] = createColSphere(value[2], value[3], value[4], value[5])
    end

    addEventHandler("onClientRender", root, function()
        local newScreen = Vector2(guiGetScreenSize())
        if newScreen ~= self.screen then
            self.screen = newScreen
            self.x, self.y = (self.screen.x - self.w) / 2, (self.screen.y - self.h) / 2
        end
    end)

    self._function = {}
    self._function.display = function(...) self:display(self) end
    addEventHandler('onClientRender', root, self._function.display, true, 'low-9999')
end

function hood:display()
    if not localPlayer:getData('logged') then
        return
    end
 -- alt kısımdan renkleri, yerleri vs ayarlayabilirsiniz   
    for index, value in ipairs(self.cols) do
        if localPlayer:isWithinColShape(value[6]) then
            -- self:dxDrawRoundedRectangle("OBT", 5, self.sy, self.w, self.h, 5, tocolor(0,0,0,220))
            dxDrawText("", 25, self.sy-250, nil, nil, tocolor(250, 91, 5), 1, self.fonts.bigIcon)
            dxDrawText("Fear-Rp Zorunludur.", 95, self.sy-222, nil, nil, tocolor(250, 91, 5), 1, self.fonts.text2)
            dxDrawText(value[1], 95, self.sy-250, nil, nil, tocolor(250, 91, 5), 1, self.fonts.text)
        end
    end
end

local rounded = {}
function hood:dxDrawRoundedRectangle(id, x, y, w, h, radius, color, post)
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

hood:new()
