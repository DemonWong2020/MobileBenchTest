#ifndef _OUT_LINE_CGINC
#define _OUT_LINE_CGINC

#include "CGDefine.cginc"

float _OutlineSize;
float4 _OutlineColor;

sampler2D _DissolveMap;
float _DissolveThreshold;

struct appdata_outline
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

struct v2f_outline
{
    float4 position : SV_Position;
    float2 uv : TEXCOORD0;
};

v2f_outline vert_outline(appdata_outline v)
{
    v2f_outline o = (v2f_outline)0;

    float3 norm = normalize(v.normal);
    v.vertex.xyz += v.normal * _OutlineSize * 0.01;
    o.position = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}

float4 frag_outline(v2f_outline i) : SV_Target
{
    float dissolve = tex2D(_DissolveMap, i.uv);
    if(_DissolveThreshold < dissolve)
    {
        discard;
    }
    return _OutlineColor;
}

#endif