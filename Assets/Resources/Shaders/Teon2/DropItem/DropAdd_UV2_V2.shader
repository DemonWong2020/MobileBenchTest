Shader "Teon2/DropItem/DropAdd_UV2" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        [MaterialToggle] _MainTex_One_UV ("MainTex_One_UV", Float ) = 0
        _Tex2 ("Tex2", 2D) = "white" {}
        _U2_Speed ("U2_Speed", Float ) = 0
        _V2_Speed ("V2_Speed", Float ) = 0
        [MaterialToggle] _Tex2_One_UV ("Tex2_One_UV", Float ) = 0
        _Mask ("Mask", 2D) = "white" {}
        _SelfItem("可拾取状态", Int) = 1
        _Fade("透明度", Float) = 1
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            //Name "FORWARD"
            //Tags {
            //    "LightMode"="ForwardBase"
            //}
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "../../Include/CGDefine.cginc"
            #pragma target 3.0

            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _U_Speed;
            uniform float _V_Speed;
            uniform float _V2_Speed;
            uniform float _U2_Speed;
            uniform sampler2D _Tex2; uniform float4 _Tex2_ST;
            uniform float _Tex2_One_UV;
            uniform float _MainTex_One_UV;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            float _SelfItem;
            float _Fade;

            UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor)
            UNITY_INSTANCING_BUFFER_END(Props)

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 vertexColor : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 vertexColor : COLOR;
                //float4 projPos : TEXCOORD2;
                UNITY_FOG_COORDS(2)
                UNITY_VERTEX_OUTPUT_STEREO
            };
            VertexOutput vert (VertexInput v) 
            {
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            float4 frag(VertexOutput i) : COLOR {
                float2 node_1202 = float2(((_U_Speed*TEON_TIME_Y)+i.uv0.r), (i.uv0.g+(TEON_TIME_Y*_V_Speed)));
                float2 _MainTex_One_UV_var = lerp( node_1202, (node_1202 + i.uv1.xy), _MainTex_One_UV );
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_MainTex_One_UV_var, _MainTex));
                float2 node_4601 = float2(((_U2_Speed*TEON_TIME_Y)+i.uv0.r), (i.uv0.g+(TEON_TIME_Y*_V2_Speed)));
                float2 _Tex2_One_UV_var = lerp( node_4601, (node_4601 + i.uv1.zw), _Tex2_One_UV );
                float4 _Tex2_var = tex2D(_Tex2,TRANSFORM_TEX(_Tex2_One_UV_var, _Tex2));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _Tint = UNITY_ACCESS_INSTANCED_PROP(Props, _TintColor);
                float3 emissive = ((_MainTex_var.rgb*i.vertexColor.rgb*_Tint.rgb*(_Tex2_var.rgb*_Mask_var.rgb)*i.vertexColor.a)*_Tint.a*_MainTex_var.a*_Tex2_var.a);
                float4 finalRGBA = float4(emissive,1);
                finalRGBA.a *= lerp(0.8, 1, _SelfItem) * _Fade;
                finalRGBA.rgb = lerp(finalRGBA * 0.5 , finalRGBA.rgb, _SelfItem);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, float4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
