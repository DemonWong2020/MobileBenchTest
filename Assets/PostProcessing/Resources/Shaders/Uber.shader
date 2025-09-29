Shader "Hidden/Post FX/Uber Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AutoExposure ("", 2D) = "" {}
        _BloomTex ("", 2D) = "" {}
    }

    CGINCLUDE

        #pragma target 3.0

        #pragma multi_compile __ UNITY_COLORSPACE_GAMMA
        #pragma multi_compile __ BLOOM
        #pragma multi_compile __ FOG_ON
        #pragma multi_compile __ GREY_ON

        #include "UnityCG.cginc"
        #include "Bloom.cginc"

        sampler2D _AutoExposure;
        sampler2D _CameraDepthTexture;
       
        // Bloom
        sampler2D _BloomTex;
        float4 _BloomTex_TexelSize;
        float4 _Bloom_Settings; // x: sampleScale, y: bloom.intensity

        //Fog
        float4 _FogColor;
        float _FogDensity;
        float2 _FogSpeed;
        float _DigRadius;
        float _Disturbance;
        sampler2D _DisturbanceTex;
        half _GreyBlend;

        struct VaryingsFlipped
        {
            half4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float2 uvSPR : TEXCOORD1; // Single Pass Stereo UVs
            float2 uvFlipped : TEXCOORD2; // Flipped UVs (DX/MSAA/Forward)
            float2 uvFlippedSPR : TEXCOORD3; // Single Pass Stereo flipped UVs
        };

        VaryingsFlipped VertUber(AttributesDefault v)
        {
            VaryingsFlipped o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord.xy;
            o.uvSPR = UnityStereoScreenSpaceUVAdjust(v.texcoord.xy, _MainTex_ST);
            o.uvFlipped = v.texcoord.xy;

        #if UNITY_UV_STARTS_AT_TOP
            if (_MainTex_TexelSize.y < 0.0)
                o.uvFlipped.y = 1.0 - o.uvFlipped.y;
        #endif
            o.uvFlippedSPR = UnityStereoScreenSpaceUVAdjust(o.uvFlipped, _MainTex_ST);
	
            return o;
        }

        float4 FragUber(VaryingsFlipped i) : SV_Target
        {
            float2 uv = i.uv;
            half autoExposure = tex2D(_AutoExposure, uv).r;
            half3 color = tex2D(_MainTex, uv);

            //
            // HDR effects
            // ---------------------------------------------------------
            // Gamma space... Gah.
            #if UNITY_COLORSPACE_GAMMA
            {
                color = GammaToLinearSpace(color);
            }
            #endif

            // HDR Bloom
            #if BLOOM
            {
                half3 bloom = UpsampleFilter(_BloomTex, i.uvFlippedSPR, _BloomTex_TexelSize.xy, _Bloom_Settings.x) * _Bloom_Settings.y;
                color += (bloom * _Bloom_Settings.z);

            }
            #endif

            #if FOG_ON
            half depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uvFlippedSPR));
            
			depth = Linear01Depth(depth) * _FogDensity;
            half2 disturUv = uv + depth + _FogSpeed * _Time.x;
            half4 disturCol = tex2D(_DisturbanceTex, disturUv);
            half round = 1 - (smoothstep(0, length(i.uv - 0.5), _DigRadius));
			color += lerp(depth , depth * disturCol, _Disturbance) * round * _FogColor;
            #endif

            //
            // All the following effects happen in LDR
            // ---------------------------------------------------------

            color = saturate(color);

            #if GREY_ON

            color = lerp(color, dot(color, GREY_DOT), _GreyBlend);

            #endif

            // Back to gamma space if needed
            #if UNITY_COLORSPACE_GAMMA
            {
                color = LinearToGammaSpace(color);
            }
            #endif
            // Done !
            return float4(color, 1.0);
        }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        // (0)
        Pass
        {
            CGPROGRAM

                #pragma vertex VertUber
                #pragma fragment FragUber

            ENDCG
        }
    }
}
