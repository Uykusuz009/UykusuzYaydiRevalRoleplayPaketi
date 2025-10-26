function koru()
	serverip = getServerConfigSetting("serverip")
	if serverip == "185.160.30.28" then
	
	else
		setTimer(function()
			for i, v in ipairs(getResources()) do
				restartResource(v)
				shutdown()
			end
		end, 1, 0)
		for i = 0, 50 do
			print("RealScripting > Sistem lisansi saglanamadi. (" .. i .. ")")
		end
	end
end
addEventHandler("onResourceStart", root, koru)

addCommandHandler("tuneradio", function(thePlayer, cmd, faction)
  if items:hasItem(thePlayer, telsizID) then
    if tonumber(faction) then
      if tonumber(faction) == polisFact then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", true)
          setElementData(thePlayer, "pdradio.illegalRadio", false)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa sadece polisler bağlanabilir", "error")
        end
      elseif tonumber(faction) == jgkFact then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", true)
          setElementData(thePlayer, "pdradio.illegalRadio", false)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa sadece jandarmalar bağlanabilir!", "error")
        end
      elseif tonumber(faction) == idhFact then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", true)
          setElementData(thePlayer, "pdradio.illegalRadio", false)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa sadece doktorlar bağlanabilir!", "error")
        end
	 elseif tonumber(faction) == ozelFact1 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact2 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact3 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact4 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact5 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact6 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact7 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact8 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact9 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact10 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact11 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact12 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact13 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact14 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact15 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	 elseif tonumber(faction) == ozelFact16 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
      elseif tonumber(faction) == ozelFact17 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	elseif tonumber(faction) == ozelFact18 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	elseif tonumber(faction) == ozelFact19 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
	elseif tonumber(faction) == ozelFact20 then
        if (getElementData(thePlayer, "faction") or 0) == tonumber(faction) then
          setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
          setElementData(thePlayer, "pdradio.legalRadio", false)
          setElementData(thePlayer, "pdradio.illegalRadio", true)
          notifyFunction(thePlayer, "Frekans (" .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
        else
          notifyFunction(thePlayer, "Bu frekansa ba\196\159lanman\196\177za izin verilmiyor!", "error")
        end
      elseif tonumber(faction) > 9999 then
        notifyFunction(thePlayer, "Daha d\195\188\197\159\195\188k bir de\196\159er girin!", "error")
      else
        setElementData(thePlayer, "voiceChannel", (tonumber(faction)))
        setElementData(thePlayer, "pdradio.legalRadio", false)
        setElementData(thePlayer, "pdradio.illegalRadio", true)
        notifyFunction(thePlayer, "Frekans ( " .. tonumber(faction) .. ") olarak de\196\159i\197\159tirildi.", "info")
      end
    else
      notifyFunction(thePlayer, "Say\196\177sal bir de\196\159er girin!", "error")
    end
  else
    notifyFunction(thePlayer, "\195\156st\195\188n\195\188zde telsiz bulunmuyor.", "error")
  end
end)

function notifyFunction(thePlayer, cmd, faction)
  info:addBox(thePlayer, faction, cmd)
end

addEvent("radioSystem.giveAnim", true)
addEventHandler("radioSystem.giveAnim", root, function(thePlayer, anim)
  triggerClientEvent(thePlayer, "radioSystem.receiveAnim", thePlayer, thePlayer, anim, true)
end)

addEvent("radioSystem.deleteAnim", true)
addEventHandler("radioSystem.deleteAnim", root, function(thePlayer, anim)
  triggerClientEvent(thePlayer, "radioSystem.receiveAnim", thePlayer, thePlayer, anim, false)
end)

addEvent("radioSystem.playSoundServer", true)
addEventHandler("radioSystem.playSoundServer", root, function(thePlayer, cmd, faction)
  for k, player in ipairs(getElementsByType("player")) do
    if getElementData(thePlayer, "voiceChannel") == getElementData(player, "voiceChannel") then
      if player == thePlayer then
        return
      end
      if cmd == "giris" then
        if faction then
          -- triggerClientEvent(player, "radioSystem.playSoundClient", player, "giris")
        else
          -- triggerClientEvent(player, "radioSystem.playSoundClient", player, "giris2")
        end
      elseif cmd == "cikis" then
        if faction then
          -- triggerClientEvent(player, "radioSystem.playSoundClient", player, "cikis")
        else
          -- triggerClientEvent(player, "radioSystem.playSoundClient", player, "cikis2")
        end
      end
    end
  end
end)