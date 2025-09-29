Shader "Teon2/Character/Base"
{
    Properties
    {
        [Header(MainTex Settings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (1,1,1,1)
        [Header(HSV Settings)]
        [Toggle(_HSV_FIXED)]_HSVFixed("HSV Fixed?", Int) = 0
        _Hue ("Hue", Range(0,359)) = 0
        _Saturation ("Saturation", Range(0,3.0)) = 1.0
        _Brightness ("Brightness", Range(0,3.0)) = 1.0
        [Toggle(_VERTEX_NORMAL)]_UseVertexNormal("Use Vertex Normal?", Int) = 0
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Range(-10, 10)) = 1
        [Header(Specular Settings)]
        _Shininess("Shininess", Range(0.03, 5)) = 0.078125
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        [Header(Rim Settings)]
        _RimInten("Rim Intensity", Float) = 1
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _Stencil ("Stencil ID", int) = 1
        [Header(Dissolve Settings)]
        _DissolveMap("DissolveMap", 2D) = "white"{}
        _DissolveThreshold("DissolveThreshold", Range(0,1)) = 0
    }
    SubShader
    {
        LOD 200
        //为了透明物体也有效 queue改为Transparent+1 对其他有影响 细节后续评估
        Tags { "Queue"="AlphaTest+10" "RenderType" = "Opaque" }
        Pass
        {
            Name "Base"
            Cull off
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
            #pragma shader_feature _VERTEX_NORMAL
            #pragma multi_compile _ _HSV_FIXED

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
                #if _VERTEX_NORMAL
                float3 worldNormal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                #else
                //T B N WP
                float4 tSpace0 : TEXCOORD2;
                float4 tSpace1 : TEXCOORD3;
                float4 tSpace2 : TEXCOORD4;
                #endif
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

            sampler2D _DissolveMap;
            float _DissolveThreshold;

            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                #if _VERTEX_NORMAL
                o.worldPos = worldPos;
                o.worldNormal = worldNormal;
                #else
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 binNormal = cross(worldNormal, worldTangent) * v.tangent.w;

                o.tSpace0 = float4(worldTangent.x, binNormal.x, worldNormal.x, worldPos.x);
                o.tSpace1 = float4(worldTangent.y, binNormal.y, worldNormal.y, worldPos.y);
                o.tSpace2 = float4(worldTangent.z, binNormal.z, worldNormal.z, worldPos.z);
                #endif

                UNITY_TRANSFER_FOG(o, o.position);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                float dissolve = tex2D(_DissolveMap, i.uv);
                if(_DissolveThreshold < dissolve)
                {
                    discard;
                }

                #if _VERTEX_NORMAL
                float3 _NormalWorld = i.worldNormal;
                float3 _WorldPos = i.worldPos;
                #else
                float3 bump = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
                float3 _NormalWorld = normalize(float3(dot(i.tSpace0.xyz, bump),
                                                     dot(i.tSpace1.xyz, bump),
                                                     dot(i.tSpace2.xyz, bump)));
                float3 _WorldPos = float3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);
                #endif

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
                float _NDotH = saturate(dot(_NormalWorld, _HalfView));
                float _VDotN = saturate(dot(_NormalWorld, _ViewDir));
                
                //SPECULAR
                float3 _SpecularTerm = BlinnPhongCustomer(_NDotH, _SpecularColor, _Shininess, 1, _SpecInten);
                //RIM
                float _Rim = 1.0 - abs(_VDotN);
                _Rim = pow5(_Rim) * _RimInten;

                _Albedo.rgb += saturate( _SpecularTerm);

                float4 col = _Albedo + _Rim * _RimColor;
                col *= (_LightColor0);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;// (1 - dot(_ViewDir, _LightDir) +  dot(_ViewDir, _LightDir) * _LightColor0);
            }

            ENDCG
        }
        //Pass
        //{
        //    Name "CHARACTERADD"
        //    // 其余光源的操作
        //    Tags {"LightMode" = "ForwardAdd"}
        //    Blend One One
        //    CGPROGRAM

        //    #pragma vertex vert
        //    #pragma fragment frag    
        //    //This line tells Unity to compile this pass for forward add, giving attenuation information for the light.
        //    #pragma multi_compile_fwdadd                    

        //    #include "UnityCG.cginc"
        //    #include "Lighting.cginc"
        //    #include "AutoLight.cginc"
        //    #include "../../Include/CGDefine.cginc"
                        
        //    struct InputData_Add 
        //    {
        //        float4 vertex : POSITION;
        //        float2 texcoord : TEXCOORD0;
        //    };

        //    struct v2f_Add
        //    {
        //        float4 pos : SV_POSITION;
        //        float2 uv : TEXCOORD0;
        //        float3 posWorld : TEXCOORD1;
        //        LIGHTING_COORDS(2, 3)
        //    };

        //    sampler2D _MainTex;
        //    float4 _MainTex_ST;

        //    sampler2D _BumpMap;
        //    float _BumpScale;

        //    v2f_Add vert(InputData_Add v)
        //    {
        //        v2f_Add o;
        //        o.pos = UnityObjectToClipPos(v.vertex);
        //        o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
        //        o.posWorld = mul(unity_ObjectToWorld, v.vertex);
        //        TRANSFER_VERTEX_TO_FRAGMENT(o);
        //        return o;
        //    }

        //    float4 frag(v2f_Add i) : COLOR
        //    {
        //        //更新多点光源计算方式
        //        float3 worldNormal = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
        //        float4 mainCol = tex2D(_MainTex, i.uv);
        //        float3 diffuse = mainCol * clamp(_LightColor0.rgb, 0, TEON_MAX_LIGHT_INTENSITY);

        //        #ifdef USING_DIRECTIONAL_LIGHT
        //            float atten = 1.0;
        //        #else
        //            #if defined (POINT)
        //                float3 lightCoord = mul(unity_WorldToLight, float4(i.posWorld, 1)).xyz;
        //                float atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
        //            #elif defined (SPOT)
        //                float4 lightCoord = mul(unity_WorldToLight, float4(i.posWorld, 1));
        //                float atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
        //            #else
        //                float atten = 1.0;
        //            #endif
        //        #endif

        //        return float4((diffuse) * atten * 0.5, 1.0);
        //    }
        //    ENDCG
        //}
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