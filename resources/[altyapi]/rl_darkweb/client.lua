local screenSize = Vector2(guiGetScreenSize())

function darkwebGUI()
	guiSetInputMode("no_binds_when_editing")
	
	window = guiCreateWindow((screenSize.x - 480) / 2, (screenSize.y - 180) / 2, 480, 180, "DarkWeb Arayüzü", false)
	guiWindowSetSizable(window, false)

	label = guiCreateLabel(10, 24, 464, 26, "İçerik:", false, window)
	guiLabelSetVerticalAlign(label, "center")
	
	edit = guiCreateEdit(10, 50, 464, 29, "", false, window)
	
	submit = guiCreateButton(10, 89, 464, 34, "Gönder ($500)", false, window)
	guiSetProperty(submit, "NormalTextColour", "FFAAAAAA")
	
	close = guiCreateButton(10, 133, 464, 34, "Kapat", false, window)
	guiSetProperty(close, "NormalTextColour", "FFAAAAAA")
	
	addEventHandler("onClientGUIClick", guiRoot, function()
		if source == close then
			destroyElement(window)
		elseif source == submit then
			if not isTimer(spamTimer) then
				if exports.rl_global:hasMoney(localPlayer, 500) then
					if string.len(guiGetText(edit)) > 0 then
						triggerServerEvent("darkweb.sendPost", localPlayer, guiGetText(edit))
						destroyElement(window)
						spamTimer = setTimer(function() end, 5 * 60 * 1000, 1)
					else
						exports.rl_infobox:addBox("error", "İçerik boş bırakılamaz.")
					end
				else
					exports.rl_infobox:addBox("error", "Gönderi atmak için yeterli paranız yok.")
				end
			else
				exports.rl_infobox:addBox("error", "Her 5 dakikada bir gönderi atabilirsiniz.")
			end
		end
	end)
end

addCommandHandler("darkweb", function()
	darkwebGUI()
end, false, false)