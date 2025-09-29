// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32932,y:32788,varname:node_4795,prsc:2|emission-8810-OUT,alpha-5118-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32235,y:32601,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-7459-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32235,y:32772,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32235,y:32983,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_DepthBlend,id:9549,x:32235,y:32446,varname:node_9549,prsc:2|DIST-2774-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2774,x:32025,y:32446,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:node_2774,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:7949,x:30792,y:32653,varname:node_7949,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6505,x:30792,y:32487,varname:node_6505,prsc:2;n:type:ShaderForge.SFN_Add,id:8365,x:31080,y:32551,varname:node_8365,prsc:2|A-5299-OUT,B-7949-U;n:type:ShaderForge.SFN_Time,id:8774,x:30813,y:32896,varname:node_8774,prsc:2;n:type:ShaderForge.SFN_Add,id:4440,x:31080,y:32767,varname:node_4440,prsc:2|A-7949-V,B-8771-OUT;n:type:ShaderForge.SFN_Append,id:7196,x:31245,y:32594,varname:node_7196,prsc:2|A-8365-OUT,B-4440-OUT;n:type:ShaderForge.SFN_Multiply,id:5299,x:30983,y:32397,varname:node_5299,prsc:2|A-236-OUT,B-6505-T;n:type:ShaderForge.SFN_ValueProperty,id:236,x:30792,y:32411,ptovrint:False,ptlb:U_Speed,ptin:_U_Speed,varname:node_236,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:8771,x:31047,y:32953,varname:node_8771,prsc:2|A-8774-T,B-1873-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1873,x:30813,y:33072,ptovrint:False,ptlb:V_Speed,ptin:_V_Speed,varname:node_1873,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:7459,x:31995,y:32618,ptovrint:False,ptlb:MainTex_One_UV,ptin:_MainTex_One_UV,varname:node_7459,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7196-OUT,B-5593-OUT;n:type:ShaderForge.SFN_TexCoord,id:4776,x:31266,y:32771,varname:node_4776,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Append,id:1772,x:31560,y:32767,varname:node_1772,prsc:2|A-4776-U,B-4776-V;n:type:ShaderForge.SFN_Add,id:5593,x:31786,y:32690,varname:node_5593,prsc:2|A-7196-OUT,B-1772-OUT;n:type:ShaderForge.SFN_TexCoord,id:2128,x:30768,y:33505,varname:node_2128,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:2465,x:30804,y:33292,varname:node_2465,prsc:2;n:type:ShaderForge.SFN_Add,id:266,x:31075,y:33452,varname:node_266,prsc:2|A-9440-OUT,B-2128-U;n:type:ShaderForge.SFN_Time,id:5568,x:30790,y:33718,varname:node_5568,prsc:2;n:type:ShaderForge.SFN_Add,id:4792,x:31075,y:33668,varname:node_4792,prsc:2|A-2128-V,B-4904-OUT;n:type:ShaderForge.SFN_Append,id:1707,x:31240,y:33495,varname:node_1707,prsc:2|A-266-OUT,B-4792-OUT;n:type:ShaderForge.SFN_Multiply,id:9440,x:31019,y:33292,varname:node_9440,prsc:2|A-141-OUT,B-2465-T;n:type:ShaderForge.SFN_ValueProperty,id:141,x:30804,y:33196,ptovrint:False,ptlb:U2_Speed,ptin:_U2_Speed,varname:_U_Speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:4904,x:31042,y:33854,varname:node_4904,prsc:2|A-5568-T,B-414-OUT;n:type:ShaderForge.SFN_ValueProperty,id:414,x:30790,y:33888,ptovrint:False,ptlb:V2_Speed,ptin:_V2_Speed,varname:_V_Speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:4274,x:31990,y:33519,ptovrint:False,ptlb:Tex2_One_UV,ptin:_Tex2_One_UV,varname:_node_7459_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-1707-OUT,B-3532-OUT;n:type:ShaderForge.SFN_TexCoord,id:7088,x:31261,y:33672,varname:node_7088,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Append,id:7489,x:31555,y:33668,varname:node_7489,prsc:2|A-7088-Z,B-7088-W;n:type:ShaderForge.SFN_Add,id:3532,x:31781,y:33591,varname:node_3532,prsc:2|A-1707-OUT,B-7489-OUT;n:type:ShaderForge.SFN_Tex2d,id:2899,x:32236,y:33519,ptovrint:False,ptlb:Tex2,ptin:_Tex2,varname:node_2899,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4274-OUT;n:type:ShaderForge.SFN_Multiply,id:5461,x:32491,y:32697,varname:node_5461,prsc:2|A-9549-OUT,B-6074-RGB,C-2053-RGB,D-797-RGB;n:type:ShaderForge.SFN_Multiply,id:8810,x:32739,y:32804,varname:node_8810,prsc:2|A-5461-OUT,B-2899-RGB;n:type:ShaderForge.SFN_Multiply,id:9344,x:32499,y:32963,varname:node_9344,prsc:2|A-6074-A,B-2053-A,C-797-A;n:type:ShaderForge.SFN_Multiply,id:5118,x:32750,y:32963,varname:node_5118,prsc:2|A-9344-OUT,B-2899-A,C-4285-R;n:type:ShaderForge.SFN_Tex2d,id:4285,x:32236,y:33726,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_4285,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:6074-797-236-1873-7459-2899-141-414-4274-4285-2774;pass:END;sub:END;*/

Shader "Teon2/Effects/Alpha_Blend_UV2" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("Color", Color) = (1,1,1,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        [MaterialToggle] _MainTex_One_UV ("MainTex_One_UV", Float ) = 0
        _Tex2 ("Tex2", 2D) = "white" {}
        _U2_Speed ("U2_Speed", Float ) = 0
        _V2_Speed ("V2_Speed", Float ) = 0
        [MaterialToggle] _Tex2_One_UV ("Tex2_One_UV", Float ) = 0
        _Mask ("Mask", 2D) = "white" {}
        //_Depth ("Depth", Float ) = 0
        //[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#define UNITY_PASS_FORWARDBASE
            #include "../../Include/CGDefine.cginc"
            //#pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            //uniform sampler2D _CameraDepthTexture;
            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform half4 _TintColor;
            //uniform half _Depth;
            uniform half _U_Speed;
            uniform half _V_Speed;
            uniform fixed _MainTex_One_UV;
            uniform half _U2_Speed;
            uniform half _V2_Speed;
            uniform fixed _Tex2_One_UV;
            uniform sampler2D _Tex2; uniform half4 _Tex2_ST;
            uniform sampler2D _Mask; uniform half4 _Mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half4 texcoord1 : TEXCOORD1;
                half4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 uv1 : TEXCOORD1;
                half4 vertexColor : COLOR;
                //half4 projPos : TEXCOORD2;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                //o.projPos = ComputeScreenPos (o.pos);
                //COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            half4 frag(VertexOutput i) : COLOR { //, half facing : VFACE
               /* half isFrontFace = ( facing >= 0 ? 1 : 0 );
                half faceSign = ( facing >= 0 ? 1 : -1 );
                half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
////// Lighting:
////// Emissive:
                //half4 node_6505 = _Time;
                //half4 node_8774 = _Time;
                half2 node_7196 = half2(((_U_Speed*TEON_TIME_Y)+i.uv0.r),(i.uv0.g+(TEON_TIME_Y*_V_Speed)));
                //half2 _MainTex_One_UV_var = lerp( node_7196, (node_7196+half2(i.uv1.r,i.uv1.g)), _MainTex_One_UV );
                half2 _MainTex_One_UV_var = lerp( node_7196, (node_7196+ i.uv1.xy), _MainTex_One_UV );
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_MainTex_One_UV_var, _MainTex));
                //half4 node_2465 = _Time;
                //half4 node_5568 = _Time;
                half2 node_1707 = half2(((_U2_Speed*TEON_TIME_Y)+i.uv0.r),(i.uv0.g+(TEON_TIME_Y*_V2_Speed)));
                //half2 _Tex2_One_UV_var = lerp( node_1707, (node_1707+half2(i.uv1.b,i.uv1.a)), _Tex2_One_UV );
                half2 _Tex2_One_UV_var = lerp( node_1707, (node_1707+ i.uv1.zw), _Tex2_One_UV );
                half4 _Tex2_var = tex2D(_Tex2,TRANSFORM_TEX(_Tex2_One_UV_var, _Tex2));
                //half3 emissive = ((saturate((sceneZ-partZ)/_Depth)*_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb)*_Tex2_var.rgb);
                half3 emissive = ((_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb)*_Tex2_var.rgb);
                //half3 finalColor = emissive;
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                fixed4 finalRGBA = fixed4(emissive,((_MainTex_var.a*i.vertexColor.a*_TintColor.a)*_Tex2_var.a*_Mask_var.r));
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
