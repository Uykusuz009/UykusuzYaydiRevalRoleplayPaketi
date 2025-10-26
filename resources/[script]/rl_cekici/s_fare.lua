-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy  

Bind = "M" -- bind a qual você quer ativar/desativar o cursor

cursorEnabled = {} -- armazenar jogadores que tem cursor ligado/desligado

function toggleCursor( thePlayer )
    if cursorEnabled[ thePlayer ] then 
        showCursor( thePlayer, false )
        cursorEnabled[ thePlayer ] = false
    else 
        showCursor( thePlayer, true )
        cursorEnabled[ thePlayer ] = true
    end
end

function reiniciarCursor()
    for index, player in ipairs(getElementsByType("player")) do
        bindKey(player, Bind, "down", toggleCursor)
        cursorEnabled[ player ] = false
    end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), reiniciarCursor)
    
function setarCursor()
    bindKey(source, Bind, "down", toggleCursor)
    cursorEnabled[ source ] = false
end
addEventHandler("onPlayerJoin", getRootElement(), setarCursor)




-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy