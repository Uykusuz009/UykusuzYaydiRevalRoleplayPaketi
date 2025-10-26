--[[



 ################################################
 #                                              #
 #              Script Criado Por               #
 #           FACEBOOK.COM/AIRNEWSCR             #
 #                                              #
 #                                              #
 ################################################   



--]]

-------------------------------------------------

function SetarNivelDeBlur ()
    setPlayerBlurLevel ( source, 0 )
end
addEventHandler ( "onPlayerJoin", getRootElement(), SetarNivelDeBlur )

-------------------------------------------------

function QuandoIniciarScript ()
    setPlayerBlurLevel ( getRootElement(), 0 )
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), QuandoIniciarScript )

-------------------------------------------------

function QuandoReiniciarScript ()
	setTimer ( QuandoIniciarScript, 4000, 1 )
end
addEventHandler( "onResourceStart", getRootElement(), QuandoReiniciarScript )

-------------------------------------------------
