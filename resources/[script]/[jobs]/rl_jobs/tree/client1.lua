local robotoB = exports.rl_fonts:getFont('RobotoB',11)
local cache = {{"axe", 323},}

function treeDamage(_, attacker)
	if attacker == localPlayer then
        if localPlayer:getData("job") == 1 then
            if getPedWeapon(localPlayer) == 12 then 
                if tonumber(source.model) == tonumber(654) then
                    triggerServerEvent(getResourceName(getThisResource())..' >> damageTree',localPlayer, localPlayer, source)
                end
            end
        end
    end
end
addEventHandler("onClientObjectDamage", root, treeDamage)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        for k,v in pairs(cache) do
            local txd = engineLoadTXD("tree/components/"..v[1]..".txd")
            engineImportTXD(txd, v[2])
            local dff = engineLoadDFF("tree/components/"..v[1]..".dff", 0)
            engineReplaceModel (dff, v[2])
        end
    end
)

addEvent(getResourceName(getThisResource())..' >> fallTree' , true)
addEventHandler(getResourceName(getThisResource())..' >> fallTree', root , function(target)
    local treeRemoveStart = getTickCount()
    local treeRemoveEnd = treeRemoveStart + 2800
    function syncTree()
        local elapsedTime = getTickCount() - treeRemoveStart
        local duration = treeRemoveEnd - treeRemoveStart
        local progress = elapsedTime / duration
        local x, y, z = interpolateBetween(0, 0, 0, 0, 80, 0, progress, "OutBounce")
        if getTickCount() >= treeRemoveEnd + 1 then
            removeEventHandler("onClientRender", getRootElement(), syncTree)
            if isElement(target) then
                eX, eY, eZ = getElementPosition(target)
            end
        else
            if isElement(target) then
                z = getElementData(target, "rotX")
                setElementRotation(target, x, y, 0)
            end
        end
    end
    addEventHandler("onClientRender", getRootElement(), syncTree)
end)

Timer(
    function()
        for i, v in ipairs(getElementsWithinRange(localPlayer.position, 5, "object")) do
            if v.model == 654 then
                if (v:getData('tree >> text') or false) then
                    if localPlayer:getData("job") == 1 then
                        dxDrawTextOnElement(v, v:getData('tree >> text'), 1, 20, 225, 225, 225, 225, 1, robotoB)
                    end
                end
            end
        end
    end, 6,0
)

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1
	local sx, sy = getScreenFromWorldPosition(x, y, z+height)
	if(sx) and (sy) then
		local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		if(distanceBetweenPoints < distance) then
			dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center", false, true, true, true)
		end
	end
end

function stopMinigunDamage ( attacker, weapon, bodypart )
    if (weapon == 12) then
        cancelEvent()
    end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), stopMinigunDamage)

local thePed = createPed(170, -1292.439453125, -2159.5546875, 22.194185256958)
setPedRotation(thePed, 180)
function clickPed(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if button=="left" and state=="down" then
        if clickedElement == thePed then
            triggerServerEvent("jobtree.giveaxe", localPlayer, localPlayer)
        end
    end
end
addEventHandler("onClientClick",root,clickPed)