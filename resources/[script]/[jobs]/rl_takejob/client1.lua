local sWidth,sHeight = guiGetScreenSize()

jobPanel = false

local positions = {
	{355.9248046875, 168.2646484375, 1008.3771362305, 3}
}

local colshape = createColSphere(unpack(positions[1]))

local fonts = {

    exports['rl_fonts']:getFont('Modern',sWidth*23/1920);
    exports['rl_fonts']:getFont('Modern',sWidth*21/1920);

}

local jobNames = {

    'Pizzacılık';
    'Tavukçuluk';
    'Elekrikcilik';
    'Tüpçülük';
    'Dondurmacılık';
    'Yumurtacılık';
    'Tırcılık';

}

screenSize = {guiGetScreenSize()}
getCursorPos = getCursorPosition
function getCursorPosition()
    if isCursorShowing() then
        local x,y = getCursorPos()
        x, y = x * screenSize[1], y * screenSize[2] 
        return x,y
    else
        return -5000, -5000
    end
end

cursorState = isCursorShowing()
cursorX, cursorY = getCursorPosition()

function isInBox(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

addEventHandler('onClientClick', root, function(button, state, x, y)
    if jobPanel == true then
       if (button == 'left') and (state == 'up') then
           if isInSlot( sWidth*20/1920, sHeight*260/1080, sWidth*300/1920, sHeight*35/1080 ) then
                localPlayer:setData("job",14)
                exports['rl_notification']:create('Başarıyla '..jobNames[1]..' isimli mesleğin belgesini aldınız.', 'success')
            elseif isInSlot ( sWidth*20/1920, sHeight*295/1080, sWidth*300/1920, sHeight*35/1080 ) then
                exports['rl_notification']:create('Başarıyla '..jobNames[2]..' isimli mesleğin belgesini aldınız.', 'success')
				localPlayer:setData('job',20)
				--localPlayer:setData('odunmeslek',true)
				localPlayer:setData('woodjobveh',true)
            elseif isInSlot ( sWidth*20/1920, sHeight*330/1080, sWidth*300/1920, sHeight*35/1080 ) then
                exports['rl_notification']:create('Başarıyla '..jobNames[3]..' isimli mesleğin belgesini aldınız.', 'success')
                localPlayer:setData("job",8)
            elseif isInSlot ( sWidth*20/1920, sHeight*365/1080, sWidth*300/1920, sHeight*35/1080 ) then
                exports['rl_notification']:create('Başarıyla '..jobNames[4]..' isimli mesleğin belgesini aldınız.', 'success')
                localPlayer:setData("job",13)
            elseif isInSlot ( sWidth*20/1920, sHeight*400/1080, sWidth*300/1920, sHeight*35/1080 ) then
                exports['rl_notification']:create('Başarıyla '..jobNames[5]..' isimli mesleğin belgesini aldınız.', 'success')
                localPlayer:setData("job",18)
            elseif isInSlot ( sWidth*20/1920, sHeight*440/1080, sWidth*300/1920, sHeight*35/1080 ) then
                exports['rl_notification']:create('Başarıyla '..jobNames[6]..' isimli mesleğin belgesini aldınız.', 'success')
                localPlayer:setData("job",19)
            elseif isInSlot ( sWidth*20/1920, sHeight*475/1080, sWidth*300/1920, sHeight*35/1080 ) then
                exports['rl_notification']:create('Başarıyla '..jobNames[7]..' isimli mesleğin belgesini aldınız.', 'success')
                localPlayer:setData("job",10)
           end
        end
    end
end)

function __renderJobPanel()

    roundedRectangle(sWidth*20/1920, sHeight*200/1080, sWidth*300/1920, sHeight*310/1080, tocolor(0, 0, 0, 200), false)
    roundedRectangle(sWidth*20/1920, sHeight*200/1080, sWidth*300/1920, sHeight*60/1080, tocolor(0, 0, 0, 255), false)

    dxDrawText ( "Meslek Belgeleri", sWidth*85/1920, sHeight*212/1080, sWidth*95/1920, sHeight*225/1080, tocolor (200, 200, 200, 255), 1, fonts[1], "left", "top", false, false, true, true, false)
    dxDrawText ( jobNames[1]..'\n'..jobNames[2]..'\n'..jobNames[3]..'\n'..jobNames[4]..'\n'..jobNames[5]..'\n'..jobNames[6]..'\n'..jobNames[7], sWidth*35/1920, sHeight*260/1080, sWidth*25/1920, sHeight*260/1080, tocolor (200, 200, 200, 255), 1, fonts[2], "left", "top", false, false, true, true, false)

   -- çöp dxDrawRectangle(sWidth*20/1920, sHeight*260/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
   -- taksi dxDrawRectangle(sWidth*20/1920, sHeight*295/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
   -- davıh dxDrawRectangle(sWidth*20/1920, sHeight*330/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
   -- tırcılık dxDrawRectangle(sWidth*20/1920, sHeight*365/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
   -- garsonluk dxDrawRectangle(sWidth*20/1920, sHeight*400/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
   -- balık dxDrawRectangle(sWidth*20/1920, sHeight*440/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)

        if isInSlot( sWidth*20/1920, sHeight*260/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*260/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
        elseif isInSlot ( sWidth*20/1920, sHeight*295/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*295/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
        elseif isInSlot ( sWidth*20/1920, sHeight*330/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*330/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)   
        elseif isInSlot ( sWidth*20/1920, sHeight*365/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*365/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
        elseif isInSlot ( sWidth*20/1920, sHeight*400/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*400/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
        elseif isInSlot ( sWidth*20/1920, sHeight*440/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*440/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
        elseif isInSlot ( sWidth*20/1920, sHeight*475/1080, sWidth*300/1920, sHeight*35/1080 ) then
            roundedRectangle(sWidth*20/1920, sHeight*475/1080, sWidth*300/1920, sHeight*35/1080, tocolor(255, 255, 255, 100), false)
        end
end

bindKey("P","down",function()
    if not localPlayer:getData("loggedin") == 1 then return end 
		if isElementWithinColShape(localPlayer, colshape) then
        if not jobPanel then
        jobPanel = true
        addEventHandler("onClientRender",root,__renderJobPanel)
        else
        jobPanel = nil
        removeEventHandler("onClientRender",root,__renderJobPanel)
		end
    end
end)

addEventHandler('onClientColShapeLeave', colshape, function()
jobPanel = nil
removeEventHandler("onClientRender",root,__renderJobPanel)
end
)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI)
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI)
	end
end