local texturesimg = {
{"img/2.png", "particleskid"},
{"img/3.png", "cloudmasked"},
{"img/3.png", "cardebris_01"},
{"img/3.png", "cardebris_02"},
{"img/3.png", "cardebris_03"},
{"img/3.png", "cardebris_04"},
{"img/3.png", "cardebris_05"},
{"img/off.png", "vehiclelights128"},
{"img/on.png", "vehiclelightson128"},
{"img/3.png", "cloudhigh"}}
addEventHandler("onClientResourceStart", resourceRoot, function()
  -- upvalues: texturesimg
  for i = 1, #texturesimg do
    local shader = dxCreateShader("chaticon.fx")
    engineApplyShaderToWorldTexture(shader, texturesimg[i][2])
    dxSetShaderValue(shader, "gTexture", dxCreateTexture(texturesimg[i][1]))
  end
end
)

--[[
SparroW MTA : https://sparrow-mta.blogspot.com/
Facebook : https://www.facebook.com/sparrowgta/
İnstagram : https://www.instagram.com/sparrowmta/
Discord : https://discord.gg/DzgEcvy
]]--




