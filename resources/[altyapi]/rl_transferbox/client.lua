screenSize = Vector2(guiGetScreenSize())

TransferBox = {}
TransferBox.fonts = {}
TransferBox.fonts.Regular = dxCreateFont("public/fonts/ClashDisplay-Regular.otf", exports.rl_ui:respc(15))
TransferBox.fonts.Bold = dxCreateFont("public/fonts/ClashDisplay-Bold.otf", exports.rl_ui:respc(85), true)
TransferBox.fonts.Light = dxCreateFont("public/fonts/ClashDisplay-Light.otf", exports.rl_ui:respc(15))
TransferBox.visible = false
TransferBox.outerPadding = exports.rl_ui:resp(50)
TransferBox.containerPosition = {
	x = TransferBox.outerPadding,
	y = TransferBox.outerPadding * 3
}
TransferBox.progressSize = {
	x = exports.rl_ui:resp(741),
	y = 15
}
TransferBox.progressPosition = {
	x = screenSize.x / 2 - TransferBox.progressSize.x / 2,
	y = screenSize.y - TransferBox.outerPadding - TransferBox.progressSize.y
}
TransferBox.sprites = {
	progress_fg = svgCreate(TransferBox.progressSize.x, TransferBox.progressSize.y, "public/images/progress-fg.svg"),
	progress_bg = svgCreate(TransferBox.progressSize.x, TransferBox.progressSize.y, "public/images/progress-bg.svg"),
	background_in = svgCreate(screenSize.x, 250, "public/images/background-in.svg")
}
TransferBox.carShaderSource = " texture renderTexture; sampler renderSampler = sampler_state { Texture = <renderTexture>; }; texture wireTexture; sampler wireSampler = sampler_state { Texture = <wireTexture>; }; float prog = 0; float feather = 0.1; float4 PixelShaderFunction(float4 Diffuse : COLOR0, float2 TexCoord : TEXCOORD0) : COLOR0 { float4 render = tex2D(renderSampler, TexCoord); float4 wire = tex2D(wireSampler, TexCoord); if(TexCoord.x > prog) return wire; else if(TexCoord.x > prog-feather) { float p = (TexCoord.x - (prog-feather))/feather; return lerp(wire, render, 1-p*p); } else return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
TransferBox.skinShaderSource = " texture renderTexture; sampler renderSampler = sampler_state { Texture = <renderTexture>; }; texture wireTexture; sampler wireSampler = sampler_state { Texture = <wireTexture>; }; texture cloudTexture; sampler cloudSampler = sampler_state { Texture = <cloudTexture>; }; float prog = 0; float feather = 0.1; float4 PixelShaderFunction(float4 Diffuse : COLOR0, float2 TexCoord : TEXCOORD0) : COLOR0 { float4 render = tex2D(renderSampler, TexCoord); float4 wire = tex2D(wireSampler, TexCoord); float4 cloud = tex2D(cloudSampler, TexCoord); float c = 1-cloud.r; if(c > prog) return wire; else if(c > prog-feather) { float p = (c - (prog-feather))/feather; return lerp(wire, render, 1-p*p); } else return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
TransferBox.enums = {}
TransferBox.enums.elements = {
	Cars = "cars",
	Skins = "skins"
}
TransferBox.currentElement = TransferBox.enums.elements.Skins
TransferBox.currentElementIndex = 1
TransferBox.elementCounts = {
	[TransferBox.enums.elements.Cars] = 3,
	[TransferBox.enums.elements.Skins] = 5
}
TransferBox.progresses = {
	[TransferBox.enums.elements.Cars] = {0, 0},
	[TransferBox.enums.elements.Skins] = {0, 0}
}
TransferBox.progressTickCount = 0
TransferBox.percentage = 25
TransferBox.downloaded = 0
TransferBox.total = 0
theme = {
	BLACK = "#000000",
	GRAY = "#BDBDBD",
	WHITE = "#FFFFFF"
}
TransferBox.music = nil

function TransferBox.renderElements()
	if getTickCount() - TransferBox.progressTickCount > 5 then
		TransferBox.progressTickCount = getTickCount()
		TransferBox.progresses[TransferBox.currentElement][1] = math.min(TransferBox.progresses[TransferBox.currentElement][1] + 0.1, 100)
		if TransferBox.progresses[TransferBox.currentElement][1] == 100 then
			TransferBox.progresses[TransferBox.currentElement][2] = math.min(TransferBox.progresses[TransferBox.currentElement][2] + 1, 255)
			if TransferBox.progresses[TransferBox.currentElement][2] == 255 then
				TransferBox.currentElementIndex = TransferBox.currentElementIndex + 1
				TransferBox.progresses[TransferBox.currentElement][1] = 0
				TransferBox.progresses[TransferBox.currentElement][2] = 0
				if TransferBox.currentElementIndex > TransferBox.elementCounts[TransferBox.currentElement] then
					TransferBox.currentElementIndex = 1
					TransferBox.currentElement = TransferBox.currentElement == TransferBox.enums.elements.Cars and TransferBox.enums.elements.Skins or TransferBox.enums.elements.Cars
				elseif TransferBox.currentElement == TransferBox.enums.elements.Cars then
					TransferBox.carShader:setValue("prog", 0)
					TransferBox.carShader:setValue("wireTexture", TransferBox.elementSprites.car[TransferBox.currentElementIndex].wireframe)
					TransferBox.carShader:setValue("renderTexture", TransferBox.elementSprites.car[TransferBox.currentElementIndex].render)
				else
					TransferBox.skinShader:setValue("prog", 0)
					TransferBox.skinShader:setValue("wireTexture", TransferBox.elementSprites.skin[TransferBox.currentElementIndex].wireframe)
					TransferBox.skinShader:setValue("renderTexture", TransferBox.elementSprites.skin[TransferBox.currentElementIndex].render)
				end
			end
		end
	end
	
	if TransferBox.currentElement == TransferBox.enums.elements.Cars then
		TransferBox.carShader:setValue("prog", TransferBox.progresses[TransferBox.currentElement][1] / 100)
		dxDrawImage(({
			x = screenSize.x / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).x / 2,
			y = screenSize.y / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).y / 2
		}).x, ({
			x = screenSize.x / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).x / 2,
			y = screenSize.y / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).y / 2
		}).y, ({
			x = screenSize.x,
			y = screenSize.x * 0.5625
		}).x, ({
			x = screenSize.x,
			y = screenSize.x * 0.5625
		}).y, TransferBox.carShader)
		
		if TransferBox.progresses[TransferBox.currentElement][1] == 100 then
			dxDrawImage(({
			x = screenSize.x / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).x / 2,
			y = screenSize.y / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).y / 2
			}).x, ({
			x = screenSize.x / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).x / 2,
			y = screenSize.y / 2 - ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).y / 2
			}).y, ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).x, ({
				x = screenSize.x,
				y = screenSize.x * 0.5625
			}).y, TransferBox.elementSprites.car[TransferBox.currentElementIndex].lights, 0, 0, 0, tocolor(255, 255, 255, TransferBox.progresses[TransferBox.currentElement][2]))
		end
	else
		TransferBox.skinShader:setValue("prog", TransferBox.progresses[TransferBox.currentElement][1] / 100)
		dxDrawImage(({
			x = screenSize.x / 2 - screenSize.y / 2,
			y = 0
		}).x, ({
			x = screenSize.x / 2 - screenSize.y / 2,
			y = 0
		}).y, ({
			x = screenSize.y,
			y = screenSize.y
		}).x, ({
			x = screenSize.y,
			y = screenSize.y
		}).y, TransferBox.skinShader)
	end
end

function TransferBox.renderBackground()
	dxDrawImage(0, 0, screenSize.x, screenSize.y, "public/images/background.png")
	TransferBox.renderElements()
end

function TransferBox.renderProgress(color)
	dxDrawImage(TransferBox.progressPosition.x, TransferBox.progressPosition.y, TransferBox.progressSize.x, TransferBox.progressSize.y, TransferBox.sprites.progress_bg)
	dxDrawImageSection(TransferBox.progressPosition.x, TransferBox.progressPosition.y, TransferBox.percentage / 100 * TransferBox.progressSize.x, TransferBox.progressSize.y, 0, 0, TransferBox.percentage / 100 * TransferBox.progressSize.x, TransferBox.progressSize.y, TransferBox.sprites.progress_fg)
	dxDrawImage(TransferBox.progressPosition.x - 20, TransferBox.progressPosition.y - 20, TransferBox.progressSize.x + 40, TransferBox.progressSize.y + 40, "public/images/progress-shade.png")
	dxDrawText("Sistemler yükleniyor", TransferBox.progressPosition.x, TransferBox.progressPosition.y - exports.rl_ui:resp(35), 0, 0, exports.rl_ui:rgba(theme[color], 1), 1, TransferBox.fonts.Regular)
	dxDrawText("İndirme İşlemi", TransferBox.progressPosition.x, TransferBox.progressPosition.y - exports.rl_ui:resp(55), 0, 0, exports.rl_ui:rgba(theme[color], 0.57), 0.7, TransferBox.fonts.Regular)
	dxDrawText(TransferBox.downloaded .. "mb/" .. TransferBox.total .. "mb", TransferBox.progressPosition.x, TransferBox.progressPosition.y - exports.rl_ui:resp(25), TransferBox.progressSize.x + TransferBox.progressPosition.x, 0, exports.rl_ui:rgba(theme[color], 0.7), 0.6, TransferBox.fonts.Regular, "right")
end

function TransferBox.render()
	if not TransferBox.visible then
		return
	end
	
	if not localPlayer:getData("logged") then
		TransferBox.renderBackground()
	else
		dxDrawImage(0, screenSize.y - 250, screenSize.x, 250, TransferBox.sprites.background_in)
	end
	
	TransferBox.renderProgress("WHITE")
end
addEventHandler("onClientRender", root, TransferBox.render, true, "high-9999")

function TransferBox.hide()
	TransferBox.visible = false
end

function TransferBox.show()
	if not localPlayer:getData("logged") then
		showChat(false)
	end
	
	setTransferBoxVisible(false)
	TransferBox.visible = true
end

addEventHandler("onClientResourceStart", root, function(startedRes)
	if startedRes == getThisResource() then
		TransferBox.elementSprites = {
			car = {
				[1] = {
					render = dxCreateTexture("public/images/cars/car_render1.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/cars/car_render1_wireframe.dds", "dxt5", true),
					lights = dxCreateTexture("public/images/cars/car_render1_lights.dds", "dxt5", true)
				},
				[2] = {
					render = dxCreateTexture("public/images/cars/car_render2.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/cars/car_render2_wireframe.dds", "dxt5", true),
					lights = dxCreateTexture("public/images/cars/car_render2_lights.dds", "dxt5", true)
				},
				[3] = {
					render = dxCreateTexture("public/images/cars/car_render3.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/cars/car_render3_wireframe.dds", "dxt5", true),
					lights = dxCreateTexture("public/images/cars/car_render3_lights.dds", "dxt5", true)
				}
			},
			skin = {
				[1] = {
					render = dxCreateTexture("public/images/skins/skins1.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/skins/skins1_wireframe.dds", "dxt5", true)
				},
				[2] = {
					render = dxCreateTexture("public/images/skins/skins2.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/skins/skins2_wireframe.dds", "dxt5", true)
				},
				[3] = {
					render = dxCreateTexture("public/images/skins/skins3.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/skins/skins3_wireframe.dds", "dxt5", true)
				},
				[4] = {
					render = dxCreateTexture("public/images/skins/skins4.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/skins/skins4_wireframe.dds", "dxt5", true)
				},
				[5] = {
					render = dxCreateTexture("public/images/skins/skins5.dds", "dxt5", true),
					wireframe = dxCreateTexture("public/images/skins/skins5_wireframe.dds", "dxt5", true)
				}
			},
			cloud = dxCreateTexture("public/images/skins/skins_noise.dds", "dxt5", true)
		}
		
		TransferBox.carShader = dxCreateShader(TransferBox.carShaderSource)
		TransferBox.carShader:setValue("wireTexture", TransferBox.elementSprites.car[TransferBox.currentElementIndex].wireframe)
		TransferBox.carShader:setValue("renderTexture", TransferBox.elementSprites.car[TransferBox.currentElementIndex].render)
		TransferBox.carShader:setValue("prog", 0)
		TransferBox.skinShader = dxCreateShader(TransferBox.skinShaderSource)
		TransferBox.skinShader:setValue("wireTexture", TransferBox.elementSprites.skin[TransferBox.currentElementIndex].wireframe)
		TransferBox.skinShader:setValue("renderTexture", TransferBox.elementSprites.skin[TransferBox.currentElementIndex].render)
		TransferBox.skinShader:setValue("cloudTexture", TransferBox.elementSprites.cloud)
		TransferBox.skinShader:setValue("prog", 0)
		
		if isTransferBoxVisible() then
			TransferBox.show()
		end
		
		return
	end
	TransferBox.hide()
end)

addEventHandler("onClientTransferBoxProgressChange", root, function(downloadedSize, totalSize)
	TransferBox.percentage = math.floor(math.min(downloadedSize / totalSize * 100, 100))
	TransferBox.downloaded = string.format("%.2f", downloadedSize / 1024 / 1024)
	TransferBox.total = string.format("%.2f", totalSize / 1024 / 1024)
	if not TransferBox.visible then
		TransferBox.show()
	end
end)