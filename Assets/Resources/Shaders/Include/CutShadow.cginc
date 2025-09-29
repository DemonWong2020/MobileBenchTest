#ifndef _CUT_SHADOW_CGINC
#define _CUT_SHADOW_CGINC

#include "CGDefine.cginc"

float _CutShadowRimPow;
float _CutShadowRimInten;
sampler2D _MaskTex;
UNITY_INSTANCING_BUFFER_START(Props)
              UNITY_DEFINE_INSTANCED_PROP(float4, _CutShadowRimColor)
UNITY_INSTANCING_BUFFER_END(Props)

struct appdata_cutShadow
{
    float4 vertex : POSITION;
    float2 texcoord : TEXCOORD0;
    //float3 normal : NORMAL;
    //Instancing
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f_cutShadow
{
    float4 position : SV_Position;
    float2 texcoord : TEXCOORD0;
    //float3 normal : NORMAL;
    //float3 viewDir : TEXCOORD0;
    //GPUInstancing
    UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
};

v2f_cutShadow vert_cutShdow(appdata_cutShadow v)
{
    v2f_cutShadow o = (v2f_cutShadow)0;
    o.position = UnityObjectToClipPos(v.vertex);
    o.texcoord = v.texcoord;
    //o.normal = UnityObjectToWorldNormal(v.normal);
    //o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
    
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.
    return o;
}

float4 frag_cutShadow(v2f_cutShadow i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.
    //float _NDotV = saturate(dot(i.normal, i.viewDir));
    float4 col = UNITY_ACCESS_INSTANCED_PROP(Props, _CutShadowRimColor);
    //col.a = saturate(pow(1 - _NDotV, _CutShadowRimPow) * _CutShadowRimInten);
    return col;
}

float4 frag_cutShadowMask(v2f_cutShadow i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.
    //float _NDotV = saturate(dot(i.normal, i.viewDir));
    float4 col = UNITY_ACCESS_INSTANCED_PROP(Props, _CutShadowRimColor);
    float4 mask = tex2D(_MaskTex, i.texcoord);

    //col.a = saturate(pow(1 - _NDotV, _CutShadowRimPow) * _CutShadowRimInten);
    return mask * col;
}

#endif