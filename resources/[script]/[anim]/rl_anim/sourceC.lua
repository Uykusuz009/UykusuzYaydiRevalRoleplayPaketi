local screenX, screenY = guiGetScreenSize()

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end


function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local panelState = false

local titleHeight = respc(40)

local panelWidth = respc(400)
local panelHeight = respc(400) + titleHeight


local panelPosX = (screenX / 2) - (panelWidth / 2)
local panelPosY = (screenY / 2) - (panelHeight / 2)

local panelFont = false
local activeButton = false

local visibleItem = 0

local panelIsMoving = false
local moveDifferenceX = 0
local moveDifferenceY = 0

addCommandHandler("stopanim",
	function()
		triggerServerEvent("stopThePanelAnimation", localPlayer)
	end
)

bindKey("space", "down", "stopanim")

local availableAnimations = {
	-- név, anim block, anim name, kategória, loop, updatepos
	{"Konuşma 1", "GANGS", "prtial_gngtlkA", "Konuşma", true},
	{"Konuşma 2", "GANGS", "prtial_gngtlkB", "Konuşma", true},
	{"Konuşma 3", "GANGS", "prtial_gngtlkC", "Konuşma", true},
	{"Konuşma 4", "GANGS", "prtial_gngtlkD", "Konuşma", true},
	{"Konuşma 5", "GANGS", "prtial_gngtlkE", "Konuşma", true},
	{"Konuşma 6", "GANGS", "prtial_gngtlkF", "Konuşma", true},
	{"Konuşma 7", "GANGS", "prtial_gngtlkG", "Konuşma", true},
	{"Konuşma 8", "GANGS", "prtial_gngtlkH", "Konuşma", true},
	{"Sopa Saldırı", "BASEBALL", "Bat_IDLE", "Çatışma", true},
	{"Silah Saldırı", "SWORD", "sword_IDLE", "Çatışma", true},
	{"Hasar Almak 1", "BASEBALL", "Bat_Hit_1", "Çatışma", false},
	{"Hasar Almak 2", "BASEBALL", "Bat_Hit_2", "Çatışma", false},
	{"Hasar Almak 3", "BASEBALL", "Bat_Hit_3", "Çatışma", false},
	{"Hasar Almak 4", "ped", "handscower", "Çatışma", false},
	{"Rap Yapmak", "benchpress", "gym_bp_celebrate", "Yemek", true},
	{"Yumruk Sallamak", "GYMNASIUM", "GYMshadowbox", "Yemek", true},
	{"Popo Tokatlamak", "MISC", "bitchslap", "Yemek", true},
	{"Tekmelemek", "POLICE", "Door_Kick", "Yemek", false},
	{"Nişan Almak", "SHOP", "ROB_Loop", "Yemek", true},
	{"Nişan Almak", "SHOP", "SHP_Gun_Aim", "Yemek", true},
	{"Yaslanarak Sigara İçmek 1", "BD_FIRE", "M_smklean_loop", "Sigara", true},
	{"Yaslanarak Sigara İçmek 2", "LOWRIDER", "F_smklean_loop", "Sigara", true},
	{"Ayakta Sigara İçmek 1", "GANGS", "smkcig_prtl", "Sigara", true},
	{"Ayakta Sigara İçmek 2", "GANGS", "smkcig_prtl_F", "Sigara", true},
	{"Ayakta Sigara İçmek 3", "LOWRIDER", "M_smkstnd_loop", "Sigara", true},
	{"Ayakta Sigara İçmek 4", "SMOKING", "M_smk_drag", "Sigara", true},
	{"Sigara Yakmak", "SMOKING", "M_smk_in", "Sigara", true},
	{"Sigara İçmek", "SMOKING", "M_smk_out", "Sigara", true},
	{"Sigara Külü Dökmek", "SMOKING", "M_smk_tap", "Sigara", true},
	{"Kumar 1", "Casino", "cards_raise", "Kumar", false},
	{"Kumar 2", "Casino", "cards_loop", "Kumar", true},
	{"Kumar 3", "Casino", "cards_lose", "Kumar", false},
	{"Kumar 4", "Casino", "cards_win", "Kumar", false},
	{"Kumar 5", "Casino", "Roulette_in", "Kumar", false},
	{"Kumar 6", "Casino", "Roulette_loop", "Kumar", true},
	{"Kumar 7", "Casino", "Roulette_lose", "Kumar", false},
	{"Kumar 8", "Casino", "Roulette_win", "Kumar", false},
	{"Kıyafetini İncele 1", "CLOTHES", "CLO_Pose_Hat", "Görünüm", true},
	{"Kıyafetini İncele 2", "CLOTHES", "CLO_Pose_Legs", "Görünüm", true},
	{"Kıyafetini İncele 3", "CLOTHES", "CLO_Pose_Shoes", "Görünüm", true},
	{"Kıyafetini İncele 4", "CLOTHES", "CLO_Pose_Torso", "Görünüm", true},
	{"Kıyafetini İncele 5", "CLOTHES", "CLO_Pose_Watch", "Görünüm", true},
	{"Ölmek 1", "CRACK", "crckdeth1", "Hasar", false},
	{"Ölmek 2", "CRACK", "crckdeth2", "Hasar", false},
	{"Ölmek 3", "CRACK", "crckdeth3", "Hasar", false},
	{"Ölmek 4", "FOOD", "FF_Die_Fwd", "Hasar", false},
	{"Ölmek 5", "FOOD", "FF_Die_Right", "Hasar", false},
	{"Ölmek 6", "FOOD", "FF_Die_Left", "Hasar", false},
	{"Ölmek 7", "CRACK", "crckidle1", "Hasar", true},
	{"Ölmek 8", "CRACK", "crckidle3", "Hasar", true},
	{"Ölmek 9", "CRACK", "crckidle4", "Hasar", true},
	{"Dans 1", "DANCING", "dance_loop", "Dans", true},
	{"Dans 2", "DANCING", "DAN_Down_A", "Dans", true},
	{"Dans 3", "DANCING", "DAN_Left_A", "Dans", true},
	{"Dans 4", "DANCING", "DAN_Loop_A", "Dans", true},
	{"Dans 5", "DANCING", "DAN_Right_A", "Dans", true},
	{"Dans 6", "DANCING", "DAN_Up_A", "Dans", true},
	{"Dans 7", "DANCING", "dnce_M_a", "Dans", true},
	{"Dans 8", "DANCING", "dnce_M_b", "Dans", true},
	{"Dans 9", "DANCING", "dnce_M_c", "Dans", true},
	{"Dans 10", "DANCING", "dnce_M_d", "Dans", true},
	{"Dans 11", "DANCING", "dnce_M_e", "Dans", true},
	{"Dans 12", "Dbd_clap", "bd_clap", "Dans", true, false},
	{"Dans 13", "Dbd_clap1", "bd_clap1", "Dans", true, true},
	{"Dans 14", "Ddance_loop", "dance_loop", "Dans", true, true},
	{"Dans 15", "DDAN_Left_A", "DAN_Left_A", "Dans", true, true},
	{"Dans 16", "DDAN_Loop_A", "DAN_Loop_A", "Dans", true, true},
	{"Dans 17", "DDAN_Right_A", "DAN_Right_A", "Dans", true, true},
	{"Dans 18", "DDAN_Up_A", "DAN_Up_A", "Dans", true, true},
	{"Dans 19", "Ddnce_M_a", "dnce_M_a", "Dans", true, true},
	{"Dans 20", "Ddnce_M_b", "dnce_M_b", "Dans", true, true},
	{"Dans 21", "Ddnce_M_e", "dnce_M_e", "Dans", true, true},
	{"Çete 1", "GANGS", "hndshkaa", "Selamlama", true},
	{"Çete 2", "GANGS", "hndshkba", "Selamlama", true},
	{"Çete 3", "GANGS", "hndshkca", "Selamlama", true},
	{"Çete 4", "GANGS", "hndshkcb", "Selamlama", true},
	{"Çete 5", "GANGS", "hndshkda", "Selamlama", true},
	{"Çete 6", "GANGS", "hndshkea", "Selamlama", true},
	{"Çete 7", "GANGS", "hndshkfa", "Selamlama", true},
	{"El Sıkışmak", "GANGS", "prtial_hndshk_biz_01", "Selamlama", true},
	{"Selam Vermek", "GHANDS", "gsign5LH", "Selamlama", true},
	{"El Sallamak", "KISSING", "gfwave2", "Selamlama", true},
	{"Öpücük 1", "KISSING", "Playa_Kiss_01", "Öpücük", true},
	{"Öpücük 2", "KISSING", "Playa_Kiss_02", "Öpücük", true},
	{"Öpücük 3", "KISSING", "Playa_Kiss_03", "Öpücük", true},
	{"Kadın Öpücük 1", "KISSING", "Grlfrd_Kiss_01", "Öpücük", true},
	{"Kadın Öpücük 2", "KISSING", "Grlfrd_Kiss_02", "Öpücük", true},
	{"Kadın Öpücük 3", "KISSING", "Grlfrd_Kiss_03", "Öpücük", true},
	{"Rahat Oturma", "Attractors", "Stepsit_in", "Oturma", false},
	{"Oturduğun Yerden Kalkma", "Attractors", "Stepsit_out", "Oturma", false},
	{"Uzanma 1", "BEACH", "bather", "Oturma", true},
	{"Uzanma 2", "FP2Parksit_M_loop", "bather", "Oturma", true},
	{"Uzanma 3", "BEACH", "Lay_Bac_Loop", "Oturma", true},
	{"Uzanma 4", "BEACH", "SitnWait_loop_W", "Oturma", true},
	{"Uzanma 5", "BEACH", "ParkSit_M_loop", "Oturma", true},
	{"Uzanma 6", "BEACH", "ParkSit_W_loop", "Oturma", true},
	{"Rahat Oturma", "int_house", "lou_loop", "Oturma", true},
	{"Bilgisayarda Oturma", "int_office", "off_sit_bored_loop", "Oturma", true},
	{"Masada Oturma", "misc", "seat_lr", "Oturma", true},
	{"Masada Oturma ve Konuşma 1", "misc", "seat_talk_01", "Oturma", true},
	{"Masada Oturma ve Konuşma 2", "misc", "seat_talk_02", "Oturma", true},
	{"Yan Yatma", "fekves", "bather", "Oturma", true},
	{"Otururken Ayak Sallandırma", "Gun_stand_2", "Gun_stand", "Oturma", true},
	{"Bağdaş Kurmak 1", "Gun_stand_4", "Gun_stand", "Oturma", true},
	{"Bağdaş Kurmak 2", "Lay_Bac_Loop", "Lay_Bac_Loop", "Oturma", true},
	{"Yüz Üstü Yatmak", "noifekv", "bather", "Oturma", true},
	{"Yerde Oturmak 1", "ParkSit_M_loop", "ParkSit_M_loop", "Oturma", true},
	{"Yerde Oturmak 2", "ParkSit_W_loop", "ParkSit_W_loop", "Oturma", true},
	{"Bomba Kurmak", "BOMBER", "BOM_Plant_Loop", "Genel", true},
	{"Eşya Kaldırmak", "CARRY", "liftup", "Genel", false},
	{"Eşya Bırakmak", "CARRY", "putdwn", "Genel", false},
	{"Çağırma Hareketi", "CAMERA", "camstnd_cmon", "Genel", true},
	{"Eğilerek Çağırma", "CAMERA", "camcrch_cmon", "Genel", true},
	{"Çömelmek", "CAMERA", "camcrch_idleloop", "Genel", false},
	{"Sevinmek", "Kumar", "manwind", "Genel", true},
	{"Saate Bakmak", "COP_AMBIENT", "Coplook_watch", "Genel", false},
	{"Düşünmek", "COP_AMBIENT", "Coplook_think", "Genel", true},
	{"Bakınmak", "COP_AMBIENT", "Coplook_shake", "Genel", true},
	{"Para Vermek", "DEALER", "shop_pay", "Genel", false},
	{"Hamburger Yemek", "FOOD", "EAT_Burger", "Genel", true},
	{"Ekmek Yemek", "FOOD", "EAT_Chicken", "Genel", true},
	{"Pizza Yenek", "FOOD", "EAT_Pizza", "Genel", true},
	{"Duruş 1", "DEALER", "DEALER_IDLE", "Genel", true},
	{"Duruş 2", "GANGS", "leanIDLE", "Genel", true},
	{"Kadın Mahçup", "leanIDLE", "leanIDLE", "Genel", true},
	{"Onaylamak", "GRAFFITI", "graffiti_Chkout", "Genel", false},
	{"Korkmak", "ped", "cower", "Genel", true},
	{"Teslim Olmak 1", "ped", "handsup", "Genel", false},
	{"Teslim Olmak 2", "SHOP", "SHP_Rob_React", "Genel", false},
	{"Teslim Olmak 3", "Rhandsup", "handsup", "Genel", false},
	{"Teslim Olmak 4", "Rtarkonhandsup_cower", "cower", "Genel", false},
	{"Kalp Masajı", "MEDIC", "CPR", "Genel", false},
	{"Rahatlamak", "CRACK", "Bbalbat_Idle_02", "Genel", true},
	{"İçecek İçmek", "gangs", "drnkbr_prtl", "Genel", true},
	{"Telefonla Konuşmak", "ped", "phone_talk", "Genel", true},
	{"Alkış 1", "clap1_tran_gtup", "tran_gtup", "Genel", true},
	{"Alkış 2", "clap2_tran_hng", "tran_hng", "Genel", true},
	{"Kol Yaslamak 1", "FP2bather", "bather", "Genel", true},
	{"Kol Yaslamak 2", "FP3bather", "bather", "Genel", true},
	{"Oturmak", "FP4bather", "bather", "Genel", true},	
	{"Ayak Yaslamak", "FP5bather", "bather", "Genel", true},	
	{"Kadın Poz", "FPbather", "SitnWait_loop_W", "Genel", true},	
	{"Çömelmek", "Lcamcrch_cmon", "camcrch_cmon", "Genel", true},	
	{"Selam Vermek", "Rtisztelges_gsign5LH", "gsign5LH", "Genel", true},	
	{"Mekik 1", "SSitnWait_loop_W", "SitnWait_loop_W", "Spor", true},
	{"Mekik 2", "FPbather", "ParkSit_W_Loop", "Spor", true},
	{"Spor 1", "S2SitnWait_loop_W", "SitnWait_loop_W", "Spor", true},
	{"Spor 2", "S3SitnWait_loop_W", "SitnWait_loop_W", "Spor", true},
	{"Şınav", "Scrckdeth2", "crckdeth2", "Spor", true},
	{"Ters Takla 1", "tricking", "bf360", "Parkur", false, true},
	{"Ters Takla 2", "tricking", "bf", "Parkur", false, true},
}

local availableCategories = {}
local expandedCategories = {}

local favoriteAnimations = {}
local favoritesList = {}

local clickTick = 0
local favoritesNum = 0
local segmentNum = 0

function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys+1] = k
	end

	if order then
		table.sort(keys,
			function (a, b)
				return order(t, a, b)
			end
		)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function processCategories()
	local initializedCategories = {}
	local categoryCount = 2
	local favoritesCount = 3

	availableCategories = {}
	favoritesList = {}

	--availableCategories[1] = {"Animáció leállítása", "stopanim"}
	availableCategories[2] = {"Favoriler", false}
	--availableCategories[2] = {"Animáció leállítása", "stopanim"}

	local function sortFunction(t, a, b)
		return a < b
	end

	for k, v in spairs(favoriteAnimations, sortFunction) do
		if expandedCategories["Favoriler"] then
			availableCategories[favoritesCount] = availableAnimations[k]
			availableCategories[favoritesCount][7] = k
			availableCategories[favoritesCount][8] = true

			favoritesCount = favoritesCount + 1
			categoryCount = categoryCount + 1
		end

		table.insert(favoritesList, availableAnimations[k])
	end

	favoritesNum = #favoritesList
	segmentNum = math.pi * 2 / favoritesNum

	if #favoritesList == 0 then
		if expandedCategories["Favoriler"] then
			availableCategories[3] = {"Favori bir animasyonun yok!", "custom_text"}
			categoryCount = 3
		end
	end

	for i = 1, #availableAnimations do
		if not favoriteAnimations[i] then
			local categoryName = availableAnimations[i][4]

			if not initializedCategories[categoryName] then
				initializedCategories[categoryName] = true

				categoryCount = categoryCount + 1

				availableCategories[categoryCount] = {categoryName, false}
			end

			if expandedCategories[categoryName] then
				categoryCount = categoryCount + 1

				availableCategories[categoryCount] = availableAnimations[i]
				availableCategories[categoryCount][7] = i
				availableCategories[categoryCount][8] = false
			end
		end
	end

	if #availableCategories > 15 then
		if visibleItem > #availableCategories - 15 then
			visibleItem = #availableCategories - 15
		end
	else
		visibleItem = 0
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if fileExists("favorites.json") then
			local jsonFile = fileOpen("favorites.json")

			if jsonFile then
				local fileContent = fileRead(jsonFile, fileGetSize(jsonFile))
				local jsonData = fromJSON(fileContent)

				fileClose(jsonFile)

				if jsonData then
					favoriteAnimations = {}

					for k, v in pairs(jsonData) do
						favoriteAnimations[tonumber(k)] = true
					end
				end
			end
		end

		processCategories()
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if fileExists("favorites.json") then
			fileDelete("favorites.json")
		end

		local jsonFile = fileCreate("favorites.json")

		if jsonFile then
			fileWrite(jsonFile, toJSON(favoriteAnimations, true))
			fileFlush(jsonFile)
			fileClose(jsonFile)
		end
	end
)

addCommandHandler("anim",
	function ()
		panelState = not panelState

		if panelState then
			showCursor ( true )
			panelFont = dxCreateFont("files/Rubik.ttf", respc(18), false, "proof")

			addEventHandler("onClientRender", getRootElement(), renderThePanel)
			addEventHandler("onClientClick", getRootElement(), clickOnPanel)
			addEventHandler("onClientKey", getRootElement(), scrollInPanel)

		else
			showCursor ( false )
			removeEventHandler("onClientRender", getRootElement(), renderThePanel)
			removeEventHandler("onClientClick", getRootElement(), clickOnPanel)
			removeEventHandler("onClientKey", getRootElement(), scrollInPanel)

			if isElement(panelFont) then
				destroyElement(panelFont)
			end

			panelFont = nil

		end
	end
)

function scrollInPanel(key, press)
	local relX, relY = getCursorPosition()

	if tonumber(relX) and tonumber(relY) then
		if key == "mouse_wheel_up" then
			if visibleItem > 0 then
				visibleItem = visibleItem - 1
			end
		elseif key == "mouse_wheel_down" then
			if visibleItem < #availableCategories - 14 then
				visibleItem = visibleItem + 1
			end
		end
	end
end

function clickOnPanel(button, state, absX, absY)
	if button == "left" then
		if state == "down" then
			if absX >= panelPosX and absX <= panelPosX + panelWidth - respc(28) - respc(5) and absY >= panelPosY and absY <= panelPosY + titleHeight then
				panelIsMoving = true
				moveDifferenceX = absX - panelPosX
				moveDifferenceY = absY - panelPosY
			else
				if renderDataDraw.activeButton then
					if renderDataDraw.activeButton == "stopAnimation" then
						if getTickCount() - clickTick >= 1000 then
							triggerServerEvent("stopThePanelAnimation", localPlayer)

							clickTick = getTickCount()

							playSound("files/select.mp3", false)
						end
					end
				end

				if activeButton then
					if activeButton == "exit" then
						panelState = false
						showCursor ( false )
						removeEventHandler("onClientRender", getRootElement(), renderThePanel)
						removeEventHandler("onClientClick", getRootElement(), clickOnPanel)
						removeEventHandler("onClientKey", getRootElement(), scrollInPanel)

						if isElement(panelFont) then
							destroyElement(panelFont)
						end

						panelFont = nil

						return
					elseif activeButton == "stopAnimation" then --wardis
						if getTickCount() - clickTick >= 1000 then
							triggerServerEvent("stopThePanelAnimation", localPlayer)

							clickTick = getTickCount()

							playSound("files/select.mp3", false)
						end
					else
						local selected = split(activeButton, "_")

						if selected[1] == "collapseCategory" then
							local categoryName = selected[2]

							if categoryName then
								expandedCategories[categoryName] = not expandedCategories[categoryName]

								processCategories()

								playSound("files/category.mp3", false)
							end
						elseif selected[1] == "addToFavorites" then
							local animationId = tonumber(selected[2])

							if animationId then
								favoriteAnimations[animationId] = true

								processCategories()

								playSound("files/select.mp3", false)
							end
						elseif selected[1] == "removeFromFavorites" then
							local animationId = tonumber(selected[2])

							if animationId then
								favoriteAnimations[animationId] = nil

								processCategories()

								playSound("files/select.mp3", false)
							end
						elseif selected[1] == "playAnimation" then
							local animationId = tonumber(selected[2])

							if animationId then
								if getTickCount() - clickTick >= 1000 then
									triggerServerEvent("setPedAnimationPanel", localPlayer, availableAnimations[animationId][2], availableAnimations[animationId][3], availableAnimations[animationId][5], availableAnimations[animationId][6])

									clickTick = getTickCount()

									playSound("files/select.mp3", false)
								end
							end
						end
					end
				end
			end
		else
			if state == "up" then
				panelIsMoving = false
				moveDifferenceX = 0
				moveDifferenceY = 0
			end
		end
	end
end

function renderThePanel()

	renderDataDraw.buttons = {}

	dxDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight - 3 + respc(50), tocolor(25, 25, 25, 255	))

	--dxDrawRectangle(panelPosX + 4, panelPosY + panelHeight + respc(50) - 3 - respc(50) + 4, panelWidth - 8, respc(50) - 8, tocolor(255, 25, 25))

	drawButton("stopAnimation", "Animasyonu Durdur",panelPosX + 4, panelPosY + panelHeight + respc(50) - 3 - respc(50) + 4, panelWidth - 8, respc(50) - 8, {215, 89, 89})

	dxDrawRectangle(panelPosX + 3, panelPosY + 3, panelWidth - 6, titleHeight - 6, tocolor(0, 0, 0, 255))
	dxDrawText("Animasyon Panel", panelPosX + respc(7), panelPosY, panelPosX + panelWidth, panelPosY + titleHeight, tocolor(200, 200, 200, 255), 0.8, panelFont, "left", "center", false, false, false, true)

	-- ** Content
	local buttons = {}

	buttons.exit = {panelPosX + panelWidth - respc(28) - respc(5), panelPosY + titleHeight / 2 - respc(14), respc(28), respc(28)}

	if activeButton == "exit" then
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(219, 125, 125))
	else
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(255, 255, 255))
	end

	local oneButtonHeight = (panelHeight - titleHeight) / 13

	for i = 2, 14 do
		local v = availableCategories[i + visibleItem]
		local y = panelPosY + titleHeight + oneButtonHeight * (i - 1) - oneButtonHeight

		if i % 2 ~= visibleItem % 2 then
			dxDrawRectangle(panelPosX + 4, y, panelWidth - 8, oneButtonHeight - 2, tocolor(25, 25, 25, 255))
		else
			dxDrawRectangle(panelPosX + 4, y, panelWidth - 8, oneButtonHeight - 2, tocolor(25, 25, 25, 255))
		end

		if v then
			if v[2] == "custom_text" then
				dxDrawText(v[1], panelPosX + respc(15), y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(215, 89, 89), 0.65, panelFont, "left", "center", true)
			elseif v[2] then
				if v[2] == "stopanim" then
					buttons.stopAnimation = {panelPosX, y, panelWidth, oneButtonHeight}

					if activeButton == "stopAnimation" then
						dxDrawRectangle(panelPosX, y, panelWidth, oneButtonHeight, tocolor(0, 0, 0, 00))
					end

					dxDrawText(v[1], panelPosX + respc(5), y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(215, 89, 89), 0.65, panelFont, "left", "center", true)
				else
					buttons["playAnimation_" .. v[7]] = {panelPosX, y, panelWidth - oneButtonHeight - respc(3), oneButtonHeight}

					if activeButton == "playAnimation_" .. v[7] then
						dxDrawRectangle(panelPosX, y, panelWidth, oneButtonHeight, tocolor(0, 0, 0, 00))
					end

					dxDrawText(v[1], panelPosX + respc(15), y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(200, 200, 200, 200), 0.65, panelFont, "left", "center", true)
					if v[8] then
						local buttonName = "removeFromFavorites_" .. v[7]
						local buttonColor = tocolor(108, 179, 201, 200)

						buttons[buttonName] = {math.floor(panelPosX + panelWidth - oneButtonHeight + respc(2)), math.floor(y + respc(5)), oneButtonHeight - respc(10), oneButtonHeight - respc(10)}

						if activeButton == buttonName then
							buttonColor = tocolor(108, 179, 201, 150)
						end

						dxDrawImage(buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], "files/starfull.png", 0, 0, 0, buttonColor)
					else
						local buttonName = "addToFavorites_" .. v[7]
						local buttonColor = tocolor(255, 255, 255, 150)

						buttons[buttonName] = {math.floor(panelPosX + panelWidth - oneButtonHeight + respc(2)), math.floor(y + respc(5)), oneButtonHeight - respc(10), oneButtonHeight - respc(10)}

						if activeButton == buttonName then
							buttonColor = tocolor(108, 179, 201, 250)
						end

						dxDrawImage(buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], "files/star.png", 0, 0, 0, buttonColor)
					end
				end
			else
				buttons["collapseCategory_" .. v[1]] = {panelPosX, y, panelWidth, oneButtonHeight}

				if activeButton == "collapseCategory_" .. v[1] then
					dxDrawRectangle(panelPosX, y, panelWidth, oneButtonHeight, tocolor(0, 0, 0, 00))
				end

				if expandedCategories[v[1]] then
					dxDrawImage(panelPosX + respc(5), y + oneButtonHeight / 2 - oneButtonHeight / 4, oneButtonHeight / 2, oneButtonHeight / 2, "files/arrow.png", 90, 0, 0, tocolor(200, 200, 200, 255))
				else
					dxDrawImage(panelPosX + respc(5), y + oneButtonHeight / 2 - oneButtonHeight / 4, oneButtonHeight / 2, oneButtonHeight / 2, "files/arrow.png", 0, 0, 0, tocolor(200, 200, 200, 255))
				end

				dxDrawText(v[1], panelPosX + respc(7) + oneButtonHeight / 2, y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(200, 200, 200, 255), 0.65, panelFont, "left", "center", true)
			end
		end
	end

	if #availableCategories > 14 then
		local contentRatio = (oneButtonHeight * 13) / #availableCategories

		dxDrawRectangle(panelPosX + panelWidth - respc(3), panelPosY + titleHeight + visibleItem * contentRatio, respc(3), contentRatio * 14, tocolor(108, 179, 201, 150))
	end

	-- ** Button handler
	activeButton = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		if panelIsMoving then
			panelPosX = absX - moveDifferenceX
			panelPosY = absY - moveDifferenceY
		else
			for k, v in pairs(buttons) do
				if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
					activeButton = k
					break
				end
			end
		end
	end

	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		renderDataDraw.activeButton = false
		if not renderDataDraw.buttons then
			return
		end
		for k,v in pairs(renderDataDraw.buttons) do
			if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
				renderDataDraw.activeButton = k
				break
			end
		end
	else
		renderDataDraw.activeButton = false
	end
end

local circleSize = 100
local arrowSize = circleSize * 0.9
local circleDist = screenY / 2 * 0.5

local hoverFavAnim = 0
local circleRubik = false

function renderCircle()
	if favoritesNum > 0 then
		local blockName, animationName = getPedAnimation(localPlayer)
		local cursorX, cursorY = getCursorPosition()

		if cursorX and cursorY then
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY
		else
			cursorX = 0
			cursorY = 0
		end

		local theX = screenX / 2
		local theY = screenY / 2
		local lastHover = hoverFavAnim

		if getDistanceBetweenPoints2D(cursorX, cursorY, theX, theY) > circleSize / 2 then
			local angle = math.atan2(cursorY - theY, cursorX - theX) - math.pi / 2 + segmentNum / 2

			if angle > math.pi then
				angle = angle - 2 * math.pi
			elseif angle < -math.pi then
				angle = angle + 2 * math.pi
			end

			angle = angle + math.pi
			hoverFavAnim = math.floor(angle / segmentNum) + 1

			local rotation = math.deg(math.floor(angle / segmentNum) * segmentNum)
			local centerY = arrowSize / 2 + circleSize / 2

			dxDrawImage(theX - arrowSize / 4 / 2, theY - arrowSize - circleSize / 2, arrowSize / 4, arrowSize, "files/tri.png", rotation, 0, centerY, tocolor(50, 50, 50, 200))
			dxDrawImage(theX - circleSize * 0.75 / 2, theY - circleSize * 0.75 / 2, circleSize * 0.75, circleSize * 0.75, "files/circle.png", 0, 0, 0, tocolor(0,0,0, 200))
			dxDrawImage(theX - circleSize * 0.5 / 2, theY - circleSize * 0.5 / 2, circleSize * 0.5, circleSize * 0.5, "files/stop.png", 0, 0, 0, tocolor(200, 200, 200, 200))
		else
			hoverFavAnim = 0

			dxDrawImage(theX - circleSize / 2, theY - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(0,0,0, 200))
			dxDrawImage(theX - circleSize * 0.75 / 2, theY - circleSize * 0.75 / 2, circleSize * 0.75, circleSize * 0.75, "files/stop.png", 0, 0, 0, tocolor(215, 89, 89, 200))
		end

		for i = 1, favoritesNum do
			local v = favoritesList[i]
			local active = false

			if blockName and animationName and string.lower(blockName) == string.lower(v[2]) and string.lower(animationName) == string.lower(v[3]) then
				active = true
			end

			local angle = math.rad(-90) + segmentNum * (i - 1)
			local x = theX + math.cos(angle) * circleDist
			local y = theY + math.sin(angle) * circleDist

			if active then
				if hoverFavAnim == i then
					dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(108, 179, 201, 200))
				else
					dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(108, 179, 201, 100))
				end
			elseif hoverFavAnim == i then
				dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(0,0,0, 200))
			else
				dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(25,25,25, 200))
			end

			if active then
				dxDrawText(v[1], x - circleSize / 2 * 0.9, y - circleSize / 2 * 0.9, x + circleSize / 2 * 0.9, y + circleSize / 2 * 0.9, tocolor(200, 200, 200, 255), 0.8, circleRubik, "center", "center", false, true)
			else
				dxDrawText(v[1], x - circleSize / 2 * 0.9, y - circleSize / 2 * 0.9, x + circleSize / 2 * 0.9, y + circleSize / 2 * 0.9, tocolor(200, 200, 200, 255), 0.8, circleRubik, "center", "center", false, true)
			end
		end

		if lastHover ~= hoverFavAnim then
			playSound("files/hover.mp3")
		end
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if key == "mouse3" then
			if not isPedInVehicle(localPlayer) then
				if not getElementData(localPlayer, "editingInterior") then
					favoritesNum = #favoritesList
					segmentNum = math.pi * 2 / favoritesNum

					if favoritesNum == 0 then
						if press then
							outputChatBox("Önce favorilerinize animasyon ekleyin! (/animpanel)")
						end
					else
						if press then
							if getTickCount() - clickTick > 100 then
								local blockName, animationName = getPedAnimation(localPlayer)

								circleRubik = dxCreateFont("files/Rubik.ttf", 14, false, "proof")
								addEventHandler("onClientRender", getRootElement(), renderCircle)

								showCursor(true)
								setCursorPosition(screenX / 2, screenY / 2)

								for i = 1, favoritesNum do
									local v = favoritesList[i]

									if blockName and animationName and string.lower(blockName) == string.lower(v[2]) and string.lower(animationName) == string.lower(v[3]) then
										local angle = math.rad(-90) + segmentNum * (i - 1)

										local x = screenX / 2 + math.cos(angle) * circleDist
										local y = screenY / 2 + math.sin(angle) * circleDist

										setCursorPosition(x, y)

										break
									end
								end

								clickTick = getTickCount()
								hoverFavAnim = 0
							end
						else
							removeEventHandler("onClientRender", getRootElement(), renderCircle)
							showCursor(false)

							if isElement(circleRubik) then
								destroyElement(circleRubik)
							end

							circleRubik = nil

							if hoverFavAnim == 0 then
								triggerServerEvent("stopThePanelAnimation", localPlayer)
							else
								local blockName, animationName = getPedAnimation(localPlayer)
								local animation = favoritesList[hoverFavAnim]

								if not blockName or not animationName or string.lower(blockName) ~= string.lower(animation[2]) or string.lower(animationName) ~= string.lower(animation[3]) then
									triggerServerEvent("setPedAnimationPanel", localPlayer, animation[2], animation[3], animation[5], animation[6])
								end
							end
						end
					end

					cancelEvent()
				end
			end
		end
	end
)


renderDataDraw = {}
renderDataDraw.colorSwitches = {}
renderDataDraw.lastColorSwitches = {}
renderDataDraw.startColorSwitch = {}
renderDataDraw.lastColorConcat = {}

function processColorSwitchEffect(key, color, duration, type)
	if not renderDataDraw.colorSwitches[key] then
		if not color[4] then
			color[4] = 255
		end

		renderDataDraw.colorSwitches[key] = color
		renderDataDraw.lastColorSwitches[key] = color

		renderDataDraw.lastColorConcat[key] = table.concat(color)
	end

	duration = duration or 500
	type = type or "Linear"

	if renderDataDraw.lastColorConcat[key] ~= table.concat(color) then
		renderDataDraw.lastColorConcat[key] = table.concat(color)
		renderDataDraw.lastColorSwitches[key] = color
		renderDataDraw.startColorSwitch[key] = getTickCount()
	end

	if renderDataDraw.startColorSwitch[key] then
		local progress = (getTickCount() - renderDataDraw.startColorSwitch[key]) / duration

		local r, g, b = interpolateBetween(
				renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3],
				color[1], color[2], color[3],
				progress, type
		)

		local a = interpolateBetween(renderDataDraw.colorSwitches[key][4], 0, 0, color[4], 0, 0, progress, type)

		renderDataDraw.colorSwitches[key][1] = r
		renderDataDraw.colorSwitches[key][2] = g
		renderDataDraw.colorSwitches[key][3] = b
		renderDataDraw.colorSwitches[key][4] = a

		if progress >= 1 then
			renderDataDraw.startColorSwitch[key] = false
		end
	end

	return renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3], renderDataDraw.colorSwitches[key][4]
end

function drawButton(key, label, x, y, w, h, activeColor, postGui, theFont)
	local buttonColor
	if renderDataDraw.activeButton == key then
		buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 175})}
	else
		buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 125})}
	end

	local alphaDifference = 175 - buttonColor[4]

	dxDrawRectangle(x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 175 - alphaDifference), postGui)
	--dxDrawInnerBorder(2, x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 125 + alphaDifference), postGui)

	labelFont = theFont or panelFont
	postGui = postGui or false
	labelScale = 0.85
	
	dxDrawText(label, x, y, x + w, y + h, tocolor(200, 200, 200, 200), labelScale, labelFont, "center", "center", false, false, postGui, true)

	renderDataDraw.buttons[key] = {x, y, w, h}
end

function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
	thickness = thickness or 1
	dxDrawRectangle(x, y, w, thickness, color, postGUI)
	dxDrawRectangle(x, y + h - thickness, w, thickness, color, postGUI)
	dxDrawRectangle(x, y, thickness, h, color, postGUI)
	dxDrawRectangle(x + w - thickness, y, thickness, h, color, postGUI)
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        engineLoadIFP("files/custom/bather.ifp", "bather")
        engineLoadIFP("files/custom/clap1_tran_gtup.ifp", "clap1_tran_gtup")
        engineLoadIFP("files/custom/clap2_tran_hng.ifp", "clap2_tran_hng")
        engineLoadIFP("files/custom/cSitnWait_loop_W.ifp", "cSitnWait_loop_W")
        engineLoadIFP("files/custom/Dbd_clap.ifp", "Dbd_clap")
        engineLoadIFP("files/custom/Dbd_clap1.ifp", "Dbd_clap1")
        engineLoadIFP("files/custom/DDAN_Down_A.ifp", "DDAN_Down_A")
        engineLoadIFP("files/custom/DDAN_Left_A.ifp", "DDAN_Left_A")
        engineLoadIFP("files/custom/DDAN_Loop_A.ifp", "DDAN_Loop_A")
        engineLoadIFP("files/custom/DDAN_Right_A.ifp", "DDAN_Right_A")
        engineLoadIFP("files/custom/DDAN_Up_A.ifp", "DDAN_Up_A")
        engineLoadIFP("files/custom/Ddance_loop.ifp", "Ddance_loop")
        engineLoadIFP("files/custom/Ddnce_M_a.ifp", "Ddnce_M_a")
        engineLoadIFP("files/custom/Ddnce_M_b.ifp", "Ddnce_M_b")
        engineLoadIFP("files/custom/Ddnce_M_e.ifp", "Ddnce_M_e")
        engineLoadIFP("files/custom/FARM2BARman_idle.ifp", "FARM2BARman_idle")
        engineLoadIFP("files/custom/FARM2SitnWait_loop_W.ifp", "FARM2SitnWait_loop_W")
        engineLoadIFP("files/custom/FARMBARman_idle.ifp", "FARMBARman_idle")
        engineLoadIFP("files/custom/FARMSitnWait_loop_W.ifp", "FARMSitnWait_loop_W")
        engineLoadIFP("files/custom/fekves.ifp", "fekves")
        engineLoadIFP("files/custom/FP2bather.ifp", "FP2bather")
        engineLoadIFP("files/custom/FP2ParkSit_M_loop.ifp", "FP2ParkSit_M_loop")
        engineLoadIFP("files/custom/FP3bather.ifp", "FP3bather")
        engineLoadIFP("files/custom/FP4bather.ifp", "FP4bather")
        engineLoadIFP("files/custom/FP5bather.ifp", "FP5bather")
        engineLoadIFP("files/custom/FPbather.ifp", "FPbather")
        engineLoadIFP("files/custom/FPCoplook_in.ifp", "FPCoplook_in")
        engineLoadIFP("files/custom/FPCoplook_loop.ifp", "FPCoplook_loop")
        engineLoadIFP("files/custom/FPGun_stand.ifp", "FPGun_stand")
        engineLoadIFP("files/custom/FPParkSit_M_loop.ifp", "FPParkSit_M_loop")
        engineLoadIFP("files/custom/fSitnWait_loop_W.ifp", "fSitnWait_loop_W")
        engineLoadIFP("files/custom/gum_eat.ifp", "gum_eat")
        engineLoadIFP("files/custom/Gun_stand.ifp", "Gun_stand")
        engineLoadIFP("files/custom/Gun_stand_2.ifp", "Gun_stand_2")
        engineLoadIFP("files/custom/Gun_stand_3.ifp", "Gun_stand_3")
        engineLoadIFP("files/custom/Gun_stand_4.ifp", "Gun_stand_4")
        engineLoadIFP("files/custom/Hcrckidle4.ifp", "Hcrckidle4")
        engineLoadIFP("files/custom/HCS_Dead_Guy.ifp", "HCS_Dead_Guy")
        engineLoadIFP("files/custom/jobb_2.ifp", "jobb_2")
        engineLoadIFP("files/custom/jobb_3.ifp", "jobb_3")
        engineLoadIFP("files/custom/Lay_Bac_Loop.ifp", "Lay_Bac_Loop")
        engineLoadIFP("files/custom/Lcamcrch_cmon.ifp", "Lcamcrch_cmon")
        engineLoadIFP("files/custom/leanIDLE.ifp", "leanIDLE")
        engineLoadIFP("files/custom/LOU.ifp", "LOU")
        engineLoadIFP("files/custom/noifekv.ifp", "noifekv")
        engineLoadIFP("files/custom/ParkSit_M_loop.ifp", "ParkSit_M_loop")
        engineLoadIFP("files/custom/ParkSit_W_loop.ifp", "ParkSit_W_loop")
        engineLoadIFP("files/custom/Rcolt45_fire_2hands.ifp", "Rcolt45_fire_2hands")
        engineLoadIFP("files/custom/Rfallfront_csplay.ifp", "Rfallfront_csplay")
        engineLoadIFP("files/custom/Rfallfrontloop_cs9mm-1.ifp", "Rfallfrontloop_cs9mm-1")
        engineLoadIFP("files/custom/Rhandsup.ifp", "Rhandsup")
        engineLoadIFP("files/custom/rSitnWait_loop_W.ifp", "rSitnWait_loop_W")
        engineLoadIFP("files/custom/Rtarkonhandsup_cower.ifp", "Rtarkonhandsup_cower")
        engineLoadIFP("files/custom/Rtisztelges_gsign5LH.ifp", "Rtisztelges_gsign5LH")
        engineLoadIFP("files/custom/S2SitnWait_loop_W.ifp", "S2SitnWait_loop_W")
        engineLoadIFP("files/custom/S3SitnWait_loop_W.ifp", "S3SitnWait_loop_W")
        engineLoadIFP("files/custom/Scrckdeth2.ifp", "Scrckdeth2")
        engineLoadIFP("files/custom/SEcrckidle1.ifp", "SEcrckidle1")
        engineLoadIFP("files/custom/SEcrckidle2.ifp", "SEcrckidle2")
        engineLoadIFP("files/custom/SEcrckidle3.ifp", "SEcrckidle3")
        engineLoadIFP("files/custom/SEcrckidle4.ifp", "SEcrckidle4")
        engineLoadIFP("files/custom/SitnWait_loop_W.ifp", "SitnWait_loop_W")
        engineLoadIFP("files/custom/SSitnWait_loop_W.ifp", "SSitnWait_loop_W")
        engineLoadIFP("files/custom/tricking.ifp", "tricking")
        engineLoadIFP("files/custom/bal_elso_2.ifp", "bal_elso_2")
    end
)

addEvent("setPedAnimationPanel", true)
addEventHandler("setPedAnimationPanel", getRootElement(),
	function (block, anim, loop, updatePos)
		if isElement(source) then
			if loop then
				if updatePos then
					setPedAnimation(source, block, anim, -1, true, true, false)
				else
					setPedAnimation(source, block, anim, -1, true, false, false)
				end
			else
				if updatePos then
					setPedAnimation(source, block, anim, 0, false, true, false)
				else
					setPedAnimation(source, block, anim, 0, false, false, false)
				end
			end
		end
	end
)

addEvent("stopThePanelAnimation", true)
addEventHandler("stopThePanelAnimation", getRootElement(),
	function ()
		if isElement(source) then
			setPedAnimation(source, false)
		end
	end
)

-----------------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
-----------------------------------------------------------------