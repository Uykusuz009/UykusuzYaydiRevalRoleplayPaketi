local screenSize = Vector2(guiGetScreenSize())

addEvent("jumpscare.renderUI", true)
addEventHandler("jumpscare.renderUI", root, function()
    local image = guiCreateStaticImage(0, 0, screenSize.x, screenSize.y, "public/images/jumpscare.jpg", false)
    local sound = playSound("public/sounds/jumpscare.mp3")
	setSoundVolume(sound, 101)
    
    setTimer(function()
        if isElement(image) then
            destroyElement(image)
        end
        if isElement(sound) then
            stopSound(sound)
        end
    end, 5000, 1)
end)