Shader "Effect/ScreenHole" 
{
    Properties 
    {
        _MainColor ("Main Color", Color) = (0,0,0,1)
        _DrakPower("Drak Power", Range(0, 10)) = 10
        _HoldeSize("Hole Size",Range(0, 1)) = 0
        _Min("Min Drak", Range(0, 1)) = 0.01
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata_t 
            {
                float4 vertex : POSITION;
                half2 texcoord :  TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                half2 texcoord :  TEXCOORD0;
            };

            half4 _MainColor;
            half _DrakPower;
            half _HoldeSize;
            half _Min;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half4 ret = _MainColor;
                ret.a = 1 - max(0.01, length(i.texcoord - fixed2(0.5,0.5)) - _HoldeSize);
                ret.a = max(_Min, pow(ret.a, _DrakPower));
                ret.a = 1 - ret.a;
                return ret;
            }


            ENDCG            
        }
    }
}