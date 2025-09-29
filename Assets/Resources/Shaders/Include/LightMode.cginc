#ifndef LIGHT_MODE_CGINC
#define LIGHT_MODE_CGINC

#include "CGDefine.cginc"

float3 BlinnPhongCustomer(float3 customerLightDir, float3 viewDir, float3 normal, float3 specularColor, float gloss, float mask, float intensity)
{
    //float3 lightDir_ViewSpace = normalize(customerLightDir.rgb * 2.0 - float3(1.0, 1.0, 1.0));
    //float3 lightDir = mul(UNITY_MATRIX_I_V, lightDir_ViewSpace);
    float3 h = normalize(customerLightDir + viewDir);
    float nh = max(0.0, 0.5 * dot(h, normal) + 0.5);
    float spec = pow(nh, gloss * 256.0);
    return (specularColor * spec * mask * intensity);
}

float3 BlinnPhongCustomer(half NdotH, float3 specularColor, float gloss, float mask, float intensity)
{
    //float3 lightDir_ViewSpace = normalize(customerLightDir.rgb * 2.0 - float3(1.0, 1.0, 1.0));
    //float3 lightDir = mul(UNITY_MATRIX_I_V, lightDir_ViewSpace);
    float nh = max(0.0, 0.5 * NdotH + 0.5);
    float spec = pow(nh, gloss * 256.0);
    return (specularColor * spec * mask * intensity);
}

float3 LambertCustomer(float3 customerLightDir, float3 normal, float3 specularColor, float atten)
{
    return (max(0, dot(normal, customerLightDir)) * specularColor) * atten;
}

#endif
