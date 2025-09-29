#ifndef _CAMERA_FILTER_CGINC_
#define _CAMERA_FILTER_CGINC_

#ifndef LIGHT_WAVE_DELTA_THETA
#define LIGHT_WAVE_DELTA_THETA 0.897597901025655210989326680937
#endif

sampler2D _MainTex;
float4 _MainTex_TexelSize;
float4 _MainTex_ST;
float _TimeX;
float4 _ScreenResolution;

struct appdata_t
{
    float4 vertex   : POSITION;
    float2 texcoord : TEXCOORD0;
};

struct v2f
{
    float4 vertex   : SV_POSITION;
    float2 texcoord  : TEXCOORD0;
}; 

v2f vert(appdata_t IN)
{
    v2f OUT;
    OUT.vertex = UnityObjectToClipPos(IN.vertex);
    OUT.texcoord = UnityStereoScreenSpaceUVAdjust(IN.texcoord, _MainTex_ST);
    
    return OUT;
}

float2 getOffset(float time, float2 uv, float distortion)
{ 
    float a = 1.0 + 0.5 * sin(time + uv.x * distortion);
    float b = 1.0 + 0.5 * cos(time + uv.y * distortion);
    return 0.02 * float2(a + sin(b), b + cos(a));
}

float mod289(float x)
{
    return x - floor(x * 0.0034602) * 289.0;
}

float4 mod289(float4 x)
{
    return x - floor(x * 0.0034602) * 289.0;
}

float4 perm(float4 x)
{
    return mod289(((x * 34.0) + 1.0) * x);
}

float noise3d(float3 p)
{
    float3 a = floor(p);
    float3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    float4 b = a.xxyy + float4(0.0, 1.0, 0.0, 1.0);
    float4 k1 = perm(b.xyxy);
    float4 k2 = perm(k1.xyxy + b.zzww);

    float4 c = k2 + a.zzzz;
    float4 k3 = perm(c);
    float4 k4 = perm(c + 1.0);

    float4 o1 = frac(k3 * 0.0243902);
    float4 o2 = frac(k4 * 0.0243902);

    float4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    float2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

//ret r: 边界内容， gb: 扰动的uv
float3 pencilEdge(float4 mainCol, float2 uv, float3 texPaper, float timeMul, float pxOffset, float powMul)
{
    float3 pe = 1;
    float4 tex1[4];
    float4 tex2[4];
    float tt = _TimeX * timeMul;
    float sinDist = floor(sin(tt * 10) * 0.02) / 12;
    float cosDist = floor(cos(tt * 10) * 0.02) / 12;
    float2 dist = float2(cosDist, sinDist) + texPaper.b * 0.02;
   
    tex2[0] = tex2D(_MainTex, uv + float2(pxOffset, 0) + dist / 128);
    tex2[1] = tex2D(_MainTex, uv + float2(-pxOffset, 0) + dist / 128);
    tex2[2] = tex2D(_MainTex, uv + float2(0, pxOffset) + dist / 128);
    tex2[3] = tex2D(_MainTex, uv + float2(0, -pxOffset) + dist / 128);

    for(int i = 0; i < 4; i++) 
    {
        tex1[i] = saturate(1.0 - distance(tex2[i].r, mainCol.r));
        tex1[i] *= saturate(1.0 - distance(tex2[i].g, mainCol.g));
        tex1[i] *= saturate(1.0 - distance(tex2[i].b, mainCol.b));
        tex1[i] = pow(tex1[i], powMul * 25);
        pe.r *= dot(tex1[i], 1.0);
    }

    pe.r = saturate(pe.r);
    pe.yz = dist;
    return pe;
}

float4 edgeFilter(in int px, in int py, float2 uvst) 
{
    float4 color = 0;
    float2 screenRes = _ScreenResolution.xy;
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + 1, py + 1)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + 1, py + 0)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + 1, py + -1)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + 0, py + 1)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + 0, py + 0)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + 0, py + -1)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + -1, py + 1)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + -1, py + 0)) / screenRes);
    color += tex2D(_MainTex, ((uvst.xy * screenRes) + float2(px + -1, py + -1)) / screenRes);

    return color / 9.0;
}

float nrand(float2 n) 
{
    return frac(sin(dot(n.xy, float2(12.9898, 78.233))) * 43758.5453);
}

float3 linearDodge(float3 s, float3 d)
{
    return s + d;
}

float mod(float x,float modu) 
{
    return x - floor(x * (1.0 / modu)) * modu;
}    


#endif