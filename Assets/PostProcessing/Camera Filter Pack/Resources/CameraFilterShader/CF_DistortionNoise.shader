//CameraFilterPack_Distortion_Noise.shader
Shader "Hidden/CF_DistortionNoise" 
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

            float _Distortion;

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                float v1 = noise3d(float3(uv * 10.0, 0.0));
                float v2 = noise3d(float3(uv * 10.0, 1.0));

                float4 color  = tex2D(_MainTex, uv + float2(v1, v2) * 0.1 * _Distortion);

                return color;	
            }
            ENDCG
        }
    }
}