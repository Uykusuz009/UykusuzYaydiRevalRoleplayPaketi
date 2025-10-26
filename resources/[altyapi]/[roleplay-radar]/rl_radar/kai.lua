local sx, sy = guiGetScreenSize()
local panelWidth, panelHeight = 1366, 768
local x, y = sx / panelWidth, sy / panelHeight

local font = exports.kaisen2_fonts:getFont("ramofont3",10*x)
local font2 = exports.kaisen2_fonts:getFont("trojfont1",7*x)
local font3 = exports.kaisen2_fonts:getFont("trojfont1",5.7*x)

local panelWidth, panelHeight = 1920, 1080
local scaleX, scaleY = sx/panelWidth, sy/panelHeight

local safeZones = {
    -- {x = 1580.99609375, y = 1799.5048828125, z = 2083.376953125, radius = 50, dimension = 144, interior = 0},
    -- {x = 383.720703125, y = -2057.5234375, z = 7.8359375, radius = 50},
    -- {x = 1187.146484375, y = -1323.5322265625, z = 13.55900859832, radius = 50},
    -- {x = 1542.0126953125, y = -1675.3994140625, z = 13.553670883179, radius = 50},
    -- {x = 1941.783203125, y = -1775.978515625, z = 13.640625, radius = 50},
    -- {x = 2296.5546875, y = -2333.5849609375, z = 13.546875, radius = 70}
}


local function isPlayerInSafeZone(player)
    for _, zone in ipairs(safeZones) do
        local px, py, pz = getElementPosition(player)
        local distance = getDistanceBetweenPoints3D(px, py, pz, zone.x, zone.y, zone.z)
        if distance <= zone.radius then
            if (not zone.dimension or getElementDimension(player) == zone.dimension) and
               (not zone.interior or getElementInterior(player) == zone.interior) then
                return true
            end
        end
    end
    return false
end

function voicePanel()
    if not getElementData(localPlayer, "logged") then return end
	if (getElementData(localPlayer, "hud_settings").radar ~= 1) then return end
	if (getElementDimension(localPlayer) ~= 0) then return end
	if getElementData(localPlayer, "hudkapa") == true then return end

    currentVoiceMode = tonumber(getElementData(localPlayer, "currentVoice")) or 1

    -- Widen the location rectangle and shift the microphone rectangle to the right
    rectangle(35 * scaleX, 760 * scaleY, 351 * scaleX, 60 * scaleY, tocolor(26, 26, 26, 220), {0.5, 0.5, 0.5, 0.5})
   -- rectangle(325 * scaleX, 760 * scaleY, 65 * scaleX, 50 * scaleY, tocolor(26, 26, 26, 220), {0.5, 0.5, 0.5, 0.5})

	dxDrawText("SINIRLI SÜRELI TEKLIF!", 50 * scaleX, 770 * scaleY, nil, nil, tocolor(200, 150, 50, 255), 1, exports.kaisen2_fonts:getFont("ramofont3", 11 * scaleX), "left")
    dxDrawText("Her bakiye yüklemenizde %25 ekstra bakiye!", 50 * scaleX, 790 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, exports.kaisen2_fonts:getFont("ramofont3", 11 * scaleX), "left")

	--dxDrawText((getZoneName(getElementPosition(localPlayer)) or "BILINMIYOR"), 355 * scaleX, 990 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, exports.kaisen2_fonts:getFont("SweetSixteen", 25 * scaleX), "right")

    if currentVoiceMode >= 1 then
        if getElementData(localPlayer, "konusuyor") then
            dxDrawText(" ", 350 * scaleX, 770 * scaleY, nil, nil, tocolor(0, 182, 148, 255), 1, exports.kaisen2_fonts:getFont("AwesomeFont", 12 * scaleX), "left")
        else
            dxDrawText(" ", 350 * scaleX, 770 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, exports.kaisen2_fonts:getFont("AwesomeFont", 12 * scaleX), "left")
        end
    end

	-- getElementData(thePlayer, "voice_channel", channel)
	
    if getElementData(localPlayer, "voice_channel") == 1 then
        dxDrawText(" ", 358 * scaleX, 793 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font3, "center")
    elseif getElementData(localPlayer, "voice_channel") == 2 then
        dxDrawText(" ", 358 * scaleX, 793 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font3, "center")
    elseif getElementData(localPlayer, "voice_channel") == 3 then
        dxDrawText(" ", 358 * scaleX, 793 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font3, "center")
    elseif getElementData(localPlayer, "voice_channel") == 4 then
        dxDrawText(" ", 358 * scaleX, 793 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font3, "center")
	elseif getElementData(localPlayer, "voice_channel") == 5 then
		dxDrawText(" ", 358 * scaleX, 793 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font3, "center")
	end

    if isPlayerInSafeZone(localPlayer) then
        dxDrawText("", 50 * scaleX, 774 * scaleY, nil, nil, tocolor(0, 182, 148, 255), 1, exports.kaisen2_fonts:getFont("FontAwesomeRegular", 14 * scaleX), "left")
        dxDrawText("Güvenli Bölge", 75 * scaleX, 769 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font2, "left")
    else
        dxDrawText(" ", 50 * scaleX, 774 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, exports.kaisen2_fonts:getFont("FontAwesomeRegular", 14 * scaleX), "left")
        dxDrawText(" ", 75 * scaleX, 769 * scaleY, nil, nil, tocolor(200, 200, 200, 255), 1, font2, "left")
    end
end
addEventHandler("onClientRender", root, voicePanel, true, "low-31")

function requestRoundRectangleShader(withoutFilled)
	local woF = not withoutFilled and ""
	return [[
	texture sourceTexture;
	float4 color = float4(1,1,1,1);
	bool textureLoad = false;
	bool textureRotated = false;
	float4 isRelative = 1;
	float4 radius = 0.25;
	float borderSoft = 0.01;
	bool colorOverwritten = true;
	]]..(woF or [[
	float2 borderThickness = float2(0.01,0.01);
	float radiusMultipler = 0.95;
	]])..[[
	SamplerState tSampler
	{
		Texture = sourceTexture;
		MinFilter = Linear;
		MagFilter = Linear;
		MipFilter = Linear;
	};
	float4 rndRect(float2 tex: TEXCOORD0, float4 _color : COLOR0):COLOR0{
		float4 result = textureLoad?tex2D(tSampler,textureRotated?tex.yx:tex)*color:color;
		float alp = 1;
		float2 tex_bk = tex;
		float2 dx = ddx(tex);
		float2 dy = ddy(tex);
		float2 dd = float2(length(float2(dx.x,dy.x)),length(float2(dx.y,dy.y)));
		float a = dd.x/dd.y;
		float2 center = 0.5*float2(1/(a<=1?a:1),a<=1?1:a);
		float4 nRadius;
		float aA = borderSoft*100;
		if(a<=1){
			tex.x /= a;
			aA *= dd.y;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.y,isRelative.y==1?radius.y/2:radius.y*dd.y,isRelative.z==1?radius.z/2:radius.z*dd.y,isRelative.w==1?radius.w/2:radius.w*dd.y);
		}
		else{
			tex.y *= a;
			aA *= dd.x;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.x,isRelative.y==1?radius.y/2:radius.y*dd.x,isRelative.z==1?radius.z/2:radius.z*dd.x,isRelative.w==1?radius.w/2:radius.w*dd.x);
		}
		float2 fixedPos = tex-center;
		float2 corner[] = {center-nRadius.x,center-nRadius.y,center-nRadius.z,center-nRadius.w};
		//LTCorner
		if(-fixedPos.x >= corner[0].x && -fixedPos.y >= corner[0].y)
		{
			float dis = distance(-fixedPos,corner[0]);
			alp = 1-(dis-nRadius.x+aA)/aA;
		}
		//RTCorner
		if(fixedPos.x >= corner[1].x && -fixedPos.y >= corner[1].y)
		{
			float dis = distance(float2(fixedPos.x,-fixedPos.y),corner[1]);
			alp = 1-(dis-nRadius.y+aA)/aA;
		}
		//RBCorner
		if(fixedPos.x >= corner[2].x && fixedPos.y >= corner[2].y)
		{
			float dis = distance(float2(fixedPos.x,fixedPos.y),corner[2]);
			alp = 1-(dis-nRadius.z+aA)/aA;
		}
		//LBCorner
		if(-fixedPos.x >= corner[3].x && fixedPos.y >= corner[3].y)
		{
			float dis = distance(float2(-fixedPos.x,fixedPos.y),corner[3]);
			alp = 1-(dis-nRadius.w+aA)/aA;
		}
		if (fixedPos.y <= 0 && -fixedPos.x <= corner[0].x && fixedPos.x <= corner[1].x && (nRadius[0] || nRadius[1])){
			alp = (fixedPos.y+center.y)/aA;
		}else if (fixedPos.y >= 0 && -fixedPos.x <= corner[3].x && fixedPos.x <= corner[2].x && (nRadius[2] || nRadius[3])){
			alp = (-fixedPos.y+center.y)/aA;
		}else if (fixedPos.x <= 0 && -fixedPos.y <= corner[0].y && fixedPos.y <= corner[3].y && (nRadius[0] || nRadius[3])){
			alp = (fixedPos.x+center.x)/aA;
		}else if (fixedPos.x >= 0 && -fixedPos.y <= corner[1].y && fixedPos.y <= corner[2].y && (nRadius[1] || nRadius[2])){
			alp = (-fixedPos.x+center.x)/aA;
		}
		alp = clamp(alp,0,1);
		]]..(woF or [[
		float2 newborderThickness = borderThickness*dd*100;
		tex_bk = tex_bk+tex_bk*newborderThickness;
		dx = ddx(tex_bk);
		dy = ddy(tex_bk);
		dd = float2(length(float2(dx.x,dy.x)),length(float2(dx.y,dy.y)));
		a = dd.x/dd.y;
		center = 0.5*float2(1/(a<=1?a:1),a<=1?1:a);
		aA = borderSoft*100;
		if(a<=1){
			tex_bk.x /= a;
			aA *= dd.y;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.y,isRelative.y==1?radius.y/2:radius.y*dd.y,isRelative.z==1?radius.z/2:radius.z*dd.y,isRelative.w==1?radius.w/2:radius.w*dd.y);
		}
		else{
			tex_bk.y *= a;
			aA *= dd.x;
			nRadius = float4(isRelative.x==1?radius.x/2:radius.x*dd.x,isRelative.y==1?radius.y/2:radius.y*dd.x,isRelative.z==1?radius.z/2:radius.z*dd.x,isRelative.w==1?radius.w/2:radius.w*dd.x);
		}
		fixedPos = (tex_bk-center*(newborderThickness+1));
		float4 nRadiusHalf = nRadius*radiusMultipler;
		corner[0] = center-nRadiusHalf.x;
		corner[1] = center-nRadiusHalf.y;
		corner[2] = center-nRadiusHalf.z;
		corner[3] = center-nRadiusHalf.w;
		//LTCorner
		float nAlp = 0;
		if(-fixedPos.x >= corner[0].x && -fixedPos.y >= corner[0].y)
		{
			float dis = distance(-fixedPos,corner[0]);
			nAlp = (dis-nRadiusHalf.x+aA)/aA;
		}
		//RTCorner
		if(fixedPos.x >= corner[1].x && -fixedPos.y >= corner[1].y)
		{
			float dis = distance(float2(fixedPos.x,-fixedPos.y),corner[1]);
			nAlp = (dis-nRadiusHalf.y+aA)/aA;
		}
		//RBCorner
		if(fixedPos.x >= corner[2].x && fixedPos.y >= corner[2].y)
		{
			float dis = distance(float2(fixedPos.x,fixedPos.y),corner[2]);
			nAlp = (dis-nRadiusHalf.z+aA)/aA;
		}
		//LBCorner
		if(-fixedPos.x >= corner[3].x && fixedPos.y >= corner[3].y)
		{
			float dis = distance(float2(-fixedPos.x,fixedPos.y),corner[3]);
			nAlp = (dis-nRadiusHalf.w+aA)/aA;
		}
		if (fixedPos.y <= 0 && -fixedPos.x <= corner[0].x && fixedPos.x <= corner[1].x && (nRadiusHalf[0] || nRadiusHalf[1])){
			nAlp = 1-(fixedPos.y+center.y)/aA;
		}else if (fixedPos.y >= 0 && -fixedPos.x <= corner[3].x && fixedPos.x <= corner[2].x && (nRadiusHalf[2] || nRadiusHalf[3])){
			nAlp = 1-(-fixedPos.y+center.y)/aA;
		}else if (fixedPos.x <= 0 && -fixedPos.y <= corner[0].y && fixedPos.y <= corner[3].y && (nRadiusHalf[0] || nRadiusHalf[3])){
			nAlp = 1-(fixedPos.x+center.x)/aA;
		}else if (fixedPos.x >= 0 && -fixedPos.y <= corner[1].y && fixedPos.y <= corner[2].y && (nRadiusHalf[1] || nRadiusHalf[2])){
			nAlp = 1-(-fixedPos.x+center.x)/aA;
		}
		alp *= clamp(nAlp,0,1);
		]])..[[
		result.rgb = colorOverwritten?result.rgb:_color.rgb;
		result.a *= _color.a*alp;
		return result;
	}
	
	
	technique rndRectTech
	{
		pass P0
		{
			PixelShader = compile ps_2_a rndRect();
		}
	}
    ]]
end

local roundedRectangleShaders = {};
function rectangle(x, y, width, height, color, radius, isFilled)
    local color = color or tocolor(24, 24, 24);
    local radius = radius or { 0.2, 0.2, 0.2, 0.2 };
    local isFilled = isFilled or false;

    local rgba = { bitExtract(color, 16, 8), bitExtract(color, 8, 8), bitExtract(color, 0, 8), bitExtract(color, 24, 8) };

    local key = table.concat(rgba, '') .. tostring(radius[1]);

    if (not roundedRectangleShaders[key]) then 
        roundedRectangleShaders[key] = {
            shader = dxCreateShader(requestRoundRectangleShader(isFilled)),
            lastTick = getTickCount(),
        };

        dxSetShaderValue(roundedRectangleShaders[key].shader, 'color', rgba[1] / 255, rgba[2] / 255, rgba[3] / 255, rgba[4] / 255);
        dxSetShaderValue(roundedRectangleShaders[key].shader, 'radius', radius[1], radius[2], radius[3], radius[4]);
    end 

    roundedRectangleShaders[key].lastTick = getTickCount();
    dxDrawImage(x, y, width, height, roundedRectangleShaders[key].shader, 0, 0, 0 );
end