



--COPYRIGHT ( No borrar, por favor. )
-----------------------------------------------------------------------------------------------------------------------------------------------
--PANEL CREADO POR <~KaMiKaZe~> ...
--Gracias por descargar ^-^
--Publicado el día 17/06/18
--Mi Página de MTA https://forum.mtasa.com/profile/62475--/
---------------------------------------------------------------------------------------------------------------------------------------------------------
--COPYRIGHT ( No borrar, por favor. )





--Panel Creado Usando GUIEDITOR...


GUIEditor = {
    label = {}
}


--Panel Creado Usando GUIEDITOR...




-- PANEL

local screenW, screenH = guiGetScreenSize()

       local window = guiCreateWindow((screenW - 323) / 2, (screenH - 383) / 2, 323, 383, "Sistema Anti-Lag", false)
        guiWindowSetSizable(window, false)
        guiSetAlpha(window, 1.00)

        vision = guiCreateScrollBar(33, 61, 244, 20, true, false, window)
		guiScrollBarSetScrollPosition(vision,50)
        GUIEditor.label[1] = guiCreateLabel(102, 35, 165, 16, "Distância de visão", false, window)
        GUIEditor.label[2] = guiCreateLabel(102, 91, 165, 16, "Distancia da Neblina", false, window)
        niebla = guiCreateScrollBar(33, 117, 244, 20, true, false, window)
		guiScrollBarSetScrollPosition(niebla,50)
       GUIEditor.label[3] = guiCreateLabel(102, 147, 165, 16, "Tamanho do sol", false, window)
       sol = guiCreateScrollBar(33, 173, 244, 20, true, false, window)
	  	guiScrollBarSetScrollPosition(sol,50) 
        GUIEditor.label[4] = guiCreateLabel(102, 203, 165, 16, "Tamanho da Lua", false, window)
        luna = guiCreateScrollBar(33, 229, 244, 20, true, false, window)
			guiScrollBarSetScrollPosition(luna,50)
        oclusion = guiCreateCheckBox(34, 272, 14, 15, "", false, false, window)
        GUIEditor.label[5] = guiCreateLabel(52, 272, 60, 15, "Oclusões", false, window)
       lluvia = guiCreateCheckBox(138, 272, 14, 15, "", false, false, window)
    GUIEditor.label[6] = guiCreateLabel(157, 272, 60, 15, "Chuva", false, window)
 nubes = guiCreateCheckBox(225, 272, 14, 15, "", false, false, window)
 GUIEditor.label[7] = guiCreateLabel(243, 272, 60, 15, "Nuvem", false, window)
 clou = guiCreateButton(287, 25, 23, 24, "X", false, window)   

 
 GUIEditor.label[8] = guiCreateLabel(59, 333, 221, 16, "brasil New Style Roleplay | PC FRACO", false, window)
 GUIEditor.label[9] = guiCreateLabel(59, 353, 221, 16, "¡ Traduzidor Por Nogueira !", false, window) 
       guiSetVisible( window, false )	

	   
	   
	   




	 
--ABRIR PANEL	   
	   

	   
	   
function abrirp()


guiSetVisible( window, true )
showCursor( true )






end
addCommandHandler("anti", abrirp)



--CERRAR PANEL



addEventHandler("onClientGUIClick", guiRoot,
function()

if source == clou then
 
guiSetVisible( window, false )
showCursor( false )

    end
end
)





--DISTANCIA DE VISIÓN


addEventHandler("onClientGUIScroll", guiRoot,
function ()

if source == vision then

local vis = guiScrollBarGetScrollPosition(vision)
if vis == 100 then

setFarClipDistance( 3000 )


          end
if vis == 0 then

setFarClipDistance( 50 )


          end		  
		  

if vis == 10 then

setFarClipDistance( 300 )


          end	


if vis == 20 then

setFarClipDistance( 400 )


          end	


if vis == 30 then

setFarClipDistance( 500 )


          end	


if vis == 40 then

setFarClipDistance( 600 )


          end	

if vis == 50 then

setFarClipDistance( 700 )


          end	


if vis == 60 then

setFarClipDistance( 800 )


          end	


if vis == 70 then

setFarClipDistance( 900 )


          end	



if vis == 80 then

setFarClipDistance( 1000 )


          end		


if vis == 90 then

setFarClipDistance( 2000 )


          end			  
		  
		  
     end
end
)




--DISTANCIA DE NEBLINA




addEventHandler("onClientGUIScroll", guiRoot,
function ()

if source == niebla then

local nie = guiScrollBarGetScrollPosition(niebla)
if nie == 100 then

setFogDistance( 50 )


          end
if nie == 0 then

setFogDistance( 0 )


          end  
		  

if nie == 10 then

setFogDistance( 5 )


          end


if nie == 20 then

setFogDistance( 10 )


          end	


if nie == 30 then

setFogDistance( 15 )


          end


if nie == 40 then

setFogDistance( 20 )


          end

if nie == 50 then

setFogDistance( 25 )


          end


if nie == 60 then

setFogDistance( 30 )


          end


if nie == 70 then

setFogDistance( 35 )


          end



if nie == 80 then

setFogDistance( 40 )


          end	


if nie == 90 then

setFogDistance( 45 )


          end
		  
		  
		  
     end
end
)









--TAMAÑO DE Sol



addEventHandler("onClientGUIScroll", guiRoot,
function ()

if source == sol then

local so = guiScrollBarGetScrollPosition(sol)
if so == 100 then

setSunSize(5)


          end

		  

if so == 0 then

setSunSize(0)


          end		  
		  
		  

if so == 30 then

setSunSize(1)


          end
		  
		  
		  if so == 50 then

setSunSize(2)


          end
		  
		  
if so == 70 then

setSunSize(3)


          end	


if so == 80 then

setSunSize(4)


          end		  
		  
		  
		  
     end
end
)




--TAMAÑO DE LA LUNA






addEventHandler("onClientGUIScroll", guiRoot,
function ()

if source == luna then

local lun = guiScrollBarGetScrollPosition(luna)

if lun == 100 then

setMoonSize(5)


          end
		  
		  
if lun == 0 then

setMoonSize(0)


          end		  
		  
		  
if lun == 30 then

setMoonSize(1)


          end		  
		  
		 
if lun == 50 then

setMoonSize(2)


          end	
		  
		  
if lun == 70 then

setMoonSize(3)


          end		



if lun == 90 then

setMoonSize(4)


          end			  

		 
		  
     end
end
)



--OCLUSIÓN

addEventHandler("onClientGUIClick", guiRoot,
function()

if source == oclusion then
local check = guiCheckBoxGetSelected(oclusion)
if check then

 setOcclusionsEnabled( true )

else

 setOcclusionsEnabled( false )

            end
		  
		  
     end
end
)



--LLUVIA

addEventHandler("onClientGUIClick", guiRoot,
function()

if source == lluvia then
local check = guiCheckBoxGetSelected(lluvia)
if check then

resetRainLevel()

else

setRainLevel(0)

            end
		  
		  
     end
end
)


--NUBES

addEventHandler("onClientGUIClick", guiRoot,
function()

if source == nubes then
local check = guiCheckBoxGetSelected(nubes)
if check then

setCloudsEnabled ( true )

else

setCloudsEnabled ( false )

            end
		  
		  
     end
end
)












	   
