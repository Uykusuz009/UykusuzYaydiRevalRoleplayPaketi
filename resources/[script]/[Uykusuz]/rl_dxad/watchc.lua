local screenWidth, screenHeight = guiGetScreenSize()
local theme = exports.rl_ui:useTheme() 
local fonts = exports.rl_ui:useFonts() 

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
		local renderTimer = nil  

		addEventHandler("onClientRender", root, function()
			if image then
				local buttonX = screenWidth - 42 
				local buttonY = screenHeight - 370 - 42  
				
				local closeButton = exports.rl_ui:drawButton({
					position = {x = buttonX, y = buttonY},
					size = {x = 30, y = 30},
					radius = 5,
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = fonts.body.regular,
						scale = 1.4, 
						padding = 0,
					},
					variant = "solid",
					color = "red",
					text = "x",
					icon = "",
				})
				if closeButton.pressed then
					triggerServerEvent("stopWatchingPlayer", localPlayer)
					if image then
						destroyElement(image)
						destroyElement(label)
					end
					image = nil
					if isTimer(renderTimer) then
						killTimer(renderTimer)
					end
				end
			end
		end)
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