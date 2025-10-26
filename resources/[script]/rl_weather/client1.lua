setDevelopmentMode(true)
local weatherID = 3
function havaDurumuBaslat()
	setWeather(weatherID)
	havaDurumuKontrolEt()
end
addEventHandler("onClientResourceStart", resourceRoot, havaDurumuBaslat)

function havaDurumuKontrolEt()
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	if getElementDimension(getLocalPlayer()) ~= 0 then
		setTime(12, 0)
		return
	end
	setTime(hours + 1, minutes)
	setWeather(weatherID)
end
addEvent("weather-system:havaDurumuKontrolEt", true)
addEventHandler("weather-system:havaDurumuKontrolEt", getRootElement(), havaDurumuKontrolEt)
addCommandHandler("havakontrol", havaDurumuKontrolEt)

setTimer(havaDurumuKontrolEt, 3600000, 0)

