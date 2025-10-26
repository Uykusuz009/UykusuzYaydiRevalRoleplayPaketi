g_artifacts = {
	--[ID] = {model, bone, x, y, z, rx, ry, rz, scale, doublesided, texture},
	["helmet"]			= {2799,1,0,0.037,0.08,7.5,0,180,1,false},
	["gasmask"]			= {3890,1,0.00825,0.14,0,0,-3,90,0.8725,true},
	["hockeymask"]		= {2397,1,0.00225,0.06,-0.51,0,-3,90,0.8625,false},
	["monstermask"]		= {2396,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["monkeymask"]		= {2398,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["smonkeymask"]		= {2399,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["carnivalmask"]	= {2407,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["elektromask"]		= {2408,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["ironmanmask"]		= {2409,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["katilmask"]		= {1667,1,0.00225,0.041,-0.51,0,-3,90,0.8625,false},
	["glass"]			= {1666,1,0.00225,0.028,-0.51,0,-2,94,0.8625,false},
	["cap"]			= {2411,1,0.00225,-0.005,-0.48,0,-3,90,0.9225,false},
	["kesemask"]		= {2410,1,0.00225,0.04,-0.50,0,-3,90,0.8625,true,{{":rl_artifacts/textures/kese.png","hoodyabase5"},}},
	["kevlar"]			= {3916,3,0,0.025,0.075,0,270,0,1.125,true},
	["rod"]				= {16442,11,0,0.037,0.08,0,270,0,2,false},
	["dufflebag"]		= {3915,3,0,-0.1325,0.145,0,0,0,1,true},
	["briefcase"]		= {1210,12,0,0.1,0.3,0,180,0,1,false},
	["backpack"]		= {3026,5,0,-0.4,0.02,0,0,80,1,true},
	["medicbag"]		= {3915,3,0,-0.1325,0.145,0,0,0,1,true,{{":rl_artifacts/textures/medicbag.png","hoodyabase5"},}},
	["bikerhelmet"]		= {3911,1,0,0.037,0.08,7.5,0,180,1,false},
	["fullfacehelmet"]	= {3917,1,0,0.037,0.08,7.5,0,180,1,false},
	["PoliceGlasses"]= {1918,1,0.00825,0.1,0.10,0.13,0.13,90,0.8725,true},
	
}
ART_MODEL = 1
ART_BONE = 2
ART_X = 3
ART_Y = 4
ART_Z = 5
ART_RX = 6
ART_RY = 7
ART_RZ = 8
ART_SCALE = 9
ART_DOUBLESIDED = 10
ART_TEXTURE = 11

g_artifacts_mes = {}

function getArtifacts()
	return g_artifacts
end

g_skinSpecifics = {
	["helmet"] = {
		--[skin] = {model, bone, x, y, z, rx, ry, rz, scale, doublesided, texture}
		[235] = {2799,1,0,-0.03,0,-80,0,180,2.6,false},
	},
	["bikerhelmet"] = {
		--[skin] = {model, bone, x, y, z, rx, ry, rz, scale, doublesided, texture}
		[235] = {3911,1,0,-0.03,0,-80,0,180,2.4,false},
	},
	["fullfacehelmet"] = {
		--[skin] = {model, bone, x, y, z, rx, ry, rz, scale, doublesided, texture}
		[235] = {3917,1,0,-0.03,0,-80,0,180,2.6,false},
	},
}

function getSkinSpecificArtifactData(artifact, skin)
	if g_skinSpecifics[artifact] then
		if g_skinSpecifics[artifact][skin] then
			local data = {}
			for k,v in ipairs(g_skinSpecifics[artifact][skin]) do
				local value
				if (v == nil) then
					value = g_artifacts[artifact][k]
				else
					value = v
				end
				table.insert(data, value)
			end
			return data
		end
	end
	return false
end