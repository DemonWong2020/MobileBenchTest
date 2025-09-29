Shader "Teon2/Scenes/Grass"
{
    Properties {
        _MainTex("Main Tex", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
        [Toggle(_HSV_FIXED)]_HSVFixed("HSV Fixed?", Int) = 0
        _Hue ("Hue", Range(0,359)) = 0
        _Saturation ("Saturation", Range(0,3.0)) = 1.0
        _Brightness ("Brightness", Range(0,3.0)) = 1.0
        [Header(Move Parameter)]
        _Range("Range", Range(0, 0.3)) = 0
        _Rate("Rate", Range(0, 8)) = 0
        [Header(Clip Parameter)]
        _Clip("Clip", Range(0, 1)) = 0.5
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
            #pragma multi_compile _ _HSV_FIXED
      
            #include "../../Include/CGDefine.cginc"
            #include "../../Include/HSVMathLib.cginc"
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;

            float _Hue;
            float _Saturation;
            float _Brightness;

            sampler2D _GShadowMask;
            sampler2D _GLightMap;
            float4 _GMapSize;        

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                //Normal
                float3 normal : NORMAL;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
               
                UNITY_FOG_COORDS(1)
                //float4 worldPos : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            //UNITY_INSTANCING_BUFFER_START(Props)
            //  //UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor)
            //UNITY_INSTANCING_BUFFER_END(Props)

            float4 _TintColor;
            float _Clip;

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);

                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

                o.uv0 = v.texcoord0;
                //float4 vertex = v.vertex;
                //o.worldPos = mul(unity_ObjectToWorld, vertex);
                //float l = dot(o.worldPos, 1);
                ////
                //vertex.xz += v.color.r * sin(TEON_TIME_Y * _Rate * frac(l)) * _Range * v.normal.x;
                o.pos = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }
            
            float4 frag(VertexOutput i) : COLOR 
            {
                UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.
                float4 col = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex)) * _TintColor;//UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                clip(col.a - _Clip);
                  
                #if _HSV_FIXED
                float3 _ColorHSV = RGBConvertToHSV(col.xyz);   //转换为HSV
                _ColorHSV.x += _Hue; //调整偏移Hue值
                _ColorHSV.x = _ColorHSV.x % 360;    //超过360的值从0开始

                _ColorHSV.y *= _Saturation;  //调整饱和度
                _ColorHSV.z *= _Brightness;                   

                col.xyz = saturate(HSVConvertToRGB(_ColorHSV.xyz));   //将调整后的HSV，转换为RGB颜色
                #endif
                col.rgb = col.rgb * _LightColor0;
                //float2 uv = i.worldPos.xz;
                //uv.x *= _GMapSize.x;
                //uv.y *= _GMapSize.y;
                //float mask = tex2D(_GShadowMask, uv).r;
                //col.rgb = col.rgb * mask + col.rgb * (1 - mask) * tex2D(_GLightMap, uv);
              
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}