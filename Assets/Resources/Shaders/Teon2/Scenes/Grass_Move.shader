Shader "Teon2/Scenes/Grass_Move"
{
    Properties {
        _MainTex("Main Tex", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
        [Header(Move Parameter)]
        _Range("Range", Range(0, 0.3)) = 0
        _Rate("Rate", Range(0, 8)) = 0
        [Header(Move Parameter)]
        _Range("Range", Range(0, 0.3)) = 0.13
        _Rate("Rate", Range(0, 8)) = 3
        [Header(Clip Parameter)]
        _Clip("Clip", Range(0, 1)) = 0.5
        _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
    }

    SubShader
    {
        Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" "IgnoreProjector"="True" }
     
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On
        Pass 
        {
            Tags { "LightMode" = "ForwardBase" }
         
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      
            #include "../../Include/CGDefine.cginc"
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            uniform sampler2D _MainTex;
            uniform half4 _MainTex_ST;

            half _Range;
            half _Rate;

            sampler2D _GShadowMask;
            sampler2D _GLightMap;
            half4 _GMapSize;        

            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            half _InvFade;

            struct VertexInput {
                half4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                //Normal
                //half3 normal : NORMAL;
                //half4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            struct VertexOutput {
                half4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
               
                UNITY_FOG_COORDS(1)
                //half4 worldPos : TEXCOORD2;
                //half4 projPos : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            //UNITY_INSTANCING_BUFFER_START(Props)
            //  //UNITY_DEFINE_INSTANCED_PROP(half4, _TintColor)
            //UNITY_INSTANCING_BUFFER_END(Props)

            half4 _TintColor;
            fixed _Clip;

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);

                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.uv0 = v.texcoord0;
                //half4 vertex = v.vertex;
                //o.worldPos = mul(unity_ObjectToWorld, vertex);
                //half l = dot(o.worldPos, 1);
                ////
                //vertex.xz += v.color.r * sin(TEON_TIME_Y * _Rate * frac(l)) * _Range * v.normal.x;
                //o.pos = UnityObjectToClipPos(vertex);

                //o.projPos = ComputeScreenPos (o.pos);
                //COMPUTE_EYEDEPTH(o.projPos.z);

                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }
            
            half4 frag(VertexOutput i) : COLOR 
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.
                half4 col = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex)) * _TintColor;//UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                clip(col.a - _Clip);

                col.rgb = col.rgb * _LightColor0;
                //half2 uv = i.worldPos.xz;
                //uv.x *= _GMapSize.x;
                //uv.y *= _GMapSize.y;
                //half mask = tex2D(_GShadowMask, uv).r;
                //col.rgb = col.rgb * mask + col.rgb * (1 - mask) * tex2D(_GLightMap, uv);
              
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}