Shader "Teon2/Projector/LightWave" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _MU_Speed ("MU_Speed", Float ) = 0
        _MV_Speed ("MV_Speed", Float ) = 0
        [MaterialToggle] _One_UV ("One_UV", Float ) = 0
        _Disturb_Tex ("Disturb_Tex", 2D) = "white" {}
        _DU_Speed ("DU_Speed", Float ) = 0
        _DV_Speed ("DV_Speed", Float ) = 0
        _Disturb_Itensity ("Disturb_Itensity", Range(0, 1)) = 0
        _Mask ("Mask", 2D) = "white" {}
        //_Depth ("Depth", Float ) = 0
    }
    Subshader{
        Tags { "Queue" = "Transparent" }
        Pass {
        ZWrite Off
        Offset -1, -1
         Blend One One
 
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "../../Include/CGDefine.cginc"
            struct v2f {
                float4 uvShadow : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform half4 _TintColor;
            uniform half _MU_Speed;
            uniform half _MV_Speed;
            //uniform half _Depth;
            uniform fixed _One_UV;
            uniform sampler2D _Disturb_Tex; uniform half4 _Disturb_Tex_ST;
            uniform sampler2D _Mask; uniform half4 _Mask_ST;
            uniform half _DU_Speed;
            uniform half _DV_Speed;
            uniform half _Disturb_Itensity;
 
            float4x4 unity_Projector;
            float4x4 unity_ProjectorClip;
 
            v2f vert(float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uvShadow = mul(unity_Projector, vertex);
                return o;
            }
 
            sampler2D _ShadowTex;
            fixed4 _Color;
 
            fixed4 frag(v2f i) : SV_Target
            {
                half4 uvShadow = UNITY_PROJ_COORD(i.uvShadow);
                half2 node_3635 = half2(((_DU_Speed * TEON_TIME_Y) + uvShadow.x),((TEON_TIME_Y * _DV_Speed) + uvShadow.y));
                node_3635 = TRANSFORM_TEX(node_3635, _Disturb_Tex);
                half4 drawUV = half4(node_3635, uvShadow.zw);
                half4 _Disturb_Tex_var = tex2Dproj(_Disturb_Tex, drawUV);
               
                //half4 node_6113 = _Time;
                //half4 node_4880 = _Time;
                half2 node_2708 = half2(((_MU_Speed * TEON_TIME_Y) + uvShadow.x),((TEON_TIME_Y * _MV_Speed) + uvShadow.y));
                half2 node_4834 = ((_Disturb_Itensity * _Disturb_Tex_var.r)+lerp(node_2708, (uvShadow.xy + node_2708), _One_UV));
                node_4834 = TRANSFORM_TEX(node_4834, _MainTex);
                drawUV = half4(node_4834, uvShadow.zw);
                half4 _MainTex_var = tex2Dproj(_MainTex, drawUV);

                half4 _Mask_var = tex2D(_Mask, uvShadow);
                //half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*saturate((sceneZ-partZ)/_Depth)*(_Mask_var.rgb*_MainTex_var.rgb*_MainTex_var.a*i.vertexColor.a*_TintColor.a));
                half3 emissive = _Disturb_Tex_var * (_TintColor.rgb * (_TintColor.a)) * _Mask_var.r;
                return half4(emissive, 1);
                //fixed4 texCookie = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
             
                //return texCookie;
            }
        ENDCG
        }
    }
 }