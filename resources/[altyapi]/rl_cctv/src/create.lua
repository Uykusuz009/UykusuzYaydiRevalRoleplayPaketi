local cctv = new('CCTV')

function cctv.prototype.____constructor(self)
	--/////////////////////////////////////////////////////////
	self._function = {}
	self._function.render = function(...) self:_render(self) end
	self._function.load = function(...) self:_load(self) end
	self._function.display = function(...) self:_display(self) end
	--/////////////////////////////////////////////////////////
	self.screen = Vector2(guiGetScreenSize())
	self.font = exports.rl_fonts:getFont('BebasNeueBold',12)
	self.font2 = exports.rl_fonts:getFont('BebasNeueRegular',12)
	self.on = false
	self.cam = {
		{1929.7922363281, -1738.6701660156, 23.292699813843, 1930.1812744141, -1739.5089111328, 22.911764144897},
		{2104.4860839844, -1819.6783447266, 17.845899581909, 2104, -1818.8521728516, 17.560821533203},
		{1503.8500976563, -1620.4155273438, 34.390701293945, 1504.2943115234, -1621.2131347656, 33.98250579834},
		{1332.1098632813, -1367.7768554688, 20.461099624634, 1331.3596191406, -1368.3088378906, 20.068439483643},
		{1181.0299072266, -1341.9682617188, 17.987600326538, 1181.1824951172, -1341.0618896484, 17.593641281128},
		{1836.3731689453, -1318.5660400391, 20.100700378418, 1836.8768310547, -1319.3624267578, 19.765930175781},
		{2234.0607910156, -1635.8319091797, 20.857799530029, 2234.1801757813, -1636.7800292969, 20.563255310059},
	}
	--/////////////////////////////////////////////////////////
	self:_get(self)
end

function cctv.prototype._render(self)
	dxDrawImage(0,0,self.screen.x,self.screen.y,'assets/line.png', 0, 0, 0, tocolor(255,255,255,100))
	dxDrawRectangle(0,0,self.screen.x,self.screen.y, tocolor(0,0,0,125))
	if getKeyState('arrow_r') and self.click+400 <= getTickCount() then
		self.click = getTickCount()
		if self.camstate < 7 then
			self.camstate = self.camstate + 1
		end
	end

	if getKeyState('arrow_l') and self.click+400 <= getTickCount() then
		self.click = getTickCount()
		if self.camstate > 1 then
			self.camstate = self.camstate - 1
		end
	end

	if getKeyState('backspace') and self.click+400 <= getTickCount() then
		self.click = getTickCount()
		self:_display(self)
	end

	for index, value in ipairs(self.cam) do
		if self.camstate == index then
			setCameraMatrix(value[1], value[2], value[3], value[4], value[5], value[6])
			dxDrawRectangle(0, self.screen.y/2-540, 2000, 100, tocolor(0, 0, 0, 500))
			dxDrawRectangle(0, self.screen.y/2+460, 2000, 100, tocolor(0, 0, 0, 500))
			dxDrawRectangle(25, 25, 35, 25, tocolor(225,75,75))
			dxDrawText('CCTV CAM', 65, 25, nil, nil, tocolor(225, 225, 225, 255), 1, self.font)
			dxDrawText('"< >" yön tuşları ile kameralar arası geçiş yapabilirsiniz.', 25, self.screen.y-45, nil, nil, tocolor(225, 225, 225, 255), 0.75, self.font2)
			dxDrawText('çıkmak için "backspace"', 25, self.screen.y-25, nil, nil, tocolor(225, 225, 225, 255), 0.75, self.font2)
			dxDrawText('Lokasyon '..getZoneName(value[1], value[2], value[3])..'', 25, 55, nil, nil, tocolor(225, 225, 225, 255), 0.8, self.font)
			dxDrawText('Live - '..index..'', 25, 70, nil, nil, tocolor(225, 225, 225, 255), 0.8, self.font)
		end
	end
end

function cctv.prototype._load(self)
	self.rot = self.rot + 5
	dxDrawRectangle(0,0,self.screen.x,self.screen.y, tocolor(0,0,0,125))
    dxDrawImage(self.screen.x/2-32, self.screen.y/2-32, 32, 32, 'assets/loading.png', self.rot)
end

function cctv.prototype._display(self)
	if self.on then
		self.on = false
		if isTimer(self.timer) then
			self.on = false
			killTimer(self.timer)
    	end
    	showCursor(false)
		showChat(true)
		localPlayer:setData('minimap:close', false)
        localPlayer:setData('hud:close', false)
        localPlayer:setData('hunger:close', false)
		triggerServerEvent('cctv.stop', localPlayer)
    	removeEventHandler('onClientRender', root, self._function.load)
		removeEventHandler('onClientRender', root, self._function.render)
	else
		self.click = 0
		self.camstate = 1
		self.rot = 0
		showCursor(true)
		showChat(false)
		addEventHandler('onClientRender', root, self._function.load, true, 'low-10')
		self.on = true
		if isTimer(self.timer) then
			self.on = false
			killTimer(self.timer)
    	end
		self.timer = Timer(function()
			removeEventHandler('onClientRender', root, self._function.load)
			addEventHandler('onClientRender', root, self._function.render, true, 'low-10')
		end, 1700, 1)
		-- Kamera açıldığında gerekli verileri kapat
		localPlayer:setData('minimap:close', true)
        localPlayer:setData('hud:close', true)
        localPlayer:setData('hunger:close', true)
	end
end

function cctv.prototype._get(self)
	addEvent('cctv.display', true)
	addEventHandler('cctv.display', root, self._function.display)
end

cctv = load(cctv)
