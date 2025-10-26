local screenX, screenY = (screenSize.x) / 2, (screenSize.y) / 2
local clickTick = 0

local dataMax = 15
local currentPages = 1
local latest = 1

local iconRotation = 0
local iconTickCount = getTickCount()

local find = {}

local balanceHistoryData = {}
local marketHistoryData = {}

addCommandHandler("market", function()
	if not isTimer(renderTimer) then
		starterPack = false
		selectedPage = 1
		selectedVehiclePage = 1
		restartMarket()
	    showCursor(true)
		showChat(false)
		setElementData(localPlayer, "hudkapa", true)

		theVehicle = createVehicle(PRIVATE_VEHICLES[selectedVehicle.selected][2], 0, 0, 0)
		setElementInterior(theVehicle, getElementInterior(localPlayer))
		setElementDimension(theVehicle, getElementDimension(localPlayer))
		vehiclePreview = exports["rl_object-preview"]:createObjectPreview(theVehicle, 0, 0, 150, screenX + 30, screenY - 200, 550, 550, false, true)
		exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)

		theWeapon = createObject(PRIVATE_WEAPONS[selectedWeapon.selected][2], 0, 0, 0)
		setElementInterior(theWeapon, getElementInterior(localPlayer))
		setElementDimension(theWeapon, getElementDimension(localPlayer))
		weaponPreview = exports["rl_object-preview"]:createObjectPreview(theWeapon, 0, 0, 180, screenX + 20, screenY - 285, 800, 800, false, true)
		exports["rl_object-preview"]:setAlpha(weaponPreview, 0)

		renderTimer = setTimer(function()
	        exports.kaisen_blur:bluredRectangle(0, 0, screenSize.x, screenSize.y)
			dxDrawRectangle(0, 0, screenSize.x, screenSize.y, exports.rl_ui:rgba(theme.GRAY[400], 0.3))
			dxDrawText("MARKET", screenX - 1240, screenY - 375, screenX, 0, tocolor(255, 255, 255, 225), 1, fonts.font1, "center")

			exports.rl_ui:drawRoundedRectangle({
				position = {
					x = screenX - 710,
					y = screenY - 420
				},

				size = {
					x = 41,
					y = 40
				},

				radius = 5,
				
				color = theme.LIGHT[900],
				
				alpha = 350
			})

			dxDrawText('ESC', screenX - 703, screenY - 409, nil, nil, tocolor(10, 10, 10, 255), 1, fonts.font5)
			dxDrawText('Marketi Kapat', screenX - 655, screenY - 409, nil, nil, exports.rl_ui:rgba(theme.LIGHT[900]), 1, fonts.font6)
			
			exports.rl_ui:drawRoundedRectangle({
				position = {
					x = screenX - 710,
					y = screenY - 300
				},

				size = {
					x = 150,
					y = 55
				},

				radius = 7,
				
				color = exports.rl_ui:RGBToHex(101, 92, 76, 255),

				alpha = 400
			})

			exports.rl_ui:drawRoundedRectangle({
				position = {
					x = screenX - 704,
					y = screenY - 293
				},

				size = {
					x = 41,
					y = 40
				},

				radius = 2,
				
				color = exports.rl_ui:RGBToHex(112, 98, 78, 255),
				
				alpha = 450
			})

			dxDrawText('', screenX - 696, screenY - 284, nil, nil, tocolor(211, 184, 125, 255), 1, fonts.font2)
			dxDrawText('DONATE', screenX - 655, screenY - 291, nil, nil, tocolor(225, 196, 133, 255), 1, fonts.font3)
			dxDrawText('MAĞAZA', screenX - 655, screenY - 274, nil, nil, tocolor(208, 182, 126, 255), 1, fonts.font4)

			posX = dxGetTextWidth(string.upper(localPlayer.name:gsub('_', ' ')), 1, fonts.font19)
			posBalance = string.len(exports.rl_global:formatMoney(localPlayer:getData('money'))) > 7 and (dxGetTextWidth(exports.rl_global:formatMoney(localPlayer:getData('money'))..' $', 1, fonts.font19) - 70) or 0

			exports.rl_ui:drawRoundedRectangle({
				position = {
					x = screenX + 500 - posX - posBalance,
					y = screenY - 370
				},

				size = {
					x = 40,
					y = 40
				},

				radius = 8,
				
				color = theme.GRAY[600],
				
				alpha = 300
			})

			
			dxDrawText('#FFFFFF'..exports.rl_global:formatMoney(localPlayer:getData('balance'))..' #0eb07bTL', screenX + 490 - posX - posBalance, screenY - 362, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font18, 'right', nil, false, false, false, true)
			dxDrawText('', screenX + 510 - posX - posBalance, screenY - 361, nil, nil, tocolor(14, 176, 123, 255), 1, fonts.font2)


			exports.rl_ui:drawRoundedRectangle({
				position = {
					x = screenX + 650 - posX,
					y = screenY - 370
				},

				size = {
					x = 40,
					y = 40
				},

				radius = 8,
				
				color = theme.GRAY[600],
				
				alpha = 300
			})

			dxDrawText('#FFFFFF'..exports.rl_global:formatMoney(localPlayer:getData('money'))..' #0eb07b$', screenX + 643 - posX, screenY - 362, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font18, 'right', nil, false, false, false, true)
			dxDrawText('', screenX + 660 - posX, screenY - 361, nil, nil, tocolor(14, 176, 123, 255), 1, fonts.font2)

			dxDrawText(string.upper(localPlayer.name:gsub('_', ' ')), screenX + 740, screenY - 368, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font19, 'right', nil, false, false, false, true)
			dxDrawText(localPlayer:getData('level')..' #0eb07blvl', screenX + 740, screenY - 340, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font19, 'right', nil, false, false, false, true)

			
			exports.rl_ui:drawRoundedRectangle({
				position = {
					x = screenX - 545,
					y = screenY - 300
				},

				size = {
					x = 1300,
					y = 55
				},

				radius = 7,
				
				color = theme.GRAY[600],

				alpha = 400
			})

			categoryX = 0
			for index, value in ipairs(CATEGORIES) do
				dxDrawText(value, screenX - 510 + categoryX, screenY - 284, nil, nil, index == selectedPage and tocolor(246, 213, 157, 255) or exports.rl_ui:inArea(screenX - 510 + categoryX, screenY - 300, dxGetTextWidth(value, 1, index > 8 and fonts.font2 or fonts.font7), 55) and tocolor(246, 213, 157, 255) or tocolor(255, 255, 255), 1, index > 8 and fonts.font2 or fonts.font7)
				
				if index < 8 then
 					dxDrawRectangle(screenX - 524 + categoryX, screenY - 250, dxGetTextWidth(value, 1, index > 8 and fonts.font2 or fonts.font7) + 30, 1, index == selectedPage and tocolor(246, 213, 157, 255) or exports.rl_ui:inArea(screenX - 510 + categoryX, screenY - 300, dxGetTextWidth(value, 1, index > 8 and fonts.font2 or fonts.font7), 55) and tocolor(246, 213, 157, 255) or tocolor(255, 255, 255))
				end

				if index == selectedPage then
					exports.rl_ui:dxDrawGradient(screenX - 524 + categoryX, screenY - 300, dxGetTextWidth(value, 1, index > 8 and fonts.font2 or fonts.font7) + 30, 25, 246, 213, 157, 50, true, true)
				end

				if (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 510 + categoryX, screenY - 300, dxGetTextWidth(value, 1, index > 8 and fonts.font2 or fonts.font7), 55) and getKeyState('mouse1') and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					selectedPage = index

					if selectedPage == 3 and selectedVehiclePage == 1 then
						currentPages = 1
						exports["rl_object-preview"]:setAlpha(weaponPreview, 0)
						exports["rl_object-preview"]:setAlpha(vehiclePreview, 255)
					elseif selectedPage == 4 then
						currentPages = 1
						exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)
						exports["rl_object-preview"]:setAlpha(weaponPreview, 255)
					elseif selectedPage == 7 then
						currentPages = 1
						exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)
						exports["rl_object-preview"]:setAlpha(weaponPreview, 0)
					elseif selectedPage == 8 then
						exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)
						exports["rl_object-preview"]:setAlpha(weaponPreview, 0)
					elseif selectedPage == 9 then
						exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)
						exports["rl_object-preview"]:setAlpha(weaponPreview, 0)
					else
						exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)
						exports["rl_object-preview"]:setAlpha(weaponPreview, 0)
					end
				end

				categoryX = categoryX + 112 + dxGetTextWidth(value, 1, index > 8 and fonts.font2 or fonts.font7)
			end

			if selectedPage == 1 then
				lineProduct = 0

				if starterPack then
					maxLineProduct = 4
				else
					maxLineProduct = 8
				end

				lineProductX = 0
				lineProductY = 0
				if starterPack then
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 20,
							y = screenY - 230
						},
		
						size = {
							x = 775,
							y = 50
						},
		
						radius = 7,
						
						color = theme.GRAY[500],
		
						alpha = 400
					})

					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 10,
							y = screenY - 225
						},
		
						size = {
							x = 40,
							y = 40
						},
		
						radius = 11,
						
						color = theme.GRAY[500],
		
						alpha = 350
					})

					dxDrawText('', screenX + 3, screenY - 217, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)

					dxDrawText('Kişisel Özellikler', screenX + 35, screenY - 220, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
					dxDrawText('Kişisel özelliklerinizi buradan satın alabilirsiniz', screenX + 35, screenY - 205, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)
					else
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 710,
								y = screenY - 230
							},
			
							size = {
								x = 1465,
								y = 50
							},
			
							radius = 7,
							
							color = theme.GRAY[500],
			
							alpha = 400
						})
	
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 700,
								y = screenY - 225
							},
			
							size = {
								x = 40,
								y = 40
							},
			
							radius = 11,
							
							color = theme.GRAY[500],
			
							alpha = 350
						})
	
						dxDrawText('', screenX - 687, screenY - 217, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)
	
						dxDrawText('Kişisel Özellikler', screenX - 650, screenY - 220, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
						dxDrawText('Kişisel özelliklerinizi buradan satın alabilirsiniz', screenX - 650, screenY - 205, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)
				end
				prizesY = 0
				for index, value in ipairs(PERSONAL_FEATURES) do
					if string.find(value[2], 'Başlangıç Paketi') then
						starterPack = true
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 710,
								y = screenY - 230
							},
							
							size = {
								x = 670,
								y = 550
							},

							radius = 10,

							color = theme.GRAY[500],

							alpha = 400
						})

						dxDrawImage(screenX - 590, screenY - 230, 550, 550, 'public/campaign-card.png')

						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 690,
								y = screenY - 200
							},
							
							size = {
								x = 400,
								y = 60	
							},

							radius = 10,

							color = theme.YELLOW[600],

							alpha = 450
						})

						dxDrawText(string.upper(((value[2]:gsub('ş', 's')):gsub('ç', 'c')):gsub('ı', 'i')), screenX - 670, screenY - 192, nil, nil, tocolor(246, 213, 157, 255), 1, fonts.font8)

						if value[3].discountPrice and tonumber(value[3].discountPrice) then
							discountPrice = value[3].discountPrice
						else
							discountPrice = false
						end
						

						if not tonumber(discountPrice) then
							exports.rl_ui:drawRoundedRectangle({
								position = {
									x = screenX - 165,
									y = screenY - 200
								},
							
								size = {
									x = 110,
									y = 60	
								},

								radius = 5,

								color = theme.GREEN[300],

								alpha = 450
							})

							dxDrawText(value[3].price..'₺', screenX - 148, screenY - 189, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font9)
						else
							exports.rl_ui:drawRoundedRectangle({
								position = {
									x = screenX - 165,
									y = screenY - 200
								},
							
								size = {
									x = 110,
									y = 60	
								},

								radius = 5,

								color = theme.RED[300],

								alpha = 450
							})

							dxDrawText(value[3].price..'₺', screenX - 148, screenY - 189, nil, nil, exports.rl_ui:rgba(theme.RED[200]), 1, fonts.font9)
							dxDrawRectangle(screenX - 155, screenY - 173, dxGetTextWidth(value[3].price..'₺', 1, fonts.font9) + 10, 1, exports.rl_ui:rgba(theme.RED[200]))
							
							exports.rl_ui:drawRoundedRectangle({
								position = {
									x = screenX - 165,
									y = screenY - 135
								},
							
								size = {
									x = 110,
									y = 60	
								},

								radius = 5,

								color = theme.GREEN[300],

								alpha = 450
							})

							dxDrawText(discountPrice..'₺', screenX - 148, screenY - 124, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font9)
						end
						for _, pv in ipairs(starterPackPrizes) do
							dxDrawRectangle(screenX - 680, screenY - 110 + prizesY, 15, 15, tocolor(47, 93, 109, 255))

							if string.find(pv[1], 'Para') then
								prizeText = ''..exports.rl_global:formatMoney(tonumber(pv[2]))..' Para'
							elseif string.find(pv[1], 'VIP') then
								prizeText = ''..tonumber(pv[2])..' Günlük VIP '..tonumber(pv[3])..''
							else
								prizeText = pv[1]
							end

							dxDrawText(prizeText, screenX - 660, screenY - 112 + prizesY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font10)


							prizesY = prizesY + 30
						end

						dxDrawText('PAKET BİLGİSİ', screenX - 680, screenY - 10, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font11)
						dxDrawText('Yeni başlayanlar için harika fırsat.\nBaşlangıç paketini alın, daha hızlı\nbir başlangıç yapın!', screenX - 680, screenY + 20, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)

						if tonumber(discountPrice) then
							dxDrawText('Bu paket '..value[3].price..'₺ yerine '..discountPrice..'₺!\nKampanyadan sadece bir kez yararlanabilirsiniz.', screenX - 680, screenY + 270, nil, nil, exports.rl_ui:rgba(theme.GRAY[100]), 1, fonts.font10)
						else
							dxDrawText('Bu paket '..value[3].price..'₺!\nKampanyadan sadece bir kez yararlanabilirsiniz.', screenX - 680, screenY + 270, nil, nil, exports.rl_ui:rgba(theme.GRAY[100]), 1, fonts.font10)
						end

						sumbitCampaignButton = exports.rl_ui:drawButton({
							position = {
								x = screenX - 270,
								y = screenY + 230
							},
							size = {
								x = 200,
								y = 60
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-bold', 15),
								scale = 1,
							},
				
							variant = "rounded",
							color = "yellow",
							
							alpha = 300,
				
							text = "HEMEN AL!",
							icon = "",
						})
						price = discountPrice and discountPrice or value[3].price
						if sumbitCampaignButton.pressed then
							if tonumber(localPlayer:getData('balance')) > tonumber(price) then
								selectedProduct = {value[2], price, value[4], index, value[1]}
							else
								exports.rl_infobox:addBox('error', 'Bu arayüze erişmek için '..price..'TL bakiyen olması gerekmektedir.')
								restartMarket()
							end
						end
						-- Kampanya Eventi ile doldur
					elseif starterPack then
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 20 + lineProductX,
								y = screenY - 165 + lineProductY
							},

							size = {
								x = 187,
								y = 100
							},

							radius = 10,

							color = (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 20 + lineProductX, screenY - 165 + lineProductY, 187, 100) and theme.GRAY[400] or theme.GRAY[500],

							alpha = 400
						})

						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 20 + lineProductX,
								y = screenY - 165 + lineProductY
							},

							size = {
								x = 187,
								y = 20
							},

							radius = 7,

							color = theme.GRAY[500],

							alpha = 370
						})
						
						dxDrawText(value[2], screenX - 13 + lineProductX, screenY - 164 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'left')

						dxDrawImage(screenX + 48 + lineProductX, screenY - 142 + lineProductY, 50, 50, 'public/personal/'..(value[1] or 'character-slot')..'.png')

						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 20 + lineProductX,
								y = screenY - 85 + lineProductY
							},

							size = {
								x = 187,
								y = 20
							},

							radius = 7,

							color = theme.YELLOW[500],

							alpha = 450
						})

						if value[3].price > 0 then
							productPrice = value[3].price..'₺'
						else
							productPrice = 'Detaylar'
						end

						if tonumber(value[3].discountPrice) and tonumber(value[3].discountPrice) > 0 then
							discountPrice = tonumber(value[3].discountPrice)..'₺'
						else
							discountPrice = false
						end

						if not discountPrice then
							dxDrawText(productPrice, screenX + 76 + lineProductX, screenY - 85 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'center')
						else
							dxDrawText(discountPrice, screenX + 100 + lineProductX, screenY - 85 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'center')
							dxDrawRectangle(screenX + 57 + lineProductX, screenY - 77 + lineProductY, dxGetTextWidth(productPrice, 1, fonts.font14), 1, exports.rl_ui:rgba(theme.RED[200]))
							dxDrawText(productPrice, screenX + 70 + lineProductX, screenY - 85 + lineProductY, nil, nil, exports.rl_ui:rgba(theme.RED[300]), 1, fonts.font14, 'center')
						end

						if (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 20 + lineProductX, screenY - 165 + lineProductY, 187, 100) and getKeyState('mouse1') and clickTick + 1000 <= getTickCount() then
							clickTick = getTickCount()
							price = discountPrice and discountPrice ~= "Detaylar" and discountPrice:gsub('₺', '') or productPrice ~= "Detaylar" and productPrice:gsub('₺', '') or 0
							if (not price or value[4] and type(value[4]) ~= "string") or tonumber(price) <= 0 and value[1] ~= 'unjail' then
								indexPage = value[1]
							elseif tonumber(localPlayer:getData('balance')) > tonumber(price) then
								if value[1] == 'faction-name-change' then
									if tonumber(getElementData(getPlayerTeam(localPlayer), "type")) == 3 then
										exports.rl_infobox:addBox('error', 'Devlet kurumunda bu işlemi yapamazsın.')
										restartMarket()
									return end
									if (tonumber(getElementData(localPlayer, "factionleader")) ~= 1) then
										exports.rl_infobox:addBox('error', 'Bu işlem için bir birlikte olmanız ve birliğinizin lideri olmanız gerekiyor.')
										restartMarket()
									return end

									selectedProduct = {value[2], price, value[4], index, value[1]}
								elseif value[1] == "unjail" then
									if not getElementData(localPlayer, 'jailtime') or getElementData(localPlayer, 'jailtime') and tonumber(getElementData(localPlayer, 'jailtime')) <= 0 then
										exports.rl_infobox:addBox('error', 'Bu arayüze erişmek için ooc hapiste olmanız gerekmektedir.')
										restartMarket()
									return end
									selectedProduct = {value[2], getJailPrice(localPlayer), value[4], index}
								else
									selectedProduct = {value[2], price, value[4], index, value[1]}
								end
							else
								exports.rl_infobox:addBox('error', 'Bu arayüze erişmek için '..price..'TL bakiyen olması gerekmektedir.')
								restartMarket()
							end
						end

						lineProductX = lineProductX + 197

						lineProduct = lineProduct + 1

						if lineProduct >= maxLineProduct then
							lineProductX = 0
							lineProductY = lineProductY + 110
							lineProduct = 0
						end
					elseif not starterPack then
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 705 + lineProductX,
								y = screenY - 165 + lineProductY
							},

							size = {
								x = 173,
								y = 95
							},

							radius = 10,

							color = (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 705 + lineProductX, screenY - 165 + lineProductY, 173, 95) and theme.GRAY[400] or theme.GRAY[500],

							alpha = 400
						})

						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 705 + lineProductX,
								y = screenY - 165 + lineProductY
							},

							size = {
								x = 173,
								y = 20
							},

							radius = 7,

							color = theme.GRAY[500],

							alpha = 370
						})
						
						dxDrawText(value[2], screenX - 697 + lineProductX, screenY - 164 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'left')

						dxDrawImage(screenX - 643 + lineProductX, screenY - 145 + lineProductY, 50, 50, 'public/personal/'..(value[1] or 'character-slot')..'.png')

						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 705 + lineProductX,
								y = screenY - 90 + lineProductY
							},

							size = {
								x = 173,
								y = 20
							},

							radius = 7,

							color = theme.YELLOW[500],

							alpha = 450
						})

						if value[3].price > 0 then
							productPrice = value[3].price..'₺'
						else
							productPrice = 'Detaylar'
						end

						if tonumber(value[3].discountPrice) and tonumber(value[3].discountPrice) > 0 then
							discountPrice = tonumber(value[3]).discountPrice..'₺'
						else
							discountPrice = false
						end

						if not discountPrice then
							dxDrawText(productPrice, screenX - 616 + lineProductX, screenY - 89 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'center')
						else
							dxDrawText(discountPrice, screenX - 595 + lineProductX, screenY - 89 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'center')
							dxDrawText(productPrice, screenX - 625 + lineProductX, screenY - 89 + lineProductY, nil, nil, exports.rl_ui:rgba(theme.RED[300]), 1, fonts.font14, 'center')
							dxDrawRectangle(screenX - 638 + lineProductX, screenY - 81 + lineProductY, dxGetTextWidth(productPrice, 1, fonts.font14), 1, exports.rl_ui:rgba(theme.RED[200]))
						end

						if (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 705 + lineProductX, screenY - 165 + lineProductY, 173, 95) and getKeyState('mouse1') and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							price = discountPrice and discountPrice ~= "Detaylar" and discountPrice:gsub('₺', '') or productPrice ~= "Detaylar" and productPrice:gsub('₺', '') or 0
							if (not price or value[4] and type(value[4]) ~= "string") or tonumber(price) <= 0 and value[1] ~= 'unjail' then
								indexPage = value[1]
							elseif tonumber(localPlayer:getData('balance')) > tonumber(price) then
								if value[1] == 'faction-name-change' then
									if tonumber(getElementData(getPlayerTeam(localPlayer), "type")) == 3 then
										exports.rl_infobox:addBox('error', 'Devlet kurumunda bu işlemi yapamazsın.')
										restartMarket()
									return end
									if (tonumber(getElementData(localPlayer, "factionleader")) ~= 1) then
										exports.rl_infobox:addBox('error', 'Bu işlem için bir birlikte olmanız ve birliğinizin lideri olmanız gerekiyor.')
										restartMarket()
									return end

									selectedProduct = {value[2], price, value[4], index, value[1]}
								elseif value[1] == "unjail" then
									if not getElementData(localPlayer, 'jailtime') or getElementData(localPlayer, 'jailtime') and tonumber(getElementData(localPlayer, 'jailtime')) <= 0 then
										exports.rl_infobox:addBox('error', 'Bu arayüze erişmek için ooc hapiste olmanız gerekmektedir.')
										restartMarket()
									return end
									selectedProduct = {value[2], getJailPrice(localPlayer), value[4], index}
								else
									selectedProduct = {value[2], price, value[4], index, value[1]}
								end
							else
								exports.rl_infobox:addBox('error', 'Bu arayüze erişmek için '..price..'TL bakiyen olması gerekmektedir.')
								restartMarket()
							end
						end

						lineProductX = lineProductX + 183

						lineProduct = lineProduct + 1

						if lineProduct >= maxLineProduct then
							lineProductX = 0
							lineProductY = lineProductY + 105
							lineProduct = 0
						end
					end
				end
			end
			if indexPage == 'character-name-change' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 125
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('İsim Değişikliği', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				personNameInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 190,
						y = screenY - 15
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_person_name",
		
					placeholder = "Karakter Adı",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 25
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					if personNameInput.value ~= "" then
						clickTick = getTickCount()
						triggerServerEvent("market.buyCharacterNameChange", localPlayer, personNameInput.value, 70)
						restartMarket()
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir araç ID girin.")
					end
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 25
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif indexPage == 'username-change' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 125
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Kullanıcı Adı Değişikliği', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				usernameInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 190,
						y = screenY - 15
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_user_name",
		
					placeholder = "Kullanıcı Adı",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 25
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					if usernameInput.value ~= "" then	
						clickTick = getTickCount()
						triggerServerEvent("market.buyAccountNameChange", localPlayer, usernameInput.value, 70)
						restartMarket()
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir araç ID girin.")
					end
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 25
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif indexPage == 'faction-name-change' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 185
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Birlik Adı Değişikliği', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				factionNameInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 190,
						y = screenY - 15
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_faction_name",
		
					placeholder = "Birlik Adı",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})

				local factionTypeRadioGroup = exports.rl_ui:drawRadioGroup({
					position = {
						x = screenX - 190,
						y = screenY + 25
					},

					name = "market_faction_type",
					options = {
						exports.rl_ui:drawRadio({ name = FACTIONTYPEsEnums.GANG, text = "Çete" }),
						exports.rl_ui:drawRadio({ name = FACTIONTYPEsEnums.MAFIA, text = "Mafya" })
					},
					defaultSelected = FACTIONTYPEsEnums.GANG,

					placement = "horizontal",

					variant = "soft",
					color = "gray",
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					if factionNameInput.value ~= "" then
						clickTick = getTickCount()
						triggerServerEvent("market.buyRenameFaction", localPlayer, factionNameInput.value, factionTypeRadioGroup.current, 40)
						restartMarket()
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir miktar girin.")
					end
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif indexPage == 'luckybox' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 185
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Şans Kutusu', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				luckBoxQuantityInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 190,
						y = screenY - 15
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_luckbox_quantity",
					regex = "^[0-9]*$",
		
					placeholder = "Adet Sayısı",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})

				local luckBoxRadioGroup = exports.rl_ui:drawRadioGroup({
					position = {
						x = screenX - 190,
						y = screenY + 25
					},

					name = "market_lucky_box",
					options = {
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.BRONZE, text = "Bronz Şans Kutusu" }),
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.SILVER, text = "Gümüş Şans Kutusu" }),
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.GOLD, text = "Altın Şans Kutusu" }),
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.DIAMOND, text = "Elmas Şans Kutusu" })
					},
					defaultSelected = LuckBoxesEnums.BRONZE,

					placement = "horizontal",

					variant = "soft",
					color = "gray",
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					if luckBoxQuantityInput.value ~= "" and tonumber(math.floor(luckBoxQuantityInput.value)) then
						local quantity = tonumber(math.floor(luckBoxQuantityInput.value))
						if quantity >= 1 and quantity <= 10 then
							triggerServerEvent("market.buyLuckBox", localPlayer, luckBoxRadioGroup.current, quantity)
							restartMarket()
						elseif quantity > 10 then
							exports.rl_infobox:addBox("error", "Maksimum 10 adet şans kutusu satın alabilirsiniz.")
						else
							exports.rl_infobox:addBox("error", "Minimum 1 adet şans kutusu satın alabilirsiniz.")
						end
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir miktar girin.")
					end
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				if luckBoxQuantityInput.value ~= "" and tonumber(math.floor(luckBoxQuantityInput.value)) then
					totalPrice = tonumber(math.floor(luckBoxQuantityInput.value)) * LUCK_BOXES[luckBoxRadioGroup.current][3]
				else
					totalPrice = 0
				end
				dxDrawText('Toplam Fiyat: '..totalPrice..'TL', screenX + 185, screenY + 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font10, 'right')


				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif indexPage == 'badge' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 125
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Özel Rozet', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				badgeInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 190,
						y = screenY - 15
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_badge_name",
		
					placeholder = "Rozet Adı",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 25
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					triggerServerEvent("market.buyPrivateBadge", localPlayer, badgeInput.value)
					restartMarket()
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 25
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif indexPage == 'luckybox' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 185
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Şans Kutusu', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				luckBoxQuantityInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 190,
						y = screenY - 15
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_luckbox_quantity",
					regex = "^[0-9]*$",
		
					placeholder = "Adet Sayısı",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})

				local luckBoxRadioGroup = exports.rl_ui:drawRadioGroup({
					position = {
						x = screenX - 190,
						y = screenY + 25
					},

					name = "market_luckybox_",
					options = {
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.BRONZE, text = "Bronz Şans Kutusu" }),
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.SILVER, text = "Gümüş Şans Kutusu" }),
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.GOLD, text = "Altın Şans Kutusu" }),
						exports.rl_ui:drawRadio({ name = LuckBoxesEnums.DIAMOND, text = "Elmas Şans Kutusu" })
					},
					defaultSelected = LuckBoxesEnums.BRONZE,

					placement = "horizontal",

					variant = "soft",
					color = "gray",
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					if luckBoxQuantityInput.value ~= "" and tonumber(math.floor(luckBoxQuantityInput.value)) then
						local quantity = tonumber(math.floor(luckBoxQuantityInput.value))
						if quantity >= 1 and quantity <= 10 then
							triggerServerEvent("market.buyLuckBox", localPlayer, luckBoxRadioGroup.current, quantity)
							restartMarket()
						elseif quantity > 10 then
							exports.rl_infobox:addBox("error", "Maksimum 10 adet şans kutusu satın alabilirsiniz.")
						else
							exports.rl_infobox:addBox("error", "Minimum 1 adet şans kutusu satın alabilirsiniz.")
						end
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir miktar girin.")
					end
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				if luckBoxQuantityInput.value ~= "" and tonumber(math.floor(luckBoxQuantityInput.value)) then
					totalPrice = tonumber(math.floor(luckBoxQuantityInput.value)) * LUCK_BOXES[luckBoxRadioGroup.current][3]
				else
					totalPrice = 0
				end
				dxDrawText('Toplam Fiyat: '..totalPrice..'TL', screenX + 185, screenY + 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font10, 'right')


				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif indexPage == 'book' then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 185
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Dövüş Kitabı', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				local fightBookRadioGroup = exports.rl_ui:drawRadioGroup({
					position = {
						x = screenX - 190,
						y = screenY - 21
					},

					name = "market_fightBook_",
					options = {
					--	exports.rl_ui:drawRadio({ name = fightBookEnums.STANDART, text = "Normal Dövüş Kitabı" }),
						exports.rl_ui:drawRadio({ name = fightBookEnums.GRABKICK, text = "Tekme Dövüş Kitabı" }),
						exports.rl_ui:drawRadio({ name = fightBookEnums.BOX, text = "Box Dövüş Kitabı" }),
						exports.rl_ui:drawRadio({ name = fightBookEnums.ELBOW, text = "Dirsek Dövüş Kitabı" }),
						exports.rl_ui:drawRadio({ name = fightBookEnums.KUNGFU, text = "Kung-Fu Dövüş Kitabı" }),
						exports.rl_ui:drawRadio({ name = fightBookEnums.KNEEHEAD, text = "Diz Dövüş Kitabı" })
					},
					defaultSelected = fightBookEnums.GRABKICK,

					placement = "horizontal",

					variant = "soft",
					color = "gray",
				})
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 95,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					triggerServerEvent("market.buyBook", localPlayer, fightBookRadioGroup.current)
					restartMarket()
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 10,
						y = screenY + 80
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end

				if fightBookRadioGroup.current then
					totalPrice = FIGHT_BOOK[fightBookRadioGroup.current][3]
				else
					totalPrice = 0
				end
				dxDrawText('Toplam Fiyat: '..totalPrice..'TL', screenX + 185, screenY + 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font10, 'right')


				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					restartMarket()
				end
			elseif selectedPage == 2 then
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},
	
					size = {
						x = 1465,
						y = 50
					},
	
					radius = 7,
					
					color = theme.GRAY[500],
	
					alpha = 400
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 700,
						y = screenY - 225
					},
	
					size = {
						x = 40,
						y = 40
					},
	
					radius = 11,
					
					color = theme.GRAY[500],
	
					alpha = 350
				})

				dxDrawText('', screenX - 691, screenY - 217, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)

				dxDrawText('VIP Olun', screenX - 650, screenY - 220, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
				dxDrawText('Size uygun olan VIP paketlerinden birisini seçerek alıma devam edin', screenX - 650, screenY - 205, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)

				vipX = 0
				vipY = 0

				for i = 1, 4 do
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 710 + vipX,
							y = screenY - 175
						},

						size = {
							x = 270,
							y = 500
						},

						radius = 10,

						color = theme.GRAY[900],

						alpha = 450
					})
					dxDrawImage(screenX - 675 + vipX, screenY - 160, 200, 250, 'public/vip/'..i..'.png')
					dxDrawText(''..(30 * i)..' ₺ #167b5f/ Ay', screenX - 620 + vipX, screenY + 290, nil, nil, exports.rl_ui:rgba(theme.GREEN[600]), 1, fonts.font16, nil, nil, false, false, false, true)
					
					if exports.rl_ui:inArea(screenX - 710 + vipX, screenY - 175, 270, 500) and getKeyState('mouse1') then
						selectedVIP = i
					end

					if selectedVIP == i or exports.rl_ui:inArea(screenX - 710 + vipX, screenY - 175, 270, 500) then
						exports.rl_ui:dxDrawGradient(screenX - 710 + vipX, screenY + 122, 270, 200, 211, 211, 211, 50, true, false)
					end

					vipX = vipX + 275
				end
				if selectedVIP then
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX + 390,
							y = screenY - 175
						},

						size = {
							x = 365,
							y = 500
						},

						radius = 10,

						color = theme.GRAY[900],

						alpha = 450
					})
					dxDrawText('VIP '..selectedVIP..' Alımı', screenX + 410, screenY - 165, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font17)

					dxDrawText('Gün Sayısı', screenX + 403, screenY + 210, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14)

					vipDayInput = exports.rl_ui:drawInput({
						position = {
							x = screenX + 403,
							y = screenY + 230
						},
		
						size = {
							x = 340,
							y = 30
						},
		
						colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
	
						rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
		
						radius = 6,
						padding = 10,
			
						name = "market_vip_day",
						regex = "^[0-9]*$",
			
						placeholder = "",
						value = "10",
						helperText = {
							text = "",
							color = exports.rl_ui:useTheme().RED[800]
						},
				
						variant = "rounded",
						color = "black",
							
						disabled = false,
						mask = false,
	
						alpha = 350
					})

					if vipDayInput.value ~= "" and tonumber(math.floor(vipDayInput.value)) then
						dxDrawText(''..(vipDayInput.value * selectedVIP)..' ₺ karşılığında '..vipDayInput.value..' günlük VIP alacaksın', screenX + 406, screenY + 262, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14)
					end

					sumbitVIPButton = exports.rl_ui:drawButton({
						position = {
							x = screenX + 403,
							y = screenY + 285
						},
						size = {
							x = 340,
							y = 30
						},
						radius = 10,
			
						textProperties = {
							align = "center",
							color = "#FFFFFF",
							font = exports.rl_fonts:getFont('sf-regular', 10),
							scale = 1,
						},
			
						variant = "rounded",
						color = "green",
						
						alpha = 300,
			
						text = "Onayla",
						icon = "",
					})
					
					if sumbitVIPButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					if vipDayInput.value ~= "" and tonumber(math.floor(vipDayInput.value)) then
						local day = tonumber(math.floor(vipDayInput.value))
						if day >= 10 then
							triggerServerEvent("market.buyVIP", localPlayer, selectedVIP, day, vipDayInput.value * selectedVIP)
							restartMarket()
						else
							exports.rl_infobox:addBox("error", "Minimum 10 günlük VIP satın alabilirsiniz.")
						end
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir miktar girin.")
					end
				  end
				end

				featuresX = 0
				featuresY = 0
				selectedFeatureY = 0
				nowFeature = 1
				for index, value in ipairs(vipFeatures) do
					if value[2] == selectedVIP then
						dxDrawRectangle(screenX + 410, screenY - 130 + selectedFeatureY, 15, 15, tocolor(47, 93, 109, 255))
						dxDrawText(value[1], screenX + 430, screenY - 130 + selectedFeatureY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font15)
						selectedFeatureY = selectedFeatureY + 17
					end

					dxDrawRectangle(screenX - 698 + featuresX, screenY + 105 + featuresY, 15, 15, tocolor(47, 93, 109, 255))
					dxDrawText(value[1], screenX - 678 + featuresX, screenY + 105 + featuresY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font15)
					if index+1 <= #vipFeatures and vipFeatures[index+1][2] == nowFeature then
						featuresY = featuresY + 17
					else
						nowFeature = nowFeature + 1
						featuresY = 0
						featuresX = featuresX + 275
					end
				end
			elseif selectedPage == 3 then
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},
	
					size = {
						x = 1465,
						y = 45
					},
	
					radius = 7,
					
					color = theme.GRAY[600],
	
					alpha = 400
				})

				vehCategoryX = 0
				for index, value in ipairs(VEHICLE_CATEGORIES) do
					dxDrawText(value, screenX - 300 + vehCategoryX, screenY - 220, nil, nil, index == selectedVehiclePage and tocolor(246, 213, 157, 255) or exports.rl_ui:inArea(screenX - 710 + vehCategoryX, screenY - 220, 1465/2+vehCategoryX, 45) and tocolor(246, 213, 157, 255) or tocolor(255, 255, 255), 1, fonts.font7)
					
					if (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 710 + vehCategoryX, screenY - 220, 1465/2+vehCategoryX, 45) and getKeyState('mouse1') and clickTick + 500 <= getTickCount() then
						clickTick = getTickCount()

						if index == 2 then
							exports["rl_object-preview"]:setAlpha(vehiclePreview, 0)
						elseif index == 1 then
							exports["rl_object-preview"]:setAlpha(vehiclePreview, 255)
						end
						selectedVehiclePage = index
					end

					vehCategoryX = vehCategoryX + 630
				end	

				if selectedVehiclePage == 1 then
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 710,
							y = screenY - 175
						},
		
						size = {
							x = 1465,
							y = 50
						},
		
						radius = 7,
						
						color = theme.GRAY[500],
		
						alpha = 400
					})
	
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 700,
							y = screenY - 170
						},
		
						size = {
							x = 40,
							y = 40
						},
		
						radius = 11,
						
						color = theme.GRAY[500],
		
						alpha = 350
					})
	
					dxDrawText('', screenX - 692, screenY - 162, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)
	
					dxDrawText('Araçlar', screenX - 650, screenY - 165, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
					dxDrawText('Özel araçlara göz atın, satın alın ve özelleştirin', screenX - 650, screenY - 150, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)

					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 710,
							y = screenY - 120
						},
	
						size = {
							x = 500,
							y = 550
						},
	
						radius = 6,
	
						color = theme.GRAY[600],
	
						alpha = 400
					})

				vehicleY = 0
				count_Data = 0
				latest = currentPages + dataMax - 1

				for index, value in ipairs(PRIVATE_VEHICLES) do
					count_Data = count_Data + 1
					if count_Data >= currentPages and count_Data <= latest then
					dxDrawText(value[1], screenX - 695, screenY - 165 + 55 + vehicleY, nil, nil, selectedVehicle and index == selectedVehicle.selected and tocolor(246, 213, 157, 255) or exports.rl_ui:inArea(screenX - 710, screenY - 175 + 55 + vehicleY, 500, 35) and tocolor(246, 213, 157, 255) or tocolor(255, 255, 255, 255), 1, fonts.font10, 'left')					
					
					if not value[4].discountPrice then
						dxDrawText(value[4].price..' TL', screenX - 225, screenY - 166 + 55 + vehicleY, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font10, 'right')	
					else
						dxDrawText(value[4].price..' TL', screenX - 275, screenY - 166 + 55 + vehicleY, nil, nil, exports.rl_ui:rgba(theme.RED[200]), 1, fonts.font10, 'right')	
						dxDrawRectangle(screenX - 324, screenY - 158 + 55 + vehicleY, dxGetTextWidth(value[4].price..'₺', 1, fonts.font10) + 10, 1, exports.rl_ui:rgba(theme.RED[200]))		
						dxDrawText(value[4].discountPrice..' TL', screenX - 225, screenY - 166 + 55 + vehicleY, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font10, 'right')	
					end

					if selectedVehicle and index == selectedVehicle.selected then
						dxDrawRectangle(screenX - 710, screenY - 170 + 55 + vehicleY, 1, 30, tocolor(246, 213, 157, 255))
					end

					dxDrawRectangle(screenX - 710, screenY - 140 + 55 + vehicleY, 500, 1, exports.rl_ui:rgba(theme.GRAY[300], 0.2))

					if exports.rl_ui:inArea(screenX - 710, screenY - 175 + 55 + vehicleY, 500, 35) and getKeyState('mouse1') and clickTick + 200 <= getTickCount() then
						clickTick = getTickCount()
						selectedVehicle = {selected = index, price = (not value[4].discountPrice and value[4].price or value[4].discountPrice)}
						setElementModel(theVehicle, PRIVATE_VEHICLES[selectedVehicle.selected][2])
					end

					vehicleY = vehicleY + 35
					end
				end

				scroll = (currentPages - 1) / (count_Data - dataMax) * (520)
				if count_Data > dataMax then
					dxDrawRectangle(screenX - 212, screenY - 168 + 55, 1, 520, tocolor(20,20,20, 220))
					dxDrawRectangle(screenX - 212, screenY - 168 + 55 + scroll, 1, 40, tocolor(246, 213, 157, 255))
				end

				if selectedVehicle then
					dxDrawText(PRIVATE_VEHICLES[selectedVehicle.selected][1], screenX - 200, screenY + 352, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font23, 'left')
					sumbitVehicleButton = exports.rl_ui:drawButton({
						position = {
							x = screenX + 670,
							y = screenY + 329
						},
						size = {
							x = 95,
							y = 35
						},
						radius = 10,
			
						textProperties = {
							align = "center",
							color = "#FFFFFF",
							font = exports.rl_fonts:getFont('sf-regular', 10),
							scale = 1,
						},
			
						variant = "rounded",
						color = "green",
						
						alpha = 300,
			
						text = "Satın Al",
						icon = "",
					})
	
					if sumbitVehicleButton.pressed and clickTick + 500 <= getTickCount() then
						if tonumber(getElementData(localPlayer, 'balance')) >= tonumber(selectedVehicle.price) then
								clickTick = getTickCount()
								selectedVehicleProduct = {selected = selectedVehicle.selected}
						else
							exports.rl_infobox:addBox("error", "Yetersiz bakiye.")
						end
					end
				end
				elseif selectedVehiclePage == 2 then
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 710,
								y = screenY - 175
							},
			
							size = {
								x = 1465,
								y = 50
							},
			
							radius = 7,
							
							color = theme.GRAY[500],
			
							alpha = 400
						})
		
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 700,
								y = screenY - 170
							},
			
							size = {
								x = 40,
								y = 40
							},
			
							radius = 11,
							
							color = theme.GRAY[500],
			
							alpha = 350
						})
		
						dxDrawText('', screenX - 690, screenY - 162, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)
		
						dxDrawText('Araç Özellikleri', screenX - 650, screenY - 165, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
						dxDrawText('Araç özelliklerini buradan satın alabilirsiniz', screenX - 650, screenY - 150, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)
						lineProduct = 0
						maxLineProduct = 8
		
						lineProductX = 0
						lineProductY = 0
						prizesY = 0
						for index, value in ipairs(VEHICLE_FEATURES) do
								exports.rl_ui:drawRoundedRectangle({
									position = {
										x = screenX - 705 + lineProductX,
										y = screenY - 165 + 55 + lineProductY
									},
		
									size = {
										x = 173,
										y = 95
									},
		
									radius = 10,
		
									color = (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 705 + lineProductX, screenY - 165 + 55 + lineProductY, 173, 95) and theme.GRAY[400] or theme.GRAY[500],
		
									alpha = 400
								})
		
								exports.rl_ui:drawRoundedRectangle({
									position = {
										x = screenX - 705 + lineProductX,
										y = screenY - 165 + 55 + lineProductY
									},
		
									size = {
										x = 173,
										y = 20
									},
		
									radius = 7,
		
									color = theme.GRAY[500],
		
									alpha = 370
								})
								
								dxDrawText(value[2], screenX - 697 + lineProductX, screenY - 164 + 55 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'left')
		
								dxDrawImage(screenX - 643 + lineProductX, screenY - 145 + 55 + lineProductY, 50, 50, 'public/vehicle/'..(value[1] or 'car-neon')..'.png')
		
								exports.rl_ui:drawRoundedRectangle({
									position = {
										x = screenX - 705 + lineProductX,
										y = screenY - 90 + 55 + lineProductY
									},
		
									size = {
										x = 173,
										y = 20
									},
		
									radius = 7,
		
									color = theme.YELLOW[500],
		
									alpha = 450
								})
		
								if value[3].price > 0 then
									productPrice = value[3].price..'₺'
								else
									productPrice = 'Detaylar'
								end
		
								if tonumber(value[3].discountPrice) and tonumber(value[3].discountPrice) > 0 then
									discountPrice = tonumber(value[3].discountPrice)..'₺'
								else
									discountPrice = false
								end
		
								if not discountPrice then
									dxDrawText(productPrice, screenX - 616 + lineProductX, screenY - 89 + 55 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'center')
								else
									dxDrawText(discountPrice, screenX - 595 + lineProductX, screenY - 89 + 55 + lineProductY, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14, 'center')
									dxDrawText(productPrice, screenX - 625 + lineProductX, screenY - 89 + 55 + lineProductY, nil, nil, exports.rl_ui:rgba(theme.RED[300]), 1, fonts.font14, 'center')
									dxDrawRectangle(screenX - 638 + lineProductX, screenY - 81 + 55 + lineProductY, dxGetTextWidth(productPrice, 1, fonts.font14), 1, exports.rl_ui:rgba(theme.RED[200]))
								end
		
								if (not selectedProduct and not indexPage) and exports.rl_ui:inArea(screenX - 705 + lineProductX, screenY - 165 + 55 + lineProductY, 173, 95) and getKeyState('mouse1') and clickTick + 500 <= getTickCount() then
									clickTick = getTickCount()
									price = discountPrice and discountPrice ~= "Detaylar" and discountPrice:gsub('₺', '') or productPrice ~= "Detaylar" and productPrice:gsub('₺', '') or 0
									if (not price or value[4] and type(value[4]) ~= "string") then
										indexPage = value[1]
									elseif tonumber(localPlayer:getData('balance')) > tonumber(price) then
											selectedProduct = {value[2], price, value[4], index, value[1], 'vehicle'}
									else
										exports.rl_infobox:addBox('error', 'Bu arayüze erişmek için '..price..'TL bakiyen olması gerekmektedir.')
										restartMarket()
									end
								end
		
								lineProductX = lineProductX + 183
		
								lineProduct = lineProduct + 1
		
								if lineProduct >= maxLineProduct then
									lineProductX = 0
									lineProductY = lineProductY + 105
									lineProduct = 0
								end
					end
					if indexPage == 'change-plate' then
						dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 200,
								y = screenY - 60
							},
		
							size = {
								x = 405,
								y = 155
							},
		
							radius = 6,
		
							color = theme.GRAY[600],
		
							alpha = 400
						})
		
						dxDrawText('Plaka Değişikliği', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
						dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))
		
						vehiclePlateInput = exports.rl_ui:drawInput({
							position = {
								x = screenX - 190,
								y = screenY - 15
							},
			
							size = {
								x = 240,
								y = 30
							},
			
							colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
		
							rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
			
							radius = 6,
							padding = 10,
				
							name = "market_vehicle_plate",
				
							placeholder = "Plaka",
							value = "",
							helperText = {
								text = "",
								color = exports.rl_ui:useTheme().RED[800]
							},
					
							variant = "rounded",
							color = "black",
								
							disabled = false,
							mask = false,
		
							alpha = 350
						})

						vehicleIDInput = exports.rl_ui:drawInput({
							position = {
								x = screenX - 190,
								y = screenY - 15 + 35
							},
			
							size = {
								x = 240,
								y = 30
							},
			
							colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
		
							rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
			
							radius = 6,
							padding = 10,
				
							name = "market_vehicle_id",
							regex = "^[0-9]*$",
				
							placeholder = "Araç ID",
							value = "",
							helperText = {
								text = "",
								color = exports.rl_ui:useTheme().RED[800]
							},
					
							variant = "rounded",
							color = "black",
								
							disabled = false,
							mask = false,
		
							alpha = 350
						})
					
						sumbitProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX + 95,
								y = screenY + 25 + 30
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "green",
							
							alpha = 300,
				
							text = "Onayla",
							icon = "",
						})
		
						if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
							if vehicleIDInput.value ~= "" and tonumber(math.floor(vehicleIDInput.value)) then
								clickTick = getTickCount()
								triggerServerEvent("market.buyVehiclePlate", localPlayer, vehicleIDInput.value, vehiclePlateInput.value)
								restartMarket()
							else
								exports.rl_infobox:addBox("error", "Lütfen geçerli bir araç ID girin.")
							end
						end
		
						cancelProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX - 10,
								y = screenY + 25 + 30
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "gray",
							
							alpha = 300,
				
							text = "İptal",
							icon = "",
						})
		
						if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
		
						dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)
		
						if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
					elseif indexPage == 'vehicle-texture' then
						dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 200,
								y = screenY - 60
							},
		
							size = {
								x = 405,
								y = 155
							},
		
							radius = 6,
		
							color = theme.GRAY[600],
		
							alpha = 400
						})
		
						dxDrawText('Araç Kaplaması', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
						dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))
		
						vehUrlInput = exports.rl_ui:drawInput({
							position = {
								x = screenX - 190,
								y = screenY - 15
							},
			
							size = {
								x = 300,
								y = 30
							},
			
							colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
		
							rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
			
							radius = 6,
							padding = 10,
				
							name = "market_vehicle_texture_url",
				
							placeholder = "URL",
							value = "",
							helperText = {
								text = "",
								color = exports.rl_ui:useTheme().RED[800]
							},
					
							variant = "rounded",
							color = "black",
								
							disabled = false,
							mask = false,
		
							alpha = 350
						})

						vehIdInput = exports.rl_ui:drawInput({
							position = {
								x = screenX - 190,
								y = screenY - 15 + 35
							},
			
							size = {
								x = 240,
								y = 30
							},
			
							colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
		
							rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
			
							radius = 6,
							padding = 10,
				
							name = "market_vehicle_id",
							regex = "^[0-9]*$",
				
							placeholder = "Araç ID",
							value = "",
							helperText = {
								text = "",
								color = exports.rl_ui:useTheme().RED[800]
							},
					
							variant = "rounded",
							color = "black",
								
							disabled = false,
							mask = false,
		
							alpha = 350
						})
					
						sumbitProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX + 95,
								y = screenY + 25 + 30
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "green",
							
							alpha = 300,
				
							text = "Onayla",
							icon = "",
						})
		
						if sumbitProductButton.pressed then
							if vehIdInput.value ~= "" then
								if vehUrlInput.value ~= "" then
									if (string.find(vehUrlInput.value, "https://") and (string.find(vehUrlInput.value, "i.imgur.com")) and (string.find(vehUrlInput.value, "png") or string.find(vehUrlInput.value, "jpg") or string.find(vehUrlInput.value, "jpeg"))) then
										if find:vehicle(vehIdInput.value) then
											local vehicle = find:vehicle(vehIdInput.value);
											if (tonumber(getElementData(vehicle, "owner")) == tonumber(getElementData(localPlayer, "dbid"))) then
												local texnames = engineGetModelTextureNames(tostring(getElementModel(vehicle)))
												for k,v in ipairs(texnames) do
													if string.find(v:lower(), "#") then
														foundedTexture = v
													end
												end
												url = (vehUrlInput.value):gsub("\n", "")
												triggerServerEvent("market.buyVehicleTexture", localPlayer, vehIdInput.value, url:gsub('https', 'http'), foundedTexture)
												restartMarket()
											else
												exports.rl_infobox:addBox("error", "Bu araç size ait değil.")
											end
										end
									else
										exports.rl_infobox:addBox("error", "Geçersiz bir URL girdiniz veya girdiğiniz site sunucuyu desteklemiyor.")
										exports.rl_infobox:addBox("error", "Desteklenen resim yükleme sunucuları: i.imgur.com")
									end
								else
									exports.rl_infobox:addBox("error", "Lütfen geçerli bir URL girin.")
								end
							else
								exports.rl_infobox:addBox("error", "Lütfen geçerli bir Araç ID girin.")
							end
						end
		
						cancelProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX - 10,
								y = screenY + 25 + 30
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "gray",
							
							alpha = 300,
				
							text = "İptal",
							icon = "",
						})
		
						if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
		
						dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)
		
						if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
					elseif indexPage == 'car-tint' then
						dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 200,
								y = screenY - 60
							},
		
							size = {
								x = 405,
								y = 125
							},
		
							radius = 6,
		
							color = theme.GRAY[600],
		
							alpha = 400
						})
		
						dxDrawText('Araç Cam Filmi', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
						dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))
		
						vehicleIDInput = exports.rl_ui:drawInput({
							position = {
								x = screenX - 190,
								y = screenY - 15
							},
			
							size = {
								x = 240,
								y = 30
							},
			
							colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
		
							rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
			
							radius = 6,
							padding = 10,
				
							name = "market_vehicle_id",
							regex = "^[0-9]*$",
				
							placeholder = "Araç ID",
							value = "",
							helperText = {
								text = "",
								color = exports.rl_ui:useTheme().RED[800]
							},
					
							variant = "rounded",
							color = "black",
								
							disabled = false,
							mask = false,
		
							alpha = 350
						})
					
						sumbitProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX + 95,
								y = screenY + 25
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "green",
							
							alpha = 300,
				
							text = "Onayla",
							icon = "",
						})
		
						if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
							if vehicleIDInput.value ~= "" and tonumber(math.floor(vehicleIDInput.value)) then
								clickTick = getTickCount()
								triggerServerEvent("market.buyVehicleTintWindows", localPlayer, vehicleIDInput.value)
								restartMarket()
							else
								exports.rl_infobox:addBox("error", "Lütfen geçerli bir araç ID girin.")
							end
						end
		
						cancelProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX - 10,
								y = screenY + 25
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "gray",
							
							alpha = 300,
				
							text = "İptal",
							icon = "",
						})
		
						if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
		
						dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)
		
						if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
					elseif indexPage == 'car-butterfly' then
						dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 200,
								y = screenY - 60
							},
		
							size = {
								x = 405,
								y = 125
							},
		
							radius = 6,
		
							color = theme.GRAY[600],
		
							alpha = 400
						})
		
						dxDrawText('Araç Kelebek Kapı', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
						dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))
		
						vehicleIDInput = exports.rl_ui:drawInput({
							position = {
								x = screenX - 190,
								y = screenY - 15
							},
			
							size = {
								x = 240,
								y = 30
							},
			
							colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
		
							rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
			
							radius = 6,
							padding = 10,
				
							name = "market_vehicle_id",
							regex = "^[0-9]*$",
				
							placeholder = "Araç ID",
							value = "",
							helperText = {
								text = "",
								color = exports.rl_ui:useTheme().RED[800]
							},
					
							variant = "rounded",
							color = "black",
								
							disabled = false,
							mask = false,
		
							alpha = 350
						})
					
						sumbitProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX + 95,
								y = screenY + 25
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "green",
							
							alpha = 300,
				
							text = "Onayla",
							icon = "",
						})
		
						if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
							if vehicleIDInput.value ~= "" and tonumber(math.floor(vehicleIDInput.value)) then
								clickTick = getTickCount()
								triggerServerEvent("market.buyVehicleButterflyDoor", localPlayer, vehicleIDInput.value)
								restartMarket()
							else
								exports.rl_infobox:addBox("error", "Lütfen geçerli bir araç ID girin.")
							end
						end
		
						cancelProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX - 10,
								y = screenY + 25
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "gray",
							
							alpha = 300,
				
							text = "İptal",
							icon = "",
						})
		
						if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
						
						dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)
		
						if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
					elseif indexPage == 'car-shield' then
						dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
						exports.rl_ui:drawRoundedRectangle({
							position = {
								x = screenX - 200,
								y = screenY - 60
							},
		
							size = {
								x = 405,
								y = 125
							},
		
							radius = 6,
		
							color = theme.GRAY[600],
		
							alpha = 400
						})
		
						dxDrawText('Araç Zırh', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
						dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))
					
						sumbitProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX + 95,
								y = screenY + 25
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "green",
							
							alpha = 300,
				
							text = "Onayla",
							icon = "",
						})
		
						if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
							if vehicleIDInput.value ~= "" and tonumber(math.floor(vehicleIDInput.value)) then
								clickTick = getTickCount()
								triggerServerEvent("market.buyShield", localPlayer)
								restartMarket()
							else
								exports.rl_infobox:addBox("error", "Lütfen geçerli bir araç ID girin.")
							end
						end
		
						cancelProductButton = exports.rl_ui:drawButton({
							position = {
								x = screenX - 10,
								y = screenY + 25
							},
							size = {
								x = 95,
								y = 35
							},
							radius = 10,
				
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = exports.rl_fonts:getFont('sf-regular', 10),
								scale = 1,
							},
				
							variant = "rounded",
							color = "gray",
							
							alpha = 300,
				
							text = "İptal",
							icon = "",
						})
		
						if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
		
						dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)
		
						if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
							clickTick = getTickCount()
							restartMarket()
						end
					end
				end
			elseif selectedPage == 4 then
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},
	
					size = {
						x = 1465,
						y = 50
					},
	
					radius = 7,
					
					color = theme.GRAY[500],
	
					alpha = 400
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 700,
						y = screenY - 225
					},
	
					size = {
						x = 40,
						y = 40
					},
	
					radius = 11,
					
					color = theme.GRAY[500],
	
					alpha = 350
				})

				dxDrawText('', screenX - 690, screenY - 217, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)

				dxDrawText('Silahlar', screenX - 650, screenY - 220, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
				dxDrawText('Özel silahlara göz atın, satın alın ve özelleştirin', screenX - 650, screenY - 205, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 175
					},

					size = {
						x = 500,
						y = 550
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				weaponY = 0
				count_Data = 0
				latest = currentPages + dataMax - 1

				for index, value in ipairs(PRIVATE_WEAPONS) do
					count_Data = count_Data + 1
					if count_Data >= currentPages and count_Data <= latest then
					dxDrawText(value[1], screenX - 695, screenY - 165 + weaponY, nil, nil, selectedWeapon and index == selectedWeapon.selected and tocolor(246, 213, 157, 255) or exports.rl_ui:inArea(screenX - 710, screenY - 175 + weaponY, 500, 35) and tocolor(246, 213, 157, 255) or tocolor(255, 255, 255, 255), 1, fonts.font10, 'left')					
					
					if not value[4].discountPrice then
						dxDrawText(value[4].price..' TL', screenX - 225, screenY - 166 + weaponY, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font10, 'right')	
					else
						dxDrawText(value[4].price..' TL', screenX - 275, screenY - 166 + weaponY, nil, nil, exports.rl_ui:rgba(theme.RED[200]), 1, fonts.font10, 'right')	
						dxDrawRectangle(screenX - 324, screenY - 158 + weaponY, dxGetTextWidth(value[4].price..'₺', 1, fonts.font10) + 10, 1, exports.rl_ui:rgba(theme.RED[200]))		
						dxDrawText(value[4].discountPrice..' TL', screenX - 225, screenY - 166 + weaponY, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font10, 'right')	
					end

					if selectedWeapon and index == selectedWeapon.selected then
						dxDrawRectangle(screenX - 710, screenY - 170 + weaponY, 1, 30, tocolor(246, 213, 157, 255))
					end

					dxDrawRectangle(screenX - 710, screenY - 140 + weaponY, 500, 1, exports.rl_ui:rgba(theme.GRAY[300], 0.2))

					if exports.rl_ui:inArea(screenX - 710, screenY - 175 + weaponY, 500, 35) and getKeyState('mouse1') and clickTick + 200 <= getTickCount() then
						clickTick = getTickCount()
						selectedWeapon = {selected = index, price = (not value[4].discountPrice and value[4].price or value[4].discountPrice)}
						setElementModel(theWeapon, PRIVATE_WEAPONS[selectedWeapon.selected][2])
					end

					weaponY = weaponY + 35
					end
				end

				scroll = (currentPages - 1) / (count_Data - dataMax) * (520)
				if count_Data > dataMax then
					dxDrawRectangle(screenX - 212, screenY - 168, 1, 520, tocolor(20,20,20, 220))
					dxDrawRectangle(screenX - 212, screenY - 168 + scroll, 1, 40, tocolor(246, 213, 157, 255))
				end

				if selectedWeapon then
					dxDrawText(PRIVATE_WEAPONS[selectedWeapon.selected][1], screenX - 200, screenY + 329, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font23, 'left')
					dxDrawText('3 Haklı', screenX - 200, screenY + 352, nil, nil, exports.rl_ui:rgba(theme.GRAY[900], 0.5), 1, fonts.font14, 'left')
					sumbitWeaponButton = exports.rl_ui:drawButton({
						position = {
							x = screenX + 670,
							y = screenY + 329
						},
						size = {
							x = 95,
							y = 35
						},
						radius = 10,
			
						textProperties = {
							align = "center",
							color = "#FFFFFF",
							font = exports.rl_fonts:getFont('sf-regular', 10),
							scale = 1,
						},
			
						variant = "rounded",
						color = "green",
						
						alpha = 300,
			
						text = "Satın Al",
						icon = "",
					})
	
					if sumbitWeaponButton.pressed and clickTick + 500 <= getTickCount() then
						if tonumber(getElementData(localPlayer, 'balance')) >= tonumber(selectedWeapon.price) then
								clickTick = getTickCount()
								triggerServerEvent("market.buyPrivateWeapon", localPlayer, selectedWeapon.selected)
						else
							exports.rl_infobox:addBox("error", "Yetersiz bakiye.")
						end
					end
				end
			elseif selectedPage == 5 then
				dxDrawImage(0, screenSize.y / 3, screenSize.x, screenSize.y, 'public/skin-bg.png', 0, 0, 0, exports.rl_ui:rgba(theme.ORANGE[400], 0.4))

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},
	
					size = {
						x = 1465,
						y = 50
					},
	
					radius = 7,
					
					color = theme.GRAY[500],
	
					alpha = 400
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 700,
						y = screenY - 225
					},
	
					size = {
						x = 40,
						y = 40
					},
	
					radius = 11,
					
					color = theme.GRAY[500],
	
					alpha = 350
				})

				dxDrawText('', screenX - 687, screenY - 217, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)

				dxDrawText('Dupont', screenX - 650, screenY - 220, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
				dxDrawText('Hazırladığınız dupont linki ile dupont kıyafet alın', screenX - 650, screenY - 205, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 245,
						y = screenY - 170
					},
	
					size = {
						x = 500,
						y = 300
					},
	
					radius = 7,
					
					color = theme.GRAY[500],
	
					alpha = 400
				})

				dxDrawText('Dupont Satın Alımı', screenX - 230, screenY - 150, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font17)

				dxDrawText('URL', screenX - 230, screenY - 110, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14)

				dupontUrlInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 230,
						y = screenY - 90
					},
	
					size = {
						x = 475,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_url_input",

					placeholder = "",
					value = "",
					helperText = {
						text = "örn: imgur.com/xxxxxx",
						color = exports.rl_ui:useTheme().GRAY[200]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})

				dxDrawText('Skin ID', screenX - 230, screenY - 30, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font14)

				dupontSkinIDInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 230,
						y = screenY - 10
					},
	
					size = {
						x = 475,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().GRAY[500],
	
					radius = 6,
					padding = 10,
		
					name = "market_skinid_input",

					placeholder = "",
					value = "",
					helperText = {
						text = "örn: 1",
						color = exports.rl_ui:useTheme().GRAY[200]
					},
			
					variant = "rounded",
					color = "black",
						
					disabled = false,
					mask = false,

					alpha = 350
				})

				sumbitClothingButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 232,
						y = screenY + 90
					},
					size = {
						x = 475,
						y = 30
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "yellow",
					
					alpha = 300,
		
					text = "Satın Al ("..DUPONT_PRICE.." TL)",
					icon = "",
				})
				if sumbitClothingButton.pressed then
					if dupontSkinIDInput.value ~= "" then
						if dupontUrlInput.value ~= "" then
							if (string.find(dupontUrlInput.value, "https://") and (string.find(dupontUrlInput.value, "i.imgur.com")) and (string.find(dupontUrlInput.value, "png") or string.find(dupontUrlInput.value, "jpg") or string.find(dupontUrlInput.value, "jpeg"))) then
								triggerServerEvent("market.buyDupont", localPlayer, dupontSkinIDInput.value, (dupontUrlInput.value):gsub("\n", ""), DUPONT_PRICE)
								restartMarket()
							else
								exports.rl_infobox:addBox("error", "Geçersiz bir URL girdiniz veya girdiğiniz site sunucuyu desteklemiyor.")
								exports.rl_infobox:addBox("error", "Desteklenen resim yükleme sunucuları: i.imgur.com")
							end
						else
							exports.rl_infobox:addBox("error", "Lütfen geçerli bir URL girin.")
						end
					else
						exports.rl_infobox:addBox("error", "Lütfen geçerli bir Skin ID girin.")
					end
				end
			elseif selectedPage == 6 then
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},

					size = {
						x = 1465,
						y = 200
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

		
				dxDrawImage(screenX - 675, screenY - 195, 250, 125, 'public/campaign-header.png')

				dxDrawText('PARA', screenX - 655, screenY - 180, nil, nil, tocolor(246, 213, 157, 255), 1, fonts.font20)
				dxDrawText('ÇEVİR', screenX - 550, screenY - 180, nil, nil, tocolor(246, 213, 157, 255), 1, fonts.font21)

				dxDrawText('Bakiyenizi oyun parasına çevirin', screenX - 668, screenY - 100, nil, nil, tocolor(246, 213, 157, 255), 1, fonts.font19)


				dxDrawImage(screenX - 715, screenY - 230, 1500, 200, 'public/money-convert.png')

				dxDrawText('Çevrim tutarını gir', screenX - 225, screenY - 192, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font22)
				dxDrawText('Tutar girin', screenX - 225, screenY - 170, nil, nil, exports.rl_ui:rgba(theme.GRAY[300]), 1, fonts.font10)

				convertMoneyInput = exports.rl_ui:drawInput({
					position = {
						x = screenX - 225,
						y = screenY - 145
					},
	
					size = {
						x = 240,
						y = 30
					},
	
					colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),

					rectangleColorTheme = exports.rl_ui:useTheme().YELLOW[700],
	
					radius = 6,
					padding = 10,
		
					name = "market_convert_money",
					regex = "^[0-9]*$",
		
					placeholder = "örn: 1000",
					value = "",
					helperText = {
						text = "",
						color = exports.rl_ui:useTheme().RED[800]
					},
			
					variant = "rounded",
					color = "yellow",
						
					disabled = false,
					mask = false,

					alpha = 350
				})

				if convertMoneyInput.value ~= "" and tonumber(math.floor(convertMoneyInput.value)) then
					dxDrawText(convertMoneyInput.value..' ₺ karşılığında '..exports.rl_global:formatMoney(convertMoneyInput.value * CONVERT_MONEY_MULTIPLIER)..'$ alacaksın', screenX - 226, screenY - 115, nil, nil, exports.rl_ui:rgba(theme.LIGHT[500]), 1, fonts.font10)
				end

				sumbitConvertButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 225,
						y = screenY - 95
					},
					size = {
						x = 240,
						y = 30
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "yellow",
					
					alpha = 300,

					disabled = loading,
		
					text = "Çevir",
					icon = "",
				})

				if sumbitConvertButton.pressed then
						local value = tonumber(convertMoneyInput.value)
						if not value then
							exports.rl_infobox:addBox("error", "Lütfen geçerli bir tutar giriniz.")
							return
						end

						if value <= 0 then
							exports.rl_infobox:addBox("error", "Lütfen geçerli bir tutar giriniz.")
							return
						end

						if not tostring(value):match("^[0-9]+$") then
							exports.rl_infobox:addBox("error", "Sadece rakam kullanabilirsiniz. (Noktalama işareti kullanamazsın)")
							return
						end

						triggerServerEvent("market.paraCevir", localPlayer, localPlayer, value, value * 2000)
						loading = false
				end
			elseif selectedPage == 7 then
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},
	
					size = {
						x = 1465,
						y = 50
					},
	
					radius = 7,
					
					color = theme.GRAY[500],
	
					alpha = 400
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 700,
						y = screenY - 225
					},
	
					size = {
						x = 40,
						y = 40
					},
	
					radius = 11,
					
					color = theme.GRAY[500],
	
					alpha = 350
				})

				dxDrawText('', screenX - 691, screenY - 217, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)

				dxDrawText('Etiketler', screenX - 650, screenY - 220, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
				dxDrawText('Özel etiketler doğrudan isim etiketinizin altında görünür', screenX - 650, screenY - 205, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 175
					},

					size = {
						x = 500,
						y = 550
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				tagY = 0
				count_Data = 0
				latest = currentPages + dataMax - 1

				for index = 1, TAG_COUNT do
					count_Data = count_Data + 1
					if count_Data >= currentPages and count_Data <= latest then
					-- if index == 100 or 101 or 102 or 103 or 104 or 105 or 106 or 107 then return end
					dxDrawText('Etiket '..index..'', screenX - 695, screenY - 165 + tagY, nil, nil, selectedTag and index == selectedTag.selected and tocolor(246, 213, 157, 255) or exports.rl_ui:inArea(screenX - 710, screenY - 175 + tagY, 500, 35) and tocolor(246, 213, 157, 255) or tocolor(255, 255, 255, 255), 1, fonts.font10, 'left')					
					
					if not TAG_DISCOUNT_PRICE then
						dxDrawText(TAG_PRICE..' TL', screenX - 225, screenY - 166 + tagY, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font10, 'right')	
					else
						dxDrawText(TAG_PRICE..' TL', screenX - 275, screenY - 166 + tagY, nil, nil, exports.rl_ui:rgba(theme.RED[200]), 1, fonts.font10, 'right')	
						dxDrawRectangle(screenX - 324, screenY - 158 + tagY, dxGetTextWidth(TAG_PRICE..'₺', 1, fonts.font10) + 10, 1, exports.rl_ui:rgba(theme.RED[200]))		
						dxDrawText(TAG_DISCOUNT_PRICE..' TL', screenX - 225, screenY - 166 + tagY, nil, nil, tocolor(127, 245, 144, 255), 1, fonts.font10, 'right')	
					end

					if selectedTag and index == selectedTag.selected then
						dxDrawRectangle(screenX - 710, screenY - 170 + tagY, 1, 30, tocolor(246, 213, 157, 255))
					end

					dxDrawRectangle(screenX - 710, screenY - 140 + tagY, 500, 1, exports.rl_ui:rgba(theme.GRAY[300], 0.2))

					if exports.rl_ui:inArea(screenX - 710, screenY - 175 + tagY, 500, 35) and getKeyState('mouse1') and clickTick + 200 <= getTickCount() then
						clickTick = getTickCount()
						selectedTag = {selected = index, name = 'Etiket '..index..'', price = (not TAG_DISCOUNT_PRICE and TAG_PRICE or TAG_DISCOUNT_PRICE)}
					end
					tagY = tagY + 35
					end
				end

				scroll = (currentPages - 1) / (count_Data - dataMax) * (520)
				if count_Data > dataMax then
					dxDrawRectangle(screenX - 212, screenY - 168, 1, 520, tocolor(20,20,20, 220))
					dxDrawRectangle(screenX - 212, screenY - 168 + scroll, 1, 40, tocolor(246, 213, 157, 255))
				end

				if selectedTag then
					local speed = 1
					if iconTickCount + speed < getTickCount() then
						iconTickCount = getTickCount()
						iconRotation = iconRotation + 2
					if iconRotation > 360 then
						iconRotation = 0
						end
					end

					dxDrawImage(screenX + 90, screenY - 70, 275, 275, 'public/icon-bg.png', iconRotation, 0, 0)
					dxDrawImage(screenX + 175, screenY + 15, 100, 100, ':rl_nametag/public/images/tags/'..selectedTag.selected..'.png')
					
					dxDrawText(selectedTag.name, screenX - 200, screenY + 329, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font23, 'left')
					dxDrawText('Etiket süresi sınırsızdır', screenX - 200, screenY + 352, nil, nil, exports.rl_ui:rgba(theme.GRAY[900], 0.5), 1, fonts.font14, 'left')
					sumbitTagButton = exports.rl_ui:drawButton({
						position = {
							x = screenX + 670,
							y = screenY + 329
						},
						size = {
							x = 95,
							y = 35
						},
						radius = 10,
			
						textProperties = {
							align = "center",	
							color = "#FFFFFF",
							font = exports.rl_fonts:getFont('sf-regular', 10),
							scale = 1,
						},
			
						variant = "rounded",
						color = "green",
						
						alpha = 300,
			
						text = "Satın Al",
						icon = "",
					})
	
					if sumbitTagButton.pressed and clickTick + 500 <= getTickCount() then
						if tonumber(getElementData(localPlayer, 'balance')) >= tonumber(selectedTag.price) then
								clickTick = getTickCount()
								triggerServerEvent("market.buyTag", localPlayer, selectedTag.selected)
						else
							exports.rl_infobox:addBox("error", "Yetersiz bakiye.")
						end
					end
				end
			elseif selectedPage == 8 then
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},

					size = {
						x = 1465,
						y = 650
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 710,
						y = screenY - 230
					},
	
					size = {
						x = 1465,
						y = 50
					},
	
					radius = 7,
					
					color = theme.GRAY[500],
	
					alpha = 400
				})

				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 700,
						y = screenY - 225
					},
	
					size = {
						x = 40,
						y = 40
					},
	
					radius = 11,
					
					color = theme.GRAY[500],
	
					alpha = 350
				})

				dxDrawText('', screenX - 690, screenY - 162 - 55, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)

				dxDrawText('Alım Geçmişi', screenX - 650, screenY - 165 - 55, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
				dxDrawText('Mağaza üzerinden aldığınız ürünlerin listesini buradan görebilirsiniz', screenX - 650, screenY - 150 - 55, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)
				
				dxDrawText('', screenX + 285, screenY, nil, nil, exports.rl_ui:rgba(theme.ORANGE[400]), 1, fonts.font24)
				
				exports.rl_ui:drawTable({
					position = {
						x = screenX - 700,
						y = screenY - 170
					},
					size = {
						width = screenSize.x / 2 - 30,
						height = 570
					},

					name = "market_market-historytable",
					columns = {
						{
							text = "Alınan Ürün",
							width = 0.45
						},
						{
							text = "Ücret",
							width = 0.2
						},
						{
							text = "Tarih",
							width = 0.2
						}
					},
					rows = marketHistoryData and map(marketHistoryData, function(_, row)
						return {
							row.product_name,
							row.price .. " TL",
							row.buying_date
						}
					end) or {},
					variant = "onlytext",
					pageVariant = "rounded",
					pageAlpha = 400,
					pageColor = 'yellow',
					color = "light",
					disabled = not marketHistoryData
				  })
				elseif selectedPage == 9 then
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 710,
							y = screenY - 230
						},
	
						size = {
							x = 1465,
							y = 650
						},
	
						radius = 6,
	
						color = theme.GRAY[600],
	
						alpha = 400
					})
	
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 710,
							y = screenY - 230
						},
		
						size = {
							x = 1465,
							y = 50
						},
		
						radius = 7,
						
						color = theme.GRAY[500],
		
						alpha = 400
					})
	
					exports.rl_ui:drawRoundedRectangle({
						position = {
							x = screenX - 700,
							y = screenY - 225
						},
		
						size = {
							x = 40,
							y = 40
						},
		
						radius = 11,
						
						color = theme.GRAY[500],
		
						alpha = 350
					})
	
					dxDrawText('', screenX - 690, screenY - 162 - 55, nil, nil, tocolor(211, 211, 211, 255), 1, fonts.font12)
	
					dxDrawText('Yükleme Geçmişi', screenX - 650, screenY - 165 - 55, nil, nil, tocolor(245, 245, 245, 255), 1, fonts.font13)
					dxDrawText('Oyuna şuana dek ne kadar para yatırdığınızı görebilirsiniz', screenX - 650, screenY - 150 - 55, nil, nil, exports.rl_ui:rgba(theme.GRAY[200]), 1, fonts.font10)
				
					dxDrawText('', screenX + 285, screenY, nil, nil, exports.rl_ui:rgba(theme.YELLOW[400]), 1, fonts.font24)

					exports.rl_ui:drawTable({
						position = {
							x = screenX - 700,
							y = screenY - 170
						},
						

						size = {
						  width = screenSize.x / 2 - 30,
						  height = 570
						},

						name = "market_market_balance_history_table",

						columns = {
							{
								text = "Tarih",
								width = 0.35
							},
							{
								text = "Yüklenen Miktar",
								width = 0.35
							},
							{
								text = "Platform",
								width = 0.35
							}
						},
						rows = balanceHistoryData and map(balanceHistoryData, function(_, row)
							return {
								row.created_on,
								row.amount .. " TL",
								row.payment_platform or "-"
							}
						end) or {},
						
						variant = "onlytext",
						pageVariant = "rounded",
						pageAlpha = 400,
						pageColor = 'yellow',
						color = "light",
						disabled = not balanceHistoryData
					  })
			end
			if selectedProduct then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 120
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Ürün Satın Alımı', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))

				dxDrawText('#2bbe8a'..selectedProduct[1]..' #FFFFFFisimli ürünü #2bbe8a'..selectedProduct[2]..'TL #FFFFFFkarşılığında satın\nalmak istiyor musunuz?', screenX - 190, screenY - 24, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font10, nil, nil, false, false, false, true)
			
				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 80,
						y = screenY + 20
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					if selectedProduct[1] == 'OOC Hapis Açtırma' then
						triggerServerEvent('market.buyUnjail', localPlayer)
						restartMarket()
					elseif type(selectedProduct[3]) ~= "string" then
						indexPage = selectedProduct[5]
					elseif selectedProduct[6] == 'vehicle' then
						triggerEvent(selectedProduct[3], localPlayer)
						restartMarket()
					else
						triggerServerEvent(selectedProduct[3], localPlayer)
						restartMarket()
					end
					selectedProduct = false
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 25,
						y = screenY + 20
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "gray",
					
					alpha = 300,
		
					text = "İptal",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					selectedProduct = false
				end

				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					selectedProduct = false
				end
			elseif selectedVehicleProduct then
				dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
				exports.rl_ui:drawRoundedRectangle({
					position = {
						x = screenX - 200,
						y = screenY - 60
					},

					size = {
						x = 405,
						y = 120 + 50
					},

					radius = 6,

					color = theme.GRAY[600],

					alpha = 400
				})

				dxDrawText('Araç Satın Alımı ('..PRIVATE_VEHICLES[selectedVehicleProduct.selected][1]..')', screenX - 190, screenY - 55, nil, nil, tocolor(230, 230, 230, 230), 1, fonts.font5)
				dxDrawRectangle(screenX - 200, screenY - 30, 405, 1, exports.rl_ui:rgba(theme.GRAY[500]))
				
				local windowTintCheckBox = exports.rl_ui:drawCheckbox({
					position = {
						x = screenX - 187,
						y = screenY - 15
					},
					size = 24,

					name = "market_vehicle_tintCheck",
					disabled = false,
					text = "Araç Cam Filmi (+"..EXTRA_VEHICLE_WINDOW_TINT.." TL)",
					helperText = {
						text = "",
						color = theme.GRAY[200],
					},

					variant = "soft",
					color = windowTint.checked and "green" or "gray",

					checked = windowTint.checked,
				})
				if windowTintCheckBox.pressed then
					windowTint = {checked = not windowTint.checked}
				end

				local vehiclePlateCheckBox = exports.rl_ui:drawCheckbox({
					position = {
						x = screenX - 187,
						y = screenY + 10
					},
					size = 24,

					name = "market_vehicle_plateCheck",
					disabled = false,
					text = "Özel Plaka (+"..EXTRA_VEHICLE_PLATE.." TL)",
					helperText = {
						text = "",
						color = theme.GRAY[200],
					},

					variant = "soft",
					color = vehiclePlate.checked and "green" or "gray",

					checked = vehiclePlate.checked,
				})
				if vehiclePlateCheckBox.pressed then
					vehiclePlate = {checked = not vehiclePlate.checked}
				end

				if vehiclePlate.checked then
					vehiclePlate_Feature = exports.rl_ui:drawInput({
						position = {
							x = screenX - 187,
							y = screenY + 38
						},
		
						size = {
							x = 100,
							y = 30
						},
		
						colorTheme = exports.rl_ui:rgba(exports.rl_ui:useTheme().LIGHT[500]),
	
						rectangleColorTheme = exports.rl_ui:useTheme().GRAY[900],
		
						radius = 6,
						padding = 10,
			
						name = "market_vehicle_plate_feature",
			
						placeholder = "Plaka yazınız",
						value = "",
						helperText = {
							text = "",
							color = exports.rl_ui:useTheme().RED[800]
						},
				
						variant = "rounded",
						color = "black",
							
						disabled = false,
						mask = false,
	
						alpha = 350
					})
				end

				sumbitProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX + 80,
						y = screenY + 20 + 50
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "green",
					
					alpha = 300,
		
					text = "Onayla",
					icon = "",
				})

				if sumbitProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					if vehiclePlate.checked and vehiclePlate_Feature.value == "" then 
						exports.rl_infobox:addBox('error', 'Lütfen bir plaka yazısı giriniz.')
						return false
					end
					triggerServerEvent("market.buyPrivateVehicle", localPlayer, selectedVehicle.selected, {vehiclePlate = vehiclePlate.checked, windowTint = windowTint.checked, plateText = vehiclePlate.checked and vehiclePlate_Feature.value or false})
					selectedVehicleProduct = false
				end

				cancelProductButton = exports.rl_ui:drawButton({
					position = {
						x = screenX - 25,
						y = screenY + 20 + 50
					},
					size = {
						x = 95,
						y = 35
					},
					radius = 10,
		
					textProperties = {
						align = "center",
						color = "#FFFFFF",
						font = exports.rl_fonts:getFont('sf-regular', 10),
						scale = 1,
					},
		
					variant = "rounded",
					color = "red",
					
					alpha = 300,
		
					text = "Vazgeç",
					icon = "",
				})

				if cancelProductButton.pressed and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					selectedVehicleProduct = false
				end

				dxDrawText('X', screenX + 180, screenY - 55, nil, nil, exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and exports.rl_ui:rgba(theme.RED[500]) or tocolor(230, 230, 230, 230), 1, fonts.font5)

				if exports.rl_ui:inArea(screenX + 180, screenY - 55, 30, 30) and getKeyState('mouse1') and clickTick <= getTickCount() then
					clickTick = getTickCount()
					selectedVehicleProduct = false
				end
			end
	    end, 0, 0)
	else
		restartMarket()
		exports["rl_object-preview"]:destroyObjectPreview(vehiclePreview)
		destroyElement(theVehicle)
		
		exports["rl_object-preview"]:destroyObjectPreview(weaponPreview)
		destroyElement(theWeapon)
		
	    killTimer(renderTimer)
	    showCursor(false)
		showChat(true)
		setElementData(localPlayer, "hudkapa", false)
	end
end, false, false)

function down()
	if isTimer(renderTimer) and count_Data > dataMax and (selectedPage == 7 or selectedPage == 3 and selectedVehiclePage == 1 or selectedPage == 4) then
		if currentPages < (count_Data) - (dataMax - 1) then
			currentPages = currentPages + 1
		end
	end
end

function up()
	if isTimer(renderTimer) and count_Data > dataMax and (selectedPage == 7 or selectedPage == 3 and selectedVehiclePage == 1 or selectedPage == 4) then
		if currentPages > 1 then
			currentPages = currentPages - 1
		end
	end
end
bindKey('mouse_wheel_up', 'down', up)
bindKey('mouse_wheel_down', 'down', down)
bindKey('pgup', 'down', up)

addEventHandler('onClientKey', root, function(b, s)
	if not isTimer(renderTimer) then return end
	if b == 'escape' then
		cancelEvent()
		
		restartMarket()
		exports["rl_object-preview"]:destroyObjectPreview(vehiclePreview)
		destroyElement(theVehicle)
		
		exports["rl_object-preview"]:destroyObjectPreview(weaponPreview)
		destroyElement(theWeapon)
		
		killTimer(renderTimer)
		showCursor(false)
		showChat(true)
	end
end)

addEventHandler("onClientCursorMove", root, function(x)
	if not isTimer(renderTimer) then return end
	if selectedPage == 4 then
		exports['rl_object-preview']:setRotation(weaponPreview, 0, 0, 200 + x * 50)
	elseif selectedPage == 3 and selectedVehiclePage == 1 then
		exports['rl_object-preview']:setRotation(vehiclePreview, 0, 0, 180 + x * 50)
	end
end)

function find:vehicle(vehicleID)
	for i,v in ipairs(getElementsByType('vehicle')) do
		if (tonumber(v:getData('dbid')) == tonumber(vehicleID)) then
			return v
		end
	end
	return false
end

addEvent("market.loadBalanceHistory", true)
addEventHandler("market.loadBalanceHistory", root, function(_balanceHistoryData)
    balanceHistoryData = _balanceHistoryData
end)

addEvent("market.loadMarketHistory", true)
addEventHandler("market.loadMarketHistory", root, function(_marketHistoryData)
    marketHistoryData = _marketHistoryData
end)