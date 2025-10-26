function realTimer() 
    local realTime = getRealTime() 
    local hour = realTime.hour
    local minute = realTime.minute

    setMinuteDuration(60000) 
    setTime(hour, minute)
    setCloudsEnabled(true)
    setSunSize(1)
	setColorFilter(63, 63, 63, 255, 63, 63, 63, 255)

    local weatherID = 0
    if (hour >= 1) and (hour <= 4) then
        weatherID = 2
    elseif (hour >= 5) and (hour <= 10) then
        weatherID = 0
    elseif (hour >= 11) and (hour <= 16) then
        weatherID = 1
    else
        weatherID = 14
    end

    setWeather(weatherID)
end
addEventHandler("onClientResourceStart", resourceRoot, realTimer)
setTimer(realTimer, 1000, 0)