Shader "Teon2/Effects/Ice" 
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Base (RGB) Alpha (A)", 2D) = "white" {}
        _Cube("Reflection Cubemap", Cube) = "" {}
        [HDR]_ReflectColor("Reflection Color", Color) = (1,1,1,0.5)
        [NoScaleOffset]
        _BumpMap("Normalmap", 2D) = "bump" {}
        _BumpScale("Normalmap Scale", Float) = 1
        _NoiseMap("NoiseMap", 2D) = "white" {}
        _NoiseSpeed("Noise Speed", Vector) = (0, 0, 0, 0)
        [Header(Specular Settings)]
        _Shininess("Shininess", Range(0.03, 5)) = 0.078125
        _SpecInten("Specular Intensity", Float) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        [Header(Rim Settings)]
        _RimPower("Rim Power", Range(0, 10)) = 1
        _RimInten("Rim Intensity", Float) = 1
        _RimColor("Rim Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags 
        {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
            ZWrite Off
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "../../Include/LightMode.cginc"
            #include "../../Include/CGDefine.cginc"
            #include "UnityCG.cginc"

            struct appdata_t 
            {
                float4 vertex : POSITION;
                half4 texcoord: TEXCOORD0;
                half3 normal : NORMAL;
            };
 
            struct v2f {
                float4 vertex : SV_POSITION;
                half4 uv : TEXCOORD0;
                half3 posWorld : TEXCOORD1;
                half3 normalWorld : TEXCOORD2;
            };

            half4 _Color;
            sampler2D _MainTex;
            half4 _MainTex_ST;    
            samplerCUBE _Cube;
            half4 _ReflectColor;
            sampler2D _BumpMap;
            half _BumpScale;
            sampler2D _NoiseMap;
            half4 _NoiseMap_ST;
            half4 _NoiseSpeed;
            half _Shininess;
            half _SpecInten;
            half4 _SpecularColor;
            half _RimPower;
            half _RimInten;
            half4 _RimColor;
 
            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _NoiseMap);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalWorld = UnityObjectToWorldNormal(v.normal);
                return o;
            }
 
            half4 frag(v2f i) : SV_Target
            {
                half3 _ViewDir = normalize(i.posWorld - _WorldSpaceCameraPos);
                half3 _LightDir = normalize(_WorldSpaceLightPos0);
                half3 _HalfView = normalize(_ViewDir + _LightDir);
                
                half2 bumpUV = i.uv.xy;
                bumpUV.x = bumpUV.x + TEON_TIME_X * _NoiseSpeed.z;
                bumpUV.y = bumpUV.y + TEON_TIME_X * _NoiseSpeed.w;
                half2 noiseUV = i.uv.zw;
                noiseUV.x = noiseUV.x + TEON_TIME_X * _NoiseSpeed.x;
                noiseUV.y = noiseUV.y + TEON_TIME_X * _NoiseSpeed.y;

                half3 bump = UnpackNormalWithScale(tex2D(_BumpMap, bumpUV), _BumpScale) ;
                half noise = tex2D(_NoiseMap, noiseUV);
                half3 refl =  reflect(_ViewDir, bump * 2 - 1);
                half4 col = tex2D(_MainTex, i.uv.xy);
                half3 reflcol = texCUBE(_Cube, refl) * _ReflectColor.a;
                half _NDotH = dot(bump, _HalfView);
                half _VDotN = max(dot(_ViewDir, i.normalWorld), 0.0001);

                reflcol *= noise;
                col.rgb = col.rgb * _Color + reflcol * _ReflectColor.rgb * col;
                half3 _SpecularTerm = BlinnPhongCustomer(_NDotH, _SpecularColor, _Shininess, 0.5, _SpecInten);
                half _Rim = abs(_VDotN);
                _Rim = pow(_Rim, _RimPower) * _RimInten;

                col.rgb += saturate( _SpecularTerm) * noise + _Rim * _RimColor;
                col.a = _Color.a;//col.a * saturate(step(1 - col.a, _Cutoff))*_Alpha;
                return col;
            }
            ENDCG
        }
    }
}