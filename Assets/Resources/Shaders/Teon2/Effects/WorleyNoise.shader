Shader "Teon2/Effect/WorleyNoise"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
        _UVScale("UV缩放", Range(1, 100)) = 10
        _InvFade ("Soft Particles Factor", Range(0.01, 10.0)) = 1.0
        [Toggle(_SOFT)]_Soft("Soft?", Int) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Blend One One
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _SOFT
            #pragma multi_compile_particles
            #include "UnityCG.cginc"
            #include "../../Include/CGDefine.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                half2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
                #ifdef SOFTPARTICLES_ON
                half4 projPos : TEXCOORD1;
                #endif
            };

            
            half _UVScale;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            half _InvFade;
            half4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                #ifdef SOFTPARTICLES_ON
                    #if _SOFT
                        o.projPos = ComputeScreenPos(o.vertex);
                        COMPUTE_EYEDEPTH(o.projPos.z);
                    #endif
                #endif
                return o;
            }

            float2 random( float2 p ) 
            {
                return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
            }

            half4 frag (v2f i) : SV_Target
            {
                half min_dist = 10;
                half3 color = 0;

                //UV Pivot Scale
                half2 uv = (i.uv - 0.5) * _UVScale + 0.5;

                half2 id = floor(uv);
                for (int m = -1; m <= 1; m++)
                {
                    for (int n = -1; n <= 1; n++)
                    {
                        half2 searchPoint = id + half2(m, n);
                        
                        searchPoint += sin(random(searchPoint) * UNITY_TWO_PI + TEON_TIME_Y) * 0.5 + 0.5;

                        half dist = distance(uv, searchPoint);
                        min_dist = min(min_dist, dist);
                    }
                }
                
                color = min_dist * min_dist * _Color;
                #ifdef SOFTPARTICLES_ON
                    #if _SOFT
                        half sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                        half partZ = i.projPos.z;
                        half fade = saturate (_InvFade * (sceneZ - partZ));
                        color *= fade;
                    #endif
                #endif
                return half4(color, 1);
            }
            ENDCG
        }
    }
}