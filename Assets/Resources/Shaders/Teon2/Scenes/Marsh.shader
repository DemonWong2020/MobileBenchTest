Shader "Teon2/Scenes/Marsh"
{
    Properties
    {
        _MainTex("泥潭浅水区图", 2D) = "white"{}
        _ShalowCol("浅水区颜色", Color) = (1, 1, 1, 1)
        _DeepCol("深水区颜色", Color) = (1, 1, 1, 1)

        [Header(Normal Settings)]
        [NoScaleOffset]
        _Bump("法线贴图（水面波浪）", 2D) = "bump"{}
        _BumpScale1("法线缩放-1", Range(-10, 10)) = 1
        _BumpScale2("法线缩放-2", Range(-10, 10)) = 1

        [Header(Specular Settings)]
        _Shininess("水面波浪泛光度", Range(0.03, 5)) = 0.078125
        _SpecInten("水面波浪强度", Float) = 1
        _SpecularColor("水面波浪颜色", Color) = (1,1,1,1)

        [Header(Swell Speed Settings)]
        _WaveParams("水面波浪流动速度 第一层：xy， 第二层：zw", Vector) = (0, 0, 0, 0)

        [Header(Foam Speed Settings)]
        _FoamDepth("浪深度", Range(0, 1)) = 1
        _FoamFactor("浪宽度", Range(0, 2)) = 1
        _FoamOffset("浪流速xy，浪复杂度zw", Vector) = (0, 0, 0, 0)
        _FoamStrength("浪强度", Float) = 1
        _FoamColor("浪颜色", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"  "Queue"="Transparent" }
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            Cull back Lighting Off ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"
            
            struct appdata_t
            {
                half4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
            };

            struct v2f 
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 posWorld : TEXCOORD1;
                half4 screenPos : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;

            half4 _ShalowCol;
            half4 _DeepCol;

            sampler2D _Bump;
            half _BumpScale1;
            half _BumpScale2;

            half _Shininess;
            half _SpecInten;
            half4 _SpecularColor;
                
            half4 _WaveParams;
            half _FoamDepth;
            half _FoamFactor;
            half4 _FoamOffset;
            half _FoamStrength;
            half4 _FoamColor;

            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.screenPos = ComputeScreenPos (o.pos);
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half4 diffuse = 1;

                half2 panner1 = (TEON_TIME_Y * _WaveParams.xy + i.uv);
                half2 panner2 = (TEON_TIME_Y * _WaveParams.zw + i.uv);

                half3 normal1 = UnpackNormalWithScale(tex2D(_Bump, panner1), _BumpScale1);
                half3 normal2 = UnpackNormalWithScale(tex2D(_Bump, panner2), _BumpScale2);
                
                half3 worldNormal = normalize(normal1 + normal1 * normal2);

                fixed3 viewDir = normalize(_WorldSpaceCameraPos - i.posWorld);
                float NdotV = saturate(dot(worldNormal, viewDir));

                diffuse.rgb *= NdotV ;
                diffuse.rgb += BlinnPhongCustomer(NdotV, _SpecularColor, _Shininess, 1, _SpecInten);
                
                half eyeDepth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos))));
                half eyeDepthSubScreenPos = abs(eyeDepth - i.screenPos.w);
                half depthMask = 1 - eyeDepthSubScreenPos + _FoamDepth;
                
                half4 mainTex = tex2D(_MainTex, i.uv);
                half3 foam1 = tex2D(_Bump, i.uv + worldNormal.xy * _FoamOffset.zw);
                half3 foam2 = tex2D(_Bump, TEON_TIME_Y * _FoamOffset.xy + i.uv + worldNormal.xy * _FoamOffset.zw);
                half temp_output = saturate( depthMask - _FoamFactor);

                diffuse *= lerp(_DeepCol, _ShalowCol * mainTex, saturate(temp_output));

                fixed4 ret =  diffuse * ((1 - temp_output) + temp_output * _FoamColor * foam2.g * _FoamStrength);
                ret.a *= saturate(1 - temp_output * depthMask);
                UNITY_APPLY_FOG(i.fogCoord, ret);
                
                return ret;
            }

            ENDCG
        }
    }
}