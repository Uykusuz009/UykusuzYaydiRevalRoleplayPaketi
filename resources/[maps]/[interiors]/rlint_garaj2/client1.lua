--------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy

--------------------------------------------------------

addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('1.txd',true)
engineImportTXD(txd, 1935)
local dff = engineLoadDFF('1.dff', 0)
engineReplaceModel(dff, 1935)
local col = engineLoadCOL('1.col')
engineReplaceCOL(col, 1935)
engineSetModelLODDistance(1935, 999)
end)


--------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy

--------------------------------------------------------