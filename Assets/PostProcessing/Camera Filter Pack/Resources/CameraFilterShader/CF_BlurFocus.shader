//CameraFilterPack_Blur_Focus.shader
Shader "Hidden/CF_BloodOnScree" 
{
    Properties 
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Size ("Size", Range(0.0, 1.0)) = 1.0
        _Circle ("Circle", Range(0.0, 1.0)) = 1.0
        _Distortion ("_Distortion", Range(0.0, 1.0)) = 0.3
        _CenterX ("_CenterX", Range(-1.0, 1.0)) = 0
        _CenterY ("_CenterY", Range(-1.0, 1.0)) = 0
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

            float _Distortion;
            float _CenterX;
            float _CenterY;
            float _Circle;
            float _Size;

            float2 barrelDistortion(float2 coord, float amt) 
            {
                float2 cc = coord - float2(0.5 + _CenterX / 2 , 0.5 + _CenterY / 2);
                return coord + cc * dot(cc, cc) * amt;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                float4 tx = 0.0;

                for (float u = 0.0; u < _Size; u += 0.2) 
                {
                    float4 a = tex2D(_MainTex, barrelDistortion(uv, u / _Circle));
                    tx += a;
                }

                tx /= _Size * 5;
                return float4(tx.rgb, 1.0);
            }

            ENDCG
        }
    }
}