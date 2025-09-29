Shader "Teon2/Character/Fast_Status"
{
    Properties
    {
        [Header(MainTex Settings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.CullMode)] _Culling ("Culling", Float) = 2
        [Header(Specular Settings)]
        _Shininess("Shininess", Range(0.03, 5)) = 0.078125
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _Stencil ("Stencil ID", int) = 1
        [Header(Rim Settings)]
        _RimPower("Rim Power", Float) = 1
        [Header(Dissolve Settings)]
        _DissolveMap("DissolveMap", 2D) = "white"{}
        _DissolveThreshold("DissolveThreshold", Range(0,1)) = 0
        _BlendLuminance("Blend Luminance", Range(0, 1)) = 0
        _BlendRim("Blend Rim", Range(0, 1)) = 0
    }
    SubShader
    {
        LOD 200
        //为了透明物体也有效 queue改为Transparent+1 对其他有影响 细节后续评估
        Tags { "Queue"="AlphaTest+10" "RenderType" = "Opaque" }
        Pass
        {
            Name "Base"
            Cull [_Culling]
            Stencil
            {
                Ref [_Stencil]
                Comp Always
                Pass Replace
                ZFail Replace
            }
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

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
                //Instancing
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                //Fog
                UNITY_FOG_COORDS(1)
                float3 worldNormal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                //GPUInstancing
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_INSTANCING_BUFFER_END(Props)

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Shininess;
            float _SpecInten;
            float4 _SpecularColor;

            float _RimPower; 

            sampler2D _DissolveMap;
            float _DissolveThreshold;

            float _BlendLuminance;
            float _BlendRim;

            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                UNITY_TRANSFER_FOG(o, o.position);
                return o;
            }

            float4 frag(v2f i, float face : VFACE) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                float dissolve = tex2D(_DissolveMap, i.uv);
                if(_DissolveThreshold < dissolve)
                {
                    discard;
                }

                float4 _Albedo = tex2D(_MainTex, i.uv);
            
                float3 _ViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 _LightDir = normalize(_WorldSpaceLightPos0);
                float3 _HalfView = normalize(_ViewDir + _LightDir);
                float _NDotH = saturate(dot(i.worldNormal, _HalfView));
                float _VDotN = saturate(dot(i.worldNormal * face, _ViewDir));
                //SPECULAR
                float3 _SpecularTerm = BlinnPhongCustomer(_NDotH, _SpecularColor, _Shininess, 1, _SpecInten);
                _Albedo.rgb += saturate( _SpecularTerm);

                float4 col = _Albedo ;
                float _Rim = saturate( 1.0 - (_VDotN));
                _Rim = pow(_Rim, _RimPower);
		
		        col.rgb = lerp(lerp(col, _VDotN * GreyColor(col), _BlendLuminance), _Rim, _BlendRim);
                col.a = lerp(1, _Rim, _BlendRim);
                col *= _LightColor0;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

            ENDCG
        }
        Pass
        {
            Name "CHARACTERADD"
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
            Name "CHARACTERSHADOWCASTER"
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