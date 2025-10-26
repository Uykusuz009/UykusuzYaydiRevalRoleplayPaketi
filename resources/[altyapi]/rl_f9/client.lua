local screenWidth,screenHeight = guiGetScreenSize()
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        myScreenSource = dxCreateScreenSource ( screenWidth, screenHeight )         
    end
)
 
function cleanmyscreen()
	if myScreenSource then
		dxUpdateScreenSource( myScreenSource )                  
		dxDrawImage( screenWidth - screenWidth,  screenHeight - screenHeight,  screenWidth, screenHeight, myScreenSource, 0, 0, 0, tocolor (255, 255, 255, 255), true)      
		dxDrawRectangle(0,0,screenWidth,50,tocolor(0,0,0),true)
		dxDrawRectangle(0,screenHeight-50,screenWidth,50,tocolor(0,0,0),true)
		dxDrawText("discord.gg/Revalroleplay",screenWidth/2,screenHeight-30,nil,nil,tocolor(255,255,255),1,exports.kaisen_fonts:getFont("Roboto-Black",12),"center","top",true,true,true,true)
	end
end


function tooglecleanmyscreen ()
enabled = not enabled
if enabled then
	addEventHandler( "onClientRender", root, cleanmyscreen)
	else
	removeEventHandler( "onClientRender", root, cleanmyscreen)
end
end
bindKey ("f9", "down", tooglecleanmyscreen)
addEvent("phone.hudKapat",true)
addEventHandler("phone.hudKapat",root,tooglecleanmyscreen)