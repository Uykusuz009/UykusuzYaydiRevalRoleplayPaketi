local s = engineLoadCOL ( "Model.col" )
engineReplaceCOL ( s, 16201 )
local s = engineLoadTXD ( "Model.txd" )
engineImportTXD ( s, 16201 )
local s = engineLoadDFF ( "Model.dff" )
engineReplaceModel ( s, 16201, true )

setOcclusionsEnabled( false )


-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy
