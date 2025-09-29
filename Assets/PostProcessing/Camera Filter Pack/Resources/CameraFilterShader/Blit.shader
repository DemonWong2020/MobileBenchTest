Shader "Hidden/CF_Blit" 
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "CameraFilter.cginc"
            
            float4 frag(v2f i) : SV_Target
            {
                float2 uv  = i.texcoord;
                return tex2D(_MainTex, uv);       
            }
            ENDCG
        }
    }
}
