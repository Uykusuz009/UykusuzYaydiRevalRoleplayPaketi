local sx, sy = guiGetScreenSize()
local pickupsCache = {}
local font = exports.rl_fonts:getFont("RobotoB", 9)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for index, value in ipairs(getElementsByType("pickup")) do
			if not pickupsCache[value] then
				if isElementStreamedIn(value) and source.dimension == localPlayer.dimension then
					createCache(value)
				end
			end
		end
		addEventHandler("onClientRender", root, drawnPickupText, false, "low-9999")
	end
)

addEventHandler("onClientElementStreamIn", root,
    function()
        if source.type == "pickup" then
        	if source.dimension == localPlayer.dimension then
            	createCache(source)
            end
        end
    end
)

addEventHandler("onClientElementStreamOut", root,
    function()
        if source.type == "pickup" then
        	if source.dimension == localPlayer.dimension then
           		destroyCache(source)
           	end
        end
    end
)

function createCache(pickup)
 	if pickup and isElement(pickup) then
		x, y, z = getElementPosition(pickup)
		pickupsCache[pickup] = {
			["position"] = {x, y, z},
			["name"] = (getElementData(pickup, "informationicons:information") or ""),
		}
	end
end

function destroyCache(pickup)
	if pickup and isElement(pickup) then
		pickupsCache[pickup] = nil
	end
end

function drawnPickupText()
	local cx,cy,cz = getCameraMatrix()
	for pickup, value in pairs(pickupsCache) do
		if not isElement(pickup) then
			pickupsCache[pickup] = nil
			break
		end
		local x, y, z = unpack(value.position)
		local information_text = value.name
		if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 12 then
			local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
			if (px and py) then
				dxDrawText(RemoveHEXColorCode(information_text), px+2, py, nil, nil, tocolor(0, 0, 0, 215), 1, font, nil, nil, false, false, false, false)
				dxDrawText(RemoveHEXColorCode(information_text), px-2, py, nil, nil, tocolor(0, 0, 0, 215), 1, font, nil, nil, false, false, false, false)
				dxDrawText(RemoveHEXColorCode(information_text), px, py+2, nil, nil, tocolor(0, 0, 0, 215), 1, font, nil, nil, false, false, false, false)
				dxDrawText(RemoveHEXColorCode(information_text), px, py-2, nil, nil, tocolor(0, 0, 0, 215), 1, font, nil, nil, false, false, false, false)
				dxDrawText(information_text, px, py, nil, nil, tocolor(255, 255, 255, 235), 1, font, nil, nil, false, false, false, true)
			end
		end
	end
end

function RemoveHEXColorCode( s )
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end