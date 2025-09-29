//CameraFilterPack_Drawing_CellShading.shader
Shader "Hidden/CF_DrawingCellShading" 
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
            float _EdgeSize;
            float _ColorLevel;

            float4 frag(v2f i) : SV_Target
            {
                float2 uvst = i.texcoord;

                float4 color = edgeFilter(0, 0, uvst);

                color.rgb = floor(7.0 * color.rgb) / _ColorLevel;

                float4 sum = abs(edgeFilter(0, 1, uvst) - edgeFilter(0, -1, uvst));
                sum += abs(edgeFilter(1, 0, uvst) - edgeFilter(-1, 0, uvst));
                sum /= 2.0;

                float edgsum = _EdgeSize + 0.05;
                if(length(sum) > edgsum) 
                {
                    color.rgb = 0.0;
                }

                return color;	
            }

            ENDCG
        }
    }
}