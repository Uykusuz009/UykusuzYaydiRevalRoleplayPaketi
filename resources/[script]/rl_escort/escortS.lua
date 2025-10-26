addEvent('take.escort.money', true)
addEventHandler('take.escort.money', root, function(amount)
    exports['rl_global']:takeMoney(source, amount)
end)