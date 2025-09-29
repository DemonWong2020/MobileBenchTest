Shader "UI/Disturbance"
{
    Properties
    {
        _MainColor("第一层贴图颜色", Color) = (1,1,1,1)
        _MainTex("第一层贴图", 2D) = "white" {}
        _MainTex_U1("第一层贴图流动_U", Float) = 0
        _MainTex_V1("第一层贴图流动_V", Float) = 0
        [Header(Mask Mode)]_TexMask1("遮罩1", 2D) = "white" {}
        _MaskRotator1("遮罩旋转", Range( 0 , 1)) = 0
        _MaskSpeedU1("遮罩流动速度U", Float) = 0
        _MaskSpeedV1("遮罩流动速度V", Float) = 0
        _TexMask2("遮罩2", 2D) = "white" {}
        _MaskRotator2("遮罩旋转", Range( 0 , 1)) = 0
        _MaskSpeedU2("遮罩流动速度U", Float) = 0
        _MaskSpeedV2("遮罩流动速度V", Float) = 0
        [Header(Noise Mode)]_DisturbanceTex1("扰动贴图", 2D) = "white" {}
        _DisturbanceScale("扰动强度", Float) = 0
        _DisturbanceTex_U("扰动流动_U", Float) = 0
        _DisturbanceTex_V("扰动流动_V", Float) = 0
        [Header(Dissslve Mode)]_DissolveTex1("溶解贴图", 2D) = "white" {}
        _DissolveTex_U2("溶解贴图流动_U", Float) = 0
        _DissolveTex_V2("溶解贴图流动_V", Float) = 0
        _DissolveIntensityCustom1z1("溶解强度", Range( 0 , 1)) = 0
        _SoftaDissolve1("软硬边强度", Range( 0 , 1)) = 0
        _DissolveWidth("溶解沟边宽度", Range( 0 , 1)) = 0.1
        [HDR]_DissolveWidthColor("溶解沟边颜色", Color) = (1,1,1,0)
        _DissolveDisturbance("溶解贴图受扰动的强度", Float) = 0

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15
    }
    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
        
        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp] 
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Fog { Mode Off }
        Blend One One

        ColorMask [_ColorMask]

        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #include "../../Include/CGDefine.cginc"
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };
            
            fixed4 _MainColor;
            sampler2D _MainTex;
            half4 _MainTex_ST;
            half _MainTex_U1;
            half _MainTex_V1;
            sampler2D _TexMask1;
            half4 _TexMask1_ST;
            half _MaskRotator1;
            half _MaskSpeedU1;
            half _MaskSpeedV1;
            sampler2D _TexMask2;
            half4 _TexMask2_ST;
            half _MaskRotator2;
            half _MaskSpeedU2;
            half _MaskSpeedV2;
            sampler2D _DisturbanceTex1;
            half4 _DisturbanceTex1_ST;
            half _DisturbanceScale;
            half _DisturbanceTex_U;
            half _DisturbanceTex_V;
            
            sampler2D _DissolveTex1;
            half4 _DissolveTex1_ST;
            half _DissolveTex_U2;
            half _DissolveTex_V2;
            half _DissolveIntensityCustom1z1;
            half _SoftaDissolve1;
            half _DissolveWidth;
            half4 _DissolveWidthColor;
            half _DissolveDisturbance;

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
#ifdef UNITY_HALF_TEXEL_OFFSET
                OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
                OUT.color = IN.color * _MainColor;
                return OUT;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half2 uv_DisturbSpeed = half2(_DisturbanceTex_U, _DisturbanceTex_V);
                half2 uv_DisturbanceTex1 = i.texcoord * _DisturbanceTex1_ST.xy + _DisturbanceTex1_ST.zw;
                half disturbCol = tex2D(_DisturbanceTex1, uv_DisturbanceTex1 + uv_DisturbSpeed * TEON_TIME_Y).r;

                half2 uv_Main =  TRANSFORM_TEX(i.texcoord, _MainTex);
                half2 uv_MainSpeed = half2(_MainTex_U1, _MainTex_V1);
               
                half2 uv_TexMask1 = i.texcoord * _TexMask1_ST.xy + _TexMask1_ST.zw;
                half2 uv_Mask1Speed = half2(_MaskSpeedU1, _MaskSpeedV1);
                half2 uv_TexMask2 = i.texcoord * _TexMask2_ST.xy + _TexMask2_ST.zw;
                half2 uv_Mask2Speed = half2(_MaskSpeedU2, _MaskSpeedV2);
                half mask2Col = tex2D(_TexMask2, uv_TexMask2 + uv_Mask2Speed * TEON_TIME_Y).r;
                half mask1Col = tex2D(_TexMask1, uv_TexMask1 + uv_Mask1Speed * TEON_TIME_Y).r * mask2Col;
                
                half2 dissolveTex_Move = half2(_DissolveTex_U2, _DissolveTex_V2);
                half2 uv_DissolveTex1 = i.texcoord * _DissolveTex1_ST.xy + _DissolveTex1_ST.zw;
                uv_DissolveTex1 = lerp(TEON_TIME_Y * dissolveTex_Move + uv_DissolveTex1, disturbCol, _DissolveDisturbance);
                half dissolveVal = tex2D(_DissolveTex1, uv_DissolveTex1).r;

                dissolveVal =  clamp(dissolveVal + 1.0 - _DissolveIntensityCustom1z1 * 2.0, 0.0, 1.0);
                half softDissolve = 1 - _SoftaDissolve1;
                half dissolveMax = smoothstep(0, softDissolve, dissolveVal);
                half dissolveMin = smoothstep(0, softDissolve + _DissolveWidth, dissolveVal);
                half4 dissolveCol = (dissolveMax - dissolveMin) * _DissolveWidthColor;

                half4 color = tex2D(_MainTex, uv_Main + uv_MainSpeed * TEON_TIME_Y + disturbCol * _DisturbanceScale) * i.color;
                color.rgb += dissolveCol.rgb;
                color.a *= mask1Col * dissolveMax;
                color.rgb *= color.a;
                
#ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.01);
#endif
                return color;
            }
        ENDCG
        }
    }
}