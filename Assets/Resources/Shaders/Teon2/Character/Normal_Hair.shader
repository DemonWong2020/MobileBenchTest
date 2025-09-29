Shader "Teon2/Character/Normal_Hair"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        _Clip("Clip",Range(0, 1)) = 0
        _ShiftTexture("Shift Texture", 2D) = "white"{}
        _PrimaryShift("Primary Shift", FLOAT) = 0
        //_SecondaryShift("Secondary Shift", FLOAT) = 0
        _SpecularMultiplier("Specular Multiplier", FLOAT) = 0
        //_SpecularMultiplier2("Specular Multiplier 2", FLOAT) = 0
        [HDR]
        _TintColor("Tint Color", COLOR) = (1,1,1,1)
        [Header(HSV Settings)]
        [Toggle(_HSV_FIXED)]_HSVFixed("HSV Fixed?", Int) = 0
        _Hue ("Hue", Range(0,359)) = 0
        _Saturation ("Saturation", Range(0,3.0)) = 1.0
        _Brightness ("Brightness", Range(0,3.0)) = 1.0
        [Header(PBR Settings)]
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Range(-10, 10)) = 1
        _MRPMap("Metal/Roughess/Parallax Map R:Metallic G:Roughness B:Parllarx", 2D) = "white" {}
        _MetallicFixed("Metallic Fixed", Range(0, 1)) = 1
        _RoughessFixed("Roughness Fixed", Range(0, 1)) = 1
        _ParallaxFixed("Parallax Fixed", Range(0, 0.1)) = 0
        [Header(Fresnel Settings)]
        _F0("Fresnel Base Raito", Color) = (0,0,0,0)
        [Header(Specular Settings)]
        //_Shininess("Shininess", Range(0.03, 5)) = 0.078125
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _SpecularColor2("Specular Color 2", Color) = (1,1,1,1)
        [Toggle(_REFLECTION)]_Reflect("Reflect On?", Int) = 0
        _ReflectCube("Reflect Cube", CUBE) = "" {}
        _ReflectBlend("Reflection Blend", Range(0, 1)) = 0
        _Pow("Pow", Float) = 0.01
        _Strength("Pow Stength", Float) = 0.01
        _RimColor("Rim Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue" = "AlphaTest" }
        Cull off

        ZWrite On

        Pass
        {
        Tags { "LightMode" = "ForwardBase" }
        Blend One OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #pragma shader_feature _REFLECTION
            #pragma multi_compile _ _HSV_FIXED

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"
            #include "../../Include/HSVMathLib.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 vertexColor : COLOR;

                //normal
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 vertexColor : COLOR;
            
                //T B N WP
                float4 tSpace0 : TEXCOORD1;
                float4 tSpace1 : TEXCOORD2;
                float4 tSpace2 : TEXCOORD3;
                SHADOW_COORDS(4)
                UNITY_FOG_COORDS(5)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TintColor;
            float _Clip;

            sampler2D _ShiftTexture;
            float _PrimaryShift;
            float _SecondaryShift;
            float _SpecularMultiplier;
            float _SpecularMultiplier2;

            float _Hue;
            float _Saturation;
            float _Brightness;

            sampler2D _BumpMap;
            float _BumpScale;

            sampler2D _MRPMap;
            float _MetallicFixed;
            float _RoughessFixed;
            float _ParallaxFixed;

            float4 _F0;

            float _SpecInten;
            float4 _SpecularColor;
            float4 _SpecularColor2;

            samplerCUBE _ReflectCube;
            float _ReflectBlend;
            
            float _Pow;
            float _Strength;
            float4 _RimColor;

            //获取头发高光
            float StrandSpecular (float3 T, float3 V, float3 L, float exponent)
            {
                float3 H = normalize(L + V);
                float dotTH = dot(T, H);
                float sinTH = sqrt(1 - dotTH * dotTH);
                float dirAtten = smoothstep(-1, 0, dotTH);
                return dirAtten * pow(sinTH, exponent);
            }
            
            //沿着法线方向调整Tangent方向
            float3 ShiftTangent (float3 T, float3 N, float shift)
            {
                return normalize(T + shift * N);
            }
            
            v2f vert(appdata v)
            {
                v2f o = (v2f)0;

                o.position = UnityObjectToClipPos(v.vertex);
                o.vertexColor = v.vertexColor;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);

            
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 binNormal = cross(worldNormal, worldTangent) * v.tangent.w;

                o.tSpace0 = float4(worldTangent.x, binNormal.x, worldNormal.x, worldPos.x);
                o.tSpace1 = float4(worldTangent.y, binNormal.y, worldNormal.y, worldPos.y);
                o.tSpace2 = float4(worldTangent.z, binNormal.z, worldNormal.z, worldPos.z);

                TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.position);
                return o;
            }

            float4 frag(v2f i, float facing : VFACE) : SV_Target
            {
                float3 bump = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);

                float3 _NormalWorld = normalize(float3(dot(i.tSpace0.xyz, bump),
                                                     dot(i.tSpace1.xyz, bump),
                                                     dot(i.tSpace2.xyz, bump))) * (facing > 0 ? 1 : -1);
                float3 _WorldPos = float3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);
                float3 _MRPCol = tex2D(_MRPMap, i.uv);
                // 高度图中描述的高度数据
                float2 parallaxDelta = GetParallaxDelta(_MRPCol.b, _ParallaxFixed, _WorldPos);
                //uv偏移
                i.uv += parallaxDelta;
                float4 _Albedo = tex2D(_MainTex, i.uv) * _TintColor * i.vertexColor.a;
                clip(_Albedo.a - _Clip);
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

                float _Metallic = _MRPCol.r * _MetallicFixed;
                float _Roughess = _MRPCol.g * (1 - _RoughessFixed);
                float _SquareRoughess = pow2(_Roughess);
            
                float _VdotH = max(dot(_ViewDir, _HalfView), 0.0001);
                float _NDotH = max(dot(_NormalWorld, _HalfView), 0.0001);
                float _NDotL = max(dot(_NormalWorld, _LightDir), 0.0001);
                float _NDotV = max(dot(_NormalWorld, _ViewDir), 0.0001);

                ////BlinnPhong计算
                //half3 _SpecularTerm = BlinnPhongCustomer(_NDotH, _LightColor0, _Shininess, _SquareRoughess, _SpecInten);
                //half3 _ReflectColor = 0;

                //#if _REFLECTION
                //half mip_roughness = _SquareRoughess * (1.7 - 0.7 * _SquareRoughess);
                //half3 reflectVec = reflect(-_ViewDir, _NormalWorld);
                //half mip = mip_roughness * UNITY_SPECCUBE_LOD_STEPS;
                //_ReflectColor = lerp(0, UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectVec, mip), _ReflectBlend);
                //#endif
                
                //half3 _Fresnel = FresnelFunction(_Albedo, _Metallic, _VdotH);
                //_Albedo.rgb *= 
                //_Albedo.rgb += (_SpecularTerm + _ReflectColor) * _Fresnel;
            
                //return _Albedo;

                //高光计算
                float D = _SquareRoughess / (pow2((_NDotH * (_SquareRoughess - 1)) + 1) * UNITY_PI);
                
                float kG = pow2(_Roughess + 1) * 0.125;// div 8
                float Gv = _NDotV / (_NDotV * (1 - kG) + kG);
                float Gl = _NDotL / (_NDotL * (1 - kG) + kG);
                float G = Gl * Gv;
                
                float F = FresnelFunction(_F0, _VdotH);

                float shiftTex = tex2D(_ShiftTexture, i.uv).r;
                //计算切线方向的偏移度
                float3 _BinNormal = float3(i.tSpace0.y, i.tSpace1.y, i.tSpace2.y);
                float3 t1 = ShiftTangent(_BinNormal, _NormalWorld, _PrimaryShift + shiftTex);
                //half3 t2 = ShiftTangent(_BinNormal, _NormalWorld, _SecondaryShift + shiftTex);
                //计算高光强度        
                float spec1 = saturate(StrandSpecular(t1, _ViewDir, _LightDir, _SpecularMultiplier));
                //half spec2 = saturate(StrandSpecular(t2, _ViewDir, _LightDir, _SpecularMultiplier2));
        
                float4 _Specualr = (spec1 * _SpecularColor  * _SpecInten);
            
                //漫反射
                float kd = (1 - F) * (1 - _Metallic);
                float _Diffuse = kd;
                //_Diffuse.rgb +=  _Albedo.rgb *  (1 - F) * (_Metallic);
                float4 _IndirectSpecualr = 0;

                #if _REFLECTION
                //环境反射
                float3 _ReflectDir = normalize(reflect(-_ViewDir, _NormalWorld));
                float _PercetualRoughness = _Roughess * (1.7 - 0.7 * _Roughess);
                float mip = _PercetualRoughness * 6;
                float4 _EnvMap = texCUBEbias(_ReflectCube, float4(_ReflectDir, mip));
                float _Grazing = saturate((1 - _Roughess) + 1 - OneMinusReflectivityFromMetallic(_Metallic));
                float _SurfaceReduction = 1 / (_SquareRoughess + 1);
                _IndirectSpecualr.rgb = lerp(0, _SurfaceReduction * _EnvMap * FresnelLerp(float4(_F0.rgb ,1), _Grazing, _NDotV) * _SpecularColor, _ReflectBlend);
                #endif
                
                float3 _PointLight = Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                                                unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                                                unity_4LightAtten0,
                                                _WorldPos, _NormalWorld);

                float4 rim = pow(saturate(1 - _NDotV), _Pow) * _MRPCol.b * _Strength * _RimColor;

                float4 ret = 0;
                
                float atten = SHADOW_ATTENUATION(i);
                ret.rgb = (UNITY_LIGHTMODEL_AMBIENT + _Diffuse + _Specualr + _PointLight + rim) * (_LightColor0 *  (_NDotL * 0.5 + 0.5) * atten) * _Albedo  + _IndirectSpecualr;
            
                UNITY_APPLY_FOG(i.fogCoord, ret);
                ret.a = _Albedo.a;
                return ret;
            }
            ENDCG
        }
        Pass
        {
            Name "Forward_Add"
            // 其余光源的操作
            Tags {"LightMode" = "ForwardAdd"}
            Blend one one
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag    
            //This line tells Unity to compile this pass for forward add, giving attenuation information for the light.
            #pragma multi_compile_fwdadd                    

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"

            struct InputData_Add 
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                //normal
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f_Add
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                //T B N WP
                float4 tSpace0 : TEXCOORD1;
                float4 tSpace1 : TEXCOORD2;
                float4 tSpace2 : TEXCOORD3;
                LIGHTING_COORDS(4, 5)
            };
        
            sampler2D _MainTex;
            float _Clip;

            sampler2D _BumpMap;
            float _BumpScale;

            sampler2D _MRPMap;
            float _MetallicFixed;
            float _RoughessFixed;

            float4 _F0;
            float _SpecInten;

            v2f_Add vert(InputData_Add v)
            {
                v2f_Add o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 binNormal = cross(worldNormal, worldTangent) * v.tangent.w;

                o.tSpace0 = float4(worldTangent.x, binNormal.x, worldNormal.x, worldPos.x);
                o.tSpace1 = float4(worldTangent.y, binNormal.y, worldNormal.y, worldPos.y);
                o.tSpace2 = float4(worldTangent.z, binNormal.z, worldNormal.z, worldPos.z);

                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(v2f_Add i, float facing : VFACE) : COLOR
            {
                float3 bump = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
                float3 _NormalWorld = normalize(float3(dot(i.tSpace0.xyz, bump),
                                                     dot(i.tSpace1.xyz, bump),
                                                     dot(i.tSpace2.xyz, bump))) * (facing > 0 ? 1 : -1);
                float3 _WorldPos = float3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);
                float4 _Albedo = tex2D(_MainTex, i.uv);
                clip (_Albedo.a - _Clip);
                float3 _MRPCol = tex2D(_MRPMap, i.uv);

                float3 _ViewDir = normalize(_WorldSpaceCameraPos - _WorldPos);
                //更新多点光源计算方式
                #ifdef USING_DIRECTIONAL_LIGHT
                    float3 _LightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                    float3 _LightDir = normalize(_WorldSpaceLightPos0.xyz - _WorldPos);
                #endif
                float3 _HalfView = normalize(_ViewDir + _LightDir);

                float _Metallic = _MRPCol.r * _MetallicFixed;
                float _Roughess = _MRPCol.g * (1 - _RoughessFixed);
                float _SquareRoughess = pow2(_Roughess);
            
                float _NDotH = max(dot(_NormalWorld, _HalfView), 0.0001);
                float _NDotL = max(dot(_NormalWorld, _LightDir), 0.0001);
        
                float _Diffuse = _NDotL;
                float _Specular = pow(_NDotH, _Roughess);
        
                #ifdef USING_DIRECTIONAL_LIGHT
                    float atten = 1.0;
                #else
                    #if defined (POINT)
                        float3 lightCoord = mul(unity_WorldToLight, float4(_WorldPos, 1)).xyz;
                        float atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                    #elif defined (SPOT)
                        float4 lightCoord = mul(unity_WorldToLight, float4(_WorldPos, 1));
                        float atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                    #else
                        float atten = 1.0;
                    #endif
                #endif
                float4 ret = _Diffuse * _Specular * _LightColor0 * _Albedo * atten;
                ret.a = _Albedo.a;
                return ret;
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