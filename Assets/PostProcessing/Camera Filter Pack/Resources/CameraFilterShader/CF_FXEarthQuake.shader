//CameraFilterPack_FX_EarthQuake.shader
Shader "Hidden/CF_FXEarthQuake" 
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

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                float t = float(int(_TimeX * _Value));
                float2 suv = 0;
                suv.x = uv.x + _Value2 * nrand(t);
                suv.y = uv.y + _Value3 * nrand(t + 23.0);
                suv.x -= _Value2 / 2;
                suv.y -= _Value3 / 2;
                float3 col = tex2D(_MainTex, suv).rgb;

                return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
