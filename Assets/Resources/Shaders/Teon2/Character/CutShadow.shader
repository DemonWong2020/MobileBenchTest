Shader "Teon2/Character/CutShadow"
{
    Properties
    {
        [Header(CutShadow Settings)]
        _CutShadowRimPow("CutShadow Rim Pow", Range(0, 10)) = 1
        _CutShadowRimInten("CutShadow Rim Intensity", Float) = 1
        _CutShadowRimColor("CutShadow Rim Color", Color) = (1,1,1,1)
        _Stencil ("Stencil ID", int) = 2
    }
    SubShader
    {
        LOD 200
        //为了透明物体也有效 queue改为Transparent+1 对其他有影响 细节后续评估
        Tags { "Queue"="AlphaTest+9" "RenderType" = "Opaque" }
        Pass
        {
            Name "CutShadow"
            Fog { Mode Off }  
            Lighting Off  
            ZWrite Off  
            ZTest Greater  
            Cull Back
            Stencil
            {
                Ref [_Stencil]
                Comp NotEqual
            }

            CGPROGRAM
            #include "../../Include/CutShadow.cginc"
            #pragma multi_compile_instancing
            #pragma vertex vert_cutShdow
            #pragma fragment frag_cutShadow

            ENDCG
        }    
    }
}