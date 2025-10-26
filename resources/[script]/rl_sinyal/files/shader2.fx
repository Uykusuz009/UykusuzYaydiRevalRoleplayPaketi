#include "mta-helper.fx"

float gMultiplier = 0;

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
    float blink = step(0.5, frac(gTime * 5)); // Creates a quick "on-off" effect
    color = color * blink;

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