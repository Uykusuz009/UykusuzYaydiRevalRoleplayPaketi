local drawTimers = {} 
local font = dxCreateFont('files/Roboto.ttf',12)
function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,tur,...)
    local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getCameraMatrix()
    local distance = distance or 20
    local height = height or 1
    local sourcePos = Vector3(getElementPosition(TheElement))
     local distance = getDistanceBetweenPoints3D(sourcePos.x, sourcePos.y, sourcePos.z, Vector3(getElementPosition(localPlayer)))
    local sx, sy = getScreenFromWorldPosition(x, y, z+height)
    if(sx) and (sy) then
    	if tur == 'destekpd' then
        dxDrawImage ( sx-15, sy+20, 32, 32, 'files/destekpd.png', 0, 0, -120 )
	elseif tur == 'destekmd' then
		dxDrawImage ( sx-15, sy+20, 32, 32, 'files/destekmd.png', 0, 0, -120 )
    elseif tur == 'takip' then
        dxDrawImage ( sx-15, sy+20, 32, 32, 'files/takip.png', 0, 0, -120 )
    end
     dxDrawText(text.." \n "..math.floor(distance).." km ", sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1), font or "arial", "center", "center")
    end
end

function destekpd(state, player)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, getPlayerName(player), 1, 20, 255, 255, 255, 255, 1, font,'destekpd')
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("lspd:destekpd",true) 
addEventHandler("lspd:destekpd", localPlayer, destekpd)

function destekmd(state, player)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, getPlayerName(player), 1, 20, 255, 255, 255, 255, 1, font,'destekmd')
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("lsfd:destekmd",true) 
addEventHandler("lsfd:destekmd", localPlayer, destekmd)

function destekpd(state, player)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, getPlayerName(player), 1, 20, 255, 255, 255, 255, 1, font,'takip')
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("lspd:takip",true) 
addEventHandler("lspd:takip", localPlayer, destekpd)