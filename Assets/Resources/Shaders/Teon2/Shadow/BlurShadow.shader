Shader "Teon2/Shadow/Blur"
{
    Properties
    {
    }
    CGINCLUDE
        #include "UnityCG.cginc"
        
        sampler2D _MainTex;
        half4 _MainTex_TexelSize;
        half _MainAlpha;
        half _AttenAlpha;
        half4 _ShadowOffset;

        struct appdata_t
        {  
            float4 vertex : POSITION;
            half2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 pos : SV_POSITION;
            half2 uv : TEXCOORD0;
        };

        static const half2 up = half2(0, 1);
        static const half2 right = half2(1, 0);
        static const half2 upRight = half2(1, 1);

        v2f vert(appdata_t v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;

            return o;
        }

        fixed4 offsetTex(sampler2D tex, fixed2 uv, fixed2 offsets)
		{ 
			fixed4 retCol = 1;

            fixed4 atten1 = tex2D(tex, uv + up * offsets.xy);
            retCol.r = min(retCol.r, atten1.r);
            retCol.g = max(0, atten1.g);
            //retCol.b += atten1.b;
            
            fixed4 atten2 = tex2D(tex, uv + right * offsets.xy);
            retCol.r = min(retCol.r, atten2.r);
            retCol.g = max(retCol.g, atten2.g);
            //retCol.b += atten2.b;

            fixed4 atten3 = tex2D(tex, uv + upRight * offsets.xy);
            retCol.r = min(retCol.r, atten3.r);
            retCol.g = max(retCol.g, atten3.g);
            //retCol.b += atten3.b;
            
            retCol.g = saturate(retCol.g) * _AttenAlpha;
            //retCol.b = saturate(retCol.b) * _AttenAlpha;
			return retCol ;
		}
    ENDCG
    SubShader
    {
        //0
        Pass
        {
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #include "../../Include/CGDefine.cginc"

			fixed4 frag(v2f i) : COLOR
            {
                half4 ret = tex2D(_MainTex, i.uv);

#if defined(LK_GLES)
                ret.g = step(ret.r, 0.9);
#else
                ret.r = 1 - ret.r;
                ret.g = step(ret.r, 0.9);
#endif
                //ret.b = 1 - ret.r;
				return ret;
			}

			ENDCG
        }
        //1
        Pass
        {
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 frag(v2f i) : COLOR
            {
				return offsetTex(_MainTex, i.uv, _MainTex_TexelSize.xy * _ShadowOffset.xy);
			}

			ENDCG
        }
        //2
        Pass
        {
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

            sampler2D _MainShadow;
            half4 _MainShadow_TexelSize;

			fixed4 frag(v2f i) : COLOR
            {
                half2 offsets = _MainTex_TexelSize.xy * _ShadowOffset.xy;
				fixed4 retCol = tex2D(_MainShadow, i.uv);
                retCol.g *= _MainAlpha;
             
                fixed4 atten1 = tex2D(_MainTex, i.uv + up * offsets.xy);
                fixed attenMask = atten1.r;
                retCol.g = max(retCol.g, atten1.g * _AttenAlpha);
                //retCol.b += atten1.b * _AttenAlpha;
            
                fixed4 atten2 = tex2D(_MainTex, i.uv + right * offsets.xy);
                attenMask = min(attenMask, atten2.r);
                retCol.g = max(retCol.g, atten2.g * _AttenAlpha);
                //retCol.b += atten2.b * _AttenAlpha;

                fixed4 atten3 = tex2D(_MainTex, i.uv + upRight * offsets.xy);
                attenMask = min(attenMask, atten3.r);
                retCol.g = max(retCol.g, atten3.g * _AttenAlpha);
                //retCol.b += atten3.b * _AttenAlpha;
                retCol.r = min(retCol.r, attenMask);
                
                //retCol += tex2D(_MainTex, i.uv + offset[0] * offsets.xy) * _AttenAlpha;
                //retCol += tex2D(_MainTex, i.uv + offset[1] * offsets.xy) * _AttenAlpha;
                //retCol += tex2D(_MainTex, i.uv + offset[2] * offsets.xy) * _AttenAlpha;
			    return retCol;
			}

			ENDCG
        }
    }
}