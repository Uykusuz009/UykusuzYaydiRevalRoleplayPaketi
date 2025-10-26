Global2 = {
    EditBox = {},
    Functions = {},
}


--Exemplo de Como Utilizar : Global2.Functions["CreateEdit"]("NomeIdentificador", x, y, w, h, maxcaracteres, masked, cortexto, cor_retangulo, textfundo, font, scale, apenas_numeros)
Global2.Functions["CreateEdit"] = function(id, x, y, w, h, max, masked, colortext, color, text, font, scale, number)
    if not Global2.EditBox[id] then
        Global2.EditBox[id] = {Positions = {x, y, w, h}, Max = max, Masked = masked, Colors = {colortext, color}, Text = "", Text2 = text, Select = false, Font = font, Scale = scale, Number = number, Tick = getTickCount(), BarraAlpha = true}
    end
end

Global2.Functions["DestroyEdit"] = function(id)
    if Global2.EditBox[id] then
        if Global2.EditBox[id].Select then
            guiSetInputMode("allow_binds")
        end
        Global2.EditBox[id] = nil
    end
end


-- Exemplo : local Texto = Global2.Functions["GetTextEdit"]("NomeIdentificador")
Global2.Functions["GetTextEdit"] = function(id)
    if Global2.EditBox[id] then
        return Global2.EditBox[id].Text
    end
end

Global2.Functions["SetTextEdit"] = function(id, text)
    if Global2.EditBox[id] then
        Global2.EditBox[id].Text = text
    end
end

Global2.Functions["SetInfoEdit"] = function(id, info, value)
    if Global2.EditBox[id] then
        Global2.EditBox[id][info] = value
    end
end


Global2.Functions["GetEditSelected"] = function()
    for i,v in pairs(Global2.EditBox) do
        if v.Select then
            return i
        end
    end
    return false
end

addEventHandler("onClientRender", root, function()
    if isCursorShowing() then
        if Global.Celular and Global.Componentes.TickAba and getTickCount() > Global.Componentes.TickAba[1] + 1000 then
            for i,v in pairs(Global2.EditBox) do
                local x, y, w, h = unpack(v.Positions)
                local Masked = v.Masked
                local ColorText, ColorRectangle = unpack(v.Colors)
                local Text = v.Masked and string.gsub(v.Text, ".", "•") or v.Text
                local Text2 = v.Text2
                local Font, Scale = v.Font, v.Scale
                -- dxDrawRectangle(x, y, w, h, ColorRectangle, true)
                if v.Select or v.Text ~= "" then
                    local Width = dxGetTextWidth(Text, Scale, Font)
                    local Height = dxGetFontHeight(Scale, Font)
                    local WidthMax = w
                    local Py = (y + (h/2)) - (Height/2)
                    if Width <= WidthMax then
                        dxDrawText(Text, x, y + 1, w, h, ColorText, Scale, Font, "left", "center", false, false, true)
                        if v.Select then
                            local PosXBarrinha = x + Width
                            dxDrawRectangle(PosXBarrinha, Py, 1, Height, v.BarraAlpha and ColorText or tocolor(0, 0, 0, 0), true)
                        end
                    else
                        dxDrawText(Text, x, y + 1, w, h, ColorText, Scale, Font, "right", "center", true, false, true)
                        if v.Select then
                            dxDrawRectangle(x + w , Py, 1, Height, v.BarraAlpha and ColorText or tocolor(0, 0, 0, 0), true)
                        end
                    end  
                else
                    dxDrawText(Text2, x, y + 1, w, h, ColorText, Scale, Font, "left", "center", false, false, true)
                end
                
                if v.Select and getTickCount() >= v.Tick + 500 then 
                    v.BarraAlpha = not v.BarraAlpha
                    v.Tick = getTickCount()
                end
                if v.Pressed and getTickCount() >= v.Pressed + 500 then
                    if #v.Text ~= 0 then
                        v.Text = string.sub(v.Text, 1, (#v.Text - 1))
                        if i == "Buscar" then
                            formatTableConversas(v.Text)
                        elseif i == "Add" and #Global.Componentes.AddContato == 0 then
                            if #v.Text == 5 then
                                v.Text = string.sub(v.Text, 1, (#v.Text - 1))
                            end
                        end
                    end
                end
            end
        end
    end
    
end)


addEventHandler("onClientKey", root, function(key, press)
    if key == "enter" and press and Global2.EditBox["Mensagem"] and Global2.EditBox["Mensagem"].Select then
        local Texto = Global2.EditBox["Mensagem"].Text
        if Texto ~= "" then
            sendMessage(Texto)
            Global2.EditBox["Mensagem"].Text = ""
        end
    end
end)

addEventHandler("onClientClick", root, function(b, s)
    if b == "left" and s == "down" and isCursorShowing() then
        for i,v in pairs(Global2.EditBox) do
            local x, y, w, h = unpack(v.Positions)
            if isCursorOnElement(x, y, w, h) then
                if Global.Componentes.IniciarConversa or Global.Componentes.selecionarContatosWhatsapp or Global.Componentes.Anexo then
                else
                    v.Select = true
                    guiSetInputMode("no_binds")
                end
            else
                if v.Select then
                    v.Select = false
                    guiSetInputMode("allow_binds")
                end
            end
        end
    end
end)

addEventHandler("onClientCharacter", root, function(key)
    if isCursorShowing() then
        for i,v in pairs(Global2.EditBox) do
            if v.Select then
                if #v.Text + 1 <= v.Max then
                    if v.Number then
                        if tonumber(key) then
                            v.Text = v.Text..key
                            if i == "Add" and #Global.Componentes.AddContato == 0 then
                                if #v.Text == 4 then
                                    v.Text = v.Text.."-"
                                end
                            end
                        end
                    else
                        v.Text = v.Text..key
                        if i == "Buscar" then
                            formatTableConversas(v.Text)
                        end
                    end     
                end
            end
        end
    end
end)

addEventHandler("onClientKey", root, function(key, pressed)
    if key == "backspace" then
        for i,v in pairs(Global2.EditBox) do
            if v.Select then
                if pressed then
                    if #v.Text ~= 0 then
                        v.Text = string.sub(v.Text, 1, (#v.Text - 1))
                        if i == "Buscar" then
                            formatTableConversas(v.Text)
                        elseif i == "Add" and #Global.Componentes.AddContato == 0 then
                            if #v.Text == 5 then
                                v.Text = string.sub(v.Text, 1, (#v.Text - 1))
                            end
                        end
                        v.Pressed = getTickCount()
                    end
                else
                    v.Pressed = nil
                end
            end
        end
    end
end)

addEventHandler("onClientPaste", root, function(text)
    for i,v in pairs(Global2.EditBox) do
        if v.Select then
            local Clipboard = text
            if Clipboard then
                if v.Number then
                    if i == "Telefone" then
                        if verifyCarac(Clipboard, "telefone") then
                            if #v.Text + #Clipboard > v.Max then
                                v.Text = string.sub(v.Text..text, 1, v.Max)
                            else
                                v.Text = v.Text..text
                            end
                        end 
                    else
                        if verifyCarac(Clipboard, "number") then
                            if #v.Text + #Clipboard > v.Max then
                                v.Text = string.sub(v.Text..text, 1, v.Max)
                            else
                                v.Text = v.Text..text
                            end
                        end 
                    end
                else
                    if verifyCarac(Clipboard, "string") then
                        if #v.Text + #Clipboard > v.Max then
                            v.Text = string.sub(v.Text..text, 1, v.Max)
                        else
                            v.Text = v.Text..text
                        end
                    end 
                end
            end 
        end     
    end
end)

function verifyCarac(text, tipo)
    if tipo == "string" then
        for i = 1,#text do
            if string.sub(text, i, i) == "\n" then
                return false
            end
        end
        return true
    elseif tipo == "number" then
        if tonumber(text) then
            return true
        end
    elseif tipo == "telefone" then
        if #text == 9 then
            if tonumber(string.sub(text, 1, 4)) and string.sub(text, 5, 5) == "-" and tonumber(string.sub(text, 6, 9)) then
                return true
            end
        end
    end
end