Shader "Teon2/Effects/Smoke"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Itensity("Itensity", Range(1, 2)) = 1
        _Distub ("Distub Tex", 2D) = "white" {}
        _DistubMovement("Distub UV Speed", Vector) = (0, 0, 0, 0)
        _DistubStart("Distub Start", Range(0, 1)) = 1
        _DistubEnd("Distub End", Range(0, 1)) = 0.2
    }
    SubShader
    {
        Blend SrcAlpha One
        ZWrite Off
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "../../Include/CGDefine.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 distubUV : TEXCOORD1;
                
            };

            sampler2D _MainTex;
            float _Itensity;
            float4 _MainTex_ST;
            sampler2D _Distub;
            float4 _Distub_ST;
            float4 _DistubMovement;
            float _DistubStart;
            float _DistubEnd;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                half2 dUV = v.uv + TEON_TIME_Y * _DistubMovement.xy;
                o.distubUV = TRANSFORM_TEX(dUV, _Distub);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 _dist = tex2D(_Distub, i.distubUV);
                half2 uv = lerp(i.uv, i.uv + _dist, saturate(abs(i.uv.y - _DistubStart)));
                
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= _Itensity;
                col.a =  lerp(col.a, _dist.r, saturate(abs(i.uv.y - _DistubStart) - _DistubEnd));
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return saturate(col);
            }
            ENDCG
        }
    }
}
