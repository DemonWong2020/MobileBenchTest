Shader "Teon2/Effects/Shield" 
{
    Properties
    {
        [Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4
        [Enum(Off,0,On,1)]_ZWrite("ZWrite", Float) = 1
        [Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 2
        [Header(Base Param)]
        [NoScaleOffset]_MainTex("_MainTex", 2D) = "white" {}
        _Color("Base Color", Color) = (0,0,0,0)
        _ColorPower("Base Color Power", Range( 0 , 3)) = 1
        _Alpha("Base Alpha", Range( 0 , 3)) = 1
        _AddOrBlend("叠加或者混合", Range( 0 , 1)) =1
        _ColorReduce("衰减", Range( 0 , 1)) = 0
        [NoScaleOffset]_FuncTex("R:置换贴图,G:置换遮罩贴图,B:溶解贴图", 2D) = "white"{}
        
        [Header(UV Param)]
        _UVOffset("偏移", Vector) = (1,1,0,0)
        _UVSpeed("流速", Vector) = (0,0,0,0)
        
        [Header(Displace Param)]
        [Toggle(_USE_DISPLACE_ON)] _DISPLACE_ON("置换效果", Float) = 0
        [Toggle(_USE_CUSTOM1_Y_DISPLACE_ON)] _CUSTOM_Y_DISPLACE_ON("自定义置换强度 uv的w", Float) = 0
        _DisplaceUVOffset("置换UV偏移", Vector) = (1,1,0,0)
        _DisplaceUVSpeed("置换UV流速", Vector) = (0,0,0,0)
        _DisplacePower("置换强度", Range( -4 , 4)) = 0
        _DisplaceMaskUVOffset("置换遮罩UV偏移", Vector) = (1,1,0,0)
        _DisplaceMaskUVSpeed("置换遮罩UV流速", Vector) = (0,0,0,0)

        [Header(Frensel Param)]
        [Toggle(_USE_FRENSEL_ON)] _FRENSEL_ON("菲尼尔效果", Float) = 1
        _FRange("菲尼尔范围", Range( 0 , 1)) = 0
        _FHard("菲尼尔硬度", Range( 0 , 1)) = 0.5
        [Toggle(_FRENSEL_FLIP_ON)] _FRENSEL_FLIP("翻转", Float) = 0
        [Toggle(_USE_DEPTH_ON)] _USE_DEPTH("使用边缘深度", Float) = 0
        _FadeDistance("深度范围", Range( 0 , 11)) = 1
        _EdgeHard("边缘硬度", Range( 0 , 1)) = 0.6
        _EdgeRange("边缘范围", Range( 0 , 1)) = 0.1
        [Toggle(_EDGE_KILL_OR_ADD_ON)] _EDGE_KILL_OR_ADD("边缘透明还是叠加", Float) = 0

        [Header(Dissolve Param)]
        [Toggle(_USE_DISSOLVE_ON)] _DISSOLVE_ON("溶解效果", Float) = 0
        _DissolveUVOffset("溶解UV偏移", Vector) = (1,1,0,0)
        _DissolveUVSpeed("溶解UV流速", Vector) = (0,0,0,0)
        _DissolveEdgeHardness("溶解边缘硬度", Range( 0 , 22)) = 16
        _Dissolve("溶解度", Range( 0 , 1)) = 1
        [Toggle(_USE_CUSTOM1_X_DISSOLVE_ON)] _CUSTOM1_X_DISSOLVE_ON("自定义溶解度 uv的z", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
        Blend One OneMinusSrcAlpha
        AlphaToMask Off
        Cull [_Cull]
        ColorMask RGBA
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        Offset 0, 0

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "UnityShaderVariables.cginc"
            #include "../../Include/CGDefine.cginc"
            #pragma shader_feature_local _USE_DISPLACE_ON
            #pragma shader_feature_local _USE_CUSTOM1_Y_DISPLACE_ON
            #pragma shader_feature_local _USE_FRENSEL_ON
            #pragma shader_feature_local _FRENSEL_FLIP_ON
            #pragma shader_feature_local _USE_DEPTH_ON
            #pragma shader_feature_local _EDGE_KILL_OR_ADD_ON
            #pragma shader_feature_local _DISSOLVE_ON
            #pragma shader_feature_local _CUSTOM1_X_DISSOLVE_ON

            struct appdata
            {
                float4 vertex : POSITION;
                half4 color : COLOR;
                half3 normal : NORMAL;
                half4 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                half4 color : COLOR;
                
                half4 texcoord : TEXCOORD0;
                half3 worldPos : TEXCOORD1;
                half3 worldNormal : TEXCOORD2;
                half4 screenPos : TEXCOORD3;

                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            //基础参数
            sampler2D _MainTex;
            half4 _Color;
            half _ColorPower;
            half _Alpha;
            half _AddOrBlend;
            half _ColorReduce;
            sampler2D _FuncTex;
            //uv动画
            half4 _UVOffset;
            half4 _UVSpeed;
            //置换参数
            half4 _DisplaceUVOffset;
            half4 _DisplaceUVSpeed;
            half _DisplacePower;
            half4 _DisplaceMaskUVOffset;
            half4 _DisplaceMaskUVSpeed;
            //菲尼尔效果
            half _FRange;
            half _FHard;
            half _FadeDistance;
            half _EdgeHard;
            half _EdgeRange;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            //溶解效果
            half4 _DissolveUVOffset;
            half4 _DissolveUVSpeed;
            half _DissolveEdgeHardness;
            half _Dissolve;

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                
                o.color = v.color;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                #if _USE_DISPLACE_ON
                    half mulTime = TEON_TIME_Y * _DisplaceUVSpeed.z;
                    half2 displaceUV = v.texcoord * _DisplaceUVOffset.xy + _DisplaceUVOffset.zw;
                    displaceUV += mulTime * _DisplaceUVSpeed.xy;
                    mulTime = TEON_TIME_Y * _DisplaceMaskUVSpeed.z;
                    half2 displaceMaskUV = v.texcoord * _DisplaceMaskUVOffset.xy + _DisplaceMaskUVOffset.zw;
                    displaceMaskUV += mulTime * _DisplaceMaskUVSpeed.xy;
                    half displacePow = _DisplacePower;
                        #if _USE_CUSTOM1_Y_DISPLACE_ON
                            displacePow = v.texcoord.w;
                        #endif
                    half3 displace = v.normal * displacePow *
                        tex2Dlod(_FuncTex, half4(displaceUV, 0, 0.0)).r *
                        tex2Dlod(_FuncTex, half4(displaceMaskUV, 0, 0.0)).g;
                    v.vertex.xyz += displace;
                #endif

                half mulUVTime = TEON_TIME_Y * _UVSpeed.z;
                v.texcoord.xy = v.texcoord * _UVOffset.xy + _UVOffset.zw;
                v.texcoord.xy += mulUVTime * _UVSpeed.xy;
                o.texcoord = v.texcoord;
                o.position = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.screenPos = ComputeScreenPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                fixed4 result;
                fixed4 mainCol = tex2D(_MainTex, i.texcoord);
                half greyCol = dot(mainCol, half3(0.299, 0.587, 0.114));
                mainCol.rgb = lerp(mainCol, greyCol, _ColorReduce);

                half frensel = 1;
                #if _USE_FRENSEL_ON
                    half3 viewDir =  normalize(_WorldSpaceCameraPos - i.worldPos);
                    half NDotV = dot(i.worldNormal, viewDir);
                    half f = saturate(smoothstep(_FRange, _FRange + _FHard, 1 - NDotV));
                        #if _FRENSEL_FLIP_ON
                            f = 1 - f;
                        #endif
                        frensel = f * f;

                        #if _USE_DEPTH_ON
                            half3 projUV = i.screenPos.xyz / i.screenPos.w;
                            projUV.z = (UNITY_NEAR_CLIP_VALUE >= 0 ) ? projUV.z : projUV.z * 0.5 + 0.5;
                            float depth =  LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, projUV.xy));
                            float distance = saturate(abs((depth - LinearEyeDepth(projUV.z) ) / _FadeDistance));
                            half smoothDepth = smoothstep(_EdgeRange , (_EdgeRange + _EdgeHard) , distance);
                            #if _EDGE_KILL_OR_ADD_ON
                                frensel *= smoothDepth;
                            #else 
                                frensel *= saturate(1 - smoothDepth);
                            #endif
                        #endif
                #endif

                half dissolve = 1;
                #if _USE_DISSOLVE_ON
                    half mulTime = TEON_TIME_Y * _DissolveUVSpeed.z;
                    half2 dissolveUV = i.texcoord * _DissolveUVOffset.xy + _DissolveUVOffset.zw;
                    dissolveUV += mulTime * _DissolveUVSpeed.xy;
                    dissolve = _Dissolve;
                    #if _USE_CUSTOM1_X_DISSOLVE_ON
                        dissolve = i.texcoord.z;
                    #endif
                    dissolve = lerp(_DissolveEdgeHardness, -1.0, dissolve);
                    dissolve = saturate(saturate(tex2D(_FuncTex, dissolveUV).b * _DissolveEdgeHardness) - dissolve);
                #endif

                result.a = i.color.a * saturate(frensel * dissolve * mainCol.a);
                result.rgb = mainCol.rgb * _Color * _ColorPower * i.color * result.a;
                result.a *= _AddOrBlend;

                return result;
            }
            ENDCG
        }
    }
}