Shader "Teon2/Character/Outline"
{
    Properties
    {
        [Header(Outline Settings)]
        _OutlineSize("Outline Size", Range(0, 10)) = 4
        _OutlineColor("Outline Color", Color) = (0.9, 0.49, 0.18, 1)
        [Header(Dissolve Settings)]
        _DissolveMap("DissolveMap", 2D) = "white"{}
        _DissolveThreshold("DissolveThreshold", Range(0,1)) = 0
        _Stencil ("Stencil ID", int) = 1
    }
    SubShader
    {
        LOD 200
        //为了透明物体也有效 queue改为Transparent+1 对其他有影响 细节后续评估
        Tags { "Queue"="AlphaTest+11" "RenderType" = "Opaque" }
        Pass
        {
            Name "Outline"
            Cull off
            ZWrite on  
            ZTest Always
            Lighting Off
            Stencil
            {
                Ref [_Stencil]
                Comp NotEqual
            }
            CGPROGRAM
            #include "../../Include/Outline.cginc"
            #pragma vertex vert_outline
            #pragma fragment frag_outline

            ENDCG
        }
    }
}