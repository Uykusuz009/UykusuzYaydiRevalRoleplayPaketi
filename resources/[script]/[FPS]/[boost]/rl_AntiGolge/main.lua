local texture = dxCreateTexture(1, 1);
local shader = dxCreateShader("shader.fx");
engineApplyShaderToWorldTexture(shader, "shad_*");
dxSetShaderValue(shader, "reTexture", texture);

addEventHandler("onClientResourceStop", resourceRoot,
function ()
	engineRemoveShaderFromWorldTexture(shader, "shad_*");
end );