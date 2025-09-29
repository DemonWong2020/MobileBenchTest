//CameraFilterPack_Light_Water2.shader
Shader "Hidden/CF_LightWater" 
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
            float _Value4;

            float col(float2 coord)
            {
                float time = _TimeX * 1.3;
                float col = 0.0;
                float theta = 0.0;
                for (int i = 0; i < 8; i++)
                {
                    float2 adjc = coord;
                    theta = LIGHT_WAVE_DELTA_THETA * float(i);
                    adjc.x += cos(theta) * time * _Value + time * _Value2;
                    adjc.y -=  sin(theta) * time * _Value - time * _Value3;
                    col = col + cos((adjc.x * cos(theta) - adjc.y *  sin(theta)) * 6.0) * _Value4;
                }
                return cos(col);
            }

            float4 frag(v2f i) : COLOR
            {
                float2 p = i.texcoord, c1 = p, c2 = p;
                float cc1 = col(c1);
                c2.x += 8.53;
                float dx = 0.5 * (cc1 - col(c2)) / 60;
                c2.x = p.x;
                c2.y += 8.53;
                float dy = 0.5 * (cc1 - col(c2)) / 60;
                c1.x += dx * 2.0;
                c1.y = (c1.y + dy * 2.0);
                float alpha = 1.0 + dot(dx, dy) * 700;
                float ddx = dx - 0.012;
                float ddy = dy - 0.012;
                if (ddx > 0.0 && ddy > 0.0) 
                    alpha = pow(alpha, ddx * ddy * 200000);
                float4 col = tex2D(_MainTex, c1) * (alpha);
                return col;
            }
            ENDCG
        }
    }
}
