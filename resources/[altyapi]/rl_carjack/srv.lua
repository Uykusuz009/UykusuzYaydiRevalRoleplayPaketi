function checkCarJack(thePlayer, seat, jacked)
   if jacked and seat == 0 then
      cancelEvent()
      outputChatBox("[RevalMTA]#ffffff Sunucuda CarJack Yasak. ", thePlayer,255,0,0,true)
   end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkCarJack)