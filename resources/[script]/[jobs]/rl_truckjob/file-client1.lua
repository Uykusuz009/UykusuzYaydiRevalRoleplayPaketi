local ekran_x,ekran_y=guiGetScreenSize()
local w,h = 500,230
local x,y = (ekran_x-w)/2,(ekran_y-h)/2

marker_shower = createMarker(2180.0498046875, -2231.4267578125, 10.443439483643,"cylinder",4,0,0,0,255)
col_loj_dx=createColSphere(2180.0498046875, -2231.4267578125, 13.443439483643,4)
lojistik_dx=nil
click=0
logo_sett={aw=40,ah=35,lw=35,lh=35,pw=40,ph=35,sw=40,sh=35}
fiyatlar={gidilecek_bolge="",tutar=""}

addEvent("depo_1_senaryo",true)
addEvent("depo_2_senaryo",true)
local o_ped = {}
local b_ped = {}
local h5nzfont = exports.rl_fonts:getFont("RobotoB",9)
function draw_dx()
roundedRectangle(x,y,w,h-200,5,tocolor(7,7,7,220))
roundedRectangle(x,y+200,w,30,5,tocolor(7,7,7,220))
roundedRectangle(x,y,w,h,5,tocolor(7,7,7,220))
dxDrawText("Lojistik Arayüzü |  Kötü yollara düşmeden fazlasıyla para kazanabileceğin bir iş...",x+10,y+8,w,h,tocolor(222,222,222,150),1,h5nzfont)
dxDrawText(fiyatlar.gidilecek_bolge,x+10,y+208,w,h,tocolor(222,222,222,190),1,h5nzfont)
dxDrawText(fiyatlar.tutar,x+330,y+208,w,h,tocolor(222,222,222,190),1,h5nzfont)
dxDrawText("Reval©",x+220,y+208,w,h,tocolor(222,222,222,150),1,h5nzfont)
dxDrawText("X",x*2-200,y+8,w,h,tocolor(222,222,222,150),1,h5nzfont)
dxDrawText("Merhaba emekçi. Aşağıdan rotasyonu seç ve dorseni depodan tırına bağla.\nEğer tır sana aitse tur parasını olduğu gibi sen alırsın, eğer \ntır başkasına aitse paranın yarısı tır sahibinin hesabına gider.",x+12,y+40,w,h,tocolor(222,222,222,210),1,h5nzfont)
dxDrawImage(x+200,y+115,w-420,h-185,"files/logo_audi.png")
--dxDrawImage(x+145,y+110,w-420,h-185,"files/logo_lays.png")
--dxDrawImage(x+270,y+110,w-420,h-185,"files/logo_pepsi.png")
--dxDrawImage(x+395,y+110,w-450,h-185,"files/logo_shell.png")
if mouse(x+210,y+115,40,50) then
logo_sett.aw=40+math.abs(math.sin(getTickCount()/500)*8)
logo_sett.ah=35+math.abs(math.sin(getTickCount()/500)*8)
fiyatlar.gidilecek_bolge="Bölge: Audi Fabrikası"
fiyatlar.tutar="Ödenecek Tutar: "..exports.rl_global:formatMoney(audi_fiyat).."₺"
if getKeyState("mouse1") and click+200<=getTickCount() then click=getTickCount()
removeEventHandler("onClientRender",getRootElement(),draw_dx)
lojistik_dx=nil
triggerServerEvent("lojistik_create",getLocalPlayer(),1)
end

else
logo_sett.aw=40
logo_sett.ah=35
logo_sett.lw=35
logo_sett.lh=35
logo_sett.pw=40
logo_sett.ph=35
logo_sett.sw=40
logo_sett.sh=35
fiyatlar.gidilecek_bolge=""
fiyatlar.tutar=""
end
end

addEventHandler("depo_1_senaryo",getRootElement(),function()
setCameraMatrix(2209.37,-2250.907,16.668,2210.34,-2251.119,16.556)
o_ped[getLocalPlayer()] = createPed(7,2221.2568359375, -2251.4931640625, 13.554685592651)
setElementRotation(o_ped[getLocalPlayer()],0,0,41.5)
setPedAnimation(o_ped[getLocalPlayer()],"POLICE","CopTraf_Come",-1,true,false,false)
setTimer(function() setCameraTarget(getLocalPlayer()) destroyElement(o_ped[getLocalPlayer()]) o_ped[getLocalPlayer()]=nil end,3000,1)
end)

addEventHandler("depo_2_senaryo",getRootElement(),function()
setCameraMatrix(2192.200,-2263.709,16.112,2193.157,-2263.998,16.070,-20)
b_ped[getLocalPlayer()] = createPed(7,2205.8896484375, -2264.435546875, 13.554685592651)
setElementRotation(b_ped[getLocalPlayer()],0,0,45.5)
setPedAnimation(b_ped[getLocalPlayer()],"POLICE","CopTraf_Come",-1,true,false,false)
setTimer(function() setCameraTarget(getLocalPlayer()) destroyElement(b_ped[getLocalPlayer()]) b_ped[getLocalPlayer()]=nil end,3000,1)
end)

function give_info(_,__)
if (_ == localPlayer) then
if lojistik_dx==nil then
if source==col_loj_dx then
local p_tiri = getPedOccupiedVehicle(getLocalPlayer())
if p_tiri then else return end
if (getElementModel(p_tiri)==403) or (getElementModel(p_tiri)==514) or (getElementModel(p_tiri)==515) then else return end
if getElementData(getLocalPlayer(),"lojistik_isci") then outputChatBox("Lojistik: #ffffffZaten çalışıyorsun!",44,44,44,true) return end
lojistik_dx=true
addEventHandler("onClientRender",getRootElement(),draw_dx)
end
end
end
end
addEventHandler("onClientColShapeHit",getRootElement(),give_info)

function take_info(_,__)
if (_ == localPlayer) then
if lojistik_dx==true then
if source==col_loj_dx then
lojistik_dx=nil
removeEventHandler("onClientRender",getRootElement(),draw_dx)
end
end
end
end
addEventHandler("onClientColShapeLeave",getRootElement(),take_info)

addEvent("dorse_started",true)
addEventHandler("dorse_started",getRootElement(),function(x,y,z,rx,ry,fiyat)
marker = createMarker(x,y,z,"checkpoint",3,255,0,0)
p_tiri = getPedOccupiedVehicle(getLocalPlayer())
addEventHandler("onClientMarkerHit",marker,function(player)
if player == localPlayer then
p_tiri = getPedOccupiedVehicle(player)
if p_tiri then else return end
if getElementType(player) == "player" and (getElementModel(p_tiri)==403) or (getElementModel(p_tiri)==514) or (getElementModel(p_tiri)==515) then triggerServerEvent("dorse_started",player,p_tiri,fiyat) destroyElement(marker) end end
end)
end)

addEvent("client_clear",true)
addEventHandler("client_clear",getRootElement(),function()
if marker then destroyElement(marker) end
end)

addEvent("truck_donus",true)
addEventHandler("truck_donus",getRootElement(),function(fiyat)
marker = createMarker(2231.75,-2218.79,13.54,"checkpoint",3,0,255,0)
--setElementData(p_tiri,"gpsDestination",{2218.55,-2226.66})
addEventHandler("onClientMarkerHit",marker,function(player)
if player == localPlayer then
p_tiri = getPedOccupiedVehicle(player)
if p_tiri then else return end
if getElementType(player) == "player" and (getElementModel(p_tiri)==403) or (getElementModel(p_tiri)==514) or (getElementModel(p_tiri)==515) then
destroyElement(marker) triggerServerEvent("truckFinish",player,fiyat)
end
end
end)
end)

function mouse(m_x,m_y,m_w,m_h)
if isCursorShowing() then else return end
local mouseX,mouseY = getCursorPosition()
m_eX,m_eY = guiGetScreenSize()
local neredeX,neredeY = mouseX*m_eX,mouseY*m_eY
if neredeX > m_x and neredeX < m_x + m_w and neredeY > m_y and neredeY < m_y + m_h then return true end
end

function roundedRectangle(x,y,width,height,radius,color,postGUI,subPixelPositioning)
dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end