Shader "Teon2/Scenes/Water"
{
    Properties
    {
        _MainTex("深浅过渡图", 2D) = "white"{}
        _ShalowCol("浅水区颜色", Color) = (1, 1, 1, 1)
        _DeepCol("深水区颜色", Color) = (1, 1, 1, 1)

        [Header(Normal Settings)]
        [NoScaleOffset]
        _Bump("法线贴图（水面波浪）", 2D) = "bump"{}

        [Header(Specular Settings)]
        _Shininess("水面波浪泛光度", Range(0.03, 5)) = 0.078125
        _SpecInten("水面波浪强度", Float) = 1
        _SpecularColor("水面波浪颜色", Color) = (1,1,1,1)

        [Header(Swell Speed Settings)]
        _WaveParams("水面波浪流动速度 第一层：xy， 第二层：zw", Vector) = (0, 0, 0, 0)
        _WaveRand("水面波浪错落度", Range(0, 1)) = 1
        _WaveSpeed("水面波浪起伏速度", Range(0, 5)) = 1
        _WaveHeight("水面波浪落差", Range(0, 1)) = 1

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
                float2 texcoord : TEXCOORD0;
            };

            struct v2f 
            {
                half4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                half4 posWorld : TEXCOORD1;
                half4 screenPos : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _ShalowCol;
            half4 _DeepCol;

            sampler2D _Bump;

            half _Shininess;
            half _SpecInten;
            half4 _SpecularColor;
                
            half4 _WaveParams;
            half _WaveRand;
            half _WaveSpeed;
            half _WaveHeight;
            half _FoamDepth;
            half _FoamFactor;
            half4 _FoamOffset;
            half _FoamStrength;
            half4 _FoamColor;

            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;

                half waveValue = sin(TEON_TIME_Y * _WaveSpeed + v.vertex.x * _WaveRand);
                v.vertex.xyz = half3(v.vertex.x, v.vertex.y + waveValue * _WaveHeight, v.vertex.z);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.posWorld.w = waveValue;
                o.screenPos = ComputeScreenPos (o.pos);
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half fade = tex2D(_MainTex, (i.uv - _MainTex_ST.zw) / _MainTex_ST.xy).r;
                half4 diffuse = lerp(_ShalowCol, _DeepCol, fade) ;

                half2 panner1 = (TEON_TIME_Y * _WaveParams.xy + i.uv);
                half2 panner2 = (TEON_TIME_Y * _WaveParams.zw + i.uv);

                half3 worldNormal = normalize(BlendNormals(UnpackNormal(tex2D(_Bump, panner1)) , UnpackNormal(tex2D(_Bump, panner2))));

                fixed3 viewDir = normalize(_WorldSpaceCameraPos - i.posWorld);
                float NdotV = saturate(dot(worldNormal, viewDir)) * 0.5 + 0.5;

                diffuse.rgb *= NdotV ;
                diffuse.rgb += BlinnPhongCustomer(NdotV, _SpecularColor, _Shininess, 1, _SpecInten);
                
                half eyeDepth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos))));
                half eyeDepthSubScreenPos = abs(eyeDepth - i.screenPos.w);
                half depthMask = 1 - eyeDepthSubScreenPos + _FoamDepth;
        
                half3 foam1 = tex2D(_MainTex, i.uv + worldNormal.xy * _FoamOffset.zw);
                half3 foam2 = tex2D(_MainTex, TEON_TIME_Y * _FoamOffset.xy + i.uv + worldNormal.xy * _FoamOffset.zw);
                half temp_output = saturate((foam1.g + foam2.g) * depthMask - (_FoamFactor - i.posWorld.w));
        
                fixed4 ret =  (1 - temp_output) * diffuse * _LightColor0 + temp_output * _FoamColor * foam2.g * _FoamStrength;
                ret.a = saturate(1 - depthMask);
                UNITY_APPLY_FOG(i.fogCoord, ret);
                
                return ret;
            }

            ENDCG
        }
    }
}