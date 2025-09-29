Shader "Teon2/Effects/DistShield"
{
    Properties
    {
        _MainTex ("Main_Tex", 2D) = "white" {}
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        _M_U ("M_U", Float ) = 0
        _M_V ("M_V", Float ) = 0
        [NoScaleOffset]_Mask ("R:Mask G:Fre_Mask B:Disturb_Mask", 2D) = "white" {}
        _Fre_Range ("Fre_Range", Range(0, 1)) = 0
        _Fre_Itensity ("Fre_Itensity", Range(0, 1)) = 0
        [HDR]_Fre_Range_Color ("Fre_Range_Color", Color) = (1,1,1,1)
        [HDR]_Fre_Color ("Fre_Color", Color) = (1,1,1,1)
        _DisturbTillingOffset("Disturb TillingOffset", Vector) = (1,1,0,0)
        _Dis_U ("Dis_U", Float ) = 0
        _Dis_V ("Dis_V", Float ) = 0
        _Disturb_Itensity ("Disturb_Itensity", Range(0, 1)) = 0
        [Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 2
        _AddOrBlend("叠加或者混合", Range( 0 , 1)) =1
    }
    SubShader
    {
         Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100

        Pass
        {
            Blend One OneMinusSrcAlpha
            AlphaToMask Off
            Cull [_Cull]
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "../../Include/CGDefine.cginc"
            //#pragma multi_compile_fog
            #pragma target 3.0

            struct appdata
            {
                float4 vertex : POSITION;
                half4 color : COLOR;
                half3 normal : NORMAL;
                half2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                half4 color : COLOR;
                half4 uv : TEXCOORD0;
                half3 worldNormal : TEXCOORD1;
                half3 worldPos : TEXCOORD2;
                //UNITY_FOG_COORDS(3)
               
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            uniform half4 _Color;
            uniform half _Fre_Range;
            uniform half _Fre_Itensity;
            uniform half4 _Fre_Range_Color;
            uniform sampler2D _Mask;
            uniform half4 _Mask_ST;
            uniform half _M_U;
            uniform half _M_V;
            uniform half4 _Fre_Color;
            uniform half4 _DisturbTillingOffset;
            uniform half _Dis_U;
            uniform half _Dis_V;
            uniform half _Disturb_Itensity;
            uniform half _AddOrBlend;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.color = v.color;
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                half2 distUV = i.uv.zw * _DisturbTillingOffset.xy + _DisturbTillingOffset.zw + TEON_TIME_Y * half2(_Dis_U, _Dis_V);
                half dist = tex2D(_Mask, distUV).b;
                half2 mainUV = i.uv + half2(TEON_TIME_Y * _M_U, TEON_TIME_Y * _M_V + _Disturb_Itensity * dist);
                half4 col = tex2D(_MainTex, mainUV);
                half4 mask = tex2D(_Mask, i.uv.zw);
                half4 freMask = mask.g;
                col.a = (col.a * i.color.a * _Color.a * mask.r);
                half3 emissive = (col.rgb*_Color.rgb * i.color.rgb) *
                                  col.a  +
                                  (_Fre_Color.rgb * 
                                  (pow(pow(1.0 - max(0, dot(i.worldNormal, viewDir)), 1 - _Fre_Range), 10.0) *
                                  (_Fre_Itensity * 20.0) * 
                                  ((_Fre_Range_Color.rgb * i.color.rgb) * 
                                  (_Fre_Range_Color.a * i.color.a * freMask)))
                                  * _Fre_Color.a);
                col.rgb = emissive;
                col.a *= _AddOrBlend;
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
