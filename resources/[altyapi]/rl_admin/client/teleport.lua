addEvent("copyPosToClipboard", true)
addEventHandler("copyPosToClipboard", localPlayer, function(text)
	setClipboard(text)
end)