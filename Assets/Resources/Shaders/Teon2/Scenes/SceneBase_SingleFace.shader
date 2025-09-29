Shader "Teon2/Scenes/Base_SingleFace"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (0.5, 0.5, 0.5, 0.5)
        [Header(HSV Settings)]
        [Toggle(_HSV_FIXED)]_HSVFixed("HSV Fixed?", Int) = 0
        _Hue ("Hue", Range(0,359)) = 0
        _Saturation ("Saturation", Range(0,3.0)) = 1.0
        _Brightness ("Brightness", Range(0,3.0)) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Range(-10, 10)) = 1
        [Header(Specular Settings)]
        _Shininess("Shininess", Range(0.03, 5)) = 0.078125
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
        [Header(Rim Settings)]
        _RimInten("Rim Intensity", Float) = 1
        _RimColor("Rim Color", Color) = (1, 1, 1, 1)
        [Header(LightMap Settings)]
        _LightmapMul("Lightmap Multiply", Range(0, 10)) = 1

        [Header(Snow Settings)]
        [Toggle(_SNOW_FEATURE)]_SnowFeature("积雪效果?", Int) = 0
        _SnowMask("积雪遮罩", 2D) = "white" {}
        _SnowDot("积雪范围", Range(0, 1)) = 0
        _SnowDeep("积雪厚度", Range(0, 1)) = 0
        _SnowDepth("积雪高度", Range(0, 1)) = 0
        _SnowStrong("积雪强度", Range(0, 5)) = 0
        _SnowColor("积雪颜色", COLOR) = (1, 1, 1, 1)
        [Toggle(_SNOW_NORMAL)]_SnowNormal("使用法线贴图？", Int) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            Cull back
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ _HSV_FIXED
            #pragma multi_compile _ _SNOW_FEATURE

            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma multi_compile _ LIGHTMAP_ON 
            #pragma multi_compile _ SHADOWS_SHADOWMASK 
            #pragma multi_compile _ SHADOWS_SCREEN

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"
            #include "../../Include/HSVMathLib.cginc"
                
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                //Normal
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 lightmapUV : TEXCOORD1;

                //Instancing
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;

                //Fog
                UNITY_FOG_COORDS(1)
                LK_SHADOW_COORDS(2)
                float2 lightmapUV : TEXCOORD3;
                //T B N WP
                float4 tSpace0 : TEXCOORD4;
                float4 tSpace1 : TEXCOORD5;
                float4 tSpace2 : TEXCOORD6;
                //GPUInstancing
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_BUFFER_START(Props)
              UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor)
            UNITY_INSTANCING_BUFFER_END(Props)

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Hue;
            float _Saturation;
            float _Brightness;

            sampler2D _BumpMap;
            float _BumpScale;

            float _Shininess;
            float _SpecInten;
            float4 _SpecularColor;

            float _RimInten;
            float4 _RimColor;

            float _LightmapMul;

            float _SnowDot;
            float _SnowDeep;
            sampler2D _SnowMask;
            float _SnowDepth;
            float _SnowStrong;
            float4 _SnowColor;
            float _SnowNormal;
            
            v2f vert (appdata_t v)
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                #ifdef LIGHTMAP_ON
                o.lightmapUV = v.lightmapUV.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 binNormal = cross(worldNormal, worldTangent) * v.tangent.w;

                #if _SNOW_FEATURE
                float snDot = dot(worldNormal, WORLD_UP);
                v.vertex.xyz += lerp(0, (worldNormal + WORLD_UP) * _SnowDepth * abs(snDot), step(0, snDot - _SnowDot));
                #endif

                o.pos = UnityObjectToClipPos(v.vertex);
                o.tSpace0 = float4(worldTangent.x, binNormal.x, worldNormal.x, worldPos.x);
                o.tSpace1 = float4(worldTangent.y, binNormal.y, worldNormal.y, worldPos.y);
                o.tSpace2 = float4(worldTangent.z, binNormal.z, worldNormal.z, worldPos.z);

                LK_TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                float3 bump = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
                float3 _NormalWorld = normalize(float3(dot(i.tSpace0.xyz, bump),
                                                     dot(i.tSpace1.xyz, bump),
                                                     dot(i.tSpace2.xyz, bump)));
                float3 _WorldPos = float3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);

                float4 _Albedo = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                
                #if _HSV_FIXED
                float3 _ColorHSV = RGBConvertToHSV(_Albedo.xyz);   //转换为HSV
                _ColorHSV.x += _Hue; //调整偏移Hue值
                _ColorHSV.x = _ColorHSV.x % 360;    //超过360的值从0开始

                _ColorHSV.y *= _Saturation;  //调整饱和度
                _ColorHSV.z *= _Brightness;                   

                _Albedo.xyz = saturate(HSVConvertToRGB(_ColorHSV.xyz));   //将调整后的HSV，转换为RGB颜色
                #endif

                float3 _ViewDir = normalize(_WorldSpaceCameraPos - _WorldPos);
                float3 _LightDir = normalize(_WorldSpaceLightPos0);
                float3 _HalfView = normalize(_ViewDir + _LightDir);
                float _NDotH = (dot(_NormalWorld, _HalfView));
                float _VDotN = (dot(_NormalWorld, _ViewDir));
                float _NDotL = saturate(dot(_NormalWorld, _LightDir));

                //_Albedo *= _NDotL * 0.5 + 0.5;
                #ifdef LIGHTMAP_ON
                    float3 lm = LK_DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmapUV));
                    float realtimeShadowAttenuation = 0;
                    float rawOcclusionMask = 0;
                    #ifdef SHADOWS_SHADOWMASK
                        rawOcclusionMask = UNITY_SAMPLE_TEX2D(unity_ShadowMask, i.lightmapUV).r;
                        realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    #endif
                    lm *= _LightmapMul * 2;
                    _Albedo.rgb = _Albedo.rgb * (lm);
                    _Albedo.rgb = BlendShadow(_Albedo, rawOcclusionMask, realtimeShadowAttenuation);
                #else
                    float realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    _Albedo.rgb = _Albedo * (_LightmapMul);
                    _Albedo.rgb = _Albedo * realtimeShadowAttenuation + _Albedo * (1 - realtimeShadowAttenuation) * 0.5;
                #endif

                //SPECULAR
                float3 _SpecularTerm = BlinnPhongCustomer(_NDotH, _SpecularColor, _Shininess, 1, _SpecInten);

                //RIM
                float _Rim = 1.0 - abs(_VDotN);
                _Rim = pow5(_Rim) * _RimInten;

                _Albedo.rgb += saturate( _SpecularTerm);
                
                #if _SNOW_FEATURE
                float4 snowMask = tex2D(_SnowMask, i.uv);
                float3 normal = lerp(float3(i.tSpace0.z, i.tSpace1.z, i.tSpace2.z), _NormalWorld, _SnowNormal);
                _Albedo.rgb = lerp(_Albedo.rgb , _SnowColor, saturate((dot(normal, WORLD_UP) + _SnowDeep) * _SnowStrong) * snowMask.r);
                #endif
                float4 col = _Albedo + _Rim * _RimColor;
                col *= _LightColor0;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return saturate(col);
            }
            ENDCG
        }
        Pass
        {
            Name "FORWARD_ADD"
            // 其余光源的操作
            Tags {"LightMode" = "ForwardAdd"}
            Blend One One
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag    
            //This line tells Unity to compile this pass for forward add, giving attenuation information for the light.
            #pragma multi_compile_fwdadd                    

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "../../Include/CGDefine.cginc"
                        
            struct InputData_Add 
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f_Add
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 posWorld : TEXCOORD1;
                LIGHTING_COORDS(2, 3)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _BumpMap;
            float _BumpScale;

            v2f_Add vert(InputData_Add v)
            {
                v2f_Add o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(v2f_Add i) : COLOR
            {
                //更新多点光源计算方式
                float3 worldNormal = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
                float4 mainCol = tex2D(_MainTex, i.uv);
                float3 diffuse = mainCol * clamp(_LightColor0.rgb, 0, TEON_MAX_LIGHT_INTENSITY);

                #ifdef USING_DIRECTIONAL_LIGHT
                    float atten = 1.0;
                #else
                    #if defined (POINT)
                        float3 lightCoord = mul(unity_WorldToLight, float4(i.posWorld, 1)).xyz;
                        float atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                    #elif defined (SPOT)
                        float4 lightCoord = mul(unity_WorldToLight, float4(i.posWorld, 1));
                        float atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                    #else
                        float atten = 1.0;
                    #endif
                #endif

                return float4((diffuse) * atten * 0.5, 1.0);
            }
            ENDCG
        }
        Pass
        {
            Name "META"
            Tags {"LightMode" = "Meta"}
            Cull Off

            CGPROGRAM
            #pragma vertex vert_meta
            #pragma fragment frag_meta

            #include "Lighting.cginc"
            #include "UnityMetaPass.cginc"

            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
            };

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _Emission;
            float _EmissionVal;

            v2f vert_meta(appdata_full v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f,o);
                o.pos = UnityMetaVertexPosition(v.vertex,v.texcoord1.xy,v.texcoord2.xy,unity_LightmapST,unity_DynamicLightmapST);
                o.uv = v.texcoord.xy;
                return o;
            }

            float4 frag_meta(v2f IN) :SV_Target
            {
                UnityMetaInput metaIN;
                UNITY_INITIALIZE_OUTPUT(UnityMetaInput,metaIN);
                metaIN.Albedo = tex2D(_MainTex,IN.uv).rgb * _Color.rgb;
                metaIN.Emission = tex2D(_Emission,IN.uv).rgb * _EmissionVal; 
                return UnityMetaFragment(metaIN);
            }
            ENDCG
        }
        Pass
        {
            Name "SHADOWCASTER"
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing // allow instanced shadow pass for most of the shaders
            #include "UnityCG.cginc"

            struct v2f { 
                V2F_SHADOW_CASTER;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
