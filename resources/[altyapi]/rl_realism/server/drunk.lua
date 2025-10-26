addEvent("setDrunkness", true)
addEventHandler("setDrunkness", root, function(level)
	setElementData(source, "alcohollevel", level or 0)
end)