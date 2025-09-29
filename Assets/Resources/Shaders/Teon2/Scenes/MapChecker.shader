Shader "Hidden/MapChecker"
{
    Properties
    {
        _MainTex("Fog Texture", 2D) = "white" {}
        _BlendFactor("Blend Factor", range(0,1)) = 0
    }
    SubShader
    {
        Tags{ "Queue" = "Transparent+10" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        ZTest Off
        Cull Back
        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                sampler2D _MainTex;
                half4 _MapSize;

                struct appdata_t
                {
                    half4 vertex : POSITION;
                    half2 texcoord : TEXCOORD0;
                };

                struct v2f
                {
                    half4 pos : SV_POSITION;
                    half2 uv : TEXCOORD0;
                };

                v2f vert(appdata_t v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = (mul(unity_ObjectToWorld, v.vertex) * _MapSize).xz;
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    half4 data = tex2D(_MainTex, i.uv);
                    if(data.g == 0)
                    {
                        data.a = 1 - data.r - data.b;
                    }
                    return data;
                }
            ENDCG
        }
    }
}
