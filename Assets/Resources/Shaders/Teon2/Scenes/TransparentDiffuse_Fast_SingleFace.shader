Shader "Teon2/Scenes/Transparent/Diffuse_Fast_SingleFace"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {

        Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
        Pass 
        {
            Tags { "LightMode" = "ForwardBase" }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off Lighting Off
            AlphaToMask On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"
            #include "../../Include/HSVMathLib.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
          
            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                //Normal
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                //Fog
                UNITY_FOG_COORDS(2)
                SHADOW_COORDS(3)

                //GPUInstancing
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_BUFFER_START(Props)
              UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert (appdata_t v) 
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target 
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                float4 _Albedo = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                clip(_Albedo.a - 0.1);
                float3 _LightDir = normalize(_WorldSpaceLightPos0);

                _Albedo.rgb = _Albedo.rgb * _LightColor0;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, _Albedo);
                return _Albedo;
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