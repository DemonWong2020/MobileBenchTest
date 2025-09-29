//CameraFilterPack_Vision_Blood_Fast.shader
Shader "Hidden/CF_VisionBlood" 
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
            float _Value2;
            float _Value3;
            float _Value4;

            float4 frag(v2f i) : COLOR
            {
                float k = 0;
                float2 uv = i.texcoord;
                float3 d =  float3(uv, 1.0) - 0.5;
                float3 o = d;
                float3 c= 0;
                float3 p= 0;

                d += float3(tex2D(_MainTex, float2(0.1, 0.5)).rgb) * 0.01;
                float xx = sin(_TimeX / 2) / 2;
                for(int i = 0; i < 3; i++)
                {
                    p = o + xx;
                    for (int j = 0; j < 7; j++) 
                    {
                        p = abs(p.zyx - 0.4) - 0.9;
                        k += exp(-1.25 * abs(dot(o, p)));
                    }

                    k /= 3.0;
                    o += d * k;
                    c = c + 0.1 * k * float3(k * k * k * 3.173, k * k * -0.041, -0.01);
                }

                float dist2 = 1.0 - smoothstep(_Value, _Value - 0.05 - _Value2, length(0.5 - uv));
                c =  0.6 * log(1.0 + c);
                c -= 0.5;
                float2 cc = float2(c.r / 2 * uv.x, c.r / 2 * uv.y);
                c += tex2D(_MainTex, cc);
                c = lerp(tex2D(_MainTex, uv), c, dist2);
                return float4(c, 1.0);
            }
            ENDCG
        }
    }
}
