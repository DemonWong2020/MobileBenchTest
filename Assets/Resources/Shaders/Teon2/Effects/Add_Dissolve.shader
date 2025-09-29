Shader "Teon2/Effects/Add_Dissolve"
{
    Properties
    {
        _MainTex("Base 2D", 2D) = "white"{}
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        [HDR]
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        [HDR]
        _DissolveColor("Dissolve Color", Color) = (0,0,0,0)
        [HDR]
        _DissolveEdgeColor("Dissolve Edge Color", Color) = (1,1,1,1)
        _DissolveItensity ("DissolveItensity", Range(0, 2)) = 0
        _DissolveMap("DissolveMap", 2D) = "white"{}
        _DissolveThreshold("DissolveThreshold", Range(0,1)) = 0
        _ColorFactor("ColorFactor", Range(0,1)) = 0.7
        _DissolveEdge("DissolveEdge", Range(0,1)) = 0.8
        [MaterialToggle] _ParticalControl ("ParticalControl", Float ) = 0
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
            Blend SrcAlpha One
            ColorMask RGB
            Cull Off
            ZWrite Off
            AlphaToMask On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag    
            //#pragma target 2.0
            #pragma multi_compile_particles
            //#pragma multi_compile_fog
            #include "Lighting.cginc"
            #include "../../Include/CGDefine.cginc"

            fixed4 _Diffuse;
            fixed4 _DissolveColor;
            fixed4 _DissolveEdgeColor;
            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            sampler2D _DissolveMap;
            fixed4 _DissolveMap_ST;
            fixed _DissolveThreshold;
            fixed _ColorFactor;
            fixed _DissolveEdge;
            fixed _U_Speed;
            fixed _V_Speed;
            fixed _ParticalControl;
            fixed _DissolveItensity;

            struct appdata_t {
                float4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
                half2 texcoord1 : TEXCOORD1;
                half4 vertexColor : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half4 uv : TEXCOORD0;    //xy main zw dissolve
                half2 uv1 : TEXCOORD1;
                half4 vertexColor : COLOR;
            };
    
            v2f vert(appdata_t v)
            {
                v2f o = (v2f)0;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _DissolveMap);
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;

                return o;
            }
    
            fixed4 frag(v2f i) : SV_Target
            {
                //采样Dissolve Map
                fixed4 dissolveValue = tex2D(_DissolveMap, i.uv.zw);
                //保留项目
                half node_2336 = (dissolveValue.r / lerp(_DissolveItensity, step(dissolveValue.r, i.uv1.r), _ParticalControl));
                half node_6017 = saturate(node_2336);
                //小于阈值的部分直接discard
                if (node_6017 < _DissolveThreshold)
                {
                    discard;
                }

                fixed2 uv = i.uv.xy + (TEON_TIME_Y * half2(_U_Speed, _V_Speed));
                fixed4 color = tex2D(_MainTex, uv) * _Diffuse;
 
                //优化版本，尽量不在shader中用分支判断的版本,但是代码很难理解啊....
                half percentage = _DissolveThreshold / dissolveValue.r;
                //如果当前百分比 - 颜色权重 - 边缘颜色
                half lerpEdge = sign(percentage - _ColorFactor - _DissolveEdge);
                //貌似sign返回的值还得saturate一下，否则是一个很奇怪的值
                fixed3 edgeColor = lerp(_DissolveEdgeColor.rgb, _DissolveColor.rgb, saturate(lerpEdge));
                //最终输出颜色的lerp值
                half lerpOut = sign(percentage - _ColorFactor);
                //最终颜色在原颜色和上一步计算的颜色之间差值（其实经过saturate（sign（..））的lerpOut应该只能是0或1）
                fixed3 colorOut = lerp(color, edgeColor, saturate(lerpOut));
                return fixed4(colorOut, color.a);
            }
            ENDCG
        }
    }
}