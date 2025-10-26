---------------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
---------------------------------------------------------------

addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('1.txd',true)
engineImportTXD(txd, 1830)
local dff = engineLoadDFF('1.dff', 0)
engineReplaceModel(dff, 1830)
local col = engineLoadCOL('1.col')
engineReplaceCOL(col, 1830)
engineSetModelLODDistance(1830, 999)
end)

---------------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
---------------------------------------------------------------