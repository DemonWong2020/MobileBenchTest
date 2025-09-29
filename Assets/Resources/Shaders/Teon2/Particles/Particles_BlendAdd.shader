// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Teon2/Particles/BlendAdd" {
Properties {
    _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    _MainTex ("Particle Texture", 2D) = "white" {}
    _MaskTex("Mask Texture", 2D) = "white" {}
    _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
    [Toggle(_SOFT)]_Soft("Soft?", Int) = 1
}

Category {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
    Blend One OneMinusSrcAlpha
    ColorMask RGB
    Cull Off Lighting Off ZWrite Off

    SubShader {
        Pass {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_particles
            #pragma multi_compile _SOFT
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _MaskTex;
            fixed4 _TintColor;

            struct appdata_t {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                half2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                half2 texcoord : TEXCOORD0;
                half2 texcoordMask : TEXCOORD1;
                UNITY_FOG_COORDS(2)
                #ifdef SOFTPARTICLES_ON
                half4 projPos : TEXCOORD3;
                #endif
                UNITY_VERTEX_OUTPUT_STEREO
            };

            half4 _MainTex_ST;
            half4 _MaskTex_ST;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                #ifdef SOFTPARTICLES_ON
                        #if _SOFT
                            o.projPos = ComputeScreenPos (o.vertex);
                            COMPUTE_EYEDEPTH(o.projPos.z);
                        #endif
                #endif
                o.color = v.color * _TintColor;
                o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
                o.texcoordMask = TRANSFORM_TEX(v.texcoord, _MaskTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            half _InvFade;

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                #ifdef SOFTPARTICLES_ON
                        #if _SOFT
                            half sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                            half partZ = i.projPos.z;
                            half fade = saturate (_InvFade * (sceneZ-partZ));
                            i.color.a *= fade;
                        #endif
                #endif

                fixed4 col = 2.0f * i.color * tex2D(_MainTex, i.texcoord);
                fixed4 mask =  2.0f * i.color * tex2D(_MaskTex, i.texcoordMask);

                col.rgb = lerp(col.rgb * mask.rgb, col.rgb + mask.rgb, col.a);

                col.a = saturate(col.a); // alpha should not have double-brightness applied to it, but we can't fix that legacy behavior without breaking everyone's effects, so instead clamp the output to get sensible HDR behavior (case 967476)

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
}
