Shader "Teon2/Character/Tex"
{
    Properties
    {
        [Header(MainTex Settings)]
        _MainTex("Diffuse ", 2D) = "white" {}
        _Stencil ("Stencil ID", int) = 1
    }
    SubShader
    {
        LOD 200
        //为了透明物体也有效 queue改为Transparent+1 对其他有影响 细节后续评估
        Tags { "Queue"="Transparent" "RenderType" = "Opaque" }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            Name "Base"
            Cull Off
            Stencil
            {
                Ref [_Stencil]
                Comp Always
                Pass Replace
                ZFail Replace
            }
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM

            #include "../../Include/CGDefine.cginc"
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;

            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;
             
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 ret = tex2D(_MainTex, i.uv);
                return ret;
            }

            ENDCG
        }
    }
}
