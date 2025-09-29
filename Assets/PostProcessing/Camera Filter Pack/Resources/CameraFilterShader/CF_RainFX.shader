//CameraFilterPack_RainFX.shader
Shader "Hidden/CF_RainFX"
{ 
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader 
    {
        Pass
        {
            Cull Off ZWrite Off ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "CameraFilter.cginc"

            sampler2D _MainTex2;
			sampler2D _MainTex3;
			float count;
			float _Value2;
			float _Value;
			float _Speed;

			float4 Coord1;
			float4 Coord2;
			float4 Coord3;
			float4 Coord4;

			float4 Dropflow(float2 uv, float2 p, float2 zoom, float count, float num, float3 mask)
			{
				float d = smoothstep(0.01, 0.1, count / 256);
				d -= smoothstep(0.7, 0.98, count / 256);
				d = saturate(d);
				zoom.y *= 0.15 * (num + 1);
				uv *= zoom;

				float2 c = float2(fmod(count, 32), 8 - floor(count / 32));
				float2 m = float2(0.03125 / zoom.x, 0.125 / zoom.y);
				float2 pos = float2(m.x * c.x, m.y * c.y);
				pos *= zoom;
				float2 spos = float2(p.x * zoom.x, p.y * zoom.y);
				pos -= spos;
				float4 n = tex2D(_MainTex3, uv + pos);
				n.rgb *= mask;
				n = n.r + n.g + n.b;
				pos = spos;
				pos.y = 1 - pos.y;
				float x = smoothstep(pos.x + 0.03122, pos.x + 0.03125, uv.x);
				x += smoothstep(pos.x + 0.0003, pos.x, uv.x);
				x += smoothstep(pos.y + 0.1242, pos.y + 0.125, 1 - uv.y);
				x += smoothstep(pos.y + 0.0003, pos.y, 1 - uv.y);
				n = lerp(n, 0, saturate(x));
	
				return n * d;
			}

			float4 Drop(float2 uv)
			{
				float2 uvd = uv;
				uvd.y -= 0.16;
				float4 n = tex2D(_MainTex2, uvd);
				uvd.y = n.b + uv.y + (_Time * _Speed * (n.b * n.b));
				float4 rd = tex2D(_MainTex2, float2(uv.x, uvd.y)).g;
				return rd * (1 - n.r);
			}

			float4 frag(v2f i) : COLOR
			{
				float2 uv = i.texcoord;

				float4 rd = Dropflow(uv, Coord1.rg, float2(0.85, 0.85), Coord1.b, Coord1.a,  float3(1, 0, 0));
				rd += Dropflow(uv, Coord2.rg, float2(0.85, 0.85), Coord2.b, Coord2.a, float3(0, 1, 0));
				rd += Dropflow(uv, Coord3.rg, float2(0.85, 0.85), Coord3.b, Coord3.a, float3(0, 0, 1));
				rd += Dropflow(uv, Coord4.rg, float2(0.85, 0.85), Coord4.b, Coord4.a, float3(1, 0, 0));

				rd += Drop(uv);
				rd += Drop(uv * 0.75 + float2(0.5, 0.5));

				rd *= _Value;
				rd = saturate(rd);
				float2 df = float2(0, rd.r) * 0.25;
				float4 tx = tex2D(_MainTex, uv + df);
				tx += rd * 0.35;

				return tx;
			}
			ENDCG
		}
	}
}
