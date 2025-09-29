//CameraFilterPack_Drawing_BluePrint.shader
Shader "Hidden/CF_DrawingBluePrint" 
{
    Properties 
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainTex2 ("Base (RGB)", 2D) = "white" {}
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

            sampler2D _MainTex2;
            float4 _PColor;
            float4 _PColor2;
            float _Value1;
            float _Value2;
            float _Value3;
            float _Value4;
            float _Value5;
            float _Value6;
            float _Value7;

            float4 frag(v2f i) : SV_Target
            {
                float2 uvst = i.texcoord;
                float4 f = tex2D(_MainTex, uvst);
                float3 paper = tex2D(_MainTex2, uvst).rgb;

                float3 pe = pencilEdge(f, uvst, paper, _Value4, _Value1, _Value2);
                float3 paper2 = tex2D(_MainTex2, uvst + pe.yz).rgb;
                float ce = saturate(pe.r);
                
                float3 ax = 1 - ce; 
                ax *= paper2.b;
                ax = ax * _Value3 * 1.5;
                float gg = lerp(1 - paper.g, 0, 1 - _Value5);
                ax = lerp(ax, 0, gg);
                paper = lerp(0.1 + float3(paper.r * 0.175, paper.r * 0.402, paper.r * 0.687), _PColor2.rgb, _Value6); 
                paper = lerp(paper, _PColor.rgb, ax * _Value3);
                paper = lerp(f, paper, _Value7);
                return float4(paper, 1.0);
            }
            ENDCG
        }
    }
}