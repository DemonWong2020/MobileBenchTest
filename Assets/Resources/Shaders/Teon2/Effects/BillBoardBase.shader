Shader "Teon2/Effects/BillBoard/Base"
{
     Properties
    {
       _MainTex("Texture Image", 2D) = "white" {}
       _ScaleX("Scale X", Float) = 1.0
       _ScaleY("Scale Y", Float) = 1.0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert  
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half _ScaleX;
            half _ScaleY;

            struct appdata_t
            {
                float4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

            v2f vert(appdata_t v)
            {
                v2f o;

                o.pos = mul(UNITY_MATRIX_P,
                                mul(UNITY_MATRIX_MV, half4(0.0, 0.0, 0.0, 1.0))
                                + v.vertex
                                * half4(_ScaleX, _ScaleY, 1.0, 1.0));

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                return tex2D(_MainTex, i.uv);
            }

            ENDCG
        }
    }
}