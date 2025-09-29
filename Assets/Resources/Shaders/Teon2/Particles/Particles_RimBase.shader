Shader "Teon2/Particles/Rim/Base" 
{
    Properties 
    {
        _MainTex ("Particle Texture", 2D) = "white" {}
        _RimPower("Rim Power", Range(0, 10)) = 1
        _RimIntensity("Rim Intensity", Float) = 1
        _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
        [Toggle(_SOFT)]_Soft("Soft?", Int) = 1
    }
    Category 
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        Blend DstColor One
        ColorMask RGB
        Cull back Lighting Off ZWrite Off

        SubShader 
        {
            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0
                #pragma multi_compile_particles
                #pragma multi_compile _SOFT
                //#pragma multi_compile_fog

                #include "UnityCG.cginc"

                sampler2D _MainTex;
                fixed4 _TintColor;
                half4 _MainTex_ST;
                UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
                half _InvFade;
                half _RimPower;
                half _RimIntensity;

                struct appdata_t 
                {
                    float4 vertex : POSITION;
                    fixed4 color : COLOR;
                    half3 normal : NORMAL;
                    half4 texcoord : TEXCOORD0;
                    half4 customData : TEXCOORD1;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct v2f 
                {
                    float4 vertex : SV_POSITION;
                    fixed4 color : COLOR;
                    half3 normalWorld : NORMAL;
                    half4 texcoord : TEXCOORD0;
                    half4 customData : TEXCOORD1;
                    half4 posWorld : TEXCOORD2;
                    UNITY_FOG_COORDS(3)
                    #ifdef SOFTPARTICLES_ON
                    half4 projPos : TEXCOORD4;
                    #endif
                    UNITY_VERTEX_OUTPUT_STEREO
                };


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
                    o.color = v.color;
                    o.texcoord.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
                    o.texcoord.zw = v.texcoord.zw;
                    o.customData = v.customData;
                    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                    o.normalWorld = UnityObjectToWorldNormal(v.normal);
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                fixed4 frag (v2f i) : SV_Target
                {
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                    half3 viewDir = normalize(_WorldSpaceCameraPos - i.posWorld);
                    #ifdef SOFTPARTICLES_ON
                        #if _SOFT
                            half sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                            half partZ = i.projPos.z;
                            half fade = saturate (_InvFade * (sceneZ-partZ));
                            i.color.a *= fade;
                        #endif
                    #endif

                    half3 rimCol = pow(1 - max(0, dot(i.normalWorld, viewDir)), _RimPower) * _RimIntensity * i.customData;

                    fixed4 col = i.color * tex2D(_MainTex, i.texcoord);
                    col.rgb *= rimCol;
                    UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
                    return col;
                }
                ENDCG
            }
        }
    }
}
