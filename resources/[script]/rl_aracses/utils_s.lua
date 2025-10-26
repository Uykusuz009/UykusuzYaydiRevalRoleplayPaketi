VEHICLES_TYPES = {
	["Bus"] = {431, 437},
	["Truck"] = {403, 406, 407, 408, 413, 414, 427, 432, 433, 443, 444, 455, 456,
				 498, 499, 514, 515, 524, 531, 544, 556, 557, 573, 578, 601, 609},
	["Sport"] = {424, 558, 568},
	["Casual"] = {416, 420,
						  436, 438, 440, 459,
						  478, 482, 490, 505,
						  526, 528, 599, 481,
						  536, 534, 576},
	["revaldeneme"] = {567},
	["reval16"] = {589, 489, 466, 419, 442, 507, 600, 500, 426, 596, 597, 598, 496, 467, 479, 422, 418, 551},
	["revaldodge"] = {555},
	["revalm4"] = {451, 603},
	["revals2000"] = {480},
	["revalkoenigsegg"] = {411},
	["revalmclaren"] = {503},
	["revalhybird"] = {517, 561},
	["revalvtec16"] = {492, 605},
	["revalvtec20"] = {},
	["revale60"] = {445},
	["revallambo"] = {506, 502},
	["revalferrari"] = {494, 401},
	["reval911gt"] = {429},
	["revaltofas"] = {405},
	["revale36"] = {436},
	["revalr34"] = {575, 562, 549},
	["revalsupra"] = {559},
	["revalm3gtr"] = {475},
	["reval350z"] = {527},
	["revallancer"] = {565, 560},
	["revalv6"] = {541, 554, 533, 516},
	["revalv8"] = {580, 400, 410, 540, 404, 543, 491, 518, 546, 477, 602, 579, 412, 587, 547, 566, 458},
	["revalv10"] = {415, 470},
	["reval20"] = {604, 421, 550, 535, 495, 585, 529},
	["Muscle"] = {474, 545, 542, 402},
	["Plane"] = {592, 577, 511, 548, 512, 593, 425, 520, 417, 487, 553, 488, 497, 563, 476, 447, 519, 460, 469, 513},
	["Boat"] = {472, 473, 493, 595, 484, 430, 453, 452, 446, 454},
	["Motorbike"] = {462, 521, 463, 522, 461, 448, 468, 586, 471, 581}
}

CLASSES = {
	[{0, 200}] = "E",
	[{200, 400}] = "D",
	[{400, 600}] = "C",
	[{600, 800}] = "B",
	[{800, 1000000000}] = "A",
}

MAX_VELOCITY = {
	[504] = 300,
	[400] = 150,
	[401] = 140,
	[402] = 178,
	[404] = 126,
	[405] = 156,
	[409] = 150,
	[410] = 123,
	[411] = 210,
	[412] = 161,
	[415] = 182,
	[418] = 110,
	[419] = 142,
	[421] = 246,
	[422] = 134,
	[424] = 128,
	[426] = 165,
	[429] = 192,
	[434] = 159,
	[436] = 142,
	[439] = 160,
	[445] = 215,
	[451] = 182,
	[458] = 150,
	[461] = 153,
	[463] = 138,
	[466] = 140,
	[467] = 134,
	[468] = 138,
	[471] = 102,
	[474] = 142,
	[475] = 165,
	[477] = 178,
	[478] = 112,
	[479] = 133,
	[480] = 178,
	[482] = 149,
	[483] = 118,
	[489] = 133,
	[491] = 142,
	[492] = 136,
	[495] = 168,
	[496] = 155,
	[500] = 134,
	[506] = 170,
	[507] = 158,
	[508] = 102,
	[516] = 150,
	[517] = 150,
	[518] = 158,
	[521] = 154,
	[526] = 150,
	[527] = 142,
	[529] = 142,
	[533] = 159,
	[534] = 161,
	[535] = 150,
	[536] = 165,
	[540] = 142,
	[541] = 192,
	[542] = 156,
	[543] = 144,
	[545] = 140,
	[546] = 142,
	[547] = 136,
	[549] = 300,
	[550] = 138,
	[551] = 150,
	[554] = 137,
	[555] = 330,
	[558] = 162,
	[559] = 350,
	[560] = 169,
	[561] = 146,
	[562] = 350,
	[565] = 165,
	[566] = 152,
	[567] = 165,
	[575] = 150,
	[576] = 150,
	[579] = 150,
	[580] = 145,
	[581] = 145,
	[585] = 145,
	[586] = 138,
	[587] = 157,
	[589] = 155,
	[600] = 144,
	[602] = 169,
	[603] = 163,
	[522] = 210,
}
function getVehicleMaxVelocity(model)
	return MAX_VELOCITY[model] or 0
end 

function getVehicleTypeByModel(model)
	for type, models in pairs(VEHICLES_TYPES) do 
		for _, mdl in pairs(models) do 
			if mdl == model then 
				return type
			end
		end
	end 
	
	return "Casual"
end

function calculateVehicleClass(vehicle)
	local handling = nil
	local v_type = nil
	if type(vehicle) == "number" then 
		handling = getOriginalHandling(vehicle)
		v_type = getVehicleTypeByModel(vehicle)
	else 
		handling = getVehicleHandling(vehicle)
		v_type = getElementData(vehicle, "vehicle:type")
	end
	
	-- engine
	local acc = handling.engineAcceleration 
	local vel = handling.maxVelocity
	local drag = handling.dragCoeff
	local c = (acc / drag / vel)
	if v_type == "Casual" then 
		c = c-0.010
	elseif v_type == "Sport" then 
		c =c-0.005
	elseif v_type == "Muscle" then 
		c = c-0.02
	elseif v_type == "Truck" then 
		c =c+0.012
	elseif v_type == "reval16" then 
		c =c+0.005
	elseif v_type == "reval20" then 
		c =c+0.005
	elseif v_type == "revalhybird" then 
		c =c+0.005
	elseif v_type == "reval911gt" then 
		c =c+0.005
	elseif v_type == "revalm4" then 
		c =c+0.005
	elseif v_type == "revals2000" then 
		c =c+0.005
	elseif v_type == "revallambo" then 
		c =c+0.005
	elseif v_type == "revalferrari" then 
		c =c+0.005
	elseif v_type == "revalkoenigsegg" then 
		c =c+0.005
	elseif v_type == "revalmclaren" then 
		c =c+0.005
	elseif v_type == "revalv6" then 
		c =c+0.005
	elseif v_type == "revalv8" then 
		c =c+0.005
	elseif v_type == "revalv10" then 
		c =c+0.005
	elseif v_type == "revaldeneme" then 
		c =c+0.005
	elseif v_type == "revaldodge" then 
		c =c+0.005
	elseif v_type == "revalvtec16" then 
		c =c+0.005
	elseif v_type == "revalvtec20" then 
		c =c+0.005
	elseif v_type == "revaltofas" then 
		c =c+0.005
	elseif v_type == "revalr34" then 
		c =c+0.005
	elseif v_type == "revallancer" then 
		c =c+0.005
	elseif v_type == "revale60" then 
		c =c+0.005
	elseif v_type == "revalsupra" then 
		c =c+0.005
	end
	
	-- steering
	local turnMass = handling.turnMass 
	local mass = handling.mass 
	local traction = handling.tractionLoss
	c = c - (turnMass/mass/traction)*0.001 
	
	return math.ceil(c*(10^4.54))
end

function getVehicleClass(vehicle)
	local class = calculateVehicleClass(vehicle)
	for required, name in pairs (CLASSES) do 
		if class >= required[1] and class <= required[2] then 
			return name
		end
	end
	
	return "E"
end 

if getModelHandling then
	for name, models in pairs(VEHICLES_TYPES) do 
		table.sort(models, function(a, b)
			return calculateVehicleClass(a) > calculateVehicleClass(b)
		end)	
	end

	--[[
	for name, models in pairs(VEHICLES_TYPES) do 
		outputChatBox("Najgorszy z "..name..": "..models[#models])
		outputChatBox("Najlepszy z "..name..": "..models[1])
	end 
	--]]
	
	function getBestVehicleClassByType(type)
		if type then 
			return VEHICLES_TYPES[type][1]
		end
	end 	
end 
