blackMales = { 310, 311, 300, 301, 302, 297, 268, 269, 270, 271, 272, 7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = { 306, 307, 309, 312, 303, 299, 291, 292, 293, 294, 1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {290, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = { 298, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
local window, editing_window = nil
local previewPed = nil
local defaultModel = 211

function fittingSk()
	return fittingskins
end

function createShopPed()
	local ped = createPed(defaultModel, 2931.212890625, 2119.7138671875, 18.390625)
	setElementFrozen(ped, true)
	setElementRotation(ped, 0, 0, 277.49966430664)
	setElementDimension(ped, 0)
	setElementInterior(ped, 0)

	setElementData(ped, 'name', 'Reval Dupont', false)
	setElementData(ped, "talk", 1, true)

	addEventHandler( 'onClientPedWasted', ped,
		function()
			setTimer(
				function()
					destroyElement(ped)
					createShopPed()
				end, 20000, 1)
		end, false)

	addEventHandler( 'onClientPedDamage', ped, cancelEvent, false )
	addEventHandler( 'onClientClick', root,
		function(button, state, absX, absY, wx, wy, wz, element)
			if button == 'right' and state == 'down' and element == ped and not window then
				local x, y, z = getElementPosition(element)
				if getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) < 3 then
					triggerServerEvent('clothing:list', resourceRoot)
				end
			end
		end, false)

	previewPed = ped
end

addEventHandler( 'onClientResourceStart', resourceRoot, createShopPed )

-- gui to show all clothing items
local screen_width, screen_height = guiGetScreenSize()
local width, height = 700, math.min(400, math.max(180, math.ceil(screen_height / 4)))
local list, checkbox, grid, editing_item = nil

local function resetPed()
	setElementModel(previewPed, defaultModel)
	setElementData(previewPed, 'clothing_id', nil, false)
	setElementRotation(previewPed, 0, 0, 155)
end

local function closeEditingWindow()
	if editing_window then
		destroyElement(editing_window)
		editing_window = nil

		guiSetInputMode('allow_binds')

		editing_item = nil
	end
end

local function closeWindow()
	if window then
		destroyElement(window)
		window = nil
	end

	closeEditingWindow()

	resetPed()
end

-- forcibly close the window upon streaming out
addEventHandler('onClientElementStreamOut', resourceRoot, closeWindow)
addEventHandler('onClientResourceStop', resourceRoot, closeWindow)

-- returns the table by [skin] = true
local function getFittingSkins()
	local race, gender = getElementData(localPlayer, 'race'), getElementData(localPlayer, 'gender')
	local temp = fittingSk()

	local t = {}
	for k, v in ipairs(temp[gender][race]) do
		t[v] = true
	end
	return t
end

-- called every once in a while when (de-)selecting the 'only show fitting' checkbox
local function updateGrid()
	-- clean up a little beforehand
	guiGridListClear(grid)

	local only_fitting = guiCheckBoxGetSelected(checkbox)
	local fitting_skins = getFittingSkins()

	for k, v in ipairs(list) do
		-- price 0 might be disabled, dont show it if the player doesnt have a key
		if canBuySkin(localPlayer, v) or canEdit(localPlayer) then
			-- either display all skins, or only those matching the race/gender
			if not only_fitting or fitting_skins[v.skin] then
				local row = guiGridListAddRow(grid)
				guiGridListSetItemText(grid, row, 1, tostring(v.id), false, true)
				guiGridListSetItemData(grid, row, 1, tostring(k)) -- index in [list]
				guiGridListSetItemText(grid, row, 2, tostring(v.description), false, false)
				guiGridListSetItemText(grid, row, 3, tostring(v.skin), false, true)
				guiGridListSetItemText(grid, row, 4, v.price == 0 and 'N/A' or ('$' .. exports.rl_global:formatMoney(v.price)), false, false)
			end
		end
	end
end

addEvent('clothing:list', true)
addEventHandler('clothing:list', resourceRoot,
	function(list_)
		closeWindow()
		local margin = 30
		window = guiCreateWindow(screen_width - width - margin+20, screen_height - height-margin, width, height, 'Özel Kıyafet Mağazası', false)
		guiWindowSetSizable(window, false)

		grid = guiCreateGridList(10, 25, width - 20, height - 60, false, window)
		guiGridListAddColumn(grid, 'ID', 0.07)
		guiGridListAddColumn(grid, 'Kıyafet Adı', 0.7)
		guiGridListAddColumn(grid, 'Model ID', 0.1)
		guiGridListAddColumn(grid, 'Fiyat', 0.1)

		local close = guiCreateButton(width - 110, height - 30, 100, 25, 'Kapat', false, window)
		addEventHandler('onClientGUIClick', close, closeWindow, false)

		local buy = guiCreateButton(width - 220, height - 30, 100, 25, 'Satın Al', false, window)
		guiSetEnabled(buy, false)

		checkbox = guiCreateCheckBox(width - 380, height - 33, 155, 22, 'Sadece giyebileceğiniz kıyafetler', true, false, window)
		addEventHandler('onClientGUIClick', checkbox, updateGrid, false)

		local scrollbar = guiCreateScrollBar(120, height - 32, 185, 22, true, false, window)
		guiSetProperty(scrollbar, "StepSize", "0.0028")
		addEventHandler('onClientGUIScroll', scrollbar,
			function()
				local rotation = tonumber(guiGetProperty(source, "ScrollPosition"))
				setElementRotation(previewPed, 0, 0, 155 + rotation * 360)
			end, false)

		local newedit = nil
		if canEdit(localPlayer) then
			newedit = guiCreateButton(10, height - 30, 100, 25, 'Yeni Kıyafet Ekle', false, window)
		end


		-- fill the skins list
		list = sortList(list_)
		updateGrid()

		-- event handler for previewing items
		addEventHandler('onClientGUIClick', grid,
			function(button)
				if button == 'left' then
					-- update the preview ped to reflect actual clothing changes
					local row, column = guiGridListGetSelectedItem(grid)
					if row == -1 then
						resetPed()

						guiSetEnabled(buy, false)

						if newedit then
							guiSetText(newedit, 'Yeni Kıyafet Ekle')
						end
					else
						local item = list[tonumber(guiGridListGetItemData(grid, row, 1))]
						if item then
							setElementModel(previewPed, item.skin)
							setElementData(previewPed, 'clothing_id', item.id, false)

							guiSetEnabled(buy, item.price == 0 or exports.rl_global:hasMoney(localPlayer, item.price))

							if newedit then
								guiSetText(newedit, 'Edit')
							end
						else
							outputDebugString('Clothing preview broke, aw.')
							guiSetEnabled(buy, false)
						end
					end

					-- we selected another row, so tweak that a bit
					closeEditingWindow()
				end
			end, false)

		-- buying things
		addEventHandler('onClientGUIClick', buy,
			function(button)
				if button == 'left' then
					local row, column = guiGridListGetSelectedItem(grid)
					if row ~= -1 then
						local item = list[tonumber(guiGridListGetItemData(grid, row, 1))]
						if item then
							triggerServerEvent('clothing:buy', resourceRoot, item.id)
						end
					end
				end
			end, false)

		-- new/edit
		if newedit then
			addEventHandler('onClientGUIClick', newedit,
				function(button)
					if button == 'left' then
						createEditWindow()
					end
				end, false)
		end


	end, false)

-- editing window
local editing_width, editing_height = 400, 145
function createEditWindow()
	if editing_window then
		destroyElement(editing_window)
	end

	-- prepare the gui
	editing_window = guiCreateWindow((screen_width - editing_width) / 2, (screen_height - editing_height) / 2, editing_width, editing_height, 'Kıyafet Ekleme Arayüzü', false)
	guiWindowSetSizable(editing_window, false)

	-- just really build a tiny list of elements
	local desc = { { 'skin', 'Model ID' }, { 'url', 'URL'}, { 'description', 'Kıyafet Adı'}, { 'price', 'Fiyat ($)'} }
	for k, v in ipairs(desc) do
		v.label = guiCreateLabel(10, 22 * k + 3, 100, 22, v[2] .. ':', false, editing_window)
		guiLabelSetHorizontalAlign(v.label, 'right')

		v.edit = guiCreateEdit(115, 22 * k, editing_width - 125, 22, '', false, editing_window)
	end

	local row, column = guiGridListGetSelectedItem(grid)
	if row == -1 then
		editing_item = nil
	else
		editing_item = tonumber(guiGridListGetItemData(grid, row, 1))

		-- pre-select values
		for k, v in ipairs(desc) do
			guiSetText(v.edit, tostring(list[editing_item][v[1]]))

			-- can't edit the url afterwards, though it'll be copied to your clipboard
			if v[1] == 'url' then
				-- reduce the size of the original widget
				local copy_width = 70
				local width, height = guiGetSize(v.edit, false)
				guiSetSize(v.edit, width - copy_width, height, false)

				local x, y = guiGetPosition(v.edit, false)

				-- stick a button next to it
				local copy = guiCreateButton(x + width - copy_width, y, copy_width, height, 'Kopyala', false, editing_window)
				addEventHandler('onClientGUIClick', copy,
					function(button)
						if button == 'left' then
							local text = guiGetText(v.edit)
							setClipboard(text)
							outputChatBox('[!] #FFFFFF \'' .. text .. '\' başarıyla kopyalandı.', 0, 255, 0, true)
						end
					end, false)
			end
		end
	end

	local discard = guiCreateButton(10, editing_height - 30, 100, 25, 'Vazgeç', false, editing_window)
	addEventHandler('onClientGUIClick', discard, closeEditingWindow, false)

	local save = guiCreateButton(editing_width - 110, editing_height - 30, 100, 25, 'Kaydet', false, editing_window)
	addEventHandler('onClientGUIClick', save,
		function()
			-- it's really only transferring edited values to the server
			local values = {}
			for k, v in ipairs(desc) do
				local value = guiGetText(v.edit)
				if k == 1 or k == 4 then
					value = tonumber(value)
				end
				values[v[1]] = value
			end
			values.id = editing_item and list[editing_item].id or nil

			triggerServerEvent('clothing:save', resourceRoot, values)

			closeEditingWindow()
		end, false)

	if editing_item then
		local delete = guiCreateButton(editing_width / 2 - 50, editing_height - 30, 100, 25, 'Sil', false, editing_window)
		addEventHandler('onClientGUIClick', delete,
			function()
				triggerServerEvent('clothing:delete', resourceRoot, list[editing_item].id)

				closeEditingWindow()
			end, false)
	end

	-- allow binds for editing
	guiSetInputMode('no_binds_when_editing')
end
