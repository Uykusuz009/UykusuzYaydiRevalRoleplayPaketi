#include "mta-helper.fx"

float gMultiplier = 1.2;

sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter = Linear;
	MagFilter = Linear;
};


struct VSInput
{
  float3 Position : POSITION0;
  float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
  float4 Position : POSITION0;
  float2 TexCoord : TEXCOORD0;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = MTACalcScreenPosition ( VS.Position );
    PS.TexCoord = VS.TexCoord;

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 color = tex2D(Sampler0, PS.TexCoord);
    color.r = color.r*gMultiplier*abs(sin(gTime*3));
    color.g = color.g*gMultiplier*abs(sin(gTime*3));
    color.b = color.b*gMultiplier*abs(sin(gTime*3));

    return color;
}

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}