Shader "Bench/Fill"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        Pass
        {
            ZTest Always ZWrite Off Cull Off
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                float4 _Color;
                int _WorkIterations; // 控制片元 ALU 工作量
                struct appdata 
                {
                    float4 vertex: POSITION; 
                    float2 uv: TEXCOORD0; 
                };

                struct v2f 
                { 
                    float4 pos: SV_POSITION; 
                };

                v2f vert(appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    return o; 
                }

                fixed4 frag(v2f i): SV_Target
                {
                    float v = 0.123;
                    // 简单 ALU 循环，防被优化
                    [loop]
                    for (int k = 0; k < _WorkIterations; k++)
                        v = sin(v + 0.915f) * 1.0001f + 0.0001f * k;
                    return float4(v, v, v, 1);
                }
            ENDCG
        }
    }
}
