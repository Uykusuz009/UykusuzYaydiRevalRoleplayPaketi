Interaction.Interactions = {}

function addInteraction(type, model, name, image, executeFunction)
	if not Interaction.Interactions[type][model] then
		Interaction.Interactions[type][model] = {} 
	end
 
	table.insert(Interaction.Interactions[type][model], {name, image, executeFunction})
end

function getInteractions(element)
	local interactions = {}
	local type = getElementType(element)
	local model = getElementModel(element)
	
	if type == "ped" then
		table.insert(interactions, {"Konuş", "icons/detector.png", 
			function()
				triggerEvent("shop.talkPed", localPlayer, element)
			end
		})
	elseif type == "vehicle" then
		if getElementData(element, "carshop") then
			table.insert(interactions, {"Satın Al ($" .. exports.rl_global:formatMoney(getElementData(element, "carshop:cost")) .. ")", "icons/trunk.png", 
				function()
					triggerServerEvent("carshop:buyCar", element, "cash")
				end
			})
		else
			table.insert(interactions, {"Araç Envanteri", "icons/trunk.png", 
				function()
					if not exports.rl_global:hasItem(localPlayer, 3, getElementData(element, "dbid")) then
						outputChatBox("[!]#FFFFFF Bu aracın envanterinin kilidini açmak için bir anahtara ihtiyacınız var.", 255, 0, 0, true)
						playSoundFrontEnd(4)
					else
						triggerServerEvent("openFreakinInventory", localPlayer, element, 500, 500)
					end
				end
			})

			table.insert(interactions, {"Kapı Kontrolü", "icons/doorcontrol.png",
				function()
					exports.rl_vehicle:fDoorControl(element)	
				end
			})

			table.insert(interactions, {"Aracın İçine Gir", "icons/stair1.png", 
				function()
					triggerServerEvent("enterVehicleInterior", localPlayer, element)
				end
			})
			
			if exports.rl_items:hasItem(element, 117) then
				table.insert(interactions, {"Rampa", "icons/ramp.png", 
					function()
						exports.rl_vehicle:toggleRamp(element)
					end
				})
			end

			if exports.rl_items:hasItem(localPlayer, 57) then
				table.insert(interactions, {"Benzin Doldur", "icons/fuel.png", 
					function()
						exports.rl_vehicle:fillFuelTank(element)
					end
				})
			end
			
			local leader = getElementData(localPlayer, "factionleader")
			if tonumber(leader) == 1 and ((getElementData(localPlayer, "faction") == 1) or (getElementData(localPlayer, "faction") == 3)) then
				table.insert(interactions, {"Aracı Ara", "icons/stretcher.png", 
					function()
						triggerServerEvent("openFreakinInventory", localPlayer, element, 500, 500)
					end
				})
			end

			if (exports.rl_global:isAdminOnDuty(localPlayer) and exports.rl_integration:isPlayerLeaderAdmin(localPlayer)) then
				table.insert(interactions, {"ADM: Yenile", "icons/adm.png", 
					function()
						triggerServerEvent("vehicle-manager:respawn", localPlayer, element)
					end
				})
			end

			if (exports.rl_global:isAdminOnDuty(localPlayer) and exports.rl_integration:isPlayerGeneralAdmin(localPlayer)) then
				table.insert(interactions, {"ADM: Texture", "icons/adm.png", 
					function()
						triggerEvent("item-texture:vehtex", localPlayer, element)
					end
				})
			end

			if (getElementModel(element) == 416) and (getElementData(localPlayer, "faction") == 2) then
				table.insert(interactions, {"Sedye", "icons/stretcher.png", 
					function()
						exports.rl_vehicle:fStretcher(element)
					end
				})
			end
		end
	end
	
	table.insert(interactions, {"Kapat", "icons/cross_x.png",
		function()
			Interaction.Close()
		end
	})
	
	return interactions
end

function isFriendOf(accountID)
	for _, data in ipairs({online, offline}) do
		for k, v in ipairs(data) do
			if v.accountID == accountID then
				return true
			end
		end
	end
	return false
end