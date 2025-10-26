bindKey("num_sub", "down", function()
    triggerServerEvent("air.down", localPlayer)
end)

bindKey("num_add", "down", function()
    triggerServerEvent("air.up", localPlayer)
end)