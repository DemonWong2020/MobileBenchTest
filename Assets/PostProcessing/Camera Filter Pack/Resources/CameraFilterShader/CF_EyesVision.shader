//CameraFilterPack_EyesVision_1.shader
Shader "Hidden/CF_EyesVision" 
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
            float _Speed;
            float _Value;
            float _Value2;
            float _Value3;
            float _Value4;

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.texcoord;
                float t = float(int(_TimeX * _Value3)) * 2;
                float2 suv = uv + 0.004 * float2(nrand(t) * -6, nrand(t + 23.0) * 4);
                suv *= 0.8;
                suv += float2(0.075, 0.05);
               
                suv += getOffset(_Value2 * _TimeX, uv, _Value);
                float3 oldfilm = tex2D(_MainTex2, suv).rgb;
                
                uv +=  oldfilm.rg * 0.125;
                float3 col = tex2D(_MainTex, uv).rgb;
                col.r += 0.08;
                col.g += 0.08;
                col.b -= 0.03;
                col = linearDodge(oldfilm, col);
                float dist = t - (sin(_TimeX * 0.5) * sin(_TimeX * 0.5) * t);
                float dist2 = 1.0 - smoothstep(dist, dist - 0.6, length(0.5 - uv.y));
                col = lerp(col, 0, dist2 * _Value4);
                return float4(col, 1.0);
            }
            ENDCG
        }
    }
}