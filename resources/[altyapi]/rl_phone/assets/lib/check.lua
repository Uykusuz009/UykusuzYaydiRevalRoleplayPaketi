Check = {
    Infos = {},
    Delay = getTickCount() + 3000,
    Svg = svgCreate(22, 22, [[
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="0.5" y="0.5" width="21" height="21" rx="10.5" stroke="#7D7D7D"/>
        </svg>

    ]])
}

Check.CreateCheck = function(x, y, w, h, color1, color2, tipo, active)
    local Infos = {Posicao = {x, y, w, h}, Colors = {color1, color2}, Type = tipo, Active = {active, getTickCount() + 200}}
    setmetatable(Infos, {__index = Check})
    Check.Infos[Infos] = true
    return Infos
end


Check.DestroyChecks = function()
    Check.Infos = {}
end

function Check:Destroy()
    Check.Infos[self] = nil
end



function Check:SetActive(number)
    Check.Infos[self].Active[1] = number
end


addEventHandler("onClientRender", root, function()
    if Global.Componentes.TickAba and getTickCount() > Global.Componentes.TickAba[1] + 1000 then
        for self in pairs(Check.Infos) do
            if self.Type == 1 then
                local x, y, w, h = unpack(self.Posicao)
                dxDrawBordRectangle(x, y, w, h, 11, self.Active[1] == 1 and self.Colors[2] or self.Colors[1], true)
                if self.Active[1] == 1 then
                    local Animation = interpolateBetween(3, 0, 0, 23, 0, 0, (getTickCount() - self.Active[2])/200, "Linear")
                    dxDrawBordRectangle(x + Animation, y + 2, 18, 18, 9, tocolor(255, 255, 255, 255), true)
                else
                    local Animation = interpolateBetween(23, 0, 0, 3, 0, 0, (getTickCount() - self.Active[2])/200, "Linear")
                    dxDrawBordRectangle(x + Animation, y + 2, 18, 18, 9, tocolor(255, 255, 255, 255), true)
                end
            elseif self.Type == 2 or self.Type == 3 or self.Type == 4 then
                local x, y, w, h = unpack(self.Posicao)
                if self.Active[1] == 1 then
                    dxDrawBordRectangle(x, y, w, h, 11, tocolor(88, 189, 129, 255), true)
                    dxDrawBordRectangle(x + 6, y + 6, 10, 10, 5, tocolor(241, 241, 241, 255), true)
                else
                    if isCursorOnElement(x, y, w, h) then
                        dxDrawBordRectangle(x, y, w, h, 11, tocolor(88, 189, 129, 255), true)
                    else
                        dxDrawImage(x, y, w, h, Check.Svg, 0, 0, 0, tocolor(255, 255, 255, 255), true)
                    end
                end
            end
        end
    end
end)

addEventHandler("onClientClick", root, function(b, s)
    if b == "left" and s == "down" then
        for self in pairs(Check.Infos) do
            local x, y, w, h = unpack(self.Posicao)
            if isCursorOnElement(x, y, w, h) then
                self.Active[1] = (self.Active[1] == 1 and 0 or 1)
                self.Active[2] = getTickCount()
                if self.Type == 1 then
                    Global.Notify.LigacaoAnonima = self.Active[1]
                    SaveJSON("notify")
                elseif self.Type == 2 then
                    Global.Notify.Mensagens = self.Active[1]
                    SaveJSON("notify")
                elseif self.Type == 3 then
                    Global.Notify.Ligacoes = self.Active[1]
                    SaveJSON("notify")
                elseif self.Type == 4 then
                    Global.Notify.MensagensEstranhos = self.Active[1]
                    SaveJSON("notify")
                end
            end
        end
    end
end)