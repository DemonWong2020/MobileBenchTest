Shader "UI/Dissolve"
{
    Properties
    {
        [PerRendererData] _MainTex("Base 2D", 2D) = "white"{}
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        [HDR]
        _Color("Diffuse", Color) = (1,1,1,1)
        [HDR]
        _DissolveColor("Dissolve Color", Color) = (0,0,0,0)
        [HDR]
        _DissolveEdgeColor("Dissolve Edge Color", Color) = (1,1,1,1)
        [HDR]
        _DissolveBlendColor("Dissolve Blend Color", Color) = (1,1,1,1)
        _DissolveItensity ("DissolveItensity", Range(0, 2)) = 0
        _DissolveMap("DissolveMap", 2D) = "white"{}
        _DissolveThreshold("DissolveThreshold", Range(0,1)) = 0
        _ColorFactor("ColorFactor", Range(0,1)) = 0.7
        _DissolveEdge("DissolveEdge", Range(0,1)) = 0.8
        [MaterialToggle] _ParticalControl ("ParticalControl", Float ) = 0
        _Mask ("Mask", 2D) = "blask" {}
        _Range ("Range", Range(0, 1)) = 0
        _SmoothRange("Smooth Range", Range(0.01, 1)) = 1
        _SmoothRange2("Smooth Range 2", Range(0.01, 1)) = 1
        _NoiseTex("Noise", 2D) = "black" {}

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp] 
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        Fog { Mode Off }

        ColorMask [_ColorMask]
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag    
            //#pragma target 2.0
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #include "../../Include/CGDefine.cginc"
            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            fixed4 _Color;
            fixed4 _DissolveColor;
            fixed4 _DissolveEdgeColor;
            fixed4 _DissolveBlendColor;
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
            fixed _Range;
            fixed _SmoothRange;
fixed _SmoothRange2;
            sampler2D _Mask;
            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            
            float4 _ClipRect;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            struct appdata_t {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD2;
                float4  mask : TEXCOORD3;
                UNITY_VERTEX_OUTPUT_STEREO
            };
    
            v2f vert(appdata_t v)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }
    
            fixed4 frag(v2f i) : SV_Target
            {
                fixed2 dissUV = i.texcoord;
                half mask = 1 - tex2D(_Mask, 0.5 - (0.5 - dissUV) * _Range).r;
                mask = smoothstep(0, 1 - _Range, mask);
                //采样Dissolve Map

                fixed4 dissolveValue = tex2D(_DissolveMap, dissUV) * mask;
                //保留项目
                half node_2336 = (dissolveValue.r / _DissolveItensity);
                half node_6017 = saturate(node_2336);
                //小于阈值的部分直接discard
                if (node_6017  < _DissolveThreshold * (1 - mask))
                {
                    discard;
                }

                fixed2 uv = i.texcoord + (TEON_TIME_Y * half2(_U_Speed, _V_Speed));
                fixed4 color = tex2D(_MainTex, uv) * _Color;
 
                //优化版本，尽量不在shader中用分支判断的版本,但是代码很难理解啊....
                half percentage = _DissolveThreshold / dissolveValue.r;
                //如果当前百分比 - 颜色权重 - 边缘颜色
                half lerpEdge = sign(percentage - _ColorFactor - _DissolveEdge);
                //貌似sign返回的值还得saturate一下，否则是一个很奇怪的值
                fixed3 edgeColor = lerp(_DissolveEdgeColor.rgb, _DissolveColor.rgb, saturate(lerpEdge));
                //最终输出颜色的lerp值
                half lerpOut = sign(percentage - _ColorFactor) * (1 - mask);

                float2 noiseUV = TRANSFORM_TEX(i.texcoord, _NoiseTex);
                float2 n1UV = noiseUV;
                n1UV.x += _Time.x;
                                float n1 = tex2D(_NoiseTex, n1UV).r;
                                   float2 n2UV = noiseUV;
                n2UV.y += _Time.x;
                 float n2 = tex2D(_NoiseTex, n2UV).r;

                mask = smoothstep(0, _SmoothRange, n1 * n2);
                //最终颜色在原颜色和上一步计算的颜色之间差值（其实经过saturate（sign（..））的lerpOut应该只能是0或1）
                fixed3 colorOut = lerp(color, edgeColor * mask + (1 - mask) * _DissolveBlendColor * color  , saturate(smoothstep(0, _SmoothRange2, lerpOut)));
               
///return color * saturate(smoothstep(0, _SmoothRange2, lerpOut));
                return fixed4(colorOut, color.a);
            }
            ENDCG
        }
    }
}