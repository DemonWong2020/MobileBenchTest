#ifndef _CGDEFINE_CGINC_
#define _CGDEFINE_CGINC_

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityStandardBRDF.cginc"
#include "UnityStandardUtils.cginc"

#ifdef SHADOWS_SCREEN
    #define SHADOWN_ATTEN 0
#else
     #define SHADOWN_ATTEN 1
#endif

#ifndef TEON_SAMPLER2D_ST
    #define TEON_SAMPLER2D_ST(name) sampler2D name; float4 name##_ST;
#endif

#ifndef TEON_TILEMAP_PHOTOSITE_TILLING
    #define TEON_TILEMAP_PHOTOSITE_TILLING(name) float4 name##R, name##G, name##B, name##A;
#endif

#ifndef TEON_DEPTH_COORDS
    #define TEON_DEPTH_COORDS(id) float dist : TEXCOORD##id;
#endif

#ifndef TEON_DEPTH
    #define TEON_DEPTH(i) (1 - saturate((mul(unity_ObjectToWorld, v.vertex).z - _ProjectionParams.y) / (_ProjectionParams.z - _ProjectionParams.y)) * _ProjectionParams.w);
#endif

#ifndef TEON_GET_DEPTH
    #define TEON_GET_DEPTH(i) i.dist;
#endif

#ifndef TEON_TIME_X
    #define TEON_TIME_X fmod(_Time.x, 65535)
#endif

#ifndef TEON_TIME_Y
    #define TEON_TIME_Y fmod(_Time.y, 65535)
#endif

#ifndef TEON_TIME_Z
    #define TEON_TIME_Z fmod(_Time.z, 65535)
#endif

#ifndef TEON_MAX_LIGHT_INTENSITY
    #define TEON_MAX_LIGHT_INTENSITY 1
#endif

#ifndef LK_SHADOW_COORDS
    #ifdef LIGHTMAP_ON
        #define LK_SHADOW_COORDS(id) float4 _LKShadowCoord : TEXCOORD##id;
    #else
         #define LK_SHADOW_COORDS(id) SHADOW_COORDS(id)
    #endif
#endif

#ifndef LK_TRANSFER_SHADOW
    #ifdef LIGHTMAP_ON
        #define LK_TRANSFER_SHADOW(o) o._LKShadowCoord = mul(unity_WorldToShadow[0], mul(unity_ObjectToWorld, v.vertex));
    #else
        #define LK_TRANSFER_SHADOW(o) TRANSFER_SHADOW(o)
    #endif
#endif

#ifndef LK_SHADOW_ATTENUATION
    #ifdef LIGHTMAP_ON
        #define LK_SHADOW_ATTENUATION(i) SampleShadow(i._LKShadowCoord);
    #else
        #define LK_SHADOW_ATTENUATION(i) SHADOW_ATTENUATION(i)
    #endif
#endif

#ifndef LK_GLES
    #if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3) || defined(SHADER_API_GLES)
        #define LK_GLES
    #endif
#endif

#ifndef WORLD_UP
    #define WORLD_UP UnityObjectToWorldNormal(half3(0, 1, 0))
#endif

uniform sampler2D _ShadowMap;
uniform float4 _ShadowColor;

float pow2(float val)
{
    return val * val;
}

float pow4(float val)
{
    return pow2(val) * pow2(val);
}

float pow5(float val)
{
    return val * val * val * val * val;
}

float pow10(float val)
{
    return pow5(val) * pow5(val);
}

//快速菲尼尔
float FastFresnel(float reflectRatio, float vDotn)
{
    return reflectRatio + (1 - reflectRatio) * pow5(1 - vDotn);
}

float3 FresnelSchlickRoughness(float cosTheta, float3 F0, float roughness)
{
    return F0 + (max(float3(1, 1, 1) * (1 - roughness), F0) - F0) * pow5(1.0 - cosTheta);
}

float3 FresnelFunction(float3 albedo, float metallic, float VdotH)
{
    float3 F0 = lerp(unity_ColorSpaceDielectricSpec.rgb, albedo, metallic);
    float3 F = F0 + (1 - F0) * exp2((-5.55473 * VdotH - 6.98316) * VdotH);

    return F;
}

float3 FresnelFunction(float3 F0, float VdotH)
{
    return F0 + (1 - F0) * exp2((-5.55473 * VdotH - 6.98316) * VdotH);
}

float2 GetParallaxDelta(float h, float fixedVal, float3 posWorld)
{
    float parallax = (h - 0.5) * fixedVal;
    float3 view = normalize(posWorld);
    
    view.z += 0.42;
    
    return view.xy / view.z * parallax;
}

//TileMap
float2 GetTileMapUV(int id, float2 mainUV, float2 atlasSize, float2 tilling)
{
    float xpos = fmod(id, atlasSize.x);
    int ypos = id / atlasSize.y + 1;
 
    float2 uv = float2(xpos, ypos) / atlasSize.xy;
 
    float xoffset = frac(mainUV.x * tilling.x) / atlasSize.x;
    float yoffset = frac(mainUV.y * tilling.y) / atlasSize.y;
 
    uv += float2(xoffset, -yoffset);
    
    return uv;
}

float3 GetTileNormal(sampler2D tileMap, int tileId, int floatIndex, float2 mainUV, float2 tileSize, float4 maskInfo)
{
    float2 bumpUV = GetTileMapUV(tileId + floatIndex, mainUV, tileSize.xy, maskInfo.xy);
    float3 bump = UnpackNormalWithScale(tex2D(tileMap, bumpUV), maskInfo.z);
    return bump;
}

float4 GetTileMapColor(sampler2D tileMap, int tileId, float2 mainUV, float2 tileSize, float4 maskInfo, float mask, float3 lightDir, inout float3 outputBump)
{
    float2 uv = GetTileMapUV(tileId, mainUV, tileSize.xy, maskInfo.xy);
    //Normal default tileMap count = 16
    int floatIndex = tileSize.x * tileSize.y * 0.5;
    float normal = GetTileNormal(tileMap, tileId, floatIndex, mainUV, tileSize, maskInfo);
    outputBump += mask * normal;
    float4 tileMapCol = tex2D(tileMap, uv);
    return mask * (tileMapCol);
}

float3 LK_DecodeLightmap(float3 lightMapCol)
{
    return 2.0 * lightMapCol;
}

float GreyColor(float3 color)
{
    return dot(color, float3(0.299, 0.587, 0.114));
}

float4 SampleShadow(float4 shadowCoord)
{
#if defined (SHADOWS_SCREEN)
    #if defined(SHADOWS_NATIVE)
        float3 coord = shadowCoord.xyz / shadowCoord.w;
        float4 shadow = tex2D(_ShadowMap, coord);
        #if defined (LK_GLES)
                float shadows = (shadow.r < coord.z) ? shadow.g : 0.0f;
        #else  
                float shadows = (shadow.r < (1 - coord.z)) ? shadow.g : 0.0f;
        #endif
        return shadows;
    #else
        float dist = SAMPLE_DEPTH_TEXTURE(_ShadowMap, shadowCoord.xy);
        // tegra is confused if we use _LightShadowData.x directly
        // with "ambiguous overloaded function reference max(mediump float, float)"
        float lightShadowDataX = _LightShadowData.x;
        float threshold = shadowCoord.z;
        return max(dist > threshold, lightShadowDataX);
    #endif
#endif
    return 0;
}

float4 BlendShadow(float4 orgColor, float shadowMask, float realTimeMask)
{
    float4 ret = orgColor;
    ret = lerp((orgColor * (1 - shadowMask) * 0.5 + orgColor * shadowMask), 
                orgColor * (1 - realTimeMask) * shadowMask + orgColor * realTimeMask * _ShadowColor, 
                shadowMask);

    return ret;
}

#endif
