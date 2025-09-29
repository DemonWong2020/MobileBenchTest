Shader "Hidden/BlurBlit"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGINCLUDE

		#include "UnityCG.cginc"		

		fixed4 offsetTex(sampler2D tex, fixed2 uv, fixed4 offsets)
		{
			fixed4 retCol = tex2D(tex, uv + offsets.xy);
			retCol += tex2D(tex, uv + offsets.zy);
			retCol += tex2D(tex, uv + offsets.xw);
			retCol += tex2D(tex, uv + offsets.zw);

			return retCol * 0.25;
		}

		fixed4 downSample(sampler2D tex, fixed2 uv, fixed4 texelSize)
		{
			fixed4 offset = fixed4(-1, -1, 1, 1) * texelSize.xyxy;

			return tex2D(tex, uv);//offsetTex(tex, uv, offset);
		}

		fixed4 upSample(sampler2D tex, fixed2 uv, fixed4 texelSize, fixed sampleScale)
		{
			float4 offset = texelSize.xyxy * half4(-1.0, -1.0, 1.0, 1.0) * (sampleScale * 0.5);

			return offsetTex(tex, uv, offset);
		}

		struct appdata
		{
			half4 vertex : POSITION;
			half2 uv : TEXCOORD0;
		};

		struct v2f
		{
			half4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
		};

		v2f vert(appdata i)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.uv = i.uv;
			return o;
		}

		ENDCG

		Pass
		{
			Name "DownSample Blur"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex; 
			fixed4 _MainTex_TexelSize;

			fixed4 frag(v2f i) : COLOR
            {
				return downSample(_MainTex, i.uv, _MainTex_TexelSize);
			}

			ENDCG
		}

		Pass
		{
			Name "UpSample Blur"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			fixed4 _MainTex_TexelSize;
			fixed _SampleScale;

			fixed4 frag(v2f i) : COLOR
			{
				return upSample(_MainTex, i.uv, _MainTex_TexelSize, _SampleScale);
			}

			ENDCG
		}
	}
}