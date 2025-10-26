pressed = nil
local show = false
local delay = 4000
local screenW, screenH = guiGetScreenSize()
local hotkeys = {}
local item_size = 85
local margin = 6
local padding = 30
switching = nil
using_weapon = nil

function weaponSwitch(prevSlot, newSlot)
	if not pressed then
		renderWeaponSelectorTimer = setTimer(renderWeaponSelector, 0, 0)
	end

	pressed = getTickCount()

	if switching or reloading then
		cancelEvent()
		return
	end
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, weaponSwitch)

local function hasWeapon(weaps,weap_id)
	for _, weap in ipairs(weaps) do
		if weap.id == weap_id then
			return true
		end
	end
end

local function getPedWeapons(player)
	local items = exports["rl_items"]:getItems(player) -- [] [1] = itemID [2] = itemValue
	local weaps = {}
	local total = 1
	local slots = 1

	weaps[1] = {}
	table.insert(weaps[1], {dbid=0, id = 0, slot = 0, name = 'Fist' })

	for _, item in ipairs(items) do
		if item[1] == 115 then
			local dbid = tonumber(item[3])
			local gunDetails = exports.rl_global:explode(':', item[2]) -- [1] = gta weapon id, [2] = serial number, [3] = weapon name
			local weapon_id = tonumber(gunDetails[1])
			local serial = tonumber(gunDetails[1])
			local weapon_slot = getSlotFromWeapon(weapon_id) + 1
			
			if not weaps[weapon_slot] then 
				weaps[weapon_slot] = {} 
				slots = slots + 1
			end
			table.insert(weaps[weapon_slot], {dbid=dbid, id = weapon_id, slot = weapon_slot, name = gunDetails[3], serial = gunDetails[2] })
			total = total + 1
		end
	end

	return weaps, total, slots
end

local fontCheck = exports.rl_fonts:getFont('sf-bold', 10)

function renderWeaponSelector()
	if getElementData(localPlayer, "logged") and exports.rl_settings:getPlayerSetting(localPlayer, "weapon_interface_visible") then
		local weaps, total, slots = getPedWeapons(localPlayer)
		local bg_w = (item_size+padding)*slots+padding
		local bg_h = item_size+padding*2
		local bg_x = (screenW - bg_w) / 2
		local bg_y = screenH/10

	    local start_x = bg_x+padding
	    local start_y = bg_y+10

		local iw_x = (screenW - bg_w) / 2
		local iw_y = (screenH - bg_h) / 2

		local can, why = canPlayerShoot()
        if why and string.len(why) > 0 then
			dxDrawText(why, -1, bg_y-20-1, screenW-1, bg_h-1, tocolor(0, 0, 0, 255), 1.00, fontCheck, "center", "top", false, true, false, false, false)
			dxDrawText(why, 0+1, bg_y-20-1, screenW+1, bg_h-1, tocolor(0, 0, 0, 255), 1.00, fontCheck, "center", "top", false, true, false, false, false)
			dxDrawText(why, 0-1, bg_y-20+1, screenW-1, bg_h-1, tocolor(0, 0, 0, 255), 1.00, fontCheck, "center", "top", false, true, false, false, false)
			dxDrawText(why, 0+1, bg_y-20+1, screenW+1, bg_h+1, tocolor(0, 0, 0, 255), 1.00, fontCheck, "center", "top", false, true, false, false, false)
			dxDrawText(why, 0, bg_y-20, screenW, bg_h, tocolor(255, 255, 255, 255), 1.00, fontCheck, "center", "top", false, true, false, false, false)
		end

		local count2 = 0
		local selected_something = false
		for slot = 1, 13 do
			if weaps[slot] then
				for i = 1, #weaps[slot] do 
					local weap = weaps[slot][i]
					if not weap.dbid or (using_weapon and using_weapon[slot-1] == weap.dbid) then
						local start_x = start_x+(count2)*(item_size+padding)+0
						local current_weap = getPedWeapon(localPlayer)
						local bg_color = tocolor(255, 255, 255, 120)
						if current_weap == weap.id then
							selected_something = true
							bg_color = tocolor(255, 255, 255, 255)
							local count3 = 1
							local current_slot = getPedWeaponSlot(localPlayer)
							for _, weap2 in ipairs(weaps[slot]) do
								if weap2 and (weap2.dbid~=0 or using_weapon[current_slot]~=0) and weap2.dbid ~= using_weapon[current_slot]  then
									local start_y2 = start_y+(count3)*(item_size+padding)
									dxDrawImage(start_x, start_y2, item_size, item_size, ":rl_items/public/images/items/-" .. weap2.id .. ".png", 0, 0, 0, bg_color, false)
							        dxDrawText(weap2.name, start_x, start_y2, start_x+item_size, start_y2+item_size+20, bg_color, 1.00, fontCheck, "center", "bottom", false, true, false, false, false)
							        dxDrawText(count3, start_x, start_y2, start_x+item_size, start_y2+item_size, bg_color, 1.00, fontCheck, "left", "top", false, true, false, false, false)
							        if not hotkeys then hotkeys = {} end
							        hotkeys[count3] = weap2
							        count3 = count3 + 1
							    end
							end
							if count3 == 1 then
								hotkeys = nil
							end
						end

				        dxDrawImage(start_x, start_y, item_size, item_size, ":rl_items/public/images/items/-" .. weap.id .. ".png", 0, 255, 0, bg_color, false)
				        dxDrawText(weap.name, start_x, start_y, start_x+item_size, start_y+item_size+20, bg_color, 1.00, fontCheck, "center", "bottom", false, true, false, false, false)
				        
				        count2 = count2 + 1
				        break
				    end
		        end
		    end
		end

		if not selected_something or count2 == 0 or not pressed or getTickCount() - pressed > delay then
			killTimer(renderWeaponSelectorTimer)
			pressed = nil
			hotkeys = nil
		end
	end
end
renderWeaponSelectorTimer = setTimer(renderWeaponSelector, 0, 0)

function updateUsingGun(given)
	using_weapon = given
	closeWeaponInteract()
end
addEvent('weapon:updateUsingGun', true)
addEventHandler('weapon:updateUsingGun', resourceRoot, updateUsingGun)

function weaponSwitch(button, press)
	if press and not switching and hotkeys then
		for key, weap in pairs(hotkeys) do
			if tostring(key) == button then
				cancelEvent()
				switching = 'Değiştiriliyor...'
				triggerServerEvent('weapon:switch_weapon_in_same_slot', localPlayer, weap.dbid, weap.slot)
				outputDebugString(switching .. " to " .. weap.dbid)
				pressed = getTickCount()
				hotkeys = nil
				break
			end
		end
	end
end
addEventHandler('onClientKey', root, weaponSwitch)

function weaponSwitch_callback(ok)
	switching = nil
	pressed = getTickCount()
	using_weapon[ok.slot] = ok.dbid
end
addEvent('weapon:weaponSwitch_callback', true)
addEventHandler('weapon:weaponSwitch_callback', root, weaponSwitch_callback)

addEventHandler("onClientPlayerWeaponFire", root, function()
	if source == localPlayer then
		if getElementData(localPlayer, 'weapon_show_selector') ~= '0' then
			if not pressed then
				renderWeaponSelectorTimer = setTimer(renderWeaponSelector, 0, 0)
			end
			pressed = getTickCount()
		end
	end
end)