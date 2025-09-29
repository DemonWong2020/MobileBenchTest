//CameraFilterPack_AAA_BloodOnScreen.shader
Shader "Hidden/CF_BloodOnScreen" 
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainTex2 ("Base (RGB)", 2D) = "white" {}
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

            sampler2D _MainTex2;
            float _Speed;
            float _Value;
            float _Value2;
            float _Value3;
            float _Value4;
            float _Value5;
            float4 _Color2;

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord.xy;
                float2 uv2 = uv;
            
                float TimeX = _Time * 8 *_Value5;

                // BLOOD 1
                float y = uv2.y;	
                float y2 = uv2.y;	
                y = y * 0.5;
                y2 = y2 * 0.2;
                y2 += 0.52;

                uv2.y = lerp(y, y2, _Value);
                float c = sin(uv2.x * 16) / 32;
                uv2.x = uv2.x - sin(TimeX) / 8;
                uv2.y += c * _Value;
                float3 col2 = tex2D(_MainTex2, uv2).rgb;
                uv2 = uv;

                // BLOOD 2
                y = uv2.y;	
                y2 = uv2.y;	
                y = y * 0.12;
                y2 = y2 * 0.1;
                y2 += 0.52;

                uv2.y = lerp(y, y2, _Value);
                c = sin(uv2.x * 4) / 128;
                uv2.x = uv2.x + sin(TimeX) / 8;
                uv2.y += c * _Value;
                float cg = _Value * 16;
                col2 += tex2D(_MainTex2, uv2 + float2(col2.r / cg, col2.r / cg)).rgb;
                uv2 = uv;

                // BLOOD 3 Distort
                y = uv2.y;	
                y2 = uv2.y;	
                y = y * 0.08;
                y2 = y2 * 0.02;
                y2 += 0.62;

                uv2.y = lerp(y, y2, _Value);
                c = sin(uv2.x * 4) / 128;
                uv2.x = uv2.x + sin(TimeX * 1.2) / 4;
                uv2.y += c * _Value;
                col2 += tex2D(_MainTex2, uv2 + float2(col2.r / cg, col2.r / cg)).rgb;

                float s = col2.r;
                float dis = s * 0.05;
                dis = saturate(dis) *  _Value4;

                float3 col = tex2D(_MainTex, uv + dis).rgb;
                col = lerp(col, col + _Color2 * _Value2, s * _Value4);
                dis -= col2.g * (_Value * _Value3);
                dis *= _Value4;

                float3 v3 = _Value3 * dis;
                v3 = lerp(dis, v3, _Color2.rgb);
                col += v3;

                return float4(col, 1.0);
            }

            ENDCG
        }    
    }
}
