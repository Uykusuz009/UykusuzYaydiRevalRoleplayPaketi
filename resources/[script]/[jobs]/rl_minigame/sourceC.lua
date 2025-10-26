local sx, sy = guiGetScreenSize()
local showed = false
color = {}
minigameData = {}
local col = tocolor(255,255,255,255)
local rotation = {
	['arrow_u'] = {0},
	['arrow_r'] = {90},
	['arrow_d'] = {180},
	['arrow_l'] = {270},
}

-- if getPlayerName(localPlayer) == 'John_Scott' or getPlayerName(localPlayer) == 'John_Steven' then 
function minigameTreatment (state, level, win, event)
	if state then 
		if level and level > 0 then
			local keys = {"arrow_l","arrow_u","arrow_d","arrow_r"}
			local times = level*4
			minigameData.level = level
			minigameData.win = win
			minigameData.event = event
			minigameData.startTick = getTickCount ()
			minigameData.duration = 700*times -level*12*times
			minigameData.times = times
			minigameData.keys = {}
			for k=1,times do
				minigameData.keys[k] = {}
				local key = keys[math.random(1,#keys)]
				if key then
					minigameData.keys[k]["key"] = key
					minigameData.keys[k]["rot"] = rotation[key][1]
					color[k] = tocolor(255,255,255,255)
					minigameData.keys[k]["passed"] = 0 -- 0 = alapértelmezett(fehér); 1 = Elrontott (piros); 2 = sikeres(Zöld)
				end
			end
		end
		removeEventHandler ("onClientKey", root, onQuizArrowClick)
		addEventHandler ("onClientKey", root, onQuizArrowClick)
		toggleAllControls(false, true, false)
	else
		removeEventHandler ("onClientKey", root, onQuizArrowClick)
		removeEventHandler('onClientPreRender', root, drawMinigames)
		toggleAllControls(true, true, true)
	end
end

function onQuizArrowClick (key,state)
	if state then
		local right = false
		local keys = {"arrow_l","arrow_u","arrow_d","arrow_r"}
		for k,v in ipairs(keys) do
			if key == v then
				right = true
				break
			end
		end
		if right then
			local iconSize = 100
			local insideIconSize = 100
			local arrowSize = 28
			
			col = tocolor(255,255,255,255)
			
			local cTick = getTickCount ()
			local delay = cTick - minigameData.startTick
			local progress = delay/minigameData.duration
			
			local totalWidth = minigameData.times*insideIconSize*0.8
			local iy = sy-100
			
			
			for k,v in ipairs(minigameData.keys) do
				if v["key"] ~= "" then
					local offset = interpolateBetween (
						0,0,0,
						totalWidth,0,0,
						(k-1)/minigameData.times,"Linear"
					)
					local cx = sx/2+220 + offset - totalWidth*progress
					if cx >= sx/2-200 and cx <= sx/2+200 then
						if cx >= sx/2-32 and cx <= sx/2+32 then
							if v["passed"] == 0 then
								if v["key"] == key then
									minigameData.keys[k]["passed"] = 2
									col = tocolor(135, 211, 124,255)
								else
									minigameData.keys[k]["passed"] = 1
									col = tocolor(210, 77, 87,255)
								end
							end
							break
						else
							if v["passed"] == 0 then
								minigameData.keys[k]["passed"] = 1
								col = tocolor(210, 77, 87,255)
								break
							end
						end
					end
				end
			end
		end
	end
end

function drawMinigames()	
	local iconSize = 120
	local insideIconSize = 120
	local arrowSize = 28
	
	local cTick = getTickCount ()
	local delay = cTick - minigameData.startTick
	local progress = delay/minigameData.duration
		
	local totalWidth = minigameData.times*insideIconSize*0.8
	local iy = sy-100
	
	local colors = tocolor(255, 255, 255, 255)
	
	for k,v in ipairs(minigameData.keys) do
		local last = false
		if k >= minigameData.times then
			last = true
		end
		if v["key"] ~= "" then
			local offset = interpolateBetween (
				0,0,0,
				totalWidth,0,0,
				(k-1)/minigameData.times,"Linear"
			)
			local cx = sx/2+220 + offset - totalWidth*progress
			if cx >= sx/2-200 and cx <= sx/2+200 then
				if v["passed"] == 0 then
				elseif v["passed"] == 1 then
					color[k] = tocolor(210, 77, 87,255)
					colors = tocolor(210, 77, 87,255)
				elseif v["passed"] == 2 then
					color[k] = tocolor(135, 211, 124,255)
					colors = tocolor(135, 211, 124,255)	
				end
				dxDrawImage (cx, iy-arrowSize/2, arrowSize, arrowSize, "files/arrow.png", v["rot"], 0, 0, color[k], true)
			end
			if cx < sx/2-32 and v["passed"] == 0 then
				minigameData.keys[k]["key"] = " "
				minigameData.keys[k]["passed"] = 1
				color[k] = tocolor(210, 77, 87,255)
				colors = tocolor(210, 77, 87,255)
			end
			
			if last then
				if cx <= sx/2-200 then
					endMinigame()
				end
			end
		end
	end
	dxDrawImage (sx/2-64/2,iy-64/2,64,64,"files/circle.png",0,0,0,colors,true)
	dxDrawRectangle (sx/2+220,iy-arrowSize/2,3,arrowSize,tocolor(255, 255, 255, 255))
	dxDrawRectangle (sx/2-220,iy-arrowSize/2,3,arrowSize,tocolor(255, 255, 255, 255))
end

function endMinigame()
	local level = minigameData.level
	local win = minigameData.win
	local event = minigameData.event
	local passed = 0
	for k,v in ipairs(minigameData.keys) do
		if v["key"] ~= "" then
			if v["passed"] == 2 then
				passed = passed+1
			end
		end
	end
	if passed >= win then
		triggerEvent('wlsMTA->#'..event, localPlayer, true)
		startMinigame (false)
	else
		triggerEvent('wlsMTA->#'..event, localPlayer, false)
		startMinigame (false)
	end
end

function startMinigame (state, levels, win, event)
	if state then 
		if not levels then levels = math.random(2,5) end
		minigameTreatment(state, math.ceil(levels), win, event)
		removeEventHandler('onClientPreRender', root, drawMinigames)
		addEventHandler('onClientPreRender', root, drawMinigames, true, 'low-5')
	else
		toggleAllControls(true, true, true)
		removeEventHandler ("onClientKey", root, onQuizArrowClick)
		removeEventHandler('onClientPreRender', root, drawMinigames)
	end
end
addEvent('wlsMTA->#startMinigame', true)
addEventHandler('wlsMTA->#startMinigame', root, startMinigame)

-- startMinigame(true, 5, 2)