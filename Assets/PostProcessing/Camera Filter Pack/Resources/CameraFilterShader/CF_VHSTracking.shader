//CameraFilterPack_VHS_Tracking.shader
Shader "Hidden/CF_VHSTracking" 
{
    Properties 
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader 
    {
        Pass
        {
            Cull Off ZWrite Off ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
            #include "CameraFilter.cginc"

            float _Value;
            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                float2 uv_org = uv;
                float t = _TimeX;
                float t2 = floor(t * 0.6);
                float x = 0;
                float y = 0;
                float yt = abs(cos(t)) * nrand(t) * 100.0;
                float xt = sin(nrand(t)) * 0.1;
                x = uv.x - xt * exp(-pow(uv.y * 32.0 - yt, 2.0) / 24.0);
                y = uv.y;
                uv.x = x;
                uv.y = y;
                yt = 0.5 * cos(yt);
                float yr = 0.1 * cos(yt);
                float3 colrgb = 0;
                float colx = 0;
                if (uv_org.y > yt && uv_org.y < yt + nrand(float2(t2, t)) * 0.25) 
                {
                    float md = mod(x * 100.0,10.0);
                    if (md * sin(t) > sin(yr * 360.0) || nrand(md) > 0.4) 
                    {
                        colx = nrand(t2) * _Value;
                    }
                }
                uv = lerp(uv_org, uv, _Value);
                return float4(tex2D(_MainTex, uv).rgb + colx, 1.0);
            }
            ENDCG
        }
    }
}