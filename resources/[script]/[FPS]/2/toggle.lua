local antiLag_settings = {
	status		= "off",
	cmd			= "fpsboost",
	farClipDist	= 198,
	gfx_table	= {
		"sm_des_bush2",
		"sm_des_bush3",
		"shad_car",
		"sm_des_bush1",
		"newtreeleaves128",
		"cloudmasked",
		"coronastar",
		"splash_up1",
		"splash_up2",
	}
}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		SHADER_FPS = dxCreateShader("texture/shader.fx")
		TEXTURE_FPS = dxCreateTexture("texture/invisible.png")
		if (SHADER_FPS and TEXTURE_FPS) then
			dxSetShaderValue(SHADER_FPS, "Tex0", TEXTURE_FPS)
		end
	end
)

addCommandHandler(antiLag_settings.cmd,
	function(x)
		if (not TEXTURE_FPS) then
			return outputChatBox("* HATA: Lütfen daha sonra tekrar deneyiniz.", 255, 0, 0)
		end
		
		if (antiLag_settings.status == "off") then
			antiLag_settings.status = "on"
			
			setFarClipDistance(antiLag_settings.farClipDist)
			setFogDistance(antiLag_settings.farClipDist)
			setCloudsEnabled(false)
			setBirdsEnabled(false)
			setOcclusionsEnabled(false)
			
			for index, shader in pairs(antiLag_settings.gfx_table) do
				engineApplyShaderToWorldTexture(SHADER_FPS, tostring(shader))
			end
			
			outputChatBox("* Anti-lag aktif edildi, FPS'inizde artış yaşanabilir.", 0, 255, 0)
		else
			antiLag_settings.status = "off"
			
			setOcclusionsEnabled(true)
			resetFarClipDistance()
			resetFogDistance()
			setCloudsEnabled(true)
			setBirdsEnabled(true)
			
			for index, shader in pairs(antiLag_settings.gfx_table) do
				engineRemoveShaderFromWorldTexture(SHADER_FPS, tostring(shader))
			end
			
			outputChatBox("* Anti-lag de-aktif edildi, bilgisayarınız kötüyse FPS'inizde düşüş yaşanabilir.", 0, 255, 0)
		end
	end
)