Shader "Teon2/Effects/Storm"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTexTiling("MainTexTiling", Vector) = (1,1,0,0)
		_Uspeed("U speed", Float) = 0
		_Vspeed("V speed", Float) = 0
		_RimMin("RimMin", Range( 0 , 1)) = 0
		_RimMax("RimMax", Range( 0 , 1)) = 0
		_RimSmooth("RimSmooth", Float) = 1
		_RimIntensity("RimIntensity", Float) = 1
		_RimAlpha("RimAlpha", Range( 0 , 1)) = 0
    }
    SubShader
    {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        
        ColorMask RGB
        Cull Off Lighting Off ZWrite Off

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "../../Include/CGDefine.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                half4 color : COLOR;
                half2 uv : TEXCOORD0;
                half3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half4 color : COLOR;
                half2 uv : TEXCOORD0;
                half3 normal : TEXCOORD1;
                half3 posWorld : TEXCOORD2;
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _MainColor;
            half4 _MainTexTiling;
            half _Uspeed;
		    half _Vspeed;
		    half _RimMin;
		    half _RimMax;
		    half _RimSmooth;
		    half _RimIntensity;
		    half _RimAlpha;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 ret = 0;
                half2 uv = (i.uv * half2(_MainTexTiling.x, _MainTexTiling.y) + i.uv) + half2(TEON_TIME_Y * _Uspeed, TEON_TIME_Y * _Vspeed);
            
                half4 mainCol = tex2D(_MainTex, uv.xy);
                
                half mask = lerp(mainCol.r, 1.0, _RimAlpha);
                half3 viewDir = normalize(_WorldSpaceCameraPos - i.posWorld);
                half nDv = dot(i.normal, viewDir);
                half smooths = smoothstep(_RimMin, _RimMax, nDv);

                ret.rgb = mainCol.rgb * _MainColor * i.color;
                ret.a = mask * _MainColor.a * i.color.a * (pow(smooths, _RimSmooth) * _RimIntensity);
                return ret;
            }
            ENDCG
        }
    }
}
