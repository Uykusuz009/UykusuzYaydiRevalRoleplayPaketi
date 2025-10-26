local timer = {}
local tuned = {}
local function updateWorldItemValue(item, station, volume)
    if station < 0 or station > #exports.rl_radio:getStreams() then return end

    local newvalue = tostring(station)
    if volume and volume ~= 100 then
        newvalue = newvalue .. ':' .. volume
    end

    setElementData(item, "itemValue", newvalue)
    dbExec(mysql:getConnection(), "UPDATE worlditems SET itemvalue='" .. newvalue .. "' WHERE id=" .. getElementData(item, "id"))
    triggerClientEvent(root, "toggleSound", item)
end

function changeTrack(item, step)
    local streams = exports.rl_radio:getStreams()
    local splitValue = split(tostring(getElementData(item, "itemValue")), ':')
    local current = tonumber(splitValue[1]) or 1
    current = current + step
    if current > #streams then
        current = 0
    elseif current < 0 then
        current = #streams
    end
    updateWorldItemValue(item, current, tonumber(splitValue[2]))
	
	if not tuned[item] then
		exports.rl_global:sendLocalMeAction(source, "gettoblasterin kanalını tanımlar.")
		tuned[item] = true
	else
		if timer[item] and isTimer(timer[item]) then
			killTimer(timer[item])
		end
		timer[item] = setTimer(function()
			tuned[item] = false
		end, 10 * 1000, 1)
	end
end
addEvent("changeGhettoblasterTrack", true)
addEventHandler("changeGhettoblasterTrack", root, changeTrack)

addEvent('changeGhettoblasterVolume', true)
addEventHandler('changeGhettoblasterVolume', root, function(newvalue)
    newvalue = math.floor(newvalue)
    if newvalue < 0 or newvalue > 100 then return end

    local splitValue = split(tostring(getElementData(source, "itemValue")), ':')

    updateWorldItemValue(source, tonumber(splitValue[1]) or 1, newvalue)
end)

function changeStation(thePlayer, commandName, operator)
	if operator then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local count = 0
		
		for key, item in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("rl_item-world")))) do
			local dbid = getElementData(item, "id")
			if dbid then
				local x, y, z = getElementPosition(item)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(item) == getElementDimension(thePlayer) and getElementInterior(item) == getElementInterior(thePlayer) then
					if getElementData(item, "itemID") == 54 or getElementData(item, "itemID") == 176 then
						local station = getElementData(item, "itemValue")
						if operator == "+" then
							if (station + 1) > 0 and (station + 1) <= #exports.rl_radio:getStreams() then
								setElementData(item, "itemValue", station + 1)
								dbExec(mysql:getConnection(), "UPDATE worlditems SET itemvalue = " .. station + 1 .. " WHERE id=" .. getElementData(item, "id"))
								triggerClientEvent(root, "toggleSound", item)
								exports.rl_global:sendLocalMeAction(thePlayer, "gettoblasterin kanalını tanımlar.")
							else
								outputChatBox("[!]#FFFFFF Gettoblaster maksimum kanala çatdı.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						elseif operator == "-" then
							if (station - 1) > 0 then
								setElementData(item, "itemValue", station - 1)
								dbExec(mysql:getConnection(), "UPDATE worlditems SET itemvalue='" .. station - 1 .. "' WHERE id=" .. getElementData(item, "id"))
								triggerClientEvent(root, "toggleSound", item)
								exports.rl_global:sendLocalMeAction(thePlayer, "gettoblasterin kanalını tanımlar.")
							else
								outputChatBox("[!]#FFFFFF Gettoblaster minimum kanala çatdı.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						end
						count = count + 1
					end
				end
			end
		end
		
		if (count == 0) then
			outputChatBox("[!]#FFFFFF Yakınlarda gettoblaster yok.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [+ / -]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("cs", changeStation, false, false)