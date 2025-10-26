addEvent("onSkinBuy", true)
addEventHandler("onSkinBuy", root, function(skinID, cost)


-- if client ~= source then 
-- kickPlayer(client,"Ramo AC - triggerServerEvent")
-- print("RamoAC 111")
-- return end

    local thePlayer = client
    local playerMoney = exports.rl_global:getMoney(thePlayer)

    
    if getElementData(thePlayer, "skinPanelActi") then
      
        if playerMoney >= cost then
           
            exports.rl_global:takeMoney(thePlayer, cost)

            
            setElementModel(thePlayer, skinID)

          
            exports.rl_items:giveItem(thePlayer, 16, skinID)

           
            exports["rl_infobox"]:addBox(thePlayer, "info", "[MARKET] " .. skinID .. " ID'li kıyafeti " .. cost .. " ₺ karşılığında başarıyla satın aldınız.")
        else
          
            exports["rl_infobox"]:addBox(thePlayer, "error", "[MARKET] Yeterli paranız yok!")
        end
  
    end
end)
