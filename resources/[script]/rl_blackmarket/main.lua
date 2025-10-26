screen = Vector2(guiGetScreenSize())
w, h = 500, 300
nx, ny = (screen.x-w)/2, (screen.y-h)/2

font, font1, font2 = exports.rl_fonts:getFont('RobotoB',14), exports.rl_fonts:getFont('Roboto',10), exports.rl_fonts:getFont('RobotoB',12)

tabs = {
    {char='Silahlar'},
    {char='Uyuşturucular'},
    {char='Diğer'}
}

guns = {
    {model='MP5', price=3500000, id=29},
    {model='TEC-9', price=2500000, id=32},
    {model='UZI', price=2200000, id=28},
	--{model='SILENCED', price=1200000,id=23},
    {model='DEAGLE', price=1000000,id=24},
    {model='COLT-45', price=800000,id=22}
}

uyusturucu = {
    {model='Cocaine',price=500,id=34},
    {model='Morphine',price=500,id=35},
    {model='Heroin',price=500,id=36},
    {model='Ekstazi',price=500,id=37},
    {model='Marijuana',price=500,id=38},
    {model='Methamphetamine',price=500,id=39},
    {model='Epinephrine',price=500,id=40},
    {model='LSD',price=500,id=41}
}

diger = {
    {model='İp', price=100,id=46},
    {model='Kar Maskesi', price=200,id=56},
    {model='Kırmızı Beyaz Çakar', price=700000,id=61},
	{model='Turuncu Çakar', price=500000,id=61},
    --{model='Çelik Yelek', price=50000,id=162},
}

addEvent('bmarket:open',true)
addEventHandler('bmarket:open', root, function()
    if not isTimer(render) then
        page = 1
        scroll = 0
        render = setTimer(function()
            roundedRectangle(nx,ny,w,h,tocolor(10,10,10))
            dxDrawShadowText('BlackMarket Arayüzü',nx+5,ny-30,w,h,tocolor(255,255,255),1,font)
            roundedRectangle(nx+465,ny+5,w-470,h-270,mousePos(nx+465,ny+5,w-470,h-270) and tocolor(255,0,0) or tocolor(240,0,0,120))
            dxDrawText('X',nx+475,ny+10,w-470,h-270,tocolor(255,255,255),1,font1)
            if mousePos(nx+465,ny+5,w-470,h-270) and getKeyState('mouse1') then
                killTimer(render)
            end
            for k, v in pairs(tabs) do
                roundedRectangle(nx+15 - 95 + (k*95),ny+15,w-415,h-270,page==k and tocolor(25,25,25) or mousePos(nx+15 - 95 + (k*95),ny+15,w-415,h-270) and tocolor(25,25,25) or tocolor(25,25,25,140))
                dxDrawText(v.char,nx+15 - 92.5 + (k*95),ny+20,w,h,tocolor(255,255,255),1,font1)
                if mousePos(nx+15 - 95 + (k*95),ny+15,w-415,h-270) and getKeyState('mouse1') then
                    page = k
                    scroll = 0
                end
            end
            dxDrawLine(nx,ny+45,nx+500,ny+45,tocolor(25,25,25),5)
            if page == 1 then
                counter = 0
                y = 0
                dxDrawText('Silah almadan önce üstünüzü temizlemenizi öneririz aksi takdirde silah vermeyebilir.',nx+10,ny+275,w,h,tocolor(255,255,255),1,font1)
                for k, v in pairs(guns) do
                    if k > scroll and counter < 6 then
                        roundedRectangle(nx+10,ny+60 + y,w-20,h-270,tocolor(30,30,30))
                        roundedRectangle(nx+420,ny+65 + y,w-440,h-280,mousePos(nx+420,ny+65 + y,w-440,h-280) and tocolor(40,40,40) or tocolor(40,40,40,180))
                        dxDrawText(v.model,nx+15,ny+67.5 +y,w,h,tocolor(255,255,255),1,font1)
                        dxDrawText('Satın Al',nx+425,ny+67.5 + y,w-440,h-280,tocolor(255,255,255),1,font1)
                        dxDrawText(tonumber(v.price)..'₺',nx+425 - dxGetTextWidth(tonumber(v.price)..'₺',1,font1,false) - 30,ny+67.5 +y,w,h,tocolor(0,102,0),1,font1)
                        if mousePos(nx+420,ny+65 + y,w-440,h-280) and getKeyState('mouse1') then
                            triggerServerEvent('bmarket:silah',localPlayer,v.price, v.id)
                            killTimer(render)
                        end
                        counter = counter + 1
                        y = y + 35
                    end
                end
            elseif page == 2 then
                counter = 0
                y = 0
                dxDrawText('Uyuşturucu almadan önce üstünüzü temizlemenizi öneririz aksi takdirde vermeyebilir.',nx+10,ny+275,w,h,tocolor(255,255,255),1,font1)
                for k, v in pairs(uyusturucu) do
                    if k > scroll and counter < 6 then
                        roundedRectangle(nx+10,ny+60 + y,w-20,h-270,tocolor(30,30,30))
                        roundedRectangle(nx+420,ny+65 + y,w-440,h-280,mousePos(nx+420,ny+65 + y,w-440,h-280) and tocolor(40,40,40) or tocolor(40,40,40,180))
                        dxDrawText(v.model,nx+15,ny+67.5 +y,w,h,tocolor(255,255,255),1,font1)
                        dxDrawText('Satın Al',nx+425,ny+67.5 + y,w-440,h-280,tocolor(255,255,255),1,font1)
                        dxDrawText(tonumber(v.price)..'₺',nx+425 - dxGetTextWidth(tonumber(v.price)..'₺',1,font1,false) - 30,ny+67.5 +y,w,h,tocolor(0,102,0),1,font1)
                        if mousePos(nx+420,ny+65 + y,w-440,h-280) and getKeyState('mouse1') then
                            triggerServerEvent('bmarket:uyusturucu',localPlayer,v.model,v.price, v.id)
                            killTimer(render)
                        end
                        counter = counter + 1
                        y = y + 35
                    end
                end
            elseif page == 3 then
                y = 0
                for k, v in pairs(diger) do
                    roundedRectangle(nx+10,ny+60 + y,w-20,h-270,tocolor(30,30,30))
                    roundedRectangle(nx+420,ny+65 + y,w-440,h-280,mousePos(nx+420,ny+65 + y,w-440,h-280) and tocolor(40,40,40) or tocolor(40,40,40,180))
                    dxDrawText(v.model,nx+15,ny+67.5 +y,w,h,tocolor(255,255,255),1,font1)
                    dxDrawText('Satın Al',nx+425,ny+67.5 + y,w-440,h-280,tocolor(255,255,255),1,font1)
                    dxDrawText(tonumber(v.price)..'₺',nx+425 - dxGetTextWidth(tonumber(v.price)..'₺',1,font1,false) - 30,ny+67.5 +y,w,h,tocolor(0,102,0),1,font1)
                    if mousePos(nx+420,ny+65 + y,w-440,h-280) and getKeyState('mouse1') then
                        triggerServerEvent('bmarket:diger',localPlayer,v.model,v.price, v.id)
                        killTimer(render)
                    end
                    y = y + 35
                end
            end
        end,0,0)
    end
end)

function up()
    if isTimer(render) then
        if scroll > 0 then
            scroll = scroll - 1
        end
    end
end

function down()
    if isTimer(render) then
        if scroll <= counter - 5 then
            scroll = scroll + 1
        end
    end
end
bindKey("mouse_wheel_up", "down", up)
bindKey("mouse_wheel_down", "down", down)
