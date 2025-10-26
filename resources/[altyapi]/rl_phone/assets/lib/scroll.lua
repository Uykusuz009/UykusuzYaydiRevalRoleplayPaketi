ScrollBar = {
    Infos = {},
    Paths = {
        [[
            <svg width="4" height="362" viewBox="0 0 4 362" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 4.00001C0 1.79087 1.79086 0 4 0V0V362V362C1.79086 362 0 360.209 0 358V4.00001Z" fill="white"/>
            </svg>
        ]],
        [[
            <svg width="4" height="71" viewBox="0 0 4 71" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 4C0 1.79086 1.79086 0 4 0V0V71V71C1.79086 71 0 69.2091 0 67V4Z" fill="#FFFFFF"/>
            </svg>
        ]],
    },
    Svgs = {},
}

ScrollBar.Svgs.BG = svgCreate(4, 362, ScrollBar.Paths[1])
ScrollBar.Svgs.Img = svgCreate(4, 71, ScrollBar.Paths[2])


ScrollBar.CreateScroll = function(x, y, w, h, lenght, color, color2, color3, horizontal)
    local Infos = {x = x, y = y, w = w, h = h, lenght = lenght, color = color, color2 = color2, color3 = color3, horizontal = horizontal, pos = (horizontal and x or y)}
    setmetatable(Infos, {__index = ScrollBar})
    ScrollBar.Infos[Infos] = true
    return Infos
end

function ScrollBar:Destroy()
    ScrollBar.Infos[self] = nil
end

function ScrollBar:GetProgress()
    local Init = (self.pos) - (self.horizontal and self.x or self.y)
    local Progress = (Init * 100 / ((self.horizontal and self.w or self.h) - self.lenght))
    return Progress
end

function ScrollBar:SetProgress(value)
    local Init = (self.horizontal and self.w or self.h) - self.lenght
    self.pos = (Init / 100 * value) + (self.horizontal and self.x or self.y)
end


addEventHandler("onClientRender", root, function()
    if isCursorShowing() then
        if Global.Celular and Global.Componentes.TickAba and getTickCount() > Global.Componentes.TickAba[1] + 1000 then
            local mx, my = getCursorPosition()
            local fullx, fully = guiGetScreenSize()
            local cursorx, cursory = mx*fullx, my*fully
            for self in pairs(ScrollBar.Infos) do
                dxDrawImage(self.x, self.y, self.w, self.h, ScrollBar.Svgs.BG, 0, 0, 0, self.color, true)
                
                if self.horizontal then
                    dxDrawImage(self.pos, self.y, self.lenght, self.h, ScrollBar.Svgs.Img, 0, 0, 0, isCursorOnElement(self.pos, self.y, self.lenght, self.h) and self.color3 or self.color2, true)
                    if self.pressed then
                        if (cursorx - (self.lenght / 2)) < self.x then
                            self.pos = self.x
                        elseif (cursorx + (self.lenght / 2)) > self.x + self.w then
                            self.pos = self.x + (self.w - self.lenght)
                        else
                            self.pos = cursorx - (self.lenght / 2)
                        end
                    end
                else
                    dxDrawImage(self.x, self.pos, self.w, self.lenght, ScrollBar.Svgs.Img, 0, 0, 0, isCursorOnElement(self.x, self.pos, self.w, self.lenght) and self.color3 or self.color2, true)
                    
                    if self.pressed then
                        if (cursory - (self.lenght / 2)) < self.y then
                            self.pos = self.y
                        elseif (cursory + (self.lenght / 2)) > self.y + self.h then
                            self.pos = self.y + (self.h - self.lenght)
                        else
                            self.pos = cursory - (self.lenght / 2)
                        end
                    end
                end
            end
        end
    end
end)

addEventHandler("onClientClick", root, function(b, s)
    if b == "left" then
        if s == "down" then
            if not Global.Componentes.IniciarConversa then
                for self in pairs(ScrollBar.Infos) do
                    if self.horizontal then
                        if isCursorOnElement(self.pos, self.y, self.lenght, self.h) then
                            self.pressed = true
                        end
                    else
                        if isCursorOnElement(self.x, self.pos, self.w, self.lenght) then
                            self.pressed = true
                        end
                    end
                end
            end
        elseif s == "up" then
            for self in pairs(ScrollBar.Infos) do
                self.pressed = nil
            end
        end
    end
end)

