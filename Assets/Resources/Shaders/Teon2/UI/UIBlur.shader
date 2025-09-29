Shader "UI/Blur"
{
    Properties
    {
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
        }

        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0

                #include "UnityCG.cginc"

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float2 texcoord : TEXCOORD0;
                    float4 color : COLOR;
                };

                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    float2 texcoord  : TEXCOORD0;
                    float4 color : COLOR;
                };

                sampler2D _GlobalGrabTexture;

                float4 _GlobalGrabTexture_TexelSize;
                float4 _Offset;

                v2f vert(appdata_t v)
                {
                    v2f OUT;
                    OUT.vertex = UnityObjectToClipPos(v.vertex);
                    OUT.texcoord = v.texcoord;
                    OUT.color = v.color;
                    return OUT;
                }

                half3 BlurFilter(sampler2D tex, half2 uv, half scale)
                {
                    half4 d = _GlobalGrabTexture_TexelSize.xyxy * half4(-scale, -scale, scale, scale);
                    half3 s = 0;
                    s += (tex2D(tex, uv + d.xy));
                    s += (tex2D(tex, uv + d.zy));
                    s += (tex2D(tex, uv + d.xw));
                    s += (tex2D(tex, uv + d.zw));

                    return clamp(s * 0.25, 0, 1);
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    half4 color = 0;

                    for(int i = 0 ; i < 4; ++i)
                    {
                        color += half4(BlurFilter(_GlobalGrabTexture, IN.texcoord, i), 1);
                    }

                    color = color * 0.25;
                    return color * IN.color;
                }
            ENDCG
        }
    }
}
