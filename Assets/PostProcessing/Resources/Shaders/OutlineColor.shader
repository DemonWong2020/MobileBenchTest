Shader "Hidden/Post FX/Outline Color" 
{
	SubShader
	{
		Pass
		{
		CGPROGRAM
			#include "UnityCG.cginc"
			struct v2f
			{
				half4 pos : SV_POSITION;
			};

			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return 1;
			}

			#pragma vertex vert
			#pragma fragment frag
		ENDCG
		}
	}
}
