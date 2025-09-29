// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI/FlowLight"
{
	Properties
	{
		[Enum(Add,1,Blend,10)]_BlendMode("【混合模式】", Float) = 10
		[PerRendererData] _MainTex("Main Tex", 2D) = "white" {}
		_AddMaskTexture("叠加遮罩", 2D) = "white" {}
		_AddMaskXSpeed("叠加遮罩X轴速度", Float) = -0.2
		_AddMaskYSpeed("叠加遮罩Y轴速度", Float) = 0.2
		_DistMainTex("扰动底图", 2D) = "white" {}
		_DisturbanceTex("【扰动遮罩贴图】", 2D) = "white" {}
		_NoiseSpeedX("扰动X轴速度", Float) = -0.2
		_NoiseSpeedY("扰动Y轴速度", Float) = 0.2
		_NoiseIntensity("扰动强度", Range( 0 , 1)) = 0
		_NoiseColor("扰动强度", Color) = (1,1,1,1)
		_NoiseStrong("扰动浓度", Range( 0 , 1)) = 0
		[Space(24)][Toggle(_DISTURBANCEPOLARSWICH_ON)] _DisturbancePolarSwich("【使用极坐标扰动遮罩】", Float) = 0
		_NoiseCenterX("极坐标扰动中心点X", Float) = 0.5
		_NoiseCenterY("极坐标扰动中心点Y", Float) = 0.5

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15
	}
	SubShader
	{
		Tags {
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

		Blend SrcAlpha [_BlendMode]
		Cull off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		ColorMask [_ColorMask]

		Pass
		{
			Name "Unlit"

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature_local _DISTURBANCEPOLARSWICH_ON

			#pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR;
				float4 mask : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform sampler2D _AddMaskTexture;
			uniform float4 _AddMaskTexture_ST;
			uniform float _AddMaskXSpeed;
			uniform float _AddMaskYSpeed;
			uniform sampler2D _DistMainTex;
			uniform float4 _DistMainTex_ST;
			uniform sampler2D _DisturbanceTex;			
			uniform float4 _DisturbanceTex_ST;
			uniform float _NoiseSpeedX;
			uniform float _NoiseSpeedY;
			uniform float _NoiseCenterX;
			uniform float _NoiseCenterY;
			uniform float _NoiseIntensity;
			uniform float4 _NoiseColor;
			uniform float _NoiseStrong;
			uniform float4 _ClipRect;
            uniform float _UIMaskSoftnessX;
            uniform float _UIMaskSoftnessY;

			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.texcoord.xy = v.texcoord.xy;
				o.color = v.color;
				
				o.vertex = UnityObjectToClipPos(v.vertex);

#ifdef UNITY_HALF_TEXEL_OFFSET
                o.vertex.xy += (_ScreenParams.zw - 1.0) * float2(-1, 1);
#endif
				float2 pixelSize = o.vertex.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                o.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 addMaskUV = TRANSFORM_TEX(i.texcoord, _AddMaskTexture);

				float2 panner3 = _Time.y * float2(_AddMaskXSpeed , _AddMaskYSpeed) + addMaskUV;
				float2 distMainTexUV = TRANSFORM_TEX(i.texcoord, _DistMainTex);
				float2 disturbanceTexUV = TRANSFORM_TEX(i.texcoord, _DisturbanceTex);
								
#ifdef _DISTURBANCEPOLARSWICH_ON
				float2 noiseCenter = float2(_NoiseCenterX , _NoiseCenterY);
				float2 CenteredUV = (disturbanceTexUV - noiseCenter);
				disturbanceTexUV = float2((length(CenteredUV) * 2.0) , (atan2(CenteredUV.x , CenteredUV.y) * (UNITY_INV_TWO_PI)));
#endif

				disturbanceTexUV = ( _Time.y * float2(_NoiseSpeedX , _NoiseSpeedY) + disturbanceTexUV);
				float2 temp_cast_0 = (tex2D( _DisturbanceTex, disturbanceTexUV ).r).xx;
				float2 lerpResult114 = lerp(distMainTexUV , temp_cast_0 , _NoiseIntensity);
				
				finalColor = tex2D(_MainTex, i.texcoord.xy)  * i.color;
				finalColor.rgb += _NoiseColor * tex2D( _AddMaskTexture, panner3) * tex2D(_DistMainTex, lerpResult114) * _NoiseStrong;

#ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(i.mask.xy)) * i.mask.zw);
                finalColor.a *= m.x * m.y;
#endif

#ifdef UNITY_UI_ALPHACLIP
                clip (finalColor.a - 0.01);
#endif
				return finalColor;
			}
			ENDCG
		}
	}
	
	Fallback Off
}