local sx,sy = guiGetScreenSize();
local clickTick = getTickCount();
local state = 0;
local clicked = false;
local load = -1;

local moneyPos = {
    [1] = {sx/2-135,sy/2+30},
    [2] = {sx/2-60,sy/2+30},
    [3] = {sx/2+10,sy/2+30},
    [4] = {sx/2+85,sy/2+30},
    [5] = {sx/2-138,sy/2+180},
    [6] = {sx/2-60,sy/2+180},
    [7] = {sx/2+10,sy/2+180},
    [9] = {sx/2+85,sy/2+180},
}

local moneys = {};

addEventHandler("onClientResourceStart",root,function()
    sColor = {100, 0, 255}
    red = {220, 73, 73}
	localPlayer:setData('river >> atmstate', nil)
	setPlayerHudComponentVisible("all",false)
	setPlayerHudComponentVisible("crosshair",true)
    font = dxCreateFont("rage.ttf",12) or "default-bold"
    font2 = dxCreateFont("rage.ttf",10) or "default-bold"
    for k,v in pairs(getElementsByType("object")) do 
        if getElementModel(v) == 2942 then 
            setObjectBreakable(v,false);
        end
    end
end);

function render(dt)
    local px,py,pz = getElementPosition(localPlayer);
    local ox,oy,oz = getElementPosition(clicked);
    if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 3 then 
        if state > 1 then 
            setElementData(clicked,"srob.state",false);
            setElementData(clicked,"srob.rabolja",localPlayer);
        end
        closeRob();
		exports['rl_bildirim']:addNotification("ATM'den ayrıldığın için soygun yarıda kesildi.", "error")
        --outputChatBox("#FFA4E3[!] #FFFFFFATM'den ayrıldığın için soygun yarıda kesildi.",255,255,255,true);
    end
    if isPedDead(localPlayer) then 
        if state > 1 then 
            setElementData(clicked,"srob.state",false);
            setElementData(clicked,"srob.rabolja",localPlayer);
        end
        closeRob();
        outputChatBox("#FFA4E3[!] #FFFFFFSen öldüğün için soygun yarıda kesildi.",255,255,255,true);
    end
    if getElementData(clicked,"srob.rabolja") and getElementData(clicked,"srob.rabolja") ~= localPlayer then 
        closeRob();
        outputChatBox("#FFA4E3[!] #FFFFFFSoyamazsın!",255,255,255,true);
    end
    if state == 1 then 
        dxDrawRectangle(sx/2-150,sy/2-50,300,100,tocolor(18,18,18,255));
        dxDrawRectangle(sx/2-150,sy/2-80,2,130,tocolor(sColor[1],sColor[2],sColor[3],255));
	    dxDrawRectangle(sx/2-150,sy/2-80,300,30,tocolor(23,23,23,255));
        dxDrawRectangle(sx/2-150,sy/2-50,300,2,tocolor(sColor[1],sColor[2],sColor[3],255));
        dxDrawText("Reval Roleplay - Atm Soygunu",5,sy/2-78,sx,100,tocolor(255,255,255),1,font,"center","top");
        dxDrawText("ATM'yi soymak ister misin?",0,sy/2-40,sx,100,tocolor(255,255,255),1,font,"center","top");
        local okColor = tocolor(sColor[1],sColor[2],sColor[3],180);
        if isMouseInPosition(sx/2-110,sy/2,100,30) then 
            okColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                state = 2;
                load = -1;
                setElementData(clicked,"srob.state",false);
                setElementData(clicked,"srob.rabolja",localPlayer);
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-110,sy/2,100,30,okColor);
        dxDrawText("Soy!",sx/2-110,sy/2,sx/2-110+100,sy/2+30,tocolor(255,255,255),1,font,"center","center");
        local noColor = tocolor(red[1],red[2],red[3],180);
        if isMouseInPosition(sx/2+10,sy/2,100,30) then 
            noColor = tocolor(red[1],red[2],red[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                closeRob();
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2+10,sy/2,100,30,noColor);
        dxDrawText("Vazgeç!",sx/2+10,sy/2,sx/2+10+100,sy/2+30,tocolor(255,255,255),1,font,"center","center");
    end
    if state == 2 then 
        dxDrawRectangle(sx/2-150,sy/2-50,300,100,tocolor(0,0,0,180));
        dxDrawRectangle(sx/2-153,sy/2-50,3,100,tocolor(sColor[1],sColor[2],sColor[3],180));
        load = load + (0.5*dt)/4
        if load > 200 then 
            generateMoney();
            state = 3;
            load = 200;
        end
        dxDrawText("ATM'yi açıyorsun...",0,sy/2-40,sx,100,tocolor(255,255,255),1,font,"center","top");
        dxDrawRectangle(sx/2-100,sy/2-15,200,30,tocolor(50,50,50));
        dxDrawRectangle(sx/2-100,sy/2-15,load,30,tocolor(sColor[1],sColor[2],sColor[3]));
        dxDrawText("İptal etmek için ATM'den çıkın.",0,sy/2+20,sx,100,tocolor(255,255,255),1,font,"center","top");
    end
    if state == 3 then 
        local all = 0;
        for k,v in pairs(moneys) do 
            if v then 
                all = all + v;
            end
        end
        dxDrawImage(sx/2-200,sy/2-350,400,700,"bg.png");
        dxDrawText("ATM'den nakitleri çıkarın.",0,sy/2-340,sx,100,tocolor(0,0,0),1,font,"center","top");
        dxDrawText("Kasadaki Para:\n"..tostring(exports.rl_global:formatMoney(all)).."₺",100,sy/2-280,sx,100,tocolor(0,0,0),1,font2,"center","top");
        for k,v in pairs(moneyPos) do 
            if moneys[k] then 
                dxDrawImage(v[1],v[2],55,99,"money.png");
                if isMouseInPosition(v[1],v[2],55,99) and getKeyState("mouse1") and clickTick+300 < getTickCount() then 
                    triggerServerEvent("srob.giveMoney",localPlayer,localPlayer,moneys[k]);
                    moneys[k] = nil;
                    local all = 0;
                    for k,v in pairs(moneys) do 
                        if v then 
                            all = all + v;
                        end
                    end
                    if all <= 0 then 
                        closeRob();
						exports['rl_bildirim']:addNotification("ATM'yi soydun, polisler yolda! Kaç!", "warning")
                        --outputChatBox("#FFA4E3[!] #FFFFFFATM'yi soydun, polisler yolda! Kaç!",255,255,255,true);
                    end
                    clickTick = getTickCount();
                end
            end
        end
        local exitColor = tocolor(red[1],red[2],red[3],200);
        if isMouseInPosition(sx/2-150/2,sy/2-40,150,25) then 
            exitColor = tocolor(red[1],red[2],red[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                closeRob();
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-150/2,sy/2-40,150,25,exitColor);
        dxDrawBorder(sx/2-150/2,sy/2-40,150,25,2,tocolor(0,0,0));
        dxDrawText("Kapat",sx/2-150/2,sy/2-40,sx/2-150/2+150,sy/2-40+25,tocolor(0,0,0),1,font,"center","center");
    end
end

addEventHandler("onClientClick",root,function(button,bstate,x,y,wx,wy,wz,clickedElement)
	if localPlayer:getData('river >> atmstate') == true or getPedOccupiedVehicle( localPlayer ) then return end
    if bstate == "down" and clickedElement and getElementData(clickedElement,"srob.loc") then 
        local px,py,pz = getElementPosition(localPlayer);
        local distance = getDistanceBetweenPoints3D(wx,wy,wz,px,py,pz);
        if distance < 3 then 
            if state == 0 then 
                if not getElementData(clickedElement,"srob.state") then 
                    --outputChatBox("#FFA4E3[!] #FFFFFFBu ATM şuan da soyuluyor! Süre: #FFA4E3"..(getElementData(clickedElement,"srob.timeleft"))"#ffffff dakika.",255,255,255,true);
					exports['rl_bildirim']:addNotification("ATM zaten soyulmuş, sonra gel.", "error")
                    --outputChatBox("#FFA4E3[!] #FFFFFFBu ATM zaten soyulmuş, sonra gel.",255,255,255,true);
                    return
                end
                if getElementData(clickedElement,"srob.rabolja") then 
					exports['rl_bildirim']:addNotification("Bu ATM zaten soyuldu!", "error")
                    --outputChatBox("#FFA4E3[!] #FFFFFFBu ATM zaten soyuldu!",255,255,255,true);
                    return;
                end
					setTimer(function()
					state = 1;
                    clicked = clickedElement;
                    removeEventHandler("onClientPreRender",root,render);
                    addEventHandler("onClientPreRender",root,render);
					setPedAnimation(localPlayer)
                    load = -1;
					--exports['rl_notification']:create('Başarıyla ATM içeriğine ulaştın, hızlı ol!', 'success')
					exports['rl_bildirim']:addNotification("Polislere soygun ihbarı gitti, işini hızlı hallet!", "info")
					end, 30000, 1)
					exports['rl_bildirim']:addNotification("Şu an atm ile uğraşıyorsun, birazdan içeriğine ulaşacaksın.", "info")
					setPedAnimation(localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
					localPlayer:setData('river >> atmstate', true)
					triggerServerEvent('river >> atmihbar', localPlayer, localPlayer)
            end
        end
    end
end);

function closeRob()
    removeEventHandler("onClientPreRender",root,render);
    state = 0;
    clicked = false;
    load = -1;
end

function generateMoney()
    moneys = {};
    local no = math.random(1000,6000);
    if no > 10 then 
        for i=1,#moneyPos do 
            local rand = math.random(1000,6000);
            moneys[i] = math.floor(tonumber(rand*2));
        end
    end
    local all = 0;
    for k,v in pairs(moneys) do 
        all = all + v;
    end
    if all == 0 then 
        outputChatBox("#FFA4E3[!] #FFFFFFNe yazık ki, para yok.",255,255,255,true);
    end
end

function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end