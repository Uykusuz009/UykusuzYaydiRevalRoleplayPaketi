local maxLoginAttempts = 10
local restrictionDuration = 10000
local connectionAttempts = {}

addEventHandler("onPlayerConnect", root, function()
	local currentTime = getTickCount()
    for i = #connectionAttempts, 1, -1 do
        if currentTime - connectionAttempts[i] > restrictionDuration then
            table.remove(connectionAttempts, i)
        end
    end
    table.insert(connectionAttempts, currentTime)
    if #connectionAttempts > maxLoginAttempts then
        cancelEvent(true, "Çok fazla giriş denemesi yapıldı. Lütfen daha sonra tekrar deneyin.")
    end
end)