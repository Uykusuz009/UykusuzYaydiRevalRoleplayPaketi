local shop = new("DXshop")

function shop.prototype.____constructor(self)
	self.screenSize = Vector2(guiGetScreenSize())
	self.sizeX, self.sizeY = 695, 400
	self.screenX, self.screenY = (self.screenSize.x - self.sizeX) / 2, (self.screenSize.y - self.sizeY) / 2
	
	self.clickTick = 0
	self.maxColumn = 7
	self.maxItem = 21
	
	self.modalVisible = false
	self.selectedProduct = 0

	self.theme = exports.rl_ui:useTheme()
	self.fonts = exports.rl_ui:useFonts()
    self.fonts.regular = exports.kaisen_fonts:getFont("sf-regular", 11)
    self.fonts.bold = exports.kaisen_fonts:getFont("sf-bold", 18)
    self.fonts.light = exports.kaisen_fonts:getFont("sf-light", 9)
    self.fonts.awesome = exports.kaisen_fonts:getFont("FontAwesome", 16)

	self._function = {
		up = function(...) self:up(...) end,
		down = function(...) self:down(...) end,
		open = function(...) self:open(...) end,
		render = function(...) self:render(...) end,
	}
	
	bindKey("mouse_wheel_up", "down", self._function.up)
	bindKey("mouse_wheel_down", "down", self._function.down)
	
	addEvent("shop.open", true)
	addEventHandler("shop.open", root, self._function.open)
end

function shop.prototype.render(self)
	showCursor(true)
	self.timer = setTimer(function()
		dxDrawRectangle(self.screenX, self.screenY, self.sizeX, self.sizeY, exports.rl_ui:rgba(self.theme.GRAY[900]))
		dxDrawText(types[self.show], self.screenX + 20, self.screenY + 20, nil, nil, tocolor(255, 255, 255, 250), 1, self.fonts.bold)
		dxDrawText("tıklayarak istediğiniz ürünü satın alın", self.screenX + 20, self.screenY + 51, nil, nil, tocolor(255, 255, 255, 150), 1, self.fonts.regular)
		
		dxDrawText("", self.screenX + self.sizeX - 40, self.screenY + 20, nil, nil, exports.rl_ui:inArea(self.screenX + self.sizeX - 40, self.screenY + 20, dxGetTextWidth("", 1, self.fonts.awesome), dxGetFontHeight(1, self.fonts.awesome)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, self.fonts.awesome)
		if exports.rl_ui:inArea(self.screenX + self.sizeX - 40, self.screenY + 20, dxGetTextWidth("", 1, self.fonts.awesome), dxGetFontHeight(1, self.fonts.awesome)) and getKeyState("mouse1") and self.clickTick + 500 <= getTickCount() and not self.modalVisible then
			self.clickTick = getTickCount()
			showCursor(false)
			killTimer(self.timer)
			self.timer = nil
		end
	
		self.newX, self.newY, self.countX, self.countY = 0, 0, 0, 0
		for key, value in pairs(shopItems[self.show]) do
			if key > self.scroll and self.countY < self.maxItem then
				dxDrawRectangle(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85, exports.rl_ui:inArea(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85) and exports.rl_ui:rgba(self.theme.GRAY[700]) or exports.rl_ui:rgba(self.theme.GRAY[800]))
				if value[1] == 115 then
					dxDrawImage(self.screenX + 20 + self.newX + 17.5, self.screenY + 15 + self.newY + 75 + 17.5, 50, 50, (fileExists(":rl_items/public/images/items/-" .. value[3] .. ".png") and ":rl_items/public/images/items/-" .. value[3] .. ".png" or ":rl_items/public/images/items/empty.png"))
				else
					dxDrawImage(self.screenX + 20 + self.newX + 17.5, self.screenY + 15 + self.newY + 75 + 17.5, 50, 50, (fileExists(":rl_items/public/images/items/" .. value[1] .. ".png") and ":rl_items/public/images/items/" .. value[1] .. ".png" or ":rl_items/public/images/items/empty.png"))
				end
				dxDrawText("$" .. exports.rl_global:formatMoney(value[2]), self.screenX + 75 + self.newX, self.screenY + self.newY + 160, self.screenX + 50 + self.newX, nil, tocolor(180, 180, 180, 255), 1, self.fonts.light, "center")
				
				if self.show == 6 then
					dxDrawText(getWeaponNameFromID(value[3]) .. " (" .. value[4] .. ")", self.screenX + 75 + self.newX, self.screenY + self.newY + 145, self.screenX + 50 + self.newX, nil, tocolor(180, 180, 180, 255), 1, self.fonts.light, "center")
				end
				
				if value[4] == true then
					if exports.rl_ui:inArea(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85) and getKeyState("mouse1") and self.clickTick + 500 <= getTickCount() and not self.modalVisible then
						self.clickTick = getTickCount()
						self.modalVisible = true
						self.selectedProduct = key
					end
					
					if self.modalVisible then
						local pageSizeX, pageSizeY = 300, 150
						local pageScreenX, pageScreenY = (self.screenSize.x - pageSizeX) / 2, (self.screenSize.y - pageSizeY) / 2
						
						dxDrawRectangle(self.screenX, self.screenY, self.sizeX, self.sizeY, tocolor(0, 0, 0, 200))
						dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, exports.rl_ui:rgba(self.theme.GRAY[800]))
						
						local quantityInput = exports.rl_ui:drawInput({
							position = {
								x = pageScreenX + 20,
								y = pageScreenY + 20
							},
							size = {
								x = pageSizeX - 40,
								y = 30
							},
							radius = DEFAULT_RADIUS,
							padding = 10,

							name = "shop_quantity",

							placeholder = "Miktar",
							value = "",
							helperText = {
								text = "",
								color = self.theme.RED[800]
							},

							variant = "solid",
							color = "gray",

							disabled = false,
							mask = false
						})
						
						local totalPrice = tonumber(quantityInput.value) and tonumber(quantityInput.value) * value[2] or 0
						
						local submitButton = exports.rl_ui:drawButton({
							position = {
								x = pageScreenX + 20,
								y = pageScreenY + 65
							},
							size = {
								x = pageSizeX - 40,
								y = 30
							},

							radius = DEFAULT_RADIUS,
							variant = "rounded",
							alpha = 300,

							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = self.fonts.body.regular,
								scale = 0.9,
							},

							color = "green",
							disabled = false,

							text = "Satın Al ($" .. exports.rl_global:formatMoney(totalPrice) .. ")",
							icon = ""
						})
						
						if submitButton.pressed and self.clickTick + 500 <= getTickCount() then
							self.clickTick = getTickCount()
							local quantity = tonumber(math.floor(tonumber(quantityInput.value)))
							if quantity then
								if quantity >= 1 and quantity <= 10 then
									triggerServerEvent("shop.buy", localPlayer, self.show, self.selectedProduct, quantity)
								elseif quantity > 10 then
									exports.rl_infobox:addBox("error", "Maksimum 10 adet satın alabilirsiniz.")
								else
									exports.rl_infobox:addBox("error", "Minimum 1 adet satın alabilirsiniz.")
								end
							else
								exports.rl_infobox:addBox("error", "Lütfen geçerli bir miktar girin.")
							end
						end
						
						local closeButton = exports.rl_ui:drawButton({
							position = {
								x = pageScreenX + 20,
								y = pageScreenY + 100
							},
							size = {
								x = pageSizeX - 40,
								y = 30
							},
							textProperties = {
								align = "center",
								color = "#FFFFFF",
								font = self.fonts.body.regular,
								scale = 0.9,
							},

							variant = "soft",
							color = "red",
							disabled = false,

							text = "Kapat",
							icon = ""
						})
						
						if closeButton.pressed then
							self.modalVisible = false
						end
					end
				else
					if exports.rl_ui:inArea(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85) and getKeyState("mouse1") and self.clickTick + 500 <= getTickCount() and not self.modalVisible then
						self.clickTick = getTickCount()
						triggerServerEvent("shop.buy", localPlayer, self.show, key)
					end
				end
	
				self.countX = self.countX + 1
				self.countY = self.countY + 1
				self.newX = self.newX + 95
				
				if self.countX == self.maxColumn then
					self.newX = 0
					self.countX = 0
					self.newY = self.newY + 95
				end
			end
		end
	end, 0, 0)
end

function shop.prototype.open(self, element)
	if not isTimer(self.timer) then
		self.show = false
		self.scroll = 0
		self.modalVisible = false
		self.selectedProduct = 0
		self.show = getElementData(element, "shop.type")
		self.timer = setTimer(self._function.render, 500, 1)
	end
end

function shop.prototype.up(self)
    if isTimer(self.timer) then 
        if exports.rl_ui:inArea(self.screenX, self.screenY, self.sizeX, self.sizeY) then 
            if self.scroll > 0 then 
                self.scroll = self.scroll - self.maxColumn
            end
        end
	end
end

function shop.prototype.down(self)
	if isTimer(self.timer) then 
		if exports.rl_ui:inArea(self.screenX, self.screenY, self.sizeX, self.sizeY) then 
			if self.scroll < #shopItems[self.show] - self.maxItem then 
				self.scroll = self.scroll + self.maxColumn
			end
		end
	end
end

load(shop)