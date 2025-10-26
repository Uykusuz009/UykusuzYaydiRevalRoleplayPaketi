local screenW, screenH = guiGetScreenSize()


function tuningGUI()
    if guiGetVisible(tuningpanel) == true then
    return end

    -- Ana panel oluşturma
    tuningpanel = guiCreateWindow((screenW - 800) / 2, (screenH - 500) / 2, 800, 500, "🏎️ Reval Roleplay - Araç Tuning Sistemi", false)
    guiWindowSetSizable(tuningpanel, false)
    guiSetProperty(tuningpanel, "CaptionColour", "FF1E90FF")
    
    -- Tab panel oluşturma
    tuningmenu = guiCreateTabPanel(10, 30, 780, 460, false, tuningpanel)
    
    -- Tuning tab'ı
    tuningtab = guiCreateTab("🔧 Tuning", tuningmenu)
    
    -- Hoş geldin mesajı
    tuningyazi = guiCreateLabel(20, 20, 740, 60, "🎯 Merhaba! Reval Araç Tuning Sistemine Hoşgeldin!\n\nBu kısımda şehirdeki tüm araçların performansını arttırabileceğin ürünler mevcut.\nLütfen satın alım öncesinde fiyatlara ve takacağın ürünlere dikkat et! Bazı işlemlerin geri dönüşü olmayabilir.", false, tuningtab)
    guiSetFont(tuningyazi, "default-bold-small")
    guiLabelSetColor(tuningyazi, 255, 255, 255)
    
    -- Motorlar bölümü
    motorlabel = guiCreateLabel(50, 100, 150, 25, "🚗 MOTORLAR", false, tuningtab)
    guiSetFont(motorlabel, "default-bold-small")
    guiLabelSetColor(motorlabel, 255, 165, 0)
    
    motor1btn = guiCreateButton(50, 130, 150, 50, "Street Pack\n💵 100.000₺", false, tuningtab)
    guiSetProperty(motor1btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(motor1btn, "HoverTextColour", "FF00FF00")
    
    motor2btn = guiCreateButton(50, 190, 150, 50, "Pro Pack\n💵 250.000₺", false, tuningtab)
    guiSetProperty(motor2btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(motor2btn, "HoverTextColour", "FF00FF00")
    
    motor3btn = guiCreateButton(50, 250, 150, 50, "Extreme Pack\n💵 500.000₺", false, tuningtab)
    guiSetProperty(motor3btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(motor3btn, "HoverTextColour", "FF00FF00")
    
    -- Turbolar bölümü
    turbolabel = guiCreateLabel(220, 100, 150, 25, "⚡ TURBOLAR", false, tuningtab)
    guiSetFont(turbolabel, "default-bold-small")
    guiLabelSetColor(turbolabel, 255, 69, 0)
    
    turbo1btn = guiCreateButton(220, 130, 150, 50, "Street Pack\n💵 150.000₺", false, tuningtab)
    guiSetProperty(turbo1btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(turbo1btn, "HoverTextColour", "FF00FF00")
    
    turbo2btn = guiCreateButton(220, 190, 150, 50, "Pro Pack\n💵 300.000₺", false, tuningtab)
    guiSetProperty(turbo2btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(turbo2btn, "HoverTextColour", "FF00FF00")
    
    turbo3btn = guiCreateButton(220, 250, 150, 50, "Extreme Pack\n💵 600.000₺", false, tuningtab)
    guiSetProperty(turbo3btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(turbo3btn, "HoverTextColour", "FF00FF00")
    
    -- Süspansiyon bölümü
    suspansiyonlabel = guiCreateLabel(390, 100, 150, 25, "🛠️ SÜSPANSİYON", false, tuningtab)
    guiSetFont(suspansiyonlabel, "default-bold-small")
    guiLabelSetColor(suspansiyonlabel, 0, 255, 255)
    
    suspansiyon1btn = guiCreateButton(390, 130, 150, 50, "Street Pack\n💵 80.000₺", false, tuningtab)
    guiSetProperty(suspansiyon1btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(suspansiyon1btn, "HoverTextColour", "FF00FF00")
    
    suspansiyon2btn = guiCreateButton(390, 190, 150, 50, "Pro Pack\n💵 200.000₺", false, tuningtab)
    guiSetProperty(suspansiyon2btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(suspansiyon2btn, "HoverTextColour", "FF00FF00")
    
    suspansiyon3btn = guiCreateButton(390, 250, 150, 50, "Extreme Pack\n💵 400.000₺", false, tuningtab)
    guiSetProperty(suspansiyon3btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(suspansiyon3btn, "HoverTextColour", "FF00FF00")
    
    -- Frenler bölümü
    frenlabel = guiCreateLabel(560, 100, 150, 25, "🛑 FRENLER", false, tuningtab)
    guiSetFont(frenlabel, "default-bold-small")
    guiLabelSetColor(frenlabel, 255, 0, 0)
    
    fren1btn = guiCreateButton(560, 130, 150, 50, "Street Pack\n💵 70.000₺", false, tuningtab)
    guiSetProperty(fren1btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(fren1btn, "HoverTextColour", "FF00FF00")
    
    fren2btn = guiCreateButton(560, 190, 150, 50, "Pro Pack\n💵 180.000₺", false, tuningtab)
    guiSetProperty(fren2btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(fren2btn, "HoverTextColour", "FF00FF00")
    
    fren3btn = guiCreateButton(560, 250, 150, 50, "Extreme Pack\n💵 350.000₺", false, tuningtab)
    guiSetProperty(fren3btn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(fren3btn, "HoverTextColour", "FF00FF00")
    
    -- Performans bilgileri
    performanslabel = guiCreateLabel(20, 320, 740, 80, "📊 PERFORMANS BİLGİLERİ:\n\n• Street Pack: +10 Hız | • Pro Pack: +25 Hız | • Extreme Pack: +40 Hız\n• Turbo: Ekstra güç artışı | • Süspansiyon: Daha iyi kontrol | • Frenler: Daha iyi durma", false, tuningtab)
    guiSetFont(performanslabel, "default-small")
    guiLabelSetColor(performanslabel, 200, 200, 200)
    
    -- Yardım tab'ı
    yardimtab = guiCreateTab("❓ Yardım", tuningmenu)
    
    yardimmemo = guiCreateMemo(10, 10, 760, 440, "🏁 Reval Roleplay V2 | Araç Tuning Sistemi\n\n⚠️ ÖNEMLİ UYARILAR:\n\n• Tamirhanelerin dışarısında bu sistemin kullanılması durumunda \"Araç Mekanikçisi\" yetkiniz alınacaktır.\n• Sistemi kullanmadan önce gerekli emotelerinizi vererek parçaları takmış olmanız gerekmektedir.\n• Dikkat edilmesi gereken noktalara uymamanız durumunda yetkiniz alınacak ve OOC ihlal cezası alacaksınız.\n\n🎯 KULLANIM:\n• Sadece Araç Mekanikçisi (Job 7) olan oyuncular kullanabilir.\n• Tamirhane interiorunda (Interior 24) olmanız gerekmektedir.\n• Araçta olmanız gerekmektedir.\n\n💰 FİYATLAR:\n• Street Pack: 70.000₺ - 150.000₺\n• Pro Pack: 180.000₺ - 300.000₺\n• Extreme Pack: 350.000₺ - 600.000₺\n\n🚀 İyi roller, iyi eğlenceler dileriz!\n\n- RL Yönetim Ekibi\n@LargeS 2020 RL V3.5", false, yardimtab)
    guiMemoSetReadOnly(yardimmemo, true)
    guiSetFont(yardimmemo, "default-small")
    
    -- Çıkış butonu
    cikisbtn = guiCreateButton(760, 5, 30, 25, "❌", false, tuningtab)
    guiSetProperty(cikisbtn, "NormalTextColour", "FFFF0000")
    guiSetProperty(cikisbtn, "HoverTextColour", "FFFF6666")
end
addEvent( "tuningGoster", true )
addEventHandler( "tuningGoster", localPlayer, tuningGUI )

    -- Onay penceresi
    soru = guiCreateWindow((screenW - 500) / 2, (screenH - 250) / 2, 500, 250, "🔧 Tuning Onayı", false)
    guiSetProperty(soru, "CaptionColour", "FF1E90FF")
    
    -- Onay mesajı
    sorulabel = guiCreateLabel(20, 20, 460, 120, "", false, soru)
    guiSetFont(sorulabel, "default-bold-small")
    guiLabelSetColor(sorulabel, 255, 255, 255)
    
    -- Onay butonu
    okbtn = guiCreateButton(50, 160, 180, 50, "✅ PARÇAYI TAK", false, soru)
    guiSetProperty(okbtn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(okbtn, "HoverTextColour", "FF00FF00")
    
    -- İptal butonu
    iptalbtn = guiCreateButton(270, 160, 180, 50, "❌ İPTAL", false, soru)
    guiSetProperty(iptalbtn, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(iptalbtn, "HoverTextColour", "FFFF0000")
    
    guiSetVisible(soru, false)
    
function btnFonks()
    if source == cikisbtn then
        guiSetVisible(tuningpanel, false)
	elseif source == motor1btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",true)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🚗 STREET PACK MOTOR\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +10 Hız\n💰 Fiyat: 100.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == motor2btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",true)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🚗 PRO PACK MOTOR\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +25 Hız\n💰 Fiyat: 250.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == motor3btn then 
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",true)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)     
        guiSetText(sorulabel, "🚗 EXTREME PACK MOTOR\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +40 Hız\n💰 Fiyat: 500.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == turbo1btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",true)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "⚡ STREET PACK TURBO\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +2 Kalkış Hızı\n💰 Fiyat: 150.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == turbo2btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",true)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "⚡ PRO PACK TURBO\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +5 Kalkış Hızı\n💰 Fiyat: 300.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == turbo3btn then 
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",true)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)     
        guiSetText(sorulabel, "⚡ EXTREME PACK TURBO\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +7 Kalkış Hızı\n💰 Fiyat: 600.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == suspansiyon1btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",true)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🛠️ STREET PACK SÜSPANSİYON\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +2 Kontrol\n💰 Fiyat: 80.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == suspansiyon2btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",true)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🛠️ PRO PACK SÜSPANSİYON\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +5 Kontrol\n💰 Fiyat: 200.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == suspansiyon3btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",true)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🛠️ EXTREME PACK SÜSPANSİYON\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +7 Kontrol\n💰 Fiyat: 400.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == fren1btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",true)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🛑 STREET PACK FREN\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +2 Fren Gücü\n💰 Fiyat: 70.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == fren2btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",true)
        setElementData(localPlayer,"fren3",false)
        guiSetText(sorulabel, "🛑 PRO PACK FREN\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +5 Fren Gücü\n💰 Fiyat: 180.000₺\n\nGerçekten takmak istiyor musunuz?")
    elseif source == fren3btn then
        guiSetVisible(tuningpanel, false)
        guiSetVisible(soru, true)
		setElementData(localPlayer,"motor1",false)
        setElementData(localPlayer,"motor2",false)
        setElementData(localPlayer,"motor3",false)
        setElementData(localPlayer,"turbo1",false)
        setElementData(localPlayer,"turbo2",false)
        setElementData(localPlayer,"turbo3",false)
        setElementData(localPlayer,"suspansiyon1",false)
        setElementData(localPlayer,"suspansiyon2",false)
        setElementData(localPlayer,"suspansiyon3",false)
        setElementData(localPlayer,"fren1",false)
        setElementData(localPlayer,"fren2",false)
        setElementData(localPlayer,"fren3",true)
        guiSetText(sorulabel, "🛑 EXTREME PACK FREN\n\nBu ürünü araçınıza takmak üzeresiniz.\n\n📊 Performans: +7 Fren Gücü\n💰 Fiyat: 350.000₺\n\nGerçekten takmak istiyor musunuz?")
    end
end
addEventHandler("onClientGUIClick", getRootElement(), btnFonks)

function soruFonks()
    if source == okbtn and getElementData(localPlayer,"motor1") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("motorvar1",localPlayer,localPlayer)
	elseif source == okbtn and getElementData(localPlayer,"motor2") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("motorvar2",localPlayer,localPlayer)
	elseif source == okbtn and getElementData(localPlayer,"motor3") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("motorvar3",localPlayer,localPlayer)
	elseif source == okbtn and getElementData(localPlayer,"turbo1") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("turbovar1",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"turbo2") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("turbovar2",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"turbo3") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("turbovar3",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"suspansiyon1") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("suspansiyonvar1",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"suspansiyon2") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("suspansiyonvar2",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"suspansiyon3") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("suspansiyonvar3",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"fren1") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("frenvar1",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"fren2") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("frenvar2",localPlayer,localPlayer)
    elseif source == okbtn and getElementData(localPlayer,"fren3") == true then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
        triggerServerEvent("frenvar3",localPlayer,localPlayer)
    elseif source == iptalbtn then
        guiSetVisible(soru, false)
        guiSetVisible(tuningpanel, true)
    end
end
addEventHandler("onClientGUIClick", getRootElement(), soruFonks)

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getVehicleRPM(vehicle)
    local vehicleRPM = 0
        if (vehicle) then  
            if (getVehicleEngineState(vehicle) == true) then
                if getVehicleCurrentGear(vehicle) > 0 then             
                    vehicleRPM = math.floor(((getElementSpeed(vehicle, "km/h") / getVehicleCurrentGear(vehicle)) * 160) + 0.5) 
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                else
                    vehicleRPM = math.floor((getElementSpeed(vehicle, "km/h") * 160) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                end
            else
                vehicleRPM = 0
            end
    
            return tonumber(vehicleRPM)
        else
            return 0
        end
    end
    

local turboses = true

function TurboSesKapat()
    turboses = false
    outputChatBox("[Reval]:#FFFFFF Araçtaki turbo sesini başarı ile kapattınız!",100,0,255,true)
end
addCommandHandler("turboseskapat", TurboSesKapat)

function TurboSesAc()
    turboses = true
    outputChatBox("[Reval]:#FFFFFF Araçtaki turbo sesini başarı ile açtınız!",100,0,255,true)
end
addCommandHandler("turbosesac", TurboSesAc)

function deviral() 
    local veh = getPedOccupiedVehicle(localPlayer)  
    if (getVehicleRPM(veh) > 6000) and getElementData(veh, "turboluke") == true then
        if turboses then
            triggerServerEvent("turbosesyollabakam", localPlayer, root)
        else
            --
        end
    end
end
bindKey("W","up", deviral)

function sesGeldimiTurbo()
    if turboses then
        local sans = math.random(1,2)
        if sans == 1 then
            local araba = getPedOccupiedVehicle(source)
            local x, y, z = getElementPosition(araba)
            local turboses = playSound3D("turbo.mp3", x,y,z, false)
            setSoundVolume ( turboses, 0.5 )
            setSoundMaxDistance( turboses, 100 )    
            setSoundVolume(turboses, 0.5)
        elseif sans == 2 then
            local araba = getPedOccupiedVehicle(source)
            local x, y, z = getElementPosition(araba)
            local turboses2 = playSound3D("turbo2.mp3", x,y,z, false)
            setSoundVolume ( turboses2, 0.5 )
            setSoundMaxDistance( turboses2, 100 )    
            setSoundVolume(turboses2, 0.5)
        end
    else
        --
    end
end
addEvent( "turbosesgeldi", true )
addEventHandler( "turbosesgeldi", root, sesGeldimiTurbo )

local egzozses = true

function EgzozSesKapat()
    egzozses = false
    outputChatBox("[Reval]:#FFFFFF Araçtaki Egzoz sesini başarı ile kapattınız!",100,0,255,true)
end
addCommandHandler("egzozseskapat", EgzozSesKapat)

function EgzozSesAc()
    egzozses = true
    outputChatBox("[Reval]:#FFFFFF Araçtaki Egzoz sesini başarı ile açtınız!",100,0,255,true)
end
addCommandHandler("egzozsesac", EgzozSesAc)

function deviral() 
    local veh = getPedOccupiedVehicle(localPlayer)  
    if (getVehicleRPM(veh) > 6000) and getElementData(veh, "egzozluke") == true then
        if turboses then
            triggerServerEvent("egzozsesyollabakam", localPlayer, root)
        else
            --
        end
    end
end
bindKey("W","up", deviral)

function sesGeldimiEgzoz()
    if egzozses then
        local sans = math.random(1,2)
        if sans == 1 then
            local araba = getPedOccupiedVehicle(source)
            local x, y, z = getElementPosition(araba)
            local egzozses = playSound3D("egzoz.mp3", x,y,z, false)
            setSoundVolume ( egzozses, 0.5 )
            setSoundMaxDistance( egzozses, 100 )    
            setSoundVolume(egzozses, 0.5)
        elseif sans == 2 then
            local araba = getPedOccupiedVehicle(source)
            local x, y, z = getElementPosition(araba)
            local egzozses2 = playSound3D("egzoz2.mp3", x,y,z, false)
            setSoundVolume ( egzozses2, 0.5 )
            setSoundMaxDistance( egzozses2, 100 )    
            setSoundVolume(egzozses2, 0.5)
        end
    else
        --
    end
end
addEvent( "egzozsesgeldi", true )
addEventHandler( "egzozsesgeldi", root, sesGeldimiEgzoz )



-- Ateşin kaybolması olayı
--egzozkisi[localPlayer] = ates
--setTimer( function()
    --if isElement(egzozkisi[localPlayer]) then
        --destroyElement (egzozkisi[localPlayer])
        --egzozkisi[localPlayer]=nil
    --end
--end, 1000, 1)