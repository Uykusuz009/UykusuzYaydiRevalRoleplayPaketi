local myWindow
local memoCodes
local memoProcedure
local content = {
    procedures = [[
		YANIT KODLARI

		Kod 1 ............ Sessiz Müdahale (size yakın normal vaka var, gidin)
		Kod 2 ............ Normal Müdahale (trafikte ilerlerken ışıklar)
		Kod 3 ............ Acil yanıt (ışıklar ve sirenler)
		Kod 4 ............ Yardıma ihtiyaç yok
		Kod 5 ............ Özel takip, uzaklaşın
		Kod 6 ............ Şüpheli ile iletişim
		Kod 7 ............ Yemek molası
		Kod 9 ............ Kullanılabilir birim yok
		Kod 10 .......... Bomba Tehdidi
		Kod 11 .......... SWAT talebi, yüksek risk
		Kod 31 .......... Durumunuzu, yerinizi ve statünüzü açıklayın
		Kod 33 .......... Yalnızca acil durum trafiği
	]],
    codes = [[
		----- ONLU KUDLAR -----
		10-1 -- Roll Call
		10-2 -- Olay yerine varıldı
		10-3 -- Negatif
		10-4 -- Olumlu
		10-5 -- Tekrarla 
		10-6 -- Yanındayım
		10-7 -- [Lokasyon] adresine bildir
		10-8 -- Şüpheli kayıp
		10-9 -- Şüpheli yakalandı
		10-10 -- Durum güncellemesi (Durum güncellemesi + 10-20 + 10-11 )
		10-11 -- Polis operasyonu
		10-12 -- Destek talebi
		10-13 -- Memur düştü (Yeni KOD0)
		10-17 -- Açıklama
		10-18 -- MDC Kontrolü
		10-20 -- Lokasyon
		10-21 -- Uyanık ol
		10-22 -- Son dediğimi dikkate alma 
		10-27 -- Şüpheli etkinlik ( Çete Şiddeti / Silah / Uyuşturucu Satışı )
		10-28 -- Sessiz olun (Telsiz sessizliği)
		10-29 -- Sessiz olma kaldırıldı
		10-30 -- Devriyeye dönüş (Şehir çapında)
		10-31 -- Departmana dönüş
		10-32 -- Daha fazla yardıma gerek yok
		10-50 -- Araç kaza yaptı
		10-55 -- Traffic Stop
		10-57 Victor -- Araç takibi
		10-57 Foxtrot -- Yaya takibi
		10-59 -- Güvenlik kontrolü
		10-99 -- Atama tamamlandı ( Durum: Yakalandı, ceza kesildi )
		11-24 -- Terk edilmiş, park edilmiş araç
		11-79 -- Yaralı için ambulans talep edildi
		11-80 -- Çok sayıda yaralı
		11-81 -- Yaralı var
		11-82 -- Kaza
		11-83 -- Kaza, bilgi yok
		11-85 -- TOW talep ediyorum
		11-94 -- Yaya durdurması
		11-95 -- Trafik durdurması
		11-96 -- Şüpheli araç
		11-96 -- Dolu, şüpheli araç
		11-99 -- Memurun acil yardıma ihtiyacı var
		
		----- YANIT KODLARI -----
		Kod 1 -- Acil durum dışı, bir şey yapmıyorsan yönel. (Çakarlar ve sirenler kapalı.)
		Kod 2 -- Acil durum dışı, bir şey yapıyorsan yönel. (Çakarlar ve sirenler kapalı.)
		Kod 3 -- Acil çağrı. (Çakarlar ve sirenler açık)
		
		----- DURUM KODLARI -----
		Status 1 -- Görevde
		Status 2 -- Görev dışı
		Status 3 -- İnaktif - Yemek molası, yakıt takviyesi vb.
		
		----- KİMLİK KODLARI -----
		IC1 – Beyaz, Avrupalı
		IC2 – Avrupalı/Hispanik
		IC3 – Afrikalı/Afro-karayip
		IC4 – Hindistan, Pakistan, Nepal, Maldivler, Bangladeş veya başka - Asyalı
		IC5 – Çin, Japon veya Güneydoğu Asyalı
	]],
    exampleRadios = [[
		ÖRNEKLER

		10 Lincoln 07'den Dispatch'e, 11-99! Çevredeki ekiplerden acil kod 3 bekleniyor.

		3 Adam 01'den Dispatch'e, Mavi Sultan için 11-95, Idlewood Gas Station, kod 6.

		2 Sam 01'den Dispatch'e, John Markes isimli sivil için.

		1 Frank 03'den Dispatch'e, Tom Thomas için 10-27 talep ediliyor.

		UPDATE

		--Başlangıç:
		1 Adam 07'den Dispatch'e, 10-50! Update bildirilerini Adam 9'ye devrediyoruz.

		--Update:
		1 Adam 09'den Dispatch'e, Pursuit Update; kırmızı elegy Idlewood'u geride bırakarak Jefferson'a yöneldi.

		SAHAYA ÇIKIŞ

		Örnek: 3 Adam 07

		3 Adam 07 iki memurla sahaya katılıyor, çağrılara açık, burası <konum>
		3 = İstasyon numarası
		Adam = İki memurlu devriye aracı
		07 = PLAKA 607 (Plakanın son iki numarasını alacaksın.)

		Örnek: 10 Lincoln 11

		10 Sam 11 yüksek komuta memuru tarafından yönetilecek şekilde sahaya katılıyor, burası <konum>
		10 = İstasyon numarası
		Lincoln = Tek memurlu devriye aracı
		11 = PLAKA 611 (Plakanın son iki numarasını alacaksın.)
	]],
    stations = [[
		İstasyon numaraları:

		1: Fullerton 13 Precinct Station (Commerce)
		2: Temple Street Police Station
		3: Wilshire Police Station (Jefferson, Main)
		4: East Venice Precinct Station (Jefferson)
		5: Southern District Police Station (Metropolitan, Temple)
	]],
    vehicles = [[
		ADAM = İki memurlu devriye aracı
		LINCOLN = Tek memurlu devriye aracı
		DAVID = SWAT
		EDWARD = Hız birimi
		FRANKBOY = Yaya devriyesi
		FRANK = Özel görevler, diğer adıyla HSU
		MARY = Motosiklet
		AIR = Hava birimi
		SAM = Supervisor (Denetleme görevleri, sevk ve departman işleri).
	]]
}

local activeTabs = {
    { label = 'Cevaplar & Onlu Kodlar', key = 'procedures' },
    { label = 'Telsiz Örnekleri', key = 'exampleRadios' },
    { label = 'Radyo Prosedürleri', key = 'codes' },
    { label = 'İstasyonlar', key = 'stations' },
    { label = 'Araçlar', key = 'vehicles' }
}

function displayPdCodes(contentFromServer)
    closePdCodes()

    if getElementData(localPlayer, "faction") ~= 1 then
        return false
    end

    myWindow = guiCreateWindow(0.25, 0.25, 0.5, 0.5, "Los Santos Hükümeti - Radyo Kodları ve Prosedürleri", true)
    local tabPanel = guiCreateTabPanel(0, 0.12, 1, 1, true, myWindow)

    for i, tab in ipairs(activeTabs) do
        local text = content[tab.key]
        local tab = guiCreateTab(tab.label, tabPanel)
        local memo = guiCreateMemo(0.02, 0.02, 0.96, 0.96, text, true, tab)
        guiMemoSetReadOnly(memo, true)
    end

    local tlBackButton = guiCreateButton(0.89, 0.05, 0.1, 0.07, "Kapat", true, myWindow) -- close button
    addEventHandler("onClientGUIClick", tlBackButton, closePdCodes, false)

    showCursor(true)
    guiSetInputEnabled(true)
end
addCommandHandler("pdcodes", displayPdCodes)

function closePdCodes()
    if myWindow and isElement(myWindow) then
        --If
        showCursor(false)
        destroyElement(myWindow)
        tlBackButton = nil
        myWindow = nil
    end
    guiSetInputEnabled(false)
end