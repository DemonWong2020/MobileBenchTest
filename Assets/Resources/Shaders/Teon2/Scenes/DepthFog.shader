// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Teon2/Scenes/DepthFog"
{
    Properties
    {
        _MainTex("雾图", 2D) = "white" {}
        _MainTex_U("流动_U", Float) = 0
        _MainTex_V("流动_V", Float) = 0
        _TintColor("附加颜色",  Color) = (1,1,1,1)
        _DepthStart("起始衰减区间", Range(0, 1)) = 1
        _DepthEnd("结束衰减区间", Range(0, 1)) = 1
        [Header(Noise Mode)]_DisturbanceTex1("扰动贴图", 2D) = "white" {}
        _DisturbanceScale("扰动强度", Float) = 0
        _DisturbanceTex_U("扰动流动_U", Float) = 0
        _DisturbanceTex_V("扰动流动_V", Float) = 0
        _FallOff("衰减图", 2D) = "black"{}
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent+1"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }

        Cull back
        Lighting Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "../../Include/CGDefine.cginc"

            struct appdata_t
            {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
                half4 uv : TEXCOORD0;
                half4 screenPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half _MainTex_U;
            half _MainTex_V;
            half4 _TintColor;
            half _DepthStart;
            half _DepthEnd; 
            sampler2D _DisturbanceTex1;
            half4 _DisturbanceTex1_ST;
            half _DisturbanceScale;
            half _DisturbanceTex_U;
            half _DisturbanceTex_V;
            sampler2D _FallOff;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos (o.pos);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = v.uv;
        
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half2 uv_DisturbSpeed = half2(_DisturbanceTex_U, _DisturbanceTex_V);
                half2 uv_MainSpeed = half2(_MainTex_U, _MainTex_V);

                half disturbCol = tex2D(_DisturbanceTex1, i.uv.xy + uv_DisturbSpeed * TEON_TIME_Y).r;
                half eyeDepth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos))));
                half eyeDepthSubScreenPos = saturate(eyeDepth - i.screenPos.w);
                half depthMask = smoothstep(_DepthStart, _DepthEnd, 1 - eyeDepthSubScreenPos);
                half2 mainUV = i.uv.xy + uv_MainSpeed * TEON_TIME_Y + disturbCol * _DisturbanceScale;
                half4 ret = tex2D(_MainTex, mainUV) * _TintColor;
                half fall = tex2D(_FallOff, i.uv.zw);
                ret.a *= (1 - depthMask) * (1 - fall);
                return ret;
            }
            ENDCG
        }
    }
}
