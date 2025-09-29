Shader "Teon2/Scenes/Diffuse_Fast_SingleFace"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (0.5, 0.5, 0.5, 0.5)
        [Header(LightMap Settings)]
        _LightmapMul("Lightmap Multiply", Range(0, 10)) = 1

        [Header(Snow Settings)]
        [Toggle(_SNOW_FEATURE)]_SNOW_FEATURE("积雪效果?", Int) = 0
        _SnowMask("Snow Mask", 2D) = "white" {}
        _SnowDot("Snow Dot", Range(0, 1)) = 0
        _SnowDeep("Snow Deep", Range(0, 1)) = 0
        _SnowDepth("Snow Depth", Range(0, 1)) = 0
        _SnowStrong("Snow Stroing", Range(0, 5)) = 0
        _SnowColor("Snow Color", COLOR) = (1, 1, 1, 1)
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
                half4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
                half2 lightmapUV : TEXCOORD1;
                //Normal
                half3 normal : NORMAL;
                //Instancing
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half2 lightmapUV : TEXCOORD1;
                half3 worldNormal : TEXCOORD2;
                //Fog
                UNITY_FOG_COORDS(3)
                LK_SHADOW_COORDS(4)
                //GPUInstancing
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_BUFFER_START(Props)
              UNITY_DEFINE_INSTANCED_PROP(half4, _TintColor)
            UNITY_INSTANCING_BUFFER_END(Props)

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half _LightmapMul;

            half _SnowDot;
            half _SnowDeep;
            sampler2D _SnowMask;
            half _SnowDepth;
            half _SnowStrong;
            half4 _SnowColor;
            
            v2f vert (appdata_t v)
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                #ifdef LIGHTMAP_ON
                o.lightmapUV = v.lightmapUV.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif

                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                #if _SNOW_FEATURE
                half snDot = dot(o.worldNormal, WORLD_UP);
                v.vertex.xyz += lerp(0, (o.worldNormal + WORLD_UP) * _SnowDepth * abs(snDot), step(0, snDot - _SnowDot));
                #endif

                o.pos = UnityObjectToClipPos(v.vertex);
                LK_TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                half4 _Albedo = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                half _NDotL = dot(i.worldNormal, normalize(_WorldSpaceLightPos0));

                //_Albedo *= _NDotL * 0.5 + 0.5;
                #ifdef LIGHTMAP_ON
                    half3 lm = LK_DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmapUV));
                    half realtimeShadowAttenuation = 0;
                    half rawOcclusionMask = 0;
                    #ifdef SHADOWS_SHADOWMASK
                        rawOcclusionMask = UNITY_SAMPLE_TEX2D(unity_ShadowMask, i.lightmapUV).r;
                        realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    #endif
                    lm *= _LightmapMul * 2;
                    _Albedo.rgb = _Albedo.rgb * (lm * _LightColor0);
                    _Albedo.rgb = BlendShadow(_Albedo, rawOcclusionMask, realtimeShadowAttenuation);
                #else
                    half realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    _Albedo.rgb = _Albedo * (_LightmapMul * _LightColor0);
                    _Albedo.rgb = _Albedo * realtimeShadowAttenuation + _Albedo * (1 - realtimeShadowAttenuation) * 0.5;
                #endif

                #if _SNOW_FEATURE
                half4 snowMask = tex2D(_SnowMask, i.uv);
                _Albedo.rgb = lerp(_Albedo.rgb , _SnowColor, saturate((dot(i.worldNormal, WORLD_UP) + _SnowDeep) * _SnowStrong) * snowMask.r);
                #endif
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, _Albedo);
                return _Albedo;
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