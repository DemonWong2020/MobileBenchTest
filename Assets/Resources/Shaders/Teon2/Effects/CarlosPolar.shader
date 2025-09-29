// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Teon2/Effect/Carlos/Polar"
{
	Properties
	{
		[Enum(Add,1,Blend,10)]_BlendMode("【混合模式】", Float) = 10
		_MainTexture("【主图】", 2D) = "white" {}
		[Toggle(_SPEEDCONTROLSWICH_ON)] _SpeedControlSwich("使用粒子控制速度", Float) = 0
		_Float6("X轴速度", Float) = -0.2
		_Float7("Y轴速度", Float) = 0.2
		[Space(24)][Toggle(_POLARSWICH_ON)] _PolarSwich("【使用极坐标】", Float) = 0
		_Float4("极坐标X轴重铺", Float) = 1
		_Float5("极坐标Y轴重铺", Float) = 1
		_MainCenterX("极坐标中心点X", Float) = 0.5
		_MainCenterY("极坐标中心点Y", Float) = 0.5
		[Space(24)]_MaskTexture1("【遮罩贴图】", 2D) = "white" {}
		_DisturbanceTex("【扰动遮罩贴图】", 2D) = "white" {}
		_NoiseSpeedX("扰动X轴速度", Float) = -0.2
		_NoiseSpeedY("扰动Y轴速度", Float) = 0.2
		_NoiseIntensity("扰动强度", Range( 0 , 1)) = 0
		[Space(24)][Toggle(_DISTURBANCEPOLARSWICH_ON)] _DisturbancePolarSwich("【使用极坐标扰动遮罩】", Float) = 0
		_NoiseCenterX("极坐标扰动中心点X", Float) = 0.5
		_NoiseCenterY("极坐标扰动中心点Y", Float) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha [_BlendMode]
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0

		Pass
		{
			Name "Unlit"

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature_local _SPEEDCONTROLSWICH_ON
			#pragma shader_feature_local _POLARSWICH_ON
			#pragma shader_feature_local _DISTURBANCEPOLARSWICH_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _BlendMode;
			uniform sampler2D _MainTexture;
			uniform float _Float6;
			uniform float _Float7;
			uniform float4 _MainTexture_ST;
			uniform float _MainCenterX;
			uniform float _MainCenterY;
			uniform float _Float4;
			uniform float _Float5;
			uniform sampler2D _MaskTexture1;
			uniform float4 _MaskTexture1_ST;
			uniform sampler2D _DisturbanceTex;
			uniform float _NoiseSpeedX;
			uniform float _NoiseSpeedY;
			uniform float4 _DisturbanceTex_ST;
			uniform float _NoiseCenterX;
			uniform float _NoiseCenterY;
			uniform float _NoiseIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord2.xy;
				o.ase_color = v.color;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 appendResult35 = (float2(_Float6 , _Float7));
				float2 uv_MainTexture = i.ase_texcoord1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				
				#ifdef _POLARSWICH_ON
				float2 appendResult22 = (float2(_MainCenterX , _MainCenterY));
				float2 CenteredUV15_g3 = ( uv_MainTexture - appendResult22 );
				float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * _Float4 * 2.0 ) , ( atan2( CenteredUV15_g3.x , CenteredUV15_g3.y ) * (UNITY_INV_TWO_PI) * _Float5 )));
				float2 staticSwitch144 = appendResult23_g3;
				#else
				float2 staticSwitch144 = uv_MainTexture;
				#endif

				float2 panner3 = ( _Time.y * appendResult35 + staticSwitch144);
				#ifdef _SPEEDCONTROLSWICH_ON
				float2 staticSwitch123 = ( staticSwitch144 + i.ase_texcoord1.zw );
				#else
				float2 staticSwitch123 = panner3;
				#endif

				float2 uv_MaskTexture1 = i.ase_texcoord1.xy * _MaskTexture1_ST.xy + _MaskTexture1_ST.zw;
				float2 appendResult117 = (float2(_NoiseSpeedX , _NoiseSpeedY));
				float2 uv_DisturbanceTex = i.ase_texcoord1.xy * _DisturbanceTex_ST.xy + _DisturbanceTex_ST.zw;
								
				#ifdef _DISTURBANCEPOLARSWICH_ON
				float2 appendResult120 = (float2(_NoiseCenterX , _NoiseCenterY));
				float2 CenteredUV15_g4 = ( uv_DisturbanceTex - appendResult120 );
				float2 appendResult23_g4 = (float2(( length( CenteredUV15_g4 ) * 2.0 ) , ( atan2( CenteredUV15_g4.x , CenteredUV15_g4.y ) * (UNITY_INV_TWO_PI))));
				float2 staticSwitch145 = appendResult23_g4;
				#else
				float2 staticSwitch145 = uv_DisturbanceTex;
				#endif

				float2 panner116 = ( _Time.y * appendResult117 + staticSwitch145);
				float2 temp_cast_0 = (tex2D( _DisturbanceTex, panner116 ).r).xx;
				float2 lerpResult114 = lerp( uv_MaskTexture1 , temp_cast_0 , _NoiseIntensity);
				
				finalColor = ( ( tex2D( _MainTexture, staticSwitch123 ) * i.ase_color ) * tex2D( _MaskTexture1, lerpResult114 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	
	Fallback Off
}