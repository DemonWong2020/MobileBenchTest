// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

Shader "Teon2/Scenes/Tree-Move"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (0.5, 0.5, 0.5, 1)
        [Toggle(_HSV_FIXED)]_HSVFixed("HSV Fixed?", Int) = 0
        _Hue ("Hue", Range(0,359)) = 0
        _Saturation ("Saturation", Range(0,3.0)) = 1.0
        _Brightness ("Brightness", Range(0,3.0)) = 1.0
        [Header(LightMap Settings)]
        _LightmapMul("Lightmap Multiply", Range(0, 10)) = 1
        [Header(Move Parameter)]
        _Range("Range", Range(0, 0.3)) = 0.13
        _Rate("Rate", Range(0, 8)) = 3
        [Header(Clip Parameter)]
        _Clip("Clip", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" "IgnoreProjector"="True" }
     
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            Cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ _HSV_FIXED

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
                float2 lightmapUV : TEXCOORD1;
                float4 color : COLOR;
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

                float3 worldNormal : TEXCOORD4;
                float3 worldPos : TEXCOORD5;
                
                //GPUInstancing
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_BUFFER_START(Props)
              UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor)
            UNITY_INSTANCING_BUFFER_END(Props)


            float _Hue;
            float _Saturation;
            float _Brightness;
            
            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _BumpMap;
            float _BumpScale;

            float _Shininess;
            float _SpecInten;
            float4 _SpecularColor;

            float _RimInten;
            float4 _RimColor;

            float _LightmapMul;
            
            float _Range;
            float _Rate;

            float _Clip;

            v2f vert (appdata_t v)
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.
                float4 vertex = v.vertex;
                o.worldPos = mul(unity_ObjectToWorld, vertex);
                float l = dot(o.worldPos, 1);
                //
                vertex.xz += v.color.r * sin(TEON_TIME_Y * _Rate * frac(l)) * _Range * v.normal.x;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                #ifdef LIGHTMAP_ON
                o.lightmapUV = v.lightmapUV.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif

                
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                LK_TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                float4 _Albedo = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                clip(_Albedo.a - _Clip);
                
                float3 _NormalWorld = i.worldNormal;
                float3 _WorldPos = i.worldPos;

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
                float _NDotL = dot(_NormalWorld, _LightDir);

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
                float4 ret = _Albedo;
                ret.rgb += saturate( _SpecularTerm);
                ret *= _LightColor0;

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, ret);
                ret.a = _Albedo.a;
                return ret;
            }
            ENDCG
        }
        Pass
        {
            Name "FORWARDMOVECLIP_ADD"
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
                float4 color : COLOR;
                float3 normal : NORMAL;
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

            float _Range;
            float _Rate;

            float _Clip;

            v2f_Add vert(InputData_Add v)
            {
                v2f_Add o;
                float4 vertex = v.vertex;
               
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.posWorld = mul(unity_ObjectToWorld, vertex);
                float l = dot(o.posWorld, 1);

                vertex.xz += v.color.r * sin(TEON_TIME_Y * _Rate * frac(l)) * _Range * v.normal.x;
                o.pos = UnityObjectToClipPos(vertex);

                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(v2f_Add i) : COLOR
            {
                //更新多点光源计算方式
                float3 worldNormal = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
                float4 mainCol = tex2D(_MainTex, i.uv);
                clip(mainCol.a - _Clip);

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
                float2 texcoord : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TintColor;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.texcoord) * _TintColor;
                clip(col.a - 0.5);
                return 1;
            }
            ENDCG
        }
    }
}