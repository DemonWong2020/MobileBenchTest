Shader "Teon2/Effects/Disturbance_9_sliced"
{
    Properties
    {
        _MainColor("第一层贴图颜色", Color) = (1,1,1,1)
        _MainTex("第一层贴图", 2D) = "white" {}
        _MainTex_U1("第一层贴图流动_U", Float) = 0
        _MainTex_V1("第一层贴图流动_V", Float) = 0
        [Header(Mask Mode)]_TexMask1("遮罩1", 2D) = "white" {}
        _MaskRotator1("遮罩旋转", Range( 0 , 1)) = 0
        _MaskSpeedU1("遮罩流动速度U", Float) = 0
        _MaskSpeedV1("遮罩流动速度V", Float) = 0
        _TexMask2("遮罩2", 2D) = "white" {}
        _MaskRotator2("遮罩旋转", Range( 0 , 1)) = 0
        _MaskSpeedU2("遮罩流动速度U", Float) = 0
        _MaskSpeedV2("遮罩流动速度V", Float) = 0
        [Header(Noise Mode)]_DisturbanceTex1("扰动贴图", 2D) = "white" {}
        _DisturbanceScale("扰动强度", Float) = 0
        _DisturbanceTex_U("扰动流动_U", Float) = 0
        _DisturbanceTex_V("扰动流动_V", Float) = 0
    }
    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        Blend One One

        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #include "../../Include/CGDefine.cginc"
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };
            
            fixed4 _MainColor;
            sampler2D _MainTex;
            half4 _MainTex_ST;
            half _MainTex_U1;
            half _MainTex_V1;
            sampler2D _TexMask1;
            half4 _TexMask1_ST;
            half _MaskRotator1;
            half _MaskSpeedU1;
            half _MaskSpeedV1;
            sampler2D _TexMask2;
            half4 _TexMask2_ST;
            half _MaskRotator2;
            half _MaskSpeedU2;
            half _MaskSpeedV2;
            sampler2D _DisturbanceTex1;
            half4 _DisturbanceTex1_ST;
            half _DisturbanceScale;
            half _DisturbanceTex_U;
            half _DisturbanceTex_V;

            float top;
            float bottom;
            float left;
            float right;
            float sx;
            float sy;

            float4 _ClipRect;

            float2 UVTransform(float2 origin)
            {
                float2 result = origin;

                if(left + right > sx)
                {
                    result.x = origin.x;
                }
                else
                {

                    if (origin.x * sx < left)
                    {
                        result.x = origin.x * sx;
                    }
                    else
                    {
                        if ((1 - origin.x) * sx < right)
                        {
                            result.x = 1 - (1 - origin.x) * sx;
                        }
                        else
                        {
                            result.x = (origin.x * sx - left) / (sx - left - right) * (1 - left - right) + left;
                        }
                    }
                }

                if (top + bottom > sy)
                {
                    result.y = origin.y;
                }else
                {

                    if (origin.y * sy < top)
                    {
                        result.y = origin.y * sy;
                    }
                    else
                    {
                        if ((1 - origin.y) * sy < bottom)
                        {
                            result.y = 1 - (1 - origin.y) * sy;
                        }
                        else
                        {
                            result.y = (origin.y * sy - top) / (sy - top - bottom) * (1 - top - bottom) + top;
                        }
                    }
                }
                return result;
            }

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = TRANSFORM_TEX(IN.texcoord, _MainTex);
#ifdef UNITY_HALF_TEXEL_OFFSET
                OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
                OUT.color = IN.color * _MainColor;
                return OUT;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half2 uv = UVTransform(i.texcoord);

                half2 uv_DisturbSpeed = half2(_DisturbanceTex_U, _DisturbanceTex_V);
                half2 uv_DisturbanceTex1 = uv * _DisturbanceTex1_ST.xy + _DisturbanceTex1_ST.zw;
                half disturbCol = tex2D(_DisturbanceTex1, uv_DisturbanceTex1 + uv_DisturbSpeed * TEON_TIME_Y).r;

                half2 uv_MainSpeed = half2(_MainTex_U1, _MainTex_V1);
                half4 color = tex2D(_MainTex, uv + uv_MainSpeed * TEON_TIME_Y + disturbCol * _DisturbanceScale) * i.color;
                half2 uv_TexMask1 = uv * _TexMask1_ST.xy + _TexMask1_ST.zw;
                half2 uv_Mask1Speed = half2(_MaskSpeedU1, _MaskSpeedV1);
                half2 uv_TexMask2 = uv * _TexMask2_ST.xy + _TexMask2_ST.zw;
                half2 uv_Mask2Speed = half2(_MaskSpeedU2, _MaskSpeedV2);
                half mask2Col = tex2D(_TexMask2, uv_TexMask2 + uv_Mask2Speed * TEON_TIME_Y).r;
                half mask1Col = tex2D(_TexMask1, uv_TexMask1 + uv_Mask1Speed * TEON_TIME_Y).r * mask2Col;

                color.a *= mask1Col ;
                color.rgb *= color.a;
#ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.01);
#endif
                return color;
            }
        ENDCG
        }
    }
}