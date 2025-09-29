Shader "Hidden/Post FX/Outline" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BlurTex("Blur", 2D) = "white"{}
	}
	CGINCLUDE
	#include "UnityCG.cginc"

	struct v2f_cull
	{
		half4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
	};

	struct v2f_blur
	{
		half4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
		half4 uv01 : TEXCOORD1;
	};

	struct v2f_add
	{
		half4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
	};

	sampler2D _MainTex;
	half4 _MainTex_TexelSize;
	sampler2D _BlurTex;
	half4 _BlurTex_TexelSize;
	half4 _Offset;
	half _OutlineStrength;
	half4 _OutlineColor;

	v2f_cull vert_cull(appdata_img v)
	{
		v2f_cull o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord;
		#if UNITY_UV_STARTS_AT_TOP
		if (_MainTex_TexelSize.y < 0)
			o.uv.y = 1 - o.uv.y;
		#endif	
		return o;
	}

	half4 frag_cull(v2f_cull i) : SV_Target
	{
		half4 colorMain = tex2D(_MainTex, i.uv);
		half4 colorBlur = tex2D(_BlurTex, i.uv);
		return colorBlur - colorMain;
	}

	v2f_blur vert_blur(appdata_img v)
	{
		v2f_blur o;
		_Offset *= _MainTex_TexelSize.xyxy;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		o.uv01 = v.texcoord.xyxy + _Offset.xyxy * half4(1, 1, -1, -1);
		return o;
	}

	fixed4 frag_blur(v2f_blur i) : SV_Target
	{
		fixed4 color = 0;
		color += tex2D(_MainTex, i.uv);
		color += tex2D(_MainTex, i.uv01.xy);
		color += tex2D(_MainTex, i.uv01.zw);
		return saturate(color);
	}

	v2f_add vert_add(appdata_img v)
	{
		v2f_add o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord.xy;
		#if UNITY_UV_STARTS_AT_TOP
		if (_MainTex_TexelSize.y < 0)
			o.uv.y = 1 - o.uv.y;
		#endif	
		return o;
	}

	fixed4 frag_add(v2f_add i) : SV_Target
	{
		fixed4 blur = tex2D(_BlurTex, i.uv) * _OutlineStrength * _OutlineColor;
		return blur;
	}

	ENDCG

	SubShader
	{
		//Pass 0 Blur
		Pass
		{
			ZTest Off
			Cull Off
			ZWrite Off
			Fog{ Mode Off }
			CGPROGRAM
			#pragma vertex vert_blur
			#pragma fragment frag_blur
			ENDCG
		}
		//Pass 1 Cull
		Pass
		{
			ZTest Off
			Cull Off
			ZWrite Off
			Fog{ Mode Off }
			CGPROGRAM
			#pragma vertex vert_cull
			#pragma fragment frag_cull
			ENDCG
		}
		//Pass 2 Outline
		Pass
		{
			ZTest Off
			Cull Off
			ZWrite Off
			Fog{ Mode Off }
			CGPROGRAM
			#pragma vertex vert_add
			#pragma fragment frag_add
			ENDCG
		}
	}
}