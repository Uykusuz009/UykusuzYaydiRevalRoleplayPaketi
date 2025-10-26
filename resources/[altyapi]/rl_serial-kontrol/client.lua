addEvent("copySerialToClipboard", true)
addEventHandler("copySerialToClipboard", localPlayer, function(text)
	setClipboard(text)
end)