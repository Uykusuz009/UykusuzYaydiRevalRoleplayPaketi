_lspdVoice = function(player,cmd,arg)

    if not arg then 
    player:outputChat("[Reval Roleplay]#FFFFFF : /"..cmd.." <1-4> ",255,255,255,true)
    return end
    local car = player:getOccupiedVehicle(player)
    local block = player:getData("lspd:block") or nil
    local _random = math.random(1,4)
    local _chats = _chatList[_random]
    if block then
        player:outputChat("[Reval Roleplay]#FFFFFF ".._chats..".",255,255,55,true)
    return end
    if not car then player:outputChat("[Reval Roleplay]#FFFFFF Bu komutu kullanabilmeniz için araçta olmanız gerekmektedir.",255,155,55,true) return end
    local _model = car:getModel(car)
    if ( policeVehicles[_model]) then 
for k, v in ipairs(megaphoneList) do

    if arg == v.command then
        local x,y,z =  getElementPosition(player)
        player:setData("lspd:block",true)
        player:outputChat("[Reval Roleplay]#FFFFFF "..v.command.." numaralı megafon seslendirildi. ",255,255,255,true)
        triggerClientEvent(root,"play:lspd",root,player,v.file,x,y,z)
    Timer(function()
    player:setData("lspd:block",nil)
    end,5000,1)
    end

end
else
    player:outputChat("[Reval Roleplay]#FFFFFF Aracınız polis aracı değil.",255,155,55,true) 
end
end
addCommandHandler("megafon",_lspdVoice)