//CameraFilterPack_Vision_Warp2.shader
Shader "Hidden/CF_VisionWarp" 
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

            float sinc(float r, float width)
            {
                width *= 10.0;
                float N = 1.1;
                float numer = sin(r / width);
                float denom = (r /width);
                if(abs(denom) <= 0.1) 
                {
                    return 1.0;
                }
                else 
                {
                    return abs(numer / denom);
                }
            } 

            float expo(float r, float dev)
            {
                return 1.0 * exp(-r * r / dev);
            }

            float4 frag(v2f i) : COLOR
            {
                float2 uv = i.texcoord;
                float2 cdiff = abs(uv - 0.5);
                float myradius = length(cdiff);
                float radius = _TimeX / 3.0; 
                float r = sin((myradius - radius) * 5.0);
                r = r * r;  
                float s = sinc(r, 0.001);
                float4 fColor = float4(s.xxx, 1.0);
                float dist2 = 1.0 - smoothstep(_Value, _Value - 0.05 - _Value2, length(0.5 - uv));
                //fColor.rgb=lerp(tex2D(_MainTex,uv),fColor.rgb,dist2).rgb;
                fColor.rgb = lerp(0, fColor.rgb, dist2).rgb;
                float3 fc = tex2D(_MainTex, uv - float2(fColor.r * _Value3, fColor.r * _Value3)).rgb;

                return float4(fc.rgb, 1.0);
            }
            ENDCG
        }
    }
}
