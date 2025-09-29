//CameraFilterPack_Distortion_Aspiration.shader
Shader "Hidden/CF_DistortionAspiration" 
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

            float4 Aspiration(float2 uv)
            {
                float b = 0;

                if (uv.x > 1) 
                { 
                    uv.x = 1 - (uv.x - 1);
                    b = uv.x - 1; 
                }

                if (uv.x < 0) 
                {
                    uv.x = 1 - (uv.x + 1);
                    b += 1 - (uv.x + 1); 
                }

                if (uv.y > 1)
                {
                    uv.y = 1 - (uv.y - 1);
                    b += uv.y - 1; 
                }

                if (uv.y < 0)
                {
                    uv.y = 1 - (uv.y + 1);
                    b += 1 - (uv.y + 1);
                }

                float4 c = float4(tex2D(_MainTex, uv).xyz, 1.0);
                b = abs(b * 2);
                c.rgb -= b;
                return c;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                float2 pos = uv + normalize(uv - float2(_Value2, _Value3)) * _Value;

                return Aspiration(pos);
            }
            ENDCG
        }
    }
}
