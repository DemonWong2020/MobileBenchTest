//CZHJH
Shader "LK/Color" {
    Properties{
        _Color("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Pass
        {
            Tags { "RenderType" = "Opaque" }
            LOD 150
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct Input {
                float4 vertex    : POSITION;
                float4 color : COLOR;
            };

            struct v2f
            {
                half4 pos    : SV_POSITION;
                half4 color    : COLOR;
            };

            v2f vert(Input v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) :COLOR
            {
                return i.color;
            }
            ENDCG
        }
    }
}

