function gorevdekiOyuncularr(meslek_id, oyuncu2)
	-- if not meslek_id then return "Meslek id girilmemiş" end
	local sayac = 0
	for _, oyuncu in ipairs(getElementsByType("player")) do
		local oyuncuMeslek = tonumber(getElementData(oyuncu, "job"))
		if oyuncuMeslek then
			if oyuncuMeslek == tonumber(meslek_id) then
				local playerItems = exports["rl_items"]:getItems(oyuncu)
				local pnumber = " Yok"
				for index, value in ipairs(playerItems) do
					if value[1] == 2 then
						pnumber = value[2]
					end
				end
				sayac = sayac + 1
				-- setTimer(function()outputChatBox("[!]#779292 "..getPlayerName(oyuncu):gsub("_"," ").." - "..pnumber, oyuncu2, 0, 100, 255, true) end,250,1)
			end
		end
	end
	return sayac
end
--///////////GÜNCELLEME////////--
-- /tamiret kaldırıldı.
-- Otomatik olarak panel açılıyor ve gerekli bilgileri algılıyor
-- Araç hasarına göre para kesiyor.
--/////////// AYARLAR /////////--
local px, py = guiGetScreenSize()
local font = dxCreateFont("files/5.ttf",10)
local font2 = dxCreateFont("files/5.ttf",9)
local font3 = dxCreateFont("files/5.ttf",50)
panel = false
buton_aktif = false
local deger = 0
local artis = 2
local renk = {
   [1] = tocolor(255, 255, 255, 255), -- Beyaz RGB
   [2] = "#FFFFFF", -- Beyaz HEX
   [3] = tocolor(100, 0, 255, 255), -- Mavi RGB
   [4] = "#6000ff", -- Mavi HEX
}
local ayarlar = { 
	yazi_1 = " Tamirciler şuan da aracınızı inceliyor \nlütfen bekleyiniz.. \n",
	yazi_2 = " Aracınızın toplam masrafı ",
	yazi_3 = " Aracınızda şuanda herhangi bir masraf yok ancak \nyinede tamir ettirebilirsiniz. ",
	x =    1911.4072265625,
	y =  -1776.88867187,
	z =  13.3828125, 
	--x =  -2052.0917968,
	--y =  156.81445,
	--z =  28.84293174,
	triger = "Tamirsistemi:tamir",
}

 local tamirci_marker = createMarker ( ayarlar.x, ayarlar.y, ayarlar.z-2, "cylinder", 3, 179, 40, 199, 100 )
 -- local tamirci_marker = createMarker ( 1920.9453125, -1790.548828125, 13.263904571533-2, "cylinder", 3, 255, 255, 0, 120 )
 --/////////// UFAK AYARLAR /////////--
 function temizle ()
	panel = false
	buton_aktif = false
	deger = 0
 end
--/////////// GİRİS /////////--
function marker_giris ( giren )
	if giren == localPlayer then
		local arac = getPedOccupiedVehicle ( giren )
		if arac then
		panel = true
		addEventHandler("onClientRender", root, onay_panel)	
		end
	end	
end
addEventHandler ( "onClientMarkerHit", tamirci_marker, marker_giris )
--/////////// ÇIKIŞ /////////--
function marker_cikis ( cikan )
	if cikan == localPlayer then
		temizle ()
		removeEventHandler("onClientRender", root, onay_panel)
		showCursor(false)
	end	
end
addEventHandler ( "onClientMarkerLeave", tamirci_marker, marker_cikis )
--/////////// PANEL /////////--

function onay_panel ()
local arac_koltuk = getPedOccupiedVehicleSeat ( getLocalPlayer() )
    if panel and arac_koltuk == 0 then
		local arac = getPedOccupiedVehicle(getLocalPlayer())
		local arac_cani = getElementHealth(arac)
		local hasar = 1000 - arac_cani
		hasar = math.floor(hasar)
		local para = math.floor(hasar * 5)
		x,y,w,h = px/2-220,py/2-220/2,450,150
		tx,ty,tw,th = x+4,y+4,w-8,20
		dxDrawRectangle(x,y,w,h,tocolor(0,0,0,130))
		dxDrawRectangle(x+4,y+4,w-8,h-8,tocolor(10,10,10,150))
		dxDrawRectangle(x+4,y+4,w-8,20,tocolor(35,35,35,120))
		dxDrawText(" "..renk[4].."Reval Roleplay#ffffff - Tamir Sistemi",tx,ty,tw+tx,th+ty,tocolor(255,255,255),1,font,"center","center",false,false,false,true)
		if hasar >= 900 then
		artis = 2.0
		elseif hasar >= 800 then
		artis = 1.8
		elseif hasar >= 700 then
		artis = 1.6
		elseif hasar >= 600 then
		artis = 1.5
		elseif hasar >= 500 then
		artis = 1.4
		elseif hasar >= 400 then
		artis = 1.3
		elseif hasar >= 300 then
		artis = 1.2
		elseif hasar >= 200 then
		artis = 1.1
		elseif hasar >= 100 then
		artis = 1.0
		end
	if deger < 100 then
		if ( deger < 100 ) then deger = deger + artis end 
		dxDrawText(ayarlar.yazi_1.." "..math.floor(deger),tx+12,ty+95,tw+tx,th+ty,tocolor(255,255,255),1,font,"center","center",false,false,false,true)
	else
		buton_aktif = true
		if para == 0 then
		dxDrawText(ayarlar.yazi_3,tx+12,ty+95,tw+tx,th+ty,tocolor(255,255,255),1,font,"center","center",false,false,false,true)
		else
		dxDrawText(ayarlar.yazi_2.." "..math.floor(para).."₺",tx+12,ty+95,tw+tx,th+ty,tocolor(255,255,255),1,font,"center","center",false,false,false,true)
		end
		drawButton(" Tamir et",x+w/2-1/2-200,y+h-50,155,30,renk[4],false, false, false, nil, true)
		drawButton(" Kapat",x+w/2+495/2-200,y+h-50,155,30,"#d20000",false, false, false, nil, true)
		showCursor(true)
		end
	end
end
--/////////// TIKLAMA OLAYLARI /////////--
addEventHandler("onClientClick",root,function(buton,durum)
	if buton == "left" and durum == "down" and buton_aktif  then
		x,y,w,h = px/2-220,py/2-220/2,450,150
			if mouse_bolgedemi(x+w/2-1/2-200,y+h-50,155,30) then
			triggerServerEvent ( ayarlar.triger, getLocalPlayer(), getLocalPlayer() )
			temizle ()
			showCursor(false)
			removeEventHandler("onClientRender", root, onay_panel)
			elseif mouse_bolgedemi(x+w/2+495/2-200,y+h-50,155,30) then
			temizle()
			removeEventHandler("onClientRender", root, onay_panel)
			showCursor(false)
		end
	end
end)

--/////////// MOUSE /////////--

function mouse_bolgedemi ( x, y, width, height )
if ( not isCursorShowing( ) ) then
return false
end
local sx, sy = guiGetScreenSize ( )
local cx, cy = getCursorPosition ( )
local cx, cy = ( cx * sx ), ( cy * sy )
if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
return true
else
return false
end
end