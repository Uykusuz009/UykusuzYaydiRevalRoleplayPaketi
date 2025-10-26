local _getVehicleName = getVehicleName
function getVehicleName(theVehicle)
	if not theVehicle or (getElementType(theVehicle) ~= "vehicle") then
		return "?"
	end
	local name = _getVehicleName(theVehicle)
	local year = getElementData(theVehicle, "year")
	local brand = getElementData(theVehicle, "brand")
	local model = getElementData(theVehicle, "model")
	if year and brand and model then
		name = tostring(year) .. " " .. tostring(brand) .. " " .. tostring(model)
	end
	return name
end

local function randomLetter()
    return string.char(math.random(65, 90))
end

-- Function to generate random letter (FIXED)
function randomLetter()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local randomIndex = math.random(1, #letters)
    return string.sub(letters, randomIndex, randomIndex)
end

-- Modified function to generate license plate: 34 UVZ 650
function generatePlate()
    -- Always start with 34
    local number1 = "34"
    
    -- Generate three letters (UVZ)
    local letter1 = randomLetter()
    local letter2 = randomLetter()
    local letter3 = randomLetter()
    
    -- Generate last three digits (650) - always 3 digits
    local number2 = math.random(100, 999)
    
    -- Combine in format: 34 UVZ 650
    local plate = number1 .. " " .. letter1 .. letter2 .. letter3 .. " " .. number2
    return plate
end

function isVehicleEmpty(vehicle)
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return true
    end

    local passengers = getVehicleMaxPassengers(vehicle)
    if type(passengers) == "number" then
        for seat = 4, passengers do
            if getVehicleOccupant(vehicle, seat) then
                return false
            end
        end
    end
    return true
end

function getVehicleVelocity(vehicle, player)
	local speedx, speedy, speedz = getElementVelocity(vehicle)
	local actualspeed = (speedx ^ 2 + speedy ^ 2 + speedz ^ 2) ^ (0.5) 
	if player and isElement(player) then
		return actualspeed * 111.847
	else 
		return actualspeed * 180
	end
end