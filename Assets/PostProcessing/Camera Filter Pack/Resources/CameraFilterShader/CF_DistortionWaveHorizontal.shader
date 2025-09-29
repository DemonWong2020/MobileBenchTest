//CameraFilterPack_Distortion_Wave_Horizontal.shader
Shader "Hidden/CF_DistortionWaveHorizontal" 
{
    Properties 
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Distortion ("_Distortion", Range(0.0, 1.0)) = 0.3
        _WaveIntensity ("_WaveIntensity", Range(1, 100)) = 1
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
            float _WaveIntensity;

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                uv.x += (sin((uv.y + (_TimeX * 0.07)) * _WaveIntensity) * 0.009) + (sin((uv.y + (_TimeX * 0.1)) * (_WaveIntensity - 10.0)) * 0.005);

                return tex2D(_MainTex, uv);
            }
            ENDCG
        }
    }
}