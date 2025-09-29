Shader "Teon2/Scenes/SceneComplete_SingleFace"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (1,1,1,1)
        [Header(PBR Settings)]
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Range(-10, 10)) = 1
        _MetallicFixed("金属度调整", Range(0, 1)) = 1
        _RoughessFixed("粗糙度调整", Range(0, 1)) = 1
        [Header(Specular Settings)]
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        [Toggle(_REFLECTION)]_Reflect("Reflect On?", Int) = 0
        _EnvCube("Cube", CUBE) = "black" {}
        _ReflectBlend("Reflection Blend", Range(0, 1)) = 0
        [Header(LightMap Settings)]
        _LightmapMul("Lightmap Multiply", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        Cull Back
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _REFLECTION
            #pragma multi_compile_fog
            #pragma multi_compile _ LIGHTMAP_ON 
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ SHADOWS_SCREEN

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"
            #include "../../Include/HSVMathLib.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
                half2 lightmapUV : TEXCOORD1;
                half4 vertexColor : COLOR;

                //normal
                half3 normal : NORMAL;
                half4 tangent : TANGENT;
            };

            struct v2f
            {
                half4 position : SV_POSITION;
                half2 uv : TEXCOORD0;
                half4 vertexColor : COLOR;
        
                //T B N WP
                half4 tSpace0 : TEXCOORD1;
                half4 tSpace1 : TEXCOORD2;
                half4 tSpace2 : TEXCOORD3;

                UNITY_FOG_COORDS(4)
                LK_SHADOW_COORDS(5)
                half2 lightmapUV : TEXCOORD6;
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _TintColor;

            sampler2D _BumpMap;
            half _BumpScale;

            half _MetallicFixed;
            half _RoughessFixed;

            half _SpecInten;
            half4 _SpecularColor;

            samplerCUBE _EnvCube;
            half _ReflectBlend;

            half _LightmapMul;
            
            v2f vert(appdata v)
            {
                v2f o = (v2f)0;

                o.position = UnityObjectToClipPos(v.vertex);
                o.vertexColor = v.vertexColor;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                #ifdef LIGHTMAP_ON
                o.lightmapUV = v.lightmapUV.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif
                half3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                half3 binNormal = cross(worldNormal, worldTangent) * v.tangent.w;
                o.tSpace0 = half4(worldTangent.x, binNormal.x, worldNormal.x, worldPos.x);
                o.tSpace1 = half4(worldTangent.y, binNormal.y, worldNormal.y, worldPos.y);
                o.tSpace2 = half4(worldTangent.z, binNormal.z, worldNormal.z, worldPos.z);

                LK_TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.position);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half3 bump = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
                half3 _NormalWorld = normalize(half3(dot(i.tSpace0.xyz, bump),
                                                     dot(i.tSpace1.xyz, bump),
                                                     dot(i.tSpace2.xyz, bump)));
                half3 _WorldPos = half3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);
                half4 _Albedo = tex2D(_MainTex, i.uv) * _TintColor * i.vertexColor.a;
        
                half3 _ViewDir = normalize(_WorldSpaceCameraPos - _WorldPos);
                half3 _LightDir = normalize(_WorldSpaceLightPos0);
                half3 _HalfView = normalize(_ViewDir + _LightDir);

                half _Metallic =  1 - _MetallicFixed;
                half _Roughess =  1 - _RoughessFixed;
                half _SquareRoughess = pow2(_Roughess);
                        
                half _VdotH = max(dot(_ViewDir, _HalfView), 0.0001);
                half _NDotH = max(dot(_NormalWorld, _HalfView), 0.0001);
                half _NDotL = max(dot(_NormalWorld, _LightDir), 0.0001);
                half _NDotV = max(dot(_NormalWorld, _ViewDir), 0.0001);
                #ifdef LIGHTMAP_ON
                    half3 lm = LK_DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmapUV));
                    half realtimeShadowAttenuation = 0;
                    half rawOcclusionMask = 0;
                    #ifdef SHADOWS_SHADOWMASK
                        rawOcclusionMask = UNITY_SAMPLE_TEX2D(unity_ShadowMask, i.lightmapUV).r;
                        realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    #endif
                    lm *= _LightmapMul * 2;
                    _Albedo.rgb = _Albedo.rgb * (lm);
                    _Albedo.rgb = BlendShadow(_Albedo, rawOcclusionMask, realtimeShadowAttenuation);
                #else
                    half realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    _Albedo.rgb = _Albedo * (_LightmapMul);
                    _Albedo.rgb = _Albedo * realtimeShadowAttenuation + _Albedo * (1 - realtimeShadowAttenuation) * 0.5;
                #endif

                //高光计算
                half D = _SquareRoughess / (pow2((_NDotH * (_SquareRoughess - 1)) + 1) * UNITY_PI);
            
                half kG = pow2(_Roughess + 1) * 0.125;// div 8
                half Gv = _NDotV / (_NDotV * (1 - kG) + kG);
                half Gl = _NDotL / (_NDotL * (1 - kG) + kG);
                half G = Gl * Gv;

                half F = 1 - abs(_NDotV);
                half4 _Specualr = (D * G * F * 0.25) / (_NDotV * _NDotL) * _SpecInten *  _SpecularColor;
            
                //漫反射
                half3 kd =  _Metallic;
                half4 _Diffuse = half4(kd * _Albedo.rgb, 1);
                
                half4 indirectSpecualr = 0;

                #if _REFLECTION
                //环境反射
                half3 _ReflectDir = normalize(reflect(-_ViewDir, _NormalWorld));
                half _PercetualRoughness = _Roughess * (1.7 - 0.7 * _Roughess);
                half mip = _PercetualRoughness * 6;
                half4 _EnvMap = texCUBEbias(_EnvCube, half4(_ReflectDir, mip));
                half _Grazing = saturate((1 - _Roughess) + 1 - OneMinusReflectivityFromMetallic(_Metallic));
                half _SurfaceReduction = 1 / (_SquareRoughess + 1);
                indirectSpecualr.rgb = lerp(0, _SurfaceReduction * _EnvMap * FresnelLerp(F * _SpecularColor , _Grazing, _NDotV), _ReflectBlend);
                #endif

                half4 col = (_Diffuse + _Specualr) * (_NDotL * 0.5 + 0.5) * UNITY_PI + indirectSpecualr;
                col *= _LightColor0;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
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