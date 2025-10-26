function setToClipboard(content)
	setClipboard(content) 
end
addEvent("official-interiors:copytoclipboard", true)
addEventHandler("official-interiors:copytoclipboard", localPlayer, setToClipboard)