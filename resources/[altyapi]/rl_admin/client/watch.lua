local screenWidth, screenHeight = guiGetScreenSize()
screenImage = nil
image = nil
name = ""
label = nil

addEvent("updateScreen", true)
addEventHandler("updateScreen", root, function(imageData, player)
	if fileExists("temp.jpg") then
		fileDelete("temp.jpg")
	end
	screenImage = fileCreate("temp.jpg")
	fileWrite(screenImage, imageData)            
	fileClose(screenImage)
	name = getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "id") .. ")"
	if not image then
		image = guiCreateStaticImage(screenWidth - 360, screenHeight - 370, 350, 350, "temp.jpg", false)
		label = guiCreateLabel(screenWidth - 360, screenHeight - 390, 350, 30, name, false)
	end
end)

addEvent("stopScreen", true)
addEventHandler("stopScreen", root, function()
	if image then
		destroyElement(image)
		destroyElement(label)
	end
	image = nil
end)

addEventHandler("onClientRender", root, function()
	if image then
		guiStaticImageLoadImage(image, "temp.jpg")
		guiSetText(label, name)
	end
end)