function loadedWeapon(target, tablem)
	if isElement(window) then destroyElement(window) end
	window = guiCreateWindow(0, 0, 549, 335, "Reval Roleplay - El koyma sistemi (( "..getPlayerName(target):gsub('_',' ').." ))", false)
	guiWindowSetSizable(window, false)
	exports.rl_global:centerWindow(window)

	tab = guiCreateTabPanel(10,20,539,275,false,window)
	tab1 = guiCreateTab("Silahlar", tab)

	grid = guiCreateGridList(3, 18, 525, 215, false, tab1)
	guiGridListAddColumn(grid, "Silah Adı", 0.5)
	guiGridListAddColumn(grid, "Şuanki hakkı", 0.4)
	for i, v in ipairs(tablem) do
		if v[1] == 115 then
			local itemid = v[1]
			local itemvalue = v[2]
			local row = guiGridListAddRow(grid)
			local silahHak = #tostring(explode(":", itemvalue)[6])>0 and explode(":", itemvalue)[6] or 3
			silahHak = not restrictedWeapons[tonumber(explode(":", itemvalue)[1])] and silahHak or "-"

			local checkString = string.sub(exports['rl_items']:getItemName(itemid, itemvalue), -4)
			if (checkString == " (D)")  then
				silahHak = "-"
			end
			
			silahHak = itemid == 115 and silahHak or "-"
		  	guiGridListSetItemText(grid, row, 1, tostring(exports['rl_items']:getItemName(v[1], v[2])), false, true)
		  	guiGridListSetItemText(grid, row, 2, silahHak, false, true)
		  	guiGridListSetItemData(grid, row, 2, tostring(explode(":", itemvalue)[2]))

	end
	end

	use = guiCreateButton(9, 300, 267, 31, "Elkoy", false, window)
	addEventHandler('onClientGUIClick',use,function()
		if guiGetSelectedTab(tab) == tab1 then
			local row = guiGridListGetSelectedItem(grid)
			if row ~= -1 then
				triggerServerEvent(getResourceName(getThisResource())..' >> takeGun',localPlayer,localPlayer,target,guiGridListGetItemData(grid, row, 2))
				destroyElement(window)
			else
				outputChatBox('[!]#D6D6D6 Lütfen listeden bir silah seçiniz', 180, 0, 0, true)
			end
		end


	end,false)
	close = guiCreateButton(286, 300, 254, 31, "Arayüzü Kapat", false, window)
		addEventHandler('onClientGUIClick',close,function()
						destroyElement(window)

	end,false)
end
addEvent(getResourceName(getThisResource())..' >> loadedWeapon', true)
addEventHandler(getResourceName(getThisResource())..' >> loadedWeapon', root, loadedWeapon)
