#ifndef ANIMATE_INSTANCE_LIB_CGINC
#define ANIMATE_INSTANCE_LIB_CGINC

#include "../../Include/CGDefine.cginc"
#include "../../Include/LightMode.cginc"
#include "../../Include/HSVMathLib.cginc"

struct appdata_instance
{
    half4 vertex : POSITION;
    half2 texcoord : TEXCOORD0;
    half4 texcoord2 : TEXCOORD1;    //for bone weight
    //Normal
    half3 normal : NORMAL;
    half4 tangent : TANGENT;
    half4 color : COLOR;
    //Instancing
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct appdata_shadow
{
    half4 vertex : POSITION;
    half3 normal : NORMAL;
    half2 texcoord : TEXCOORD0;
    half4 texcoord2 : TEXCOORD1;    //for bone weight
    half4 color : COLOR;
    //Instancing
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    half4 position : SV_POSITION;
    half2 uv : TEXCOORD0;
    //Fog
    UNITY_FOG_COORDS(1)
    #if _VERTEX_NORMAL
    half3 worldNormal : TEXCOORD2;
    half3 worldPos : TEXCOORD3;
    #else
    //T B N WP
    half4 tSpace0 : TEXCOORD2;
    half4 tSpace1 : TEXCOORD3;
    half4 tSpace2 : TEXCOORD4;
    #endif
    //GPUInstancing
    UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
};

struct v2f_shadow
{
    half4 position : SV_POSITION;
    //GPUInstancing
    UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
};

//#pragma target 3.0

sampler2D _BoneTexture;
int _BoneTextureBlockWidth;
int _BoneTextureBlockHeight;
int _BoneTextureWidth;
int _BoneTextureHeight;


UNITY_INSTANCING_BUFFER_START(_Instance_Props)
    UNITY_DEFINE_INSTANCED_PROP(float, _PreFrameIndex)
#define preFrameIndex_arr _Instance_Props
    UNITY_DEFINE_INSTANCED_PROP(float, _FrameIndex)
#define frameIndex_arr _Instance_Props
    UNITY_DEFINE_INSTANCED_PROP(float, _TransitionProgress)
#define transitionProgress_arr _Instance_Props
UNITY_INSTANCING_BUFFER_END(_Instance_Props)

half4x4 loadMatFromTexture(uint frameIndex, uint boneIndex)
{
    uint blockCount = _BoneTextureWidth / _BoneTextureBlockWidth;
    int2 uv;
    uv.y = frameIndex / blockCount * _BoneTextureBlockHeight;
    uv.x = _BoneTextureBlockWidth * (frameIndex - _BoneTextureWidth / _BoneTextureBlockWidth * uv.y);

    uint matCount = _BoneTextureBlockWidth * 0.25;
    uv.x = uv.x + (boneIndex % matCount) * 4;
    uv.y = uv.y + boneIndex / matCount;

    float2 uvFrame;
    uvFrame.x = uv.x / (float)_BoneTextureWidth;
    uvFrame.y = uv.y / (float)_BoneTextureHeight;
    half4 uvf = half4(uvFrame, 0, 0);

    float offset = 1.0f / (float)_BoneTextureWidth;
    half4 c1 = tex2Dlod(_BoneTexture, uvf);
    uvf.x = uvf.x + offset;
    half4 c2 = tex2Dlod(_BoneTexture, uvf);
    uvf.x = uvf.x + offset;
    half4 c3 = tex2Dlod(_BoneTexture, uvf);
    uvf.x = uvf.x + offset;
    //half4 c4 = tex2Dlod(_BoneTexture, uvf);
    half4 c4 = half4(0, 0, 0, 1);
    //float4x4 m = float4x4(c1, c2, c3, c4);
    half4x4 m;
    m._11_21_31_41 = c1;
    m._12_22_32_42 = c2;
    m._13_23_33_43 = c3;
    m._14_24_34_44 = c4;
    return m;
}

half4 skinning(inout appdata_instance v)
{
    fixed4 w = v.color;
    half4 bone = half4(v.texcoord2.x, v.texcoord2.y, v.texcoord2.z, v.texcoord2.w);

    float curFrame = UNITY_ACCESS_INSTANCED_PROP(frameIndex_arr, _FrameIndex);
    float preAniFrame = UNITY_ACCESS_INSTANCED_PROP(preFrameIndex_arr, _PreFrameIndex);
    float progress = UNITY_ACCESS_INSTANCED_PROP(transitionProgress_arr, _TransitionProgress);

    //float curFrame = UNITY_ACCESS_INSTANCED_PROP(frameIndex);
    int preFrame = curFrame;
    int nextFrame = curFrame + 1.0f;
    half4x4 localToWorldMatrixPre = loadMatFromTexture(preFrame, bone.x) * w.x;
    localToWorldMatrixPre += loadMatFromTexture(preFrame, bone.y) * max(0, w.y);
    localToWorldMatrixPre += loadMatFromTexture(preFrame, bone.z) * max(0, w.z);
    localToWorldMatrixPre += loadMatFromTexture(preFrame, bone.w) * max(0, w.w);

    half4x4 localToWorldMatrixNext = loadMatFromTexture(nextFrame, bone.x) * w.x;
    localToWorldMatrixNext += loadMatFromTexture(nextFrame, bone.y) * max(0, w.y);
    localToWorldMatrixNext += loadMatFromTexture(nextFrame, bone.z) * max(0, w.z);
    localToWorldMatrixNext += loadMatFromTexture(nextFrame, bone.w) * max(0, w.w);

    half4 localPosPre = mul(v.vertex, localToWorldMatrixPre);
    half4 localPosNext = mul(v.vertex, localToWorldMatrixNext);
    half4 localPos = lerp(localPosPre, localPosNext, curFrame - preFrame);

    half3 localNormPre = mul(v.normal, (float3x3)localToWorldMatrixPre);
    half3 localNormNext = mul(v.normal, (float3x3)localToWorldMatrixNext);
    v.normal = normalize(lerp(localNormPre, localNormNext, curFrame - preFrame));
    half3 localTanPre = mul(v.tangent, localToWorldMatrixPre);
    half3 localTanNext = mul(v.tangent, localToWorldMatrixNext);
    v.tangent.xyz = normalize(lerp(localTanPre, localTanNext, curFrame - preFrame));

    half4x4 localToWorldMatrixPreAni = loadMatFromTexture(preAniFrame, bone.x);
    half4 localPosPreAni = mul(v.vertex, localToWorldMatrixPreAni);
    localPos = lerp(localPos, localPosPreAni, (1.0f - progress) * (preAniFrame > 0.0f));
    return localPos;
}

half4 skinningShadow(inout appdata_shadow v)
{
    half4 bone = half4(v.texcoord2.x, v.texcoord2.y, v.texcoord2.z, v.texcoord2.w);

    float curFrame = UNITY_ACCESS_INSTANCED_PROP(frameIndex_arr, _FrameIndex);
    float preAniFrame = UNITY_ACCESS_INSTANCED_PROP(preFrameIndex_arr, _PreFrameIndex);
    float progress = UNITY_ACCESS_INSTANCED_PROP(transitionProgress_arr, _TransitionProgress);

    int preFrame = curFrame;
    int nextFrame = curFrame + 1.0f;
    half4x4 localToWorldMatrixPre = loadMatFromTexture(preFrame, bone.x);
    half4x4 localToWorldMatrixNext = loadMatFromTexture(nextFrame, bone.x);
    half4 localPosPre = mul(v.vertex, localToWorldMatrixPre);
    half4 localPosNext = mul(v.vertex, localToWorldMatrixNext);
    half4 localPos = lerp(localPosPre, localPosNext, curFrame - preFrame);
    half4x4 localToWorldMatrixPreAni = loadMatFromTexture(preAniFrame, bone.x);
    half4 localPosPreAni = mul(v.vertex, localToWorldMatrixPreAni);
    localPos = lerp(localPos, localPosPreAni, (1.0f - progress) * (preAniFrame > 0.0f));
    //half4 localPos = v.vertex;
    return localPos;
}

//void vert(inout appdata_t v)
//{
//#ifdef UNITY_PASS_SHADOWCASTER
//    v.vertex = skinningShadow(v);
//#else
//    v.vertex = skinning(v);
//#endif
//}

#endif