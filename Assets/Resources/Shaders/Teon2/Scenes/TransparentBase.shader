Shader "Teon2/Scenes/Transparent/Base"
{
    Properties
    {
        [Header(MainTexSettings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        [HDR]
        _TintColor("Tint Color", COLOR) = (1,1,1,1)
        [Header(HSV Settings)]
        [Toggle(_HSV_FIXED)]_HSVFixed("HSV Fixed?", Int) = 0
        _Hue ("Hue", Range(0,359)) = 0
        _Saturation ("Saturation", Range(0,3.0)) = 1.0
        _Brightness ("Brightness", Range(0,3.0)) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Range(-10, 10)) = 1
        [Header(Specular Settings)]
        _Shininess("Shininess", Range(0.03, 5)) = 0.078125
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        [Header(Rim Settings)]
        _RimInten("Rim Intensity", Float) = 1
        _RimColor("Rim Color", Color) = (1,1,1,1)

        [Header(Snow Settings)]
        [Toggle(_SNOW_FEATURE)]_SnowFeature("积雪效果?", Int) = 0
        _SnowMask("积雪遮罩", 2D) = "white" {}
        _SnowDot("积雪范围", Range(0, 1)) = 0
        _SnowDeep("积雪厚度", Range(0, 1)) = 0
        _SnowDepth("积雪高度", Range(0, 1)) = 0
        _SnowStrong("积雪强度", Range(0, 5)) = 0
        _SnowColor("积雪颜色", COLOR) = (1, 1, 1, 1)
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
            #pragma multi_compile _ _HSV_FIXED
            #pragma multi_compile _ _SNOW_FEATURE

            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"
            #include "../../Include/HSVMathLib.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _BumpMap;
            float _BumpScale;

            float _Shininess;
            float _SpecInten;
            float4 _SpecularColor;

            float _RimInten;
            float4 _RimColor;
          
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

                //Fog
                UNITY_FOG_COORDS(1)
                SHADOW_COORDS(2)

                float3 worldNormal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                
                //GPUInstancing
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_BUFFER_START(Props)
              UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor)
            UNITY_INSTANCING_BUFFER_END(Props)

            float _Hue;
            float _Saturation;
            float _Brightness;

            float _SnowDot;
            float _SnowDeep;
            sampler2D _SnowMask;
            float _SnowDepth;
            float _SnowStrong;
            float4 _SnowColor;

            v2f vert (appdata_t v) 
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                #if _SNOW_FEATURE
                float snDot = dot(o.worldNormal, WORLD_UP);
                v.vertex.xyz += lerp(0, (o.worldNormal + WORLD_UP) * _SnowDepth * abs(snDot), step(0, snDot - _SnowDot));
                #endif

                TRANSFER_SHADOW(o)
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target 
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.

                float3 _NormalWorld = i.worldNormal;
                float3 _WorldPos = i.worldPos;
            
                float4 _Albedo = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                clip(_Albedo.a - 0.1);
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
                float _NDotH = max(dot(_NormalWorld, _HalfView), 0.0001);
                float _VDotN = max(dot(_NormalWorld, _ViewDir), 0.0001);

                _Albedo.rgb = _Albedo.rgb;
                //SPECULAR
                float3 _SpecularTerm = BlinnPhongCustomer(_NDotH, _SpecularColor, _Shininess, 1, _SpecInten);
            
                _Albedo.rgb += saturate( _SpecularTerm);

                #if _SNOW_FEATURE
                float4 snowMask = tex2D(_SnowMask, i.uv);
                _Albedo.rgb = lerp(_Albedo.rgb , _SnowColor, saturate((dot(_NormalWorld, WORLD_UP) + _SnowDeep) * _SnowStrong) * snowMask.r);
                #endif

                float4 col = _Albedo;
                //RIM
                float _Rim = 1.0 - abs(_VDotN);
                _Rim = pow5(_Rim) * _RimInten;
                col.rgb = _Albedo.rgb + _Rim * _RimColor;
                col *= (_LightColor0);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
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