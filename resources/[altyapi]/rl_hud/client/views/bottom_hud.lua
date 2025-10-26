Labels = {
    screenSize = Vector2(guiGetScreenSize()),

    index = function(self)
        framesPerSecond = 0
        framesDeltaTime = 0
        lastRenderTick = false 

        label = GuiLabel(0, 0, self.screenSize.x, 15, "", false) 
        label:setAlpha(0.5)
    end
}

instance = new(Labels)
instance:index()

setTimer(function()
	if getElementData(localPlayer, "logged") then
		local currentTick = getTickCount() 
		lastRenderTick = lastRenderTick or currentTick 
		framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick) 
		lastRenderTick = currentTick 
		framesPerSecond = framesPerSecond + 1
		
		local time = getRealTime()
		local hours = time.hour
		local minutes = time.minute
		local seconds = time.second

		local monthday = time.monthday
		local month = time.month
		local year = time.year
		
		local formattedTime = string.format("%02d/%02d/%04d", monthday, month + 1, year + 1900)
		local formattedHour = string.format("%02d:%02d:%02d", hours, minutes, seconds)
		
		if framesDeltaTime >= 1000 then 
			ping = localPlayer:getPing()
			dbid = getElementData(localPlayer, "dbid") or 0
			
			label:setText("" .. exports.rl_global:getServerSettings().version .. " — 【" .. framesPerSecond .. " fps " .. ping .. " ms】【" .. formattedTime .. " " .. formattedHour .. "】【ID: " .. (dbid or "yükleniyor...") .. "】")
			label:setSize(instance.screenSize.x - guiLabelGetTextExtent(label) + 5, 14, false)
			label:setPosition(instance.screenSize.x - guiLabelGetTextExtent(label) - 74, instance.screenSize.y - 15, false)
			
			framesDeltaTime = framesDeltaTime - 1000 
            framesPerSecond = 0
		end
	else
		label:setText("")
	end
end, 0, 0)