function boya(thePlayer, commandName, target, ...)
	if getElementData(thePlayer, 'mekanik.duty') then
		if not tonumber(target) or not (...) then
			exports.rl_infobox:addBox(thePlayer, "info", "KULLANIM: /" .. commandName .. " [Araç ID] [Renk ...]")
		else
			local username = getPlayerName(thePlayer)
			for i,c in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(target)) then
					theVehicle = c
					break
				end
			end

			if theVehicle then
				local colors = {...}
				local col = {}
				for i = 1, math.min( 4, #colors ) do
					local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
					if r and g and b then
						col[i] = {r=r, g=g, b=b}
					elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
						col[i] = math.floor(tonumber(colors[i]))
					else
						exports.rl_infobox:addBox(thePlayer, "error", "Geçersiz Renk.")
						return
					end
				end
				if not col[2] then col[2] = col[1] end
				if not col[3] then col[3] = col[1] end
				if not col[4] then col[4] = col[2] end

				local set = false
				if type( col[1] ) == "number" then
					set = setVehicleColor(theVehicle, col[1], col[2], col[3], col[4])
				else
					set = setVehicleColor(theVehicle, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
				end

				if set then

                    exports.rl_infobox:addBox(thePlayer, "success", "Araç Rengini Başarıyla Değiştirdin.")

					exports['rl_save']:saveVehicleMods(theVehicle)
				else
                    exports.rl_infobox:addBox(thePlayer, "error", "Geçersiz Araç Id.")
				end
			else
				exports.rl_infobox:addBox(thePlayer, "error", "Araç Bulunamadı.")
			end
		end
	end
end
addCommandHandler("boya", boya, false, false)