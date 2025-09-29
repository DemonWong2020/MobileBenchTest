Shader "Teon2/Effects/Alpha_Blend_Dissolve_v5" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("MainColor", Color) = (1,1,1,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        _DissolveTex ("DissolveTex", 2D) = "white" {}
        _Dissolve_U_Speed ("Dissolve_U_Speed", Float ) = 0
        _Dissolve_V_Speed ("Dissolve_V_Speed", Float ) = 0
        [HDR]_DissolveColor ("DissolveColor", Color) = (1,1,1,1)
        _DissolveItensity ("DissolveItensity", Range(0, 2)) = 0
        _DissolveRange ("DissolveRange", Range(0.5, 1)) = 0 
        [MaterialToggle] _ParticalControl ("ParticalControl", Float ) = 0
        _Disturb_Tex ("Disturb_Tex", 2D) = "white" {}
        _DU_Speed ("DU_Speed", Float ) = 0
        _DV_Speed ("DV_Speed", Float ) = 0
        _Disturb_Itensity ("Disturb_Itensity", Range(0, 1)) = 0
        _Mask ("Mask", 2D) = "white" {}
        _MaskRange("MaskRange", Range(-1, 1)) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass 
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "../../Include/CGDefine.cginc"
            #pragma target 3.0
            uniform sampler2D _MainTex;
            uniform half4 _MainTex_ST;
            uniform half4 _TintColor;
            uniform sampler2D _DissolveTex;
            uniform half4 _DissolveTex_ST;
            uniform half _DissolveItensity;
            uniform half _DissolveRange;
            uniform half4 _DissolveColor;
            uniform fixed _ParticalControl;
            uniform half _U_Speed;
            uniform half _V_Speed;

            uniform half _Dissolve_U_Speed;
            uniform half _Dissolve_V_Speed;

            uniform sampler2D _Disturb_Tex;
            uniform half4 _Disturb_Tex_ST;
            uniform half _DU_Speed;
            uniform half _DV_Speed;
            uniform half _Disturb_Itensity;
            uniform sampler2D _Mask;
            uniform float _MaskRange;


            struct VertexInput 
            {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half2 texcoord1 : TEXCOORD1;
                half4 vertexColor : COLOR;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                half4 vertexColor : COLOR;
                half2 uv0 : TEXCOORD0;
                half2 uv1 : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };

            VertexOutput vert(VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR 
            {
                half2 _DissolveUV = TRANSFORM_TEX(i.uv0 + (TEON_TIME_Y * half2(_Dissolve_U_Speed, _Dissolve_V_Speed)), _DissolveTex);
                half4 _DissolveTex_var = tex2D(_DissolveTex, TRANSFORM_TEX(_DissolveUV, _DissolveTex));
                half _DissolveThreshold = saturate(_DissolveTex_var.r / lerp( _DissolveItensity, i.uv1.r, _ParticalControl));
                
                clip(_DissolveThreshold - 0.5);
                half3 emissive = (_DissolveColor.rgb * step(_DissolveThreshold, (_DissolveRange)));

                half2 _DisturbUV = half2(((_DU_Speed * TEON_TIME_Y) + i.uv0.x), ((TEON_TIME_Y * _DV_Speed) + i.uv0.y));
                half _Disturb_Tex_var = tex2D(_Disturb_Tex, TRANSFORM_TEX(_DisturbUV, _Disturb_Tex));

                half2 mainUV = _Disturb_Tex_var * _Disturb_Itensity + (i.uv0 + (TEON_TIME_Y * half2(_U_Speed, _V_Speed)));
                half4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(mainUV, _MainTex));
                half2 maskUV = i.uv0;
                half maskAlpha = tex2D(_Mask, maskUV).g;
                maskUV.x += lerp(_MaskRange, i.uv1.g, _ParticalControl);
                half _Mask_var = 1 - tex2D(_Mask, maskUV).r;
                half3 finalColor = emissive + (_MainTex_var.rgb * _TintColor.rgb * i.vertexColor.rgb);
                fixed4 finalRGBA = fixed4(finalColor, ((i.vertexColor.a * _MainTex_var.a * _TintColor.a) * _DissolveThreshold) * _Mask_var * maskAlpha);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0, 0, 0, 0));
                return finalRGBA;
            }
            ENDCG
        }
    }
}
