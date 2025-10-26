itemsPackages = {
	-- name, description, category, model, rx, ry, rz, zoffset
	-- categories:
	-- 1 = Food & Drink
	-- 2 = Keys
	-- 3 = Drugs
	-- 4 = Other
	-- 5 = Books
	-- 6 = Clothing & Accessories
	-- 7 = Electronics
	-- 8 = guns
	-- 9 = bullets
	-- 10 = wallet
	
	[1] = { "Hotdog", "A steamy, good looking and tasty hotdog.", 1, 2215, 205, 205, 0, 0.01, weight = 0.1 },
	[2] = { "iPhone", "iPhone iletişim kurmanıza yardımcı olur.", 7, 330, 90, 90, 0, 0, weight = 0.3 },
	[3] = { "Vehicle Key", "A vehicle key with a small manufacturers badge on it.", 2, 1581, 270, 270, 0, 0, weight = 0.1 },
	[4] = { "House Key", "A green house key.", 2, 1581, 270, 270, 0, 0, weight = 0.1 },
	[5] = { "Business Key", "A blue business key.", 2, 1581, 270, 270, 0, 0, weight = 0.1 },
	[6] = { "Radio", "A black radio.", 7, 330, 90, 90, 0, -0.05, weight = 0.2, preventSpawn = true },
	[7] = { "Phonebook", "A torn phonebook.", 5, 2824, 0, 0, 0, -0.01, weight = 2 },
	[8] = { "Sandwich", "A yummy sandwich with cheese.", 1, 2355, 205, 205, 0, 0.06, weight = 0.3 },
	[9] = { "Softdrink", "A can of Sprunk.", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	[10] = { "Tek zar", "1,6 arası rastgele sayılar gelen zar.", 4, 1271, 0, 0, 0, 0.285, weight = 0.1 },
	[11] = { "Taco", "A greasy mexican taco.", 1, 2215, 205, 205, 0, 0.06, weight = 0.1 },
	[12] = { "Burger", "A double cheeseburger with bacon.", 1, 2703, 265, 0, 0, 0.06, weight = 0.3 },
	[13] = { "Donut", "Hot sticky sugar covered donut.", 1, 2222, 0, 0, 0, 0.07, weight = 0.2 },
	[14] = { "Cookie", "A luxury chocolate chip cookie.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1 },
	[15] = { "Water", "A bottle of mineral water.", 1, 1484, -15, 30, 0, 0.2, weight = 1 },
	[16] = { "Kıyafet", "Üzerinize giydiklerinizdir ((Skin ID ##v))", 6, 2386, 0, 0, 0, 0.1, weight = 1 },
	[17] = { "Saat", "Ufak standart saat.", 6, 1271, 0, 0, 0, 0.285, weight = 0.1 },
	[18] = { "City Guide", "A small city guide booklet.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[19] = { "MP3 Player", "A white, sleek looking MP3 Player. The brand reads EyePod.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 },
	[20] = { "Standard Fighting for Dummies", "A book on how to do standard fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[21] = { "Boxing for Dummies", "A book on how to do boxing.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[22] = { "Kung Fu for Dummies", "A book on how to do kung fu.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[23] = { "Knee Head Fighting for Dummies", "A book on how to do grab kick fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[24] = { "Grab Kick Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[25] = { "Elbow Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[26] = { "Gas Mask", "A black gas mask, blocks out the effects of gas and flashbangs.", 6, 2386, 0, 0, 0, 0.1, weight = 0.5 },
	[27] = { "Flashbang", "A small grenade canister with FB written on the side.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[28] = { "Glowstick", "A green glowstick.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[29] = { "Door Ram", "A red metal door ram.", 4, 1587, 90, 0, 0, 0.05, weight = 3 },
	[30] = { "Cannabis Sativa", "Cannabis Sativa, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[31] = { "Cocaine Alkaloid", "Cocaine Alkaloid, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[32] = { "Lysergic Acid", "Lysergic Acid, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[33] = { "Unprocessed PCP", "Unprocessed PCP, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[34] = { "Kokain", "Büyük bir enerji artışı yaratır, toz bir madde.", 3, 1575, 0, 0, 0, 0, weight = 0.1 },
	[35] = { "Morfin", "Güçlü etkileri olan bir hap veya sıvı madde.", 3, 1578, 0, 0, 0, -0.02, weight = 0.1 },
	[36] = { "Ecstasy", "Güçlü görseller ve Coşku.", 3, 1576, 0, 0, 0, 0.07, weight = 0.1 },
	[37] = { "Heroin", "Güçlü bir  yavaşlama efektleri coşku. Sıvı veya toz bir madde.", 3, 1579, 0, 0, 0, 0, weight = 0.1 },
	[38] = { "Marijuana", "Green, good tasting weed.", 3, 3044, 0, 0, 0, 0.04, weight = 0.1 },
	[39] = { "Methamphetamine", "Güçlü enerji ve tekme efektleri ile kristal benzeri bir madde.", 3, 1580, 0, 0, 0, 0, weight = 0.1 },
	[40] = { "Epinephrine (Adrenaline)", "Epinephrine - a liquid substance that boosts adrenaline.", 3, 1575, 0, 0, 0, -0.02, weight = 0.1 },
	[41] = { "LSD", "Lysergic acid with diethylamide, gives funny visuals.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[42] = { "Shrooms", "Dry golden teacher mushrooms.", 3, 1577, 0, 0, 0, 0, weight = 0.1 },
	[43] = { "PCP", "Phencyclidine powder.", 3, 1578, 0, 0, 0, 0, weight = 0.1 },
	[44] = { "Chemistry Set", "A small chemistry set.", 4, 1210, 90, 0, 0, 0.1, weight = 3 },
	[45] = { "Handcuffs", "A pair of metal handcuffs.", 4, 2386, 0, 0, 0, 0.1, weight = 0.4 },
	[46] = { "İp", "Uzun bir ip.", 4, 1271, 0, 0, 0, 0.285, weight = 0.3 },
	[47] = { "Handcuff Keys", "A small pair of handcuff keys.", 4, 2386, 0, 0, 0, 0.1, weight = 0.05 },
	[48] = { "Sırt Çantası", "Daha fazla eşya koyabilmenize yarar.", 4, 3026, 270, 0, 0, 0, weight = 1 },
	[49] = { "Fishing Rod", "A 7 foot carbon steel fishing rod.", 4, 338, 80, 0, 0, -0.02, weight = 1.5 },
	[50] = { "Los Santos Highway Code", "The Los Santos Highway Code.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[51] = { "Chemistry 101",  "An Introduction to Useful Chemistry.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[52] = { "Police Officer's Manual", "The Police Officer's Manual.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[53] = { "Breathalizer", "A small black breathalizer.", 4, 1271, 0, 0, 0, 0.285, weight = 0.2 },
	[54] = { "Ghettoblaster", "A black Ghettoblaster.", 7, 2226, 0, 0, 0, 0, weight = 3 },
	[55] = { "Business Card", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.1 }, --Steven Pullman - L.V. Freight Depot, Tel: 12555
	[56] = { "Yüz Maskesi", "Bir Adet Maske.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 },
	[57] = { "Benzin", "Bir bidon benzin.", 4, 1650, 0, 0, 0, 0.30, weight = 1 }, -- would prolly to make sense to make it heavier if filled
	[58] = { "Ziebrand Beer", "The finest beer, imported from Holland.", 1, 1520, 0, 0, 0, 0.15, weight = 1 },
	[59] = { "Mudkip", "So i herd u liek mudkips? mabako's Favorite.", 1, 1579, 0, 0, 0, 0, weight = 0 },
	[60] = { "Safe", "A safe to store your items in.", 4, 2332, 0, 0, 0, 0, weight = 5 },
	[61] = { "Emergency Light Strobes", "An Emergency Light Strobe which you can put on you car.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 },
	[62] = { "Bastradov Vodka", "For your best friends - Bastradov Vodka.", 1, 1512, 0, 0, 0, 0.25, weight = 1 },
	[63] = { "Scottish Whiskey", "The Best Scottish Whiskey, now exclusively made from Haggis.", 1, 1512, 0, 0, 0, 0.25, weight = 1 },
	[64] = { "İEM Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[65] = { "BARON Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[66] = { "Blindfold", "A black blindfold.", 6, 2386, 0, 0, 0, 0.1, weight = 0.1 },
	[67] = { "GPS", "((This item is currently disabled.))", 6, 1210, 270, 0, 0, 0.1, weight = 0.8 },
	[68] = { "Lottery Ticket", "A Los Santos Lottery ticket.", 6, 2894, 0, 0, 0, -0.01, weight = 0.1 },
	[69] = { "Dictionary", "A Dictionary.", 5, 2824, 0, 0, 0, -0.01, weight = 1.5 },
	[70] = { "Medkit", "Saves a Life. Can be used #v times.", 4, 1240, 90, 0, 0, 0.05, weight = function(v)
																									       local v = type(v) == "number" and v or 0.5
																										   return v / 3 
																									   end
	},
	[71] = { "Notebook", "A small collection of blank papers, useful for writing notes. There are #v pages left. ((/writenote))", 4, 2894, 0, 0, 0, -0.01, weight = function(v) return v*0.01 end },
	[72] = { "Note", "The note reads: #v", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 },
	[73] = { "Elevator Remote", "A small remote to change an elevator's mode.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[74] = { "Bomb", "What could possibly happen when you use this?", 4, 363, 270, 0, 0, 0.05, weight = 100000 },
	[75] = { "Bomb Remote", "Has a funny red button.", 4, 364, 0, 0, 0, 0.05, weight = 100000 },
	[76] = { "Riot Shield", "A heavy riot shield.", 4, 1631, -90, 0, 0, 0.1, weight = 1 },
	[77] = { "Card Deck", "A card deck to play some games.", 4,2824, 0, 0, 0, -0.01, weight = 0.1 },
	[78] = { "San Andreas Pilot Certificate", "An official permission to fly planes and helicopters.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[79] = { "Porn Tape", "A porn tape, #v", 4,2824, 0, 0, 0, -0.01, weight = 0.2 },
	[80] = { "Generic Item", "#v", 4, 1271, 0, 0, 0, 0, weight = 1 },
	[81] = { "Fridge", "A fridge to store food and drinks in.", 7, 2147, 0, 0, 0, 0, weight = 0.1},
	[82] = { "Rapid Towing Identification", "This Rapid Towing Identification has been issued to #v.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[83] = { "Coffee", "A small cup of Coffee.", 1, 2647, 0, 0, 0, 0.12, weight = 0.25 },
	[84] = { "Escort 9500ci Radar Detector", "Detects Police within a half mile.", 7, 330, 90, 90, 0, -0.05, weight = 1 },
	[85] = { "Emergency Siren", "An emergency siren to put in your car.", 7, 330, 90, 90, 0, -0.05, weight = 0.2 },
	[86] = { "LSN Identifcation", "#v.", 10, 330, 90, 90, 0, -0.05, weight = 0.3 },
	[87] = { "JGK Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.5 },
	[88] = { "Earpiece", "A small earpiece, can be connected to a radio.", 7, 1581, 270, 270, 0, 0, weight = 0.15 },
	[89] = { "Food", "", 1, 2222, 0, 0, 0, 0.07, weight = 1 },
	[90] = { "Motocross Kaskı", "İdeal Motocross sürüş kaskı.", 6, 2799, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true },
	[91] = { "Eggnog", "Yum Yum.", 1, 2647, 0, 0, 0, 0.1, weight = 0.5 }, --91
	[92] = { "Turkey", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1, weight = 3.8 },
	[93] = { "Christmas Pudding", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1, weight = 0.4 },
	[94] = { "Christmas Present", "I know you want one.", 4, 1220, 0, 0, 0, 0.1, weight = 1 },
	[95] = { "Drink", "", 1, 1484, -15, 30, 0, 0.2, weight = 1 },
	[96] = { "Macbook pro A1286 Core i7", "A top of the range Macbook to view e-mails and browse the internet.", 6, 2886, 0, 0, 180, 0.1, weight = function(v) return v == 1 and 0.2 or 1.5 end },
	[97] = { "LSFD Procedures Manual", "The Los Santos Emergency Service procedures handbook.", 5, 2824, 0, 0, 0, -0.01, weight = 0.5 },
	[98] = { "Garage Remote", "A small remote to open or close a Garage.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[99] = { "Mixed Dinner Tray", "Lets play the guessing game.", 1, 2355, 205, 205, 0, 0.06, weight = 0.4 },
	[100] = { "Small Milk Carton", "Lumps included!", 1, 2856, 0, 0, 0, 0, weight = 0.2 },
	[101] = { "Small Juice Carton", "Thirsty?", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	[102] = { "Çiçek", "Bir Adet Çiçek.", 1, 1271, 0, 0, 0, 0.1, weight = 0.4 },
	[103] = { "Shelf", "A large shelf to store stuff on", 4, 3761, -0.15, 0, 85, 1.95, weight = 0.1 },
	[104] = { "Portable TV", "A portable TV to watch TV shows with.", 6, 1518, 0, 0, 0, 0.29, weight = 1 },
	[105] = { "Pack of cigarettes", "Pack with #v cigarettes in it.", 6, 3044 , 270, 0, 0, 0.1, weight = function(v) return 0.1 + v*0.03 end }, -- 105
	[106] = { "Cigarette", "Something you can smoke.", 6, 3044 , 270, 0, 0, 0.1, weight = 0.03 },
	[107] = { "Çakmak", "Ateş çıkarmaya yarıyan alet.", 6, 1210, 270, 0, 0, 0.1, weight = 0.05 },
	[108] = { "Pancake", "Yummy, a pancake!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.5 },
	[109] = { "Fruit", "Yummy, healthy food!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.35 },
	[110] = { "Vegetable", "Yummy, healthy food!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.35 },
	[111] = { "Portable GPS", "A GPS, also contains recent maps.", 6, 1210, 270, 0, 0, 0.1, weight = 0.3 },
	[112] = { "Sezon Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[113] = { "Pack of Glowsticks", "Pack with #v glowsticks in it, from the brand 'Friday'.", 6, 1210, 270, 0, 0, 0.1, weight = function(v) return v * 0.2 end },
	[114] = { "Vehicle Upgrade", "#v", 4, 1271, 0, 0, 0, 0.285, weight = 1.5 }, -- 114
	[115] = { "Silah", "#v ", 8, 2886, 270, 0, 1, 0.1, 2, weight = function(v)
																		local weaponID = tonumber(explode(":", v)[1])
																		return weaponID and weaponweights[weaponID] or 1
																	end
	}, -- 115
	[116] = { "Mermi", "#v.", 9, 2040, 0, 1, 0, 0.1, 3, weight = function(v) local weaponID = tonumber(explode(":", v)[1]) local ammo = tonumber(explode(":", v)[2]) return weaponID and ammo and ammoweights[weaponID] and ammoweights[weaponID] * ammo or 0.2 end }, -- 2886 / 116
	[117] = { "Ramp", "Useful for loading DFT-30s.", 4, 1210, 270, 1, 0, 0.1, 3, weight = 5 }, -- 117
	[118] = { "Toll Pass", "Put it in your car, charges you every time you drive through a toll booth.", 6, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 118
	[119] = { "Sanitary Andreas ID", "A Sanitary Andreas Identification Card.", 10, 1210, 270, 0, 0, 0.1, weight = 0.2 }, -- 119
	[120] = { "Scuba Gear", "Allows you to stay under-water for quite some time", 6, 1271, 0, 0, 0, 0.285, weight = 4 }, --120
	[121] = { "Box with supplies", "Pretty large box full with supplies!", 4, 1271, 0, 0, 0, 0.285, weight = function(v) return v * 0.07 end }, --121
	[122] = { "Light Blue Bandana", "A light blue rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 122
	[123] = { "Red Bandana", "A red rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 123
	[124] = { "Yellow Bandana", "A yellow rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 124
	[125] = { "Purple Bandana", "A purple rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 125
	[126] = { "Duty Belt", "A slick black leather duty belt, with many holsters.", 4, 2386, 270, 0, 0, 0, weight = 1 }, -- 126
	[127] = { "TRT Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --127
	[128] = { "Rapid Towing", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --128 --Farid | ADD TTR FACTION BAGDE ITEM | 24.1.14
	[129] = { "Direct Imports ID", "A Direct Imports ID.", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --129
	[130] = { "Vehicle Alarm System", "A vehicle alarm system.", 6, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 130
	[131] = { "LSCSD Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, -- 131
	[132] = { "Prescription Bottle", "A prescription bottle, contains prescription medicine.", 3, 1575, 0, 0, 0, 0.04, weight = 0.1 }, --132
	[133] = { "Driver's License - Automotive", "A Los Santos driving license.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[134] = { "Para", "Para birimi.", 10, 1212, 0, 0, 0, 0.04, weight = 0.3 }, -- 134
	[135] = { "Blue Bandana", "A blue rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 135
	[136] = { "Brown Bandana", "A brown rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 136
	[137] = { "Snake Cam", "A snake cam, used in SWAT operations.", 7, 330, 90, 90, 0, -0.05, weight = 0.3 }, -- 137
	[138] = { "Bait Vehicle System", "A device used in Police operations.", 4, 1271, 0, 0, 0, 0.285, weight = 0.5 }, -- 138
	[139] = { "Vehicle Tracker", "A device used to track the vehicles position", 7, 1271, 0, 0, 0, 0.285, weight = 0.2 }, --139
	[140] = { "Orange Light Strobes", "An Orange Light Strobe which you can put on you car.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 }, --140
	[141] = { "Megaphone", "A cone-shaped device used to intensify or direct your voice.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 }, --141
	[142] = { "Los Santos Cab & Bus ID", "A Los Santos Cab & Bus Identification Card.", 10, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 142
	[143] = { "Mobile Data Terminal", "A Mobile Data Terminal.", 7, 2886, 0, 0, 180, 0.1, weight = 0.1 }, -- 143
	[144] = { "Yellow Strobe", "A yellow strobe to put on your car.", 7, 2886, 270, 0, 0, 0.1, weight = 0.1 }, -- 144
	[145] = { "Flashlight", "Lights up the environment.", 7, 1210, 0, 0, 0, 0, weight = 1 }, --145
	[146] = { "Los Santos District Court Identification Card", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[147] = { "Duvar Kağıdı", "Duvara yapıştırmalık kağıt.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, --147
	[148] = { "Open Carry Weapon License", "A firearm permit which allows a person to openly carry a firearm.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[149] = { "Concealed Carry Weapon License", "A firearm permit which allows the concealment of a firearm.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[150] = { "ATM Card", "A plastic card used to make transactions with a very limited amount per day from an automatic teller machine (ATM).", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[151] = { "Lift Remote", "A remote device for a vehicle lift.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[152] = { "Kimlik", "Kişisel bilgilerinizin yer aldığı kimlik kartı.", 10, 1581, 270, 270, 0, 0, weight = 0.1 }, -- PEDROLANGES
	[153] = { "Driver's License - Motorbike", "A Los Santos driving license.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[154] = { "Fishing Permit", "A Los Santos fishing permit", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[155] = { "Driver's License - Boat", "A Los Santos driving license.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[156] = { "Superior Court of San Andreas ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[157] = { "Toolbox", "A metallic red toolbox containing various tools.", 4, 1271, 0, 0, 0, 0, weight = 0.5 },
	[158] = { "Green Bandana", "A green rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 158
	[159] = { "Cargo Group ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- 159 | anumaz Cargo Group ID card
	[160] = { "El Çantası", "Bir el Çantası.", 6, 1210, 90, 0, 0, 0.1, weight = 0.4}, -- Exciter
	[161] = { "Fleming Architecture and Construction ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- 161 | anumaz Fleming Architecture and Construction ID
	[162] = { "Body Armour", "Bulletproof vest.", 6, 3916, 90, 0, 0, 0.1, weight = 4}, -- Exciter
	[163] = { "Spor Çantası", "Spor yaparken kullanılan bir çantadır.", 6, 3915, 90, 0, 0, 0.2, weight = 0.4}, -- Exciter
	[164] = { "Medical Bag", "Bag with advanced medical equipment.", 6, 3915, 0, 0, 0, 0.2, weight = 1, texture = {{":artifacts/textures/medicbag.png", "hoodyabase5"}} }, -- Exciter
	[165] = { "DVD", "A video disc.", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, -- Exciter
	[166] = { "ClubTec VS1000", "Video System.", 4, 3388, 0, 0, 90, -0.01, weight = 5, scale = 0.6, preventSpawn = true, newPickupMethod = true }, -- Exciter
	[167] = { "Framed Picture (Golden Frame)", "Put your picture in and hang it on your wall.", 4, 2287, 0, 0, 0, 0, weight = 1, doubleSided = true, newPickupMethod = true }, -- Exciter
	[168] = { "Orange Bandana", "A orange rag.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 },
	[169] = { "Keyless Digital Door Lock", "This high-ended security system is much more secure than a traditional keyed lock because they can't be picked or bumped.", 6, 2922, 0, 0, 180, 0.2, weight = 0.5 }, --Farid
	[170] = { "Keycard", "A swipe card for #v", 2, 1581, 270, 270, 0, 0, weight = 0.1 }, -- Exciter
	[171] = { "Bisiklet Kaskı", "İdeal Bisiklet sürüş kaskı.", 6, 3911, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true },
	[172] = { "Tam Yüz Kaskı", "İdeal Motor sürüş kaskı.", 6, 3917, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true },
	[173] = { "DMV Vehicle Ownership Transfer", "Document needed to sell a vehicle to someone else.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, -- Anumaz
	[174] = { "FAA Electronical Map Book", "Electronic device displaying information and maps around all San Andreas.", 4, 1271, 0, 0, 0, -0.01, weight = 0.01 }, -- Anumaz
	[175] = { "Poster", "Reklam Posterleri.", 4, 2717, 0, 0, 0, 0.7, weight = 0.01, hideItemValue = true }, -- Exciter
	[176] = { "Speaker", "Big black speaker that kicks out huge, gives you sound big enough to fill any space, clear sound at any volume.", 7, 2232, 0, 0, 0, 0.6, weight = 3 }, -- anumaz
	[177] = { "Remote Dispatch Device", "A remote dispatch device connected to Dispatch Center, powered by Tree Technology.", 7, 1581, 0, 0, 0, 0.6, weight = 0.01 }, -- anumaz
    [178] = { "Book", "#v", 5, 2824, 0, 0, 0, -0.1, weight = 0.1}, -- Chaos
    [179] = { "Car Motive", "A motive to decorate your car with.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, -- Exciter
    [180] = { "SAPT ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- Exciter
    [181] = { "Sarma Paketi", "Sarma paketi içerisinde #v sarma boş sigara bulunuyor.", 4, 3044 , 270, 0, 0, 0.1, weight = function(v) return 0.1 + v*0.03 end },
    [182] = { "Sarma Sigara", "İçi #v dolu Sarma Sigara.", 4, 1485, 270, 0, 0, 0.1, weight = 0.03 },
    [183] = { "Viozy Membership Card", "Viozy Businesses Exclusive Membership", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --  Chase
    [184] = { "HP Charcoal Window Film", "Viozy HP Charcoal Window Film ((50 /chance))", 4, 1271, 0, 0, 0, 0, weight = 0.6 }, -- Chase
    [185] = { "CXP70 Window Film", "Viozy CXP70 Window Film ((95 /chance))", 4, 1271, 0, 0, 0, 0, weight = 0.3 }, -- Chase
    [186] = { "Viozy Border Edge Cutter (Red Anodized)", "Border Edge Cutter for Tinting", 4, 1271, 0, 0, 0, 0, weight = 0.05 }, -- Chase
    [187] = { "Viozy Solar Spectrum Tranmission Meter", "Spectrum Meter for testing film before use", 7, 1271, 0, 0, 0, 0, weight = 2 }, -- Chase
    [188] = { "Viozy Tint Chek 2800", "Measures the Visible Light Transmission on any film/glass", 7, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [189] = { "Viozy Equalizer Heatwave Heat Gun", "Easy to use heat gun perfect for shrinking back windows", 7, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [190] = { "Viozy 36 Multi-Purpose Cutter Bucket", "Ideal for light cutting jobs while applying tint", 4, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    [191] = { "Viozy Tint Demonstration Lamp", "Effectve presentation of tinted application", 7, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    [192] = { "Viozy Triumph Angled Scraper", "6-inch Angled Scraper for applying tint", 4, 1271, 0, 0, 0, 0, weight = 0.3 }, -- Chase
    [193] = { "Viozy Performax 48oz Hand Sprayer", "Performax Hand Sprayer for tint application", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [194] = { "Viozy Vehicle Ignition - 2010 ((20 /chance))", "Vehicle Ignition made by Viozy for 2010", 4, 1271, 0, 0, 0, 0, weight = 1.5 }, -- Chase
    [195] = { "Viozy Vehicle Ignition - 2011 ((30 /chance))", "Vehicle Ignition made by Viozy for 2011", 4, 1271, 0, 0, 0, 0, weight = 1.3 }, -- Chase
    [196] = { "Viozy Vehicle Ignition - 2012 ((40 /chance))", "Vehicle Ignition made by Viozy for 2012", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [197] = { "Viozy Vehicle Ignition - 2013 ((50 /chance))", "Vehicle Ignition made by Viozy for 2013", 4, 1271, 0, 0, 0, 0, weight = 0.8 }, -- Chase
    [198] = { "Viozy Vehicle Ignition - 2014 ((70 /chance))", "Vehicle Ignition made by Viozy for 2014", 4, 1271, 0, 0, 0, 0, weight = 0.6 }, -- Chase
    [199] = { "Viozy Vehicle Ignition - 2015 ((90 /chance))", "Vehicle Ignition made by Viozy for 2015", 4, 1271, 0, 0, 0, 0, weight = 0.4 }, -- Chase
    [200] = { "Viozy Vehicle Ignition - 2016", "Vehicle Ignition not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    [201] = { "Viozy Vehicle Ignition - 2017", "Vehicle Ignition not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    [202] = { "Viozy Vehicle Ignition - 2018", "Vehicle Ignition not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    [203] = { "Viozy Hidden Vehicle Tracker 315 Pro ((Undetectable))", "GPS HVT 315 Pro, easy installation ((and undetectable)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 3 }, -- Chase
    [204] = { "Viozy Hidden Vehicle Tracker 272 Micro ((30 /chance))", "GPS HVT 272 Micro, easy installation ((30 /chance to be found)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    [205] = { "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))", "GPS HVT 358 Spark Nano 4.0 Portable ((50 /chance to be found)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 0.2 }, -- Chase
	[206] = { "Wheat Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	[207] = { "Barley Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	[208] = { "Oat Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	[209] = { "FLU Device", "An eletronical device by Firearms Licensing Unit", 7, 1271, 0, 0, 0, 0, weight = 0.1}, -- anumaz
	[210] = { "Coca-Cola Christmas", "A bottle of coke, christmas edition.", 1, 2880, 180, 0, 0, 0, weight = 0.2}, -- Exciter
	[211] = { "A Christmas Lottery Ticket", "From the Coca-Cola Santa.", 10, 1581, 270, 270, 0, 0, weight = 0.1}, -- Exciter
	[212] = { "Kar Lastikleri", "Karda aracınızdan daha iyi performans alın!", 4, 1098, 0, 0, 0, 0, weight = 1, preventSpawn = true}, -- Exciter
	[213] = { "Pinnekjott", "Exciter's christmas favourite.", 1, 2215, 205, 205, 0, 0.06, weight = 0.1, preventSpawn = true}, -- Exciter
	[214] = { "Generic Drug", "#v", 3, 1576, 0, 0, 0, 0.07, weight = 0.1}, -- Chaos
	[215] = { "LSMD Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[216] = { "FBI Rozeti", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[217] = { "Cift zar", "1,6 arası rastgele sayılar gelen iki zar.", 4, 1271, 0, 0, 0, 0.285, weight = 0.1 },
	[218] = { "Fakir Şapkası", "Aksesuar.", 6, 1905, 0, 0, 0, 0.285, weight = 1 },
	[219] = { "Noel Şapkası", "Aksesuar.", 6, 1906, 0, 0, 0, 0.285, weight = 1 },
	[220] = { "Domuz Maskesi", "Aksesuar.", 6, 2374, 0, 0, 0, 0.285, weight = 1 },
	[221] = { "Tamir Kit", "Aracınızı Onarmak İçin Kullanılır", 6, 2396, 0, 0, 0, 0.285, weight = 1 },
	[222] = { "Hokey Maskesi", "Aksesuar.", 6, 2397, 0, 0, 0, 0.285, weight = 1 },
	[223] = { "Maymun Maskesi", "Aksesuar.", 6, 2398, 0, 0, 0, 0.285, weight = 1 },
	[224] = { "Sigara İçen Maymun Maskesi", "Aksesuar.", 6, 2399, 0, 0, 0, 0.285, weight = 1 },
	[225] = { "Karnaval Maskesi", "Aksesuar.", 6, 2407, 0, 0, 0, 0.285, weight = 1 },
	[226] = { "Gitar", "Aksesuar.", 6, 1907, 0, 0, 0, 0.285, weight = 1 },
	[227] = { "Siyah Güneş Gözlüğü", "Aksesuar.", 6, 1908, 0, 0, 0, 0.285, weight = 1 },
	[228] = { "Mikrofon", "Aksesuar.", 6, 1909, 0, 0, 0, 0.285, weight = 1 },
	[229] = { "Nike Cap", "Aksesuar.", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[230] = { "Sigara", "Aksesuar.", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[231] = { "Bal Kabağı (Halloween)", "Aksesuar.", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[232] = { "Gunes Gozlugu (Siyah) 1", "Gunes Gozlugu #1", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[233] = { "Resim", "Fotoğraf makinesi ile çekilmiş bir resim.", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[234] = { "Korku Maskesi", "Mavi bir yuz maskesi", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[235] = { "Siyah Güneş Gözlüğü", "Güneş Gözlüğü", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[236] = { "Dag Alabaligi", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[237] = { "Deniz Alabaligi", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[238] = { "Dere Alabaligi", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[239] = { "Sudak Baligi", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[240] = { "Dron Kumandası", "Dronunuzu kontrol etmeye yarayan alet.", 6, 364, 0, 0, 0, 0.285, weight = 0.2, }, --preventSpawn = true },
	[241] = { "Telsiz", "((/telsiz komutuyla kullanabilirsiniz.))", 7, 330, 0, 0, 0, 0.285, weight = 0.2 },
	[242] = { "Beyaz Pitbul", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 310, 0, 0, 0, 0.285, weight = 1 },
	[243] = { "Siyah Pitbul", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 311, 0, 0, 0, 0.285, weight = 1 },
	[244] = { "Gri Pitbul", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 304, 0, 0, 0, 0.285, weight = 1 },
	[245] = { "Kahverengi Pitbul", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 298, 0, 0, 0, 0.285, weight = 1 },
	[246] = { "Alman Kurdu", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 301, 0, 0, 0, 0.285, weight = 1 },
	[247] = { "Rottweiler", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 302, 0, 0, 0, 0.285, weight = 1 },
	[248] = { "Kedi", "((Yanınıza çağırmak için tıklayın. Tekrar envantere alamazsınız.))", 4, 10, 0, 0, 0, 0.285, weight = 1 },
	[249] = { "Tasma", "Evcil hayvanınızı kontrol etmede kullanırsınız.", 4, 2386, 0, 0, 0, 0.285, weight = 0.3 },
	[250] = { "Kömür", "Odunlarınızı alevlendirmeye yarar.", 4, 2386, 0, 0, 0, 0.285, weight = 0.5 },
	[251] = { "Odun", "Ağaç parçaları.", 4, 2386, 0, 0, 0, 0.285, weight = 0.5 },
	[252] = { "Kamp Ateşi", "Odun ve Kömürlerden oluşan ateş.", 4, 2386, 0, 0, 0, 0.285, weight = 0.5, preventSpawn = true },
	[253] = { "Siyah Güneş Gözlüğü 1", "Güneş Gözlüğü.", 4, 2386, 0, 0, 0, 0.285, weight = 0.5 },
	[254] = { "Sosisli Tezgahı", "Satış yapabileceğiniz bir tezgah.", 4, 2386, 0, 0, 0, 0.285, weight = 2 },
	[255] = { "Çin Mutfağı Tezgahı", "Satış yapabileceğiniz bir tezgah.", 4, 2386, 0, 0, 0, 0.285, weight = 2 },
	[256] = { "Dondurma Tezgahı", "Satış yapabileceğiniz bir tezgah.", 4, 2386, 0, 0, 0, 0.285, weight = 2 },
	[257] = { "Snapper Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[258] = { "Çapak Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[259] = { "Butterfish", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[260] = { "Ton Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[261] = { "Qılınc Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[262] = { "Kalamar", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[263] = { "Köpek Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[264] = { "Ringa Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[265] = { "Barbunya Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[266] = { "Çipura", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[267] = { "Gökkuşağı Alabalığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[268] = { "Siyah Cod", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[269] = { "Beyaz Seabass", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[270] = { "Monk Balık", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[271] = { "Beyaz Bass", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[272] = { "Tatlısu Drum", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[273] = { "Balık", "#v", 4, 1271, 0, 0, 0, 0, weight = 1, preventSpawn = true },
	[274] = { "Ağızlı Bas", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[275] = { "Sarı Perch", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[276] = { "Northern Pike", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[277] = { "Kanal Yayın Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[278] = { "Flathead Catfish", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[279] = { "Sarı Bullhead", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[280] = { "Benekli Bass", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[281] = { "Siyah Crappie", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[282] = { "Göl Alabalığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[283] = { "Sazan Balığı", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[284] = { "Smallmouth Bass", "Denizde bulunan bir balik cesiti", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[285] = { "Pizza Kutusu", "#v Dilim Pizza .", 6, 3044 , 270, 0, 0, 0.1, weight = function(v) return 0.5 + v*0.5 end },
	[286] = { "Dilim Pizza", "Bir Pizza Dilimi", 6, 1271, 0, 0, 0, 0.285, weight = 0.4 },
	[287] = { "Mavi Beyaz Şemsiye", "Mavi ve Beyaz renkte bir Şemsiye", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[288] = { "Pembe Beyaz Şemsiye", "Pembe ve Beyaz renkte bir Şemsiye", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[289] = { "Yeşil Beyaz Şemsiye", "Yeşil ve Beyaz renkte bir Şemsiye", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[290] = { "Kırmızı Beyaz Şemsiye", "Kırmızı ve Beyaz renkte bir Şemsiye", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[291] = { "Kamp", "Kamp malzemeleri", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[292] = { "Buğday Tohumu", "#v Gram Tohum", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[293] = { "Buğday", "#v Gram Buğday", 6, 1271, 0, 0, 0, 0.285, weight = 1 },
	[294] = { "Balkabağı Kafası", "Halloween Malzemeleri", 6, 1913, 0, 0, 0, 0.285, weight = 0.5 },
	[295] = { "At Kafası", "Maskeler #1", 6, 1914, 0, 0, 0, 0.285, weight = 0.5 },
	[296] = { "Köpek Kafası", "Maskeler #2", 6, 1915, 0, 0, 0, 0.285, weight = 0.5 },
	[297] = { "Civciv Kafası", "Maskeler #3", 6, 1916, 0, 0, 0, 0.285, weight = 0.5 },
	[298] = { "Kurt Kafası", "Maskeler #4", 6, 1917, 0, 0, 0, 0.285, weight = 0.5 },
	[299] = { "Yılbaşı Şapkası", "Maskeler #5", 6, 1917, 0, 0, 0, 0.285, weight = 0.5 },
	[300] = { "Polis Şapkası", "Maskeler #6", 6, 1917, 0, 0, 0, 0.285, weight = 0.5 },
	[301] = { "Polis Cap [1]", "Maskeler #7", 6, 1917, 0, 0, 0, 0.285, weight = 0.5 },
	[302] = { "Gözlük [1]", "Gözlük #1", 6, 1917, 0, 0, 0, 0.285, weight = 0.2 },
	[303] = { "Gözlük [2]", "Gözlük #2", 6, 1917, 0, 0, 0, 0.285, weight = 0.2 },
	[304] = { "Mikrafon", "Elektronik Cihaz", 6, 1917, 0, 0, 0, 0.285, weight = 0.2 },
	[305] = { "Piyango Bileti", "Bilet", 6, 3026, 0, 0, 0, 0.285, weight = 0.2 },
	[306] = { "Yılbaşı Hediye Paketi", "Noel Paketi", 6, 1271, 0, 0, 0, 0.285, weight = 0.2, preventSpawn = true },
	[307] = { "Sandalye", "3 Adet sandalye", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[308] = { "Mangal Izgarası", "Demir bir Izgaralık", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[309] = { "Altın Madalya", "Altın bir Madalya", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[310] = { "Gümüş Madalya", "Gümüş bir Madalya", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[311] = { "Bronz Madalya", "Bronz bir Madalya", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[312] = { "Chicago Bulls Mask", "Chicago Mask", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[313] = { "Görüntülenebilir Resim", "Bir çerçeve içinde resim", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[314] = { "Hydrolic Air", "Araçlar için tuşlu Air-Ride Sistemi", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[315] = { "Nargile", "Bir tutam duman kafalar pırıl pırıl", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[316] = { "Sihirbaz Şapkası", "Özel Şapka 1", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[317] = { "Çeyrek Bilet", "#v", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
	[318] = { "Yarım Bilet", "#v", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
	[319] = { "Tam Bilet", "#v", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
	[320] = { "Lunapark Bileti", "(#v)", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
	[321] = { "Açık Mavi Kask", "Yeni moda motorcu Kaskı", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[322] = { "Baret Kask", "Korunmak önemli.", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[323] = { "Kışlık Şapka", "Beyaz bir bere", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[324] = { "Renkli Motorcu Kaskı [1]", "Sarı ve Turuncu renkler.", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[325] = { "Renkli Motorcu Kaskı [2]", "Mavi Redbull Motorcu Kaskı.", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[326] = { "Yuvarlak Mavi Cam Gözlük", "Yakışıklı olmayan takmasın.", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[327] = { "Yuvarlak Pembe Cam Gözlük", "Kezbanlar takmasın.", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[328] = { "Yuvarlak Siyah Cam Gözlük", "Bunu sadece ağır abiler takabilir.", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[329] = { "Yuvarlak Siyah Cam Gözlük", "Private Nichola Rackford", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[330] = { "Siyah Şapka", "Siyah yuvarlak şapka", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[331] = { "Jack Daniels Viski", "Amerikan Üretimi", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[332] = { "Şarap", "Hahn marka şarap", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[333] = { "Yunan Rakısı", "Ouzo Marka Rakı (Uzo)", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[334] = { "Brooklyn Bira", "Amerikan Birası", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[335] = { "Rus Vodkası", "Standart Rus İçkisi", 6, 1271, 0, 0, 0, 0.285, weight = 0 },
	[336] = { "Saksı", "Çiçek veya Bitki büyütmeye yarar.", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[337] = { "Tohum", "#v", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[338] = { "Araba Kornası", "#v", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[339] = { "Kedi Maması", "Kedilere özel mama.", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[340] = { "Köpek Maması", "Köpeklere özel mama.", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[341] = { "Su Kabı", "Hayvanlar için su kabı.", 6, 1271, 0, 0, 0, 0.285, weight = 0.5 },
	[342] = { "İstiridye", "", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
    [343] = { "Mavi İnci", "", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
    [344] = { "Kırmızı İnci", "", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
    [345] = { "Beyaz İnci", "", 6, 1271, 0, 0, 0, 0.285, weight = 0, preventSpawn = true },
	[346] = { "Kenevir", "Kenevir işlenmesi bekleniyor.", 4, 3044, 270, 0, 0, 0, weight = 0.01 },
	[347] = { "Rozet", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[348] = { "Can", "Canınızı 100% olarak ayarlar.", 3, 3044, 0, 0, 0, 0.04, weight = 0.1 },
	[349] = { "Zırh", "Zırhınızı 100% olarak ayarlar.", 3, 3044, 0, 0, 0, 0.04, weight = 0.1 },
	[350] = { "Yılbaşı Kutusu", "Boş - (500,000$ - 1,000,000$) - (3 - 7) günlük VIP 3 - (3 - 7) günlük VIP 4 - (5 TL - 10 TL) - (Tec-9, MP5, AK47, M4) Çıkabilir.", 4, 1271, 0, 0, 0, 0, weight = 0 },
	[351] = { "Bronz Şans Kutusu", "Boş - (50,000$ - 100,000$) - 3 günlük VIP 2 - 7 günlük VIP 2 Çıkabilir.", 4, 1271, 0, 0, 0, 0, weight = 0 },
	[352] = { "Gümüş Şans Kutusu", "Boş - (150,000$ - 250,000$) - 15 günlük VIP 2 - 3 günlük VIP 3 Çıkabilir.", 4, 1271, 0, 0, 0, 0, weight = 0 },
	[353] = { "Altın Şans Kutusu", "Boş - (300,000$ - 500,000$) - 7 günlük VIP 3 - 15 günlük VIP 3 Çıkabilir.", 4, 1271, 0, 0, 0, 0, weight = 0 },
	[354] = { "Elmas Şans Kutusu", "Boş - (550,000$ - 750,000$) - 3 günlük VIP 4 - 7 günlük VIP 4 Çıkabilir.", 4, 1271, 0, 0, 0, 0, weight = 0 },
	[355] = { "Mayın", "Patlayıcı tuzak kurmak için kullanılan bir mayın.", 4, 2886, 0, 0, 0, 0, 0, weight = 0.1 },
    [356] = { "Altın", "İşlenmiş Altın Madeni", 6, 602, 0, 0, 0, 0.285, weight = 0.5 },
    [357] = { "Demir", "İşlenmiş Demir Madeni", 6, 603, 0, 0, 0, 0.285, weight = 0.5 },
	[358] = { "Bakır", "İşlenmiş Bakır Madeni", 6, 604, 0, 0, 0, 0.285, weight = 0.5 },
	[359] = { "Kömür", "İşlenmiş Kömür Madeni", 6, 605, 0, 0, 0, 0.285, weight = 0.5 },
	[360] = { "Elmas", "İşlenmiş Elmas Madeni", 6, 606, 0, 0, 0, 0.285, weight = 0.5 },
    [361] = { "Kazma", "Kazı yaparken kullanabileceğiniz bir eşya.", 4, 2386, 0, 0, 0, 0.285, weight = 0.1 }, -- 
	[367] = { "İşlenmemiş kenevir", "Yeni topraktan çıkmış işlenmemiş kenevir.", 7, 330, 90, 90, 0, 0, weight = 0.3 },
    [368] = { "İşlenmiş", "Yeni işlenmiş kenevir.", 7, 330, 90, 90, 0, 0, weight = 0.3 },
    [369] = { "Kimyasal Eldiven", "Kenevir ve Meth toplarken işinize yaracak bir eldiven.", 7, 330, 90, 90, 0, 0, weight = 0.3 },
}

weaponmodels  =  {
	[1] = 331, [2] = 333, [3] = 326, [4] = 335, [5] = 336, [6] = 337, [7] = 338, [8] = 339, [9] = 341,
	[15] = 326, [22] = 346, [23] = 347, [24] = 348, [25] = 349, [26] = 350, [27] = 351, [28] = 352,
	[29] = 353, [32] = 372, [30] = 355, [31] = 356, [33] = 357, [34] = 358, [35] = 359, [36] = 360,
	[37] = 361, [38] = 362, [16] = 342, [17] = 343, [18] = 344, [39] = 363, [41] = 365, [42] = 366,
	[43] = 367, [10] = 321, [11] = 322, [12] = 323, [14] = 325, [44] = 368, [45] = 369, [46] = 371,
	[40] = 364, [100] = 373, [101] = 337
}

weaponweights = {
	[22] = 1.14, [23] = 1.24, [24] = 2, [25] = 3.1, [26] = 2.1, [27] = 4.2, [28] = 3.6, [29] = 2.640, [30] = 4.3, [31] = 2.68, [32] = 3.6, [33] = 4.0, [34] = 4.3
}

ammoweights = {
	[22] = 0.0224, [23] = 0.0224, [24] = 0.017, [25] = 0.037, [26] = 0.037, [27] = 0.037, [28] = 0.009, [29] = 0.012, [30] = 0.0165, [31] = 0.0112, [32] = 0.009, [33] = 0.0128, [34] = 0.027
}

vehicleupgrades = {
    "Pro Rüzgarlık", "Win Rüzgarlık", "Drag Rüzgarlık", "Alpha Rüzgarlık", "Champ Scoop Hood",
    "Fury Scoop Hood", "Üst Havalandırma Scoop", "Sağ Marşpiyel", "5x Nitro", "2x Nitro",
    "10x Nitro", "Race Scoop Hood", "Worx Scoop Hood", "Round Fog Lights", "Champ Rüzgarlık",
    "Race Rüzgarlık", "Worx Rüzgarlık", "Sol Marşpiyel", "Upswept Egzoz", "Twin Egzoz",
    "Büyük Boy Egzoz", "Orta Boy Egzoz", "Küçük Boy Egzoz", "Fury Rüzgarlık", "Square Fog Lights",
    "Offroad Jant & Lastik Takımı", "Sağ Alien Marşpiyel (Sultan)", "Sol Alien Marşpiyel (Sultan)",
    "Alien Egzoz (Sultan)", "X-Flow Egzoz (Sultan)", "Sol X-Flow Marşpiyel (Sultan)",
    "Sağ X-Flow Marşpiyel (Sultan)", "Alien Üst Havalandırma (Sultan)", "X-Flow Üst Havalandırma (Sultan)",
    "Alien Egzoz (Elegy)", "X-Flow Üst Havalandırma (Elegy)", "Sağ Alien Marşpiyel (Elegy)",
    "X-Flow Egzoz (Elegy)", "Alien Üst Havalandırma (Elegy)", "Sol X-Flow Marşpiyel (Elegy)",
    "Sol Alien Marşpiyel (Elegy)", "Sağ X-Flow Marşpiyel (Elegy)", "Sağ Chrome Marşpiyel (Broadway)",
    "Slamin Egzoz (Chrome)", "Chrome Egzoz (Broadway)", "X-Flow Egzoz (Flash)", "Alien Egzoz (Flash)",
    "Sağ Alien Marşpiyel (Flash)", "Sağ X-Flow Marşpiyel (Flash)", "Alien Rüzgarlık (Flash)",
    "X-Flow Rüzgarlık (Flash)", "Sol Alien Marşpiyel (Flash)", "Sol X-Flow Marşpiyel (Flash)",
    "X-Flow Üst Havalandırma (Flash)", "Alien Üst Havalandırma (Flash)", "Alien Üst Havalandırma (Stratum)", "Sağ Alien Marşpiyel (Stratum)",
    "Sağ X-Flow Marşpiyel (Stratum)", "Alien Rüzgarlık (Stratum)", "X-Flow Egzoz (Stratum)",
    "X-Flow Rüzgarlık (Stratum)", "X-Flow Üst Havalandırma (Stratum)", "Sol Alien Marşpiyel (Stratum)",
    "Sol X-Flow Marşpiyel (Stratum)", "Alien Egzoz (Stratum)", "Alien Egzoz (Jester)",
    "X-FLow Egzoz (Jester)", "Alien Üst Havalandırma (Jester)", "X-Flow Üst Havalandırma (Jester)", "Sağ Alien Marşpiyel (Jester)",
    "Sağ X-Flow Marşpiyel (Jester)", "Sol Alien Marşpiyel (Jester)", "Sol X-Flow Marşpiyel (Jester)",
    "Shadow Jant & Lastik Takımı", "Mega Jant & Lastik Takımı", "Rimshine Jant & Lastik Takımı", "Wires Jant & Lastik Takımı", "Classic Jant & Lastik Takımı", "Twist Jant & Lastik Takımı",
    "Cutter Jant & Lastik Takımı", "Switch Jant & Lastik Takımı", "Grove Jant & Lastik Takımı", "Import Jant & Lastik Takımı", "Dollar Jant & Lastik Takımı", "Trance Jant & Lastik Takımı",
    "Atomic Jant & Lastik Takımı", "Stereo System", "Hidrolik", "Alien Üst Havalandırma (Uranus)", "X-Flow Egzoz (Uranus)",
    "Sağ Alien Marşpiyel (Uranus)", "X-Flow Üst Havalandırma (Uranus)", "Alien Egzoz (Uranus)",
    "Sağ X-Flow Marşpiyel (Uranus)", "Sol Alien Marşpiyel (Uranus)", "Sol X-Flow Marşpiyel (Uranus)",
    "Ahab Jant & Lastik Takımı", "Virtual Jant & Lastik Takımı", "Access Jant & Lastik Takımı", "Sol Chrome Marşpiyel (Broadway)",
    "Chrome Grill (Remington)", "Sol 'Chrome Flames' Marşpiyel (Remington)",
    "Sol 'Chrome Strip' Marşpiyel (Savanna)", "Covertible (Blade)", "Chrome Egzoz (Blade)",
    "Slamin Egzoz (Blade)", "Sağ 'Chrome Arches' Marşpiyel (Remington)",
    "Sol 'Chrome Strip' Marşpiyel (Blade)", "Sağ 'Chrome Strip' Marşpiyel (Blade)",
    "Chrome Arka Tampon (Slamvan)", "Slamin Arka Tampon (Slamvan)", false, false, "Chrome Egzoz (Slamvan)",
    "Slamin Egzoz (Slamvan)", "Chrome Ön Tampon (Slamvan)", "Slamin Ön Tampon (Slamvan)",
    "Chrome Ön Tampon (Slamvan)", "Sağ 'Chrome Trim' Marşpiyel (Slamvan)",
    "Sağ 'Wheelcovers' Marşpiyel (Slamvan)", "Sol 'Chrome Trim' Marşpiyel (Slamvan)",
    "Sol 'Wheelcovers' Marşpiyel (Slamvan)", "Sağ 'Chrome Flames' Marşpiyel (Remington)",
    "Boğa Boynuzu Chrome Bars (Remington)", "Sol 'Chrome Arches' Marşpiyel (Remington)", "Boğa Boynuzu Chrome Lights (Remington)",
    "Chrome Egzoz (Remington)", "Slamin Egzoz (Remington)", "Vinyl Hardtop (Blade)", "Chrome Egzoz (Savanna)",
    "Hardtop (Savanna)", "Softtop (Savanna)", "Slamin Egzoz (Savanna)", "Sağ 'Chrome Strip' Marşpiyel (Savanna)",
    "Sağ 'Chrome Strip' Marşpiyel (Tornado)", "Slamin Egzoz (Tornado)", "Chrome Egzoz (Tornado)",
    "Sol 'Chrome Strip' Marşpiyel (Tornado)", "Alien Rüzgarlık (Sultan)", "X-Flow Rüzgarlık (Sultan)",
    "X-Flow Arka Tampon (Sultan)", "Alien Arka Tampon (Sultan)", "Sol Oval Havalandırma", "Sağ Oval Havalandırma",
    "Sol Square Vents", "Sağ Kare Havalandırma", "X-Flow Rüzgarlık (Elegy)", "Alien Rüzgarlık (Elegy)",
    "X-Flow Arka Tampon (Elegy)", "Alien Arka Tampon (Elegy)", "Alien Arka Tampon (Flash)",
    "X-Flow Arka Tampon (Flash)", "X-Flow Ön Tampon (Flash)", "Alien Ön Tampon (Flash)",
    "Alien Arka Tampon (Stratum)", "Alien Ön Tampon (Stratum)", "X-Flow Arka Tampon (Stratum)",
    "X-Flow Ön Tampon (Stratum)", "X-Flow Rüzgarlık (Jester)", "Alien Arka Tampon (Jester)",
    "Alien Ön Tampon (Jester)", "X-Flow Arka Tampon (Jester)", "Alien Rüzgarlık (Jester)",
    "X-Flow Rüzgarlık (Uranus)", "Alien Rüzgarlık (Uranus)", "X-Flow Ön Tampon (Uranus)",
    "Alien Ön Tampon (Uranus)", "X-Flow Arka Tampon (Uranus)", "Alien Arka Tampon (Uranus)",
    "Alien Ön Tampon (Sultan)", "X-Flow Ön Tampon (Sultan)", "Alien Ön Tampon (Elegy)",
    "X-Flow Ön Tampon (Elegy)", "X-Flow Ön Tampon (Jester)", "Chrome Ön Tampon (Broadway)",
    "Slamin Ön Tampon (Broadway)", "Chrome Arka Tampon (Broadway)", "Slamin Arka Tampon (Broadway)",
    "Slamin Arka Tampon (Remington)", "Chrome Ön Tampon (Remington)", "Chrome Arka Tampon (Remington)",
    "Slamin Ön Tampon (Blade)", "Chrome Ön Tampon (Blade)", "Slamin Arka Tampon (Blade)",
    "Chrome Arka Tampon (Blade)", "Slamin Ön Tampon (Remington)", "Slamin Arka Tampon (Savanna)",
    "Chrome Arka Tampon (Savanna)", "Slamin Ön Tampon (Savanna)", "Chrome Ön Tampon (Savanna)",
    "Slamin Ön Tampon (Tornado)", "Chrome Ön Tampon (Tornado)", "Chrome Arka Tampon (Tornado)",
    "Slamin Arka Tampon (Tornado)"
}

function getBadges()
    return {
        -- [itemID] = { elementData, name, factionIDs, color, iconID }
        [156] = { "Superior Court of San Andreas ID", "", { [50] = true }, { 0, 102, 255 }, 1 },
        [64] = { "İEM Rozeti", "", { [1] = true }, { 65, 65, 255, true }, 1 },
        [215] = { "LSMD Rozeti", "", { [2] = true }, { 255, 130, 130, true }, 1 },
        [87] = { "JGK Rozeti", "", { [3] = true }, { 0, 80, 0 }, 1 },
        [82] = { "Rapid Towing", "", { [4] = true }, { 0, 255, 0 }, 1 },
        [86] = { "LSN Rozeti", "", { [5] = true }, { 250, 125, 0 }, 1 },
        [65] = { "BARON Rozeti", "", { [7] = true }, { 175, 50, 50 }, 1 },
        [127] = { "TRT Rozeti", "", { [47] = true }, { 255, 140, 0 }, 1 },
        [159] = { "Cargo Group ID", "", { [56] = true }, { 255, 102, 0 }, 1 },
        [131] = { "LSCSD Rozeti", "", { [59] = true }, { 50, 107, 50 }, 1 },
        [180] = { "SAPT ID", "", { [64] = true }, { 73, 136, 245 }, 1 },
        [216] = { "FBI Rozeti", "", { [148] = true }, { 0, 168, 255, true }, 1 },
        [347] = { "Rozet", "", { [-1] = true }, { 255, 255, 255, true }, 1 },
        [112] = { "Sezon Rozeti", "", { [-1] = true }, { 255, 215, 0, true }, 1 },
		
        [122] = { "light blue bandana", "", { [-1] = true }, { 0, 185, 200 }, 122 },
        [123] = { "red bandana", "", { [-1] = true }, { 190, 0, 0 }, 123 },
        [124] = { "yellow bandana", "", { [-1] = true }, { 255, 250, 0 }, 124 },
        [125] = { "purple bandana", "", { [-1] = true }, { 220, 0, 255 }, 125 },
        [135] = { "blue bandana", "", { [-1] = true }, { 0, 100, 255 }, 135 },
        [136] = { "brown bandana", "", { [-1] = true }, { 125, 63, 50 }, 136 },
        [158] = { "green bandana", "", { [-1] = true }, { 50, 150, 50 }, 158 },
        [168] = { "orange bandana", "", { [-1] = true }, { 210, 105, 30 }, 168 },
    }
end

for k, v in pairs(getBadges()) do
	if not v[3][-1] and itemsPackages[k][3] ~= 10 then
		outputDebugString('Badge/ID' .. k .. ' is not in wallet.')
	end
end

function getMasks()
	return {
		[26]  = {"gasmask", "gaz maskesini yüzüne geçirir",	"gaz maskesini çıkartır", false},
		[56]  = {"mask", "maskeyi yüzüne geçirir", "yüzündeki maskeyi çıkartır", true},
		[90]  = {"helmet", "kaskı kafasına geçirir.", "kaskı kafasından çıkartır", false},
		[120] = {"scuba", "oksijen tüpünü aktif eder", "oksijen tüpünü kapatır", false},
		[171] = {"bikerhelmet", "bisiklet kaskını kafasına geçirir", "bisiklet kaskını çıkartır", false},
		[172] = {"fullfacehelmet", "tam yüz kaskını takar", "tam yüz kaskını çıkartır", false},
	}
end

restrictedWeapons = {}
for i = 0, 15 do
	restrictedWeapons[i] = true
end