addEventHandler("onPlayerJoin", root, function()
	setPlayerBlurLevel(source, 0)
end)

addEventHandler("onResourceStart", resourceRoot, function()
	setPlayerBlurLevel(root, 0)
end)