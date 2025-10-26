function setPlayerDebug (player)
    setPlayerScriptDebugLevel(player, 3)
    outputChatBox("Debug Acıldı", player)
end 
addCommandHandler("debug", setPlayerDebug) 

function debugkapat (player)
    setPlayerScriptDebugLevel(player, 0)
    outputChatBox("Debug Kapatıldı", player)
end 
addCommandHandler("debugkapat", debugkapat) 