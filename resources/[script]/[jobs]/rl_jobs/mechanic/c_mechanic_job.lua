-- Main Mechanic window
wMechanic, bMechanicOne, bMechanicOne, bMechanicThree, bMechanicFour, bMechanicFive, bMechanicSix, bMechanicEight, bMechanicNine, bMechanicClose = nil

-- Tyre change window
wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil

-- Paintjob window
wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil

-- Upgrade window
wUpgrades, gUpgrades, bUpgradesClose = nil

currentVehicle = nil
vehicleWithPaintjob = { [562] = true,[559] = true,[565] = true,[561] = true,[560] = true,[558] = true,[411] = true,[503] = true,[494] = true,[541] = true,[401] = true,[506] = true,[429] = true,[451] = true,[579] = true,[495] = true,[555] = true,[602] = true,[603] = true,[474] = true,[403] = true,[514] = true,[515] = true,[580] = true,[410] = true,[589] = true,[404] = true,[415] = true,[480] = true,[422] = true,[587] = true,[419] = true,[475] = true,[547] = true,[536] = true,[466] = true,[534] = true,[467] = true,[426] = true,[543] = true,[521] = true,[418] = true,[445] = true,[518] = true,[585] = true,[517] = true,[500] = true,[479] = true,[496] = true,[576] = true,[461] = true,[566] = true,[554] = true,[492] = true,[546] = true,[524] = true,[491] = true,[409] = true,[458] = true,[550] = true,[533] = true,[516] = true,[540] = true,[470] = true,[527] = true,[529] = true,[507] = true,[502] = true,[575] = true,[567] = true,[405] = true,[551] = true,[436] = true,[400] = true,[443] = true,[535] = true,[526] = true,[605] = true,[542] = true,[402] = true,[442] = true,[505] = true,[489] = true,[413] = true,[477] = true,[478] = true,[541] = true,[467] = true,[482] = true,[581] = true,[549] = true,[523] = true,[412] = true,[421] = true,[475] = true,[419] = true,[600] = true,[439] = true,[604] = true,[586] = true,[468] = true,[463] = true,[522] = true,[462] = true,[609] = true,[498] = true,[508] = true,[504] = true }

function displayMechanicJob()
	outputChatBox("#FF9933Use the #FF0000right-click menu#FF9933 to view the services you can provide.", 255, 194, 15, true)
end

local noTyres = { Boat = true, Helicopter = true, Plane = true, Train = true }
local noUpgrades = { Boat = true, Helicopter = true, Plane = true, Train = true, BMX = true }

function mechanicWindow(vehicle)
	local job = getElementData(getLocalPlayer(), "job")
	--local playerDimension = getElementDimension(getLocalPlayer())
	local faction = getElementData(getLocalPlayer(), "faction")
	if (job==7) then
	--[[local theTeam = getPlayerTeam(localPlayer)
	local factionType = tonumber(getElementData(theTeam, "type"))
	if factionType == 7 then -- Mechanic Faction / Adams]]
		if not vehicle then
			outputChatBox("You must select a vehicle.", 255, 0, 0)
		else
			currentVehicle = vehicle
			-- Window variables
			local Width = 200
			local Height = 450
			local screenwidth, screenheight = guiGetScreenSize()
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			if not (wMechanic) then
				-- Create the window
				wMechanic = guiCreateWindow(X, Y, Width, Height, "Tamirci Paneli", false )
				
				local y = 0.05
				-- Body work
				--bMechanicOne = guiCreateButton( 0.05, y, 0.9, 0.1, "Bodywork Repair - $50", true, wMechanic )
				--addEventHandler( "onClientGUIClick", bMechanicOne, bodyworkTrigger, false)
				--y = y + 0.1
				
				-- Service
				bMechanicTwo = guiCreateButton( 0.05, y, 0.9, 0.1, "Tamir Et - 110₺", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicTwo, serviceTrigger, false)
				y = y + 0.1
				
				-- Tyre Change
				if not noTyres[getVehicleType(vehicle)] then
					bMechanicThree = guiCreateButton( 0.05, y, 0.9, 0.1, "Lastik Değiştir - 10₺", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicThree, tyreWindow, false)
					y = y + 0.1
				end
				
				if faction == 4 or ( tonumber( getElementData(vehicle, "job") or 0 ) == 0 and ( getElementData(vehicle, "faction") == -1 or getElementData(vehicle, "faction") == faction ) ) then
					bMechanicFour = guiCreateButton( 0.05, y, 0.9, 0.1, "Renk - 4.000₺", true, wMechanic )
						
					addEventHandler( "onClientGUIClick", bMechanicFour, paintWindow, false)
					y = y + 0.1
				end
				-- Replace lights
				if vehicleWithPaintjob[getElementModel(vehicle)] then
					bMechanicNine = guiCreateButton( 0.05, y, 0.9, 0.1, "Far Renk - 5.000₺", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicNine, replaceLightsWindow, false)
					y = y + 0.1
				end
				if not getElementData(vehicle, "tintedwindows") then
					bMechanicEight = guiCreateButton( 0.05, y, 0.9, 0.1, "Cam Filmi Tak 10.000₺", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicEight, addTintWindow, false)
					y = y + 0.1
				else
					bMechanicEight = guiCreateButton( 0.05, y, 0.9, 0.1, "Cam Filmi Sök 2.000₺", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicEight, removeTintWindow, false)
					y = y + 0.1
				end
				--end
				
				-- Close
				bMechanicClose = guiCreateButton( 0.05, 0.85, 0.9, 0.1, "Kapat", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicClose, closeMechanicWindow, false )
				
				showCursor(true)
			end
		end
	end
end
addEvent("openMechanicFixWindow")
addEventHandler("openMechanicFixWindow", getRootElement(), mechanicWindow)

function removeNosFromVehicle()
	triggerServerEvent( "removeNOS", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function addTintWindow()
	triggerServerEvent("tintedWindows", getLocalPlayer(), currentVehicle, 1)
	closeMechanicWindow()
end

function removeTintWindow()
	triggerServerEvent("tintedWindows", getLocalPlayer(), currentVehicle, 2)
	closeMechanicWindow()
end

function tyreWindow()
	-- Window variables
	local Width = getVehicleType(currentVehicle) == "Bike" and 100 or 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wTyre) then
		-- Create the window
		wTyre = guiCreateWindow(X+100, Y, Width, Height, "Select a tyre to change.", false )
		
		if getVehicleType(currentVehicle) ~= "Bike" then
			-- Front left
			bTyreOne = guiCreateButton( 0.05, 0.1, 0.45, 0.35, "Front Left", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreOne, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 1)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- Back left
			bTyreTwo = guiCreateButton( 0.05, 0.5, 0.45, 0.35, "Back Left", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreTwo, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 2)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- front right
			bTyreThree = guiCreateButton( 0.5, 0.1, 0.45, 0.35, "Front Right", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreThree, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 3)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- back right
			bTyreFour = guiCreateButton( 0.5, 0.5, 0.45, 0.35, "Back Right", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreFour, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 4)
					closeMechanicWindow()
					
				end
			end, false)
		else
			-- Front
			bTyreOne = guiCreateButton( 0.05, 0.1, 0.9, 0.35, "Front", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreOne, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 1)
					closeMechanicWindow()
					
				end
			end, false)
		
			-- back right
			bTyreThree = guiCreateButton( 0.05, 0.5, 0.9, 0.35, "Back", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreThree, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 2)
					closeMechanicWindow()
					
				end
			end, false)
		end
		-- Close
		bTyreClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Close", true, wTyre )
		addEventHandler( "onClientGUIClick", bTyreClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bTyreOne)
				if bTyreTwo then
					destroyElement(bTyreTwo)
				end
				destroyElement(bTyreThree)
				if bTyreFour then
					destroyElement(bTyreFour)
				end
				destroyElement(bTyreClose)
				destroyElement(wTyre)
				wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
				
			end
		end, false)
	end
end

-- Paint window
wPaint, iColour1, iColour2, iColour3, iColour4, colourChart, bPaintSubmit, bPaintClose, currentColor = nil
r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = nil
local savedPaintColors = {}
function paintColor( colorIndex )
	if exports.rl_colorblender:isPickerOpened("paintjob") then
		outputChatBox("You're still editing another colour, fool.", 255, 0 ,0)
		return
	end
	local r, g, b = 0,0 ,0
	r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true )
	if colorIndex == 1 then
		r = r1
		g = g1
		b = b1
	elseif colorIndex == 2 then
		r = r2
		g = g2
		b = b2
	elseif colorIndex == 3 then
		r = r3
		g = g3
		b = b3
	elseif colorIndex == 4 then
		r = r4
		g = g4
		b = b4
	end
	currentColor = colorIndex
	exports.rl_colorblender:openPicker("paintjob", string.format("#%02X%02X%02X", r, g, b) , "Pick a color for your vehicle:")
end

addEventHandler("onColorPickerChange", root, 
 function(element, hex, r, g, b)
	if element == "paintjob" and currentColor then
		-- Its for us!
		local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
		if currentColor == 1 then
			r1 = r
			g1 = g
			b1 = b
		elseif currentColor == 2 then
			r2 = r
			g2 = g
			b2 = b
		elseif currentColor == 3 then
			r3 = r
			g3 = g
			b3 = b
		elseif currentColor == 4 then
			r4 = r
			g4 = g
			b4 = b
		end
		
		triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, {r1, g1, b1}, {r2, g2, b2}, {r3, g3, b3}, {r4, g4, b4})
	elseif element == "headlights" then
		triggerServerEvent( "headlightPreview", localPlayer, currentVehicle, r, g, b)
	end
end)

--

addEventHandler("onColorPickerOK", root,
	function(id, hex, r, g, b)
		if id == 'paintjob' and currentColor then
			savedPaintColors[currentColor] = {r, g, b}
			triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, unpack(savedPaintColors))
		elseif id == 'headlights' then
			triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
			triggerServerEvent( "editVehicleHeadlights", localPlayer, currentVehicle, r, g, b)
		end
	end)

--

addEventHandler("onColorPickerCancel", root,
	function(id, hex, r, g, b)
		if id == 'paintjob' then
			triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, unpack(savedPaintColors))
		elseif id == 'headlights' then
			triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
		end
	end)

--

function paintWindow()

	local windowWidth = 400
	local windowHeight = 300
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowX = (screenWidth - windowWidth)/2
	local windowY = (screenHeight - windowHeight)/2

	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
	savedPaintColors = { { r1, g1, b1 }, { r2, g2, b2 }, { r3, g3, b3 }, { r4, g4, b4 } }

	if not (wPaint) then
		wPaint = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Vehicle Paint", false )
		bPaintColor1 = guiCreateButton( 0.05, 0.1, 0.45, 0.2, "Set colour 1", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor1,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 1 )
			end
		end, false)	 
		bPaintColor2 = guiCreateButton( 0.55, 0.1, 0.45, 0.2, "Set colour 2", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor2,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 2 )
			end
		end, false)	
		bPaintColor3 = guiCreateButton( 0.05, 0.4, 0.45, 0.2, "Set colour 3", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor3,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 3 )
			end
		end, false)	
		bPaintColor4 = guiCreateButton( 0.55, 0.4, 0.45, 0.2, "Set colour 4", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor4,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 4 )
			end
		end, false)	
		
		bPaintSubmit = guiCreateButton( 0.05, 0.75, 0.90, 0.1, "Save", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintSubmit,  function(button, state)
			if(button == "left" and state == "up") then
				local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)	
				triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
				triggerServerEvent( "repaintVehicle", getLocalPlayer(), currentVehicle, {r1, g1, b1}, {r2, g2, b2}, {r3, g3, b3}, {r4, g4, b4})
				
				exports.rl_colorblender:closePicker("paintjob")
				closeMechanicWindow()
			end
		end, false)
		
		bPaintClose = guiCreateButton( 0.05, 0.85, 0.90, 0.1, "Close", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintClose,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wPaint)
				wPaint = nil
				triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
				exports.rl_colorblender:closePicker("paintjob")
				guiSetInputEnabled(false)
			end
		end, false)	 
	end
end

function replaceLightsWindow()
	if exports.rl_colorblender:isPickerOpened("paintjob") then
		outputChatBox("You're still editing another colour, fool.", 255, 0 ,0)
		return
	end

	local r, g, b = getVehicleHeadLightColor( currentVehicle )
	exports.rl_colorblender:openPicker("headlights", string.format("#%02X%02X%02X", r, g, b) , "Pick a color for the lights:")
end

function paintjobWindow()
	-- Window variables
	local Width = 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wPaintjob) then
		oldPaintjob = getVehiclePaintjob( currentVehicle )
		oldColors = { getVehicleColor( currentVehicle ) }
		
		-- Create the window
		wPaintjob = guiCreateWindow(X+100, Y, Width, Height, "Select a new Paintjob.", false )
		
		-- Paintjob 1
		bPaintjob1 = guiCreateButton( 0.05, 0.1, 0.9, 0.17, "Paintjob 1", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob1, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 0)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob1, function()
			if source == bPaintjob1 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 0)
			end
		end)
		
		-- Paintjob 2
		bPaintjob2 = guiCreateButton( 0.05, 0.3, 0.9, 0.17, "Paintjob 2", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob2, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 1)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob2, function()
			if source == bPaintjob2 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 1)
			end
		end)
		
		-- Paintjob 3
		bPaintjob3 = guiCreateButton( 0.05, 0.5, 0.9, 0.17, "Paintjob 3", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob3, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 2)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob3, function()
			if source == bPaintjob3 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 2)
			end
		end)
		
		-- Paintjob 4
		bPaintjob4 = guiCreateButton( 0.05, 0.7, 0.9, 0.17, "Paintjob 4", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob4, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 3)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob4, function()
			if source == bPaintjob4 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 3)
			end
		end)
		
		function restorePaintjob()
			triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
		end
		
		addEventHandler( "onClientMouseLeave", bPaintjob1, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob2, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob3, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob4, restorePaintjob)
		
		-- Close
		bPaintjobClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Close", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjobClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bPaintjob1)
				destroyElement(bPaintjob2)
				destroyElement(bPaintjob3)
				destroyElement(bPaintjob4)
				destroyElement(bPaintjobClose)
				destroyElement(wPaintjob)
				wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil
				triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
				
			end
		end, false)
	end
end

function serviceTrigger()
	triggerServerEvent( "serviceVehicle", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function bodyworkTrigger()
	triggerServerEvent( "repairBody", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function closeMechanicWindow()
	if exports.rl_colorblender:closePicker("headlights") then
		triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
	end
	
	if(wTyre)then
		destroyElement(bTyreOne)
		if bTyreTwo then
			destroyElement(bTyreTwo)
		end
		destroyElement(bTyreThree)
		if bTyreFour then
			destroyElement(bTyreFour)
		end
		destroyElement(bTyreClose)
		destroyElement(wTyre)
		wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
	end
	
	if(wPaint)then
		if isElement(iColour1) then
			destroyElement(iColour1)
		end
		if isElement(iColour2) then
			destroyElement(iColour2)
		end
		if isElement(iColour3) then
			destroyElement(iColour3)
		end
		if isElement(iColour4) then
			destroyElement(iColour4)
		end
		if isElement(lcol1) then
			destroyElement(lcol1)
		end
		if isElement(lcol2) then
			destroyElement(lcol2)
		end
		if isElement(lcol3) then
			destroyElement(lcol3)
		end
		if isElement(lcol4) then
			destroyElement(lcol4)
		end
		if isElement(colourChart) then
			destroyElement(colourChart)
		end
		if isElement(bPaintClose) then
			destroyElement(bPaintClose)
		end
		destroyElement(wPaint)
		wPaint, iColour1, iColour2, iColour3, iColour4, lcol1, lcol2, lcol3, lcol4, colourChart, bPaintClose = nil
		triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
		guiSetInputEnabled(false)
	end
	
	if wPaintjob then
		destroyElement(bPaintjob1)
		destroyElement(bPaintjob2)
		destroyElement(bPaintjob3)
		destroyElement(bPaintjob4)
		destroyElement(bPaintjobClose)
		destroyElement(wPaintjob)
		wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil
		triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
	end
	
	if wUpgrades then
		destroyElement(bUpgradesClose)
		destroyElement(gUpgrades)
		destroyElement(wUpgrades)
		wUpgrades, gUpgrades, bUpgradesClose = nil
		
		if oldUpgradeSlot then
			triggerServerEvent( "upgradeEndPreview", getLocalPlayer(), currentVehicle, oldUpgradeSlot)
			oldUpgradeSlot = nil
		end
	end
	
	if bMechanicOne then
		destroyElement(bMechanicOne)
	end
	if bMechanicTwo then
		destroyElement(bMechanicTwo)
	end
	if bMechanicThree then
		destroyElement(bMechanicThree)
	end
	if bMechanicFour then
		destroyElement(bMechanicFour)
	end
	if bMechanicFive then
		destroyElement(bMechanicFive)
	end
	if bMechanicSix then
		destroyElement(bMechanicSix)
	end
	if bMechanicEight then
		destroyElement(bMechanicEight)
	end
	if bMechanicClose then
		destroyElement(bMechanicClose)
	end
	destroyElement(wMechanic)
	wMechanic, bMechanicOne, bMechanicOne, bMechanicClose, bMechanicThree, bMechanicFour, bMechanicFive, bMechanicSix, bMechanicEight = nil
	
	currentVehicle = nil
	exports.rl_colorblender:closePicker("paintjob")
	showCursor(false)
end