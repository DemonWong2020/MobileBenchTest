Shader "Teon2/Scenes/Skybox_Texture"
{
    Properties
    {
        _SkyTex("Sky Texture", 2D) = "white"{}
        _SkyColor("Sky Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Cull Front
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                half4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                return o;
            }

            sampler2D _SkyTex;
            fixed4 _SkyColor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_SkyTex, i.uv) * _SkyColor;
                return col;
            }
            ENDCG
        }
    }
}