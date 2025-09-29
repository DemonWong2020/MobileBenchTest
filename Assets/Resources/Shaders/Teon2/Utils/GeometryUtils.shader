Shader "Hidden/GeometryUtils"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            Name "Forward_Add"
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
            Name "Forward_GroundAdd"
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

            sampler2D _MaskMap1;
            sampler2D _MaskMap2;

            TEON_SAMPLER2D_ST(_TileMapAtlas)
            TEON_TILEMAP_PHOTOSITE_TILLING(_MaskMap1);
            TEON_TILEMAP_PHOTOSITE_TILLING(_MaskMap2);

            v2f_Add vert(InputData_Add v)
            {
                v2f_Add o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(v2f_Add i) : COLOR
            {
                //更新多点光源计算方式
                float4 maskMap1 = tex2D(_MaskMap1, i.uv);
                float4 maskMap2 = tex2D(_MaskMap2, i.uv);
                float3 normal = 0;
                float4 result = 0;
                float3 lightDir = normalize(_WorldSpaceLightPos0);

                result += GetTileMapColor(_TileMapAtlas, 0, i.uv, _TileMapAtlas_ST.xy, _MaskMap1R,
                                           maskMap1.r, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 1, i.uv, _TileMapAtlas_ST.xy, _MaskMap1G,
                                           maskMap1.g, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 2, i.uv, _TileMapAtlas_ST.xy, _MaskMap1B,
                                           maskMap1.b, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 3, i.uv, _TileMapAtlas_ST.xy, _MaskMap1A,
                                           maskMap1.a, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 4, i.uv, _TileMapAtlas_ST.xy, _MaskMap2R,
                                           maskMap2.r, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 5, i.uv, _TileMapAtlas_ST.xy, _MaskMap2G,
                                           maskMap2.g, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 6, i.uv, _TileMapAtlas_ST.xy, _MaskMap2B,
                                           maskMap2.b, lightDir, normal);
                result += GetTileMapColor(_TileMapAtlas, 7, i.uv, _TileMapAtlas_ST.xy, _MaskMap2A,
                                           maskMap2.a, lightDir, normal);  

                float3 diffuse = result * clamp(_LightColor0.rgb, 0, TEON_MAX_LIGHT_INTENSITY);

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

                return float4(diffuse * atten * 0.5, 1.0);
            }
            ENDCG
        }
        Pass
        {
            Name "Meta"
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
            Name "ShadowCaster"
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
        Pass
        {
            Name "CharacterAdd"
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
            Name "CharacterShadowCaster"
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
                float2 uv : TEXCOORD1;
            };

            sampler2D _DissolveMap;
            float _DissolveThreshold;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.uv = v.texcoord;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float dissolve = tex2D(_DissolveMap, i.uv);
                if(_DissolveThreshold < dissolve)
                {
                    discard;
                }

                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}