//CameraFilterPack_Distortion_Dream2.shader
Shader "Hidden/CF_DistortionDream" 
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

            float _Speed;
            float _Distortion;

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord.xy;
                uv += getOffset(_Speed *  _TimeX, uv, _Distortion);
                return tex2D(_MainTex, uv * 0.9);
            }

            ENDCG
        }
    }
}
