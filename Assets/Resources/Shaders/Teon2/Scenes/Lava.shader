Shader "Teon2/Scenes/Lava"
{
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _MoveSpeed("Move Speed x:第一层流速, y:第二层流速 ", Vector) = (-0.1, 0.1, 0, 0)
        _ExtrudeTex ("Extrusion Texture", 2D) = "white" {}
        _ExtrudeMul ("Extrusion Speed", Range(0, 10)) = 2
        _Amount ("Extrusion Multiplier", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"  "Queue"="Transparent" }
        Pass
        {
            Cull back Lighting Off ZWrite Off
            CGPROGRAM
                #include "UnityCG.cginc"
                #pragma vertex vert
                #pragma fragment frag

                struct appdata_t
                {
                    half4 vertex : POSITION;
                    half2 texcoord : TEXCOORD0;
                    half3 normal : NORMAL;
                };

                struct v2f 
                {
                    half4 pos : SV_POSITION;
                    half2 uv : TEXCOORD0;
                    half color : COLOR;
                    UNITY_FOG_COORDS(1)
                };

                sampler2D _MainTex;
                half4 _MainTex_ST;
                half4 _Color;
                half4 _MoveSpeed;
                sampler2D _ExtrudeTex;
                half4 _ExtrudeTex_ST;
                half _ExtrudeMul;
                half _Amount;

                v2f vert(appdata_t v)
                {
                    v2f o;

                    half sinTime = _SinTime * _ExtrudeMul;
                    half extrude = tex2Dlod(_ExtrudeTex, half4(v.texcoord.xy * _ExtrudeTex_ST.xy + _ExtrudeTex_ST.zw , 0, 0)).r * sinTime;

                    v.vertex.xyz += v.normal * extrude * _Amount;
                    
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    o.color = extrude * _Amount;
                    UNITY_TRANSFER_FOG(o, o.pos);

                    return o;
                }

                half4 frag(v2f i) : SV_Target
                {
                    half4 lava_1 = tex2D(_MainTex, i.uv + half2(i.color * _MoveSpeed.x, 0));
                    half4 lava_2 = tex2D(_MainTex, i.uv + half2(i.color * _MoveSpeed.y, 0));

                    half4 ret = lava_1 + lava_1 * lava_2;
                    ret *= _Color;
                    UNITY_APPLY_FOG(i.fogCoord, ret);
                    return ret;
                }
            ENDCG
        }
    }
}