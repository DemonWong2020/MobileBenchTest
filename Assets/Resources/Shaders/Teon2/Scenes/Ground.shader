Shader "Teon2/Scenes/Ground"
{
    Properties
    {
        [NoScaleOffset] _MaskMap1("Mask Map 1", 2D) = "black" {}
        [NoScaleOffset] _MaskMap2("Mask Map 2", 2D) = "black" {}

        _TileMapAtlas("Tilemap Atlas,Tilling Size For Size(ex.4x4=16 quads)", 2D) = "black" {}
      
        _MaskMap1R("MaskMap1 R Channel Photosite Tilling", vector) = (1,1,0,0)
        _MaskMap1G("MaskMap1 G Channel Photosite Tilling", vector) = (1,1,0,0)
        _MaskMap1B("MaskMap1 B Channel Photosite Tilling", vector) = (1,1,0,0)
        _MaskMap1A("MaskMap1 A Channel Photosite Tilling", vector) = (1,1,0,0)

        _MaskMap2R("MaskMap2 R Channel Photosite Tilling", vector) = (1,1,0,0)
        _MaskMap2G("MaskMap2 G Channel Photosite Tilling", vector) = (1,1,0,0)
        _MaskMap2B("MaskMap2 B Channel Photosite Tilling", vector) = (1,1,0,0)
        _MaskMap2A("MaskMap2 A Channel Photosite Tilling", vector) = (1,1,0,0)

        [Header(LightMap Settings)]
        _LightmapMul("Lightmap Multiply", Range(0, 10)) = 1
    }
 
    SubShader
    {
        Tags { "Queue"="AlphaTest+11" "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fog
            #pragma multi_compile _ LIGHTMAP_ON 
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ SHADOWS_SCREEN
            #include "../../Include/CGDefine.cginc"
 
            sampler2D _MaskMap1;
            sampler2D _MaskMap2;

            TEON_SAMPLER2D_ST(_TileMapAtlas)
            TEON_TILEMAP_PHOTOSITE_TILLING(_MaskMap1);
            TEON_TILEMAP_PHOTOSITE_TILLING(_MaskMap2);

            float _LightmapMul;

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float2 lightmapUV : TEXCOORD1;
            };
 
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 lightmapUV : TEXCOORD1;
                //Fog
                UNITY_FOG_COORDS(2)
                LK_SHADOW_COORDS(3)
            };
 
            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                #ifdef LIGHTMAP_ON
                o.lightmapUV = v.lightmapUV.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif
                LK_TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }
 
            float4 frag(v2f i) : SV_Target
            {
                float4 maskMap1 = tex2D(_MaskMap1, i.uv);
                float4 maskMap2 = tex2D(_MaskMap2, i.uv);

                float4 result = 0;

                float3 lightDir = normalize(_WorldSpaceLightPos0);
                float3 normal = 0;

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

                float3 _LightDir = normalize(_WorldSpaceLightPos0);
                float _NDotL = dot(normal, _LightDir);

                #ifdef LIGHTMAP_ON
                    float3 lm = LK_DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmapUV));
                    float realtimeShadowAttenuation = 0;
                    float rawOcclusionMask = 0;
                    #ifdef SHADOWS_SHADOWMASK
                        rawOcclusionMask = UNITY_SAMPLE_TEX2D(unity_ShadowMask, i.lightmapUV).r;
                        realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    #endif
                    lm *= _LightmapMul * 2;
                    result.rgb *= (lm * _LightColor0);
                    result.rgb = BlendShadow(result, rawOcclusionMask, realtimeShadowAttenuation);
                #else
                    float realtimeShadowAttenuation = LK_SHADOW_ATTENUATION(i);
                    result.rgb *= (_LightmapMul * _LightColor0);
                    result.rgb *= realtimeShadowAttenuation * 0.5 +  0.5;
                #endif
                //Fog
                UNITY_APPLY_FOG(i.fogCoord, result);
               
                return saturate(result);
            }
            ENDCG
        }
        Pass
        {
            Name "FORWARD_GROUNDADD"
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