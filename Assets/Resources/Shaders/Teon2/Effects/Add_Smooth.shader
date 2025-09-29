
Shader "Teon2/Effects/Add_Smooth" {
    Properties {
        [HDR]_TintColor("Color", Color) = (1,1,1,1)
        _FadeRange("range", range(-1,0)) = -0.5
        _FadeFactor("factor", range(0,10)) = 1
        _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
        [Toggle(_SOFT)]_Soft("Soft?", Int) = 1
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "DisableBatching" = "true"
        }

        Cull Off
        ZWrite Off

        Pass {
            Blend SrcAlpha One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _SOFT
            #include "UnityCG.cginc"
            //uniform float4 _MainTex_ST;

            half4 _TintColor;
            half _Range;
            half _FadeRange;
            half _FadeFactor;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            half _InvFade;
            //uniform float _Depth;
            struct VertexInput 
            {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half4 vertexColor : COLOR;
                half3 normal:NORMAL;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 vertexColor : COLOR;
                half3 worldNormal : TEXCOORD1;
                half3 worldPos : TEXCOORD2;
                half modelPosZ : TEXCOORD3;
                UNITY_FOG_COORDS(4)
                #ifdef SOFTPARTICLES_ON
                half4 projPos : TEXCOORD5;
                #endif
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.modelPosZ = v.vertex.y;
                
                o.pos = UnityObjectToClipPos( v.vertex );
                
                #ifdef SOFTPARTICLES_ON
                    #if _SOFT
                        o.projPos = ComputeScreenPos (o.vertex);
                        COMPUTE_EYEDEPTH(o.projPos.z);
                    #endif
                #endif
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR 
            {
                 #ifdef SOFTPARTICLES_ON
                    #if _SOFT
                        half sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                        half partZ = i.projPos.z;
                        half fade = saturate (_InvFade * (sceneZ-partZ));
                        i.vertexColor.a *= fade;
                    #endif
                #endif
                //边缘虚化
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 worldNormal = normalize(i.worldNormal);
                _TintColor.a *= abs(dot(viewDir, worldNormal));

                //底部虚化
                if (i.modelPosZ < _FadeRange) {
                    _TintColor.a = lerp(_TintColor.a, 0, saturate(abs(i.modelPosZ - _FadeRange) * _FadeFactor));
                }

                half3 finalColor = i.vertexColor.a * _TintColor.a * i.vertexColor.rgb * _TintColor.rgb;
                fixed4 finalRGBA = fixed4(finalColor,  i.vertexColor.a * _TintColor.a);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,1));

                return finalRGBA;
            }
            ENDCG
        }
    }
    //CustomEditor "ShaderForgeMaterialInspector"
}
