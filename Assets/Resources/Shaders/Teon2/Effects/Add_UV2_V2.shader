// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32808,y:32626,varname:node_4795,prsc:2|emission-6330-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32072,y:32587,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-8283-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32421,y:32776,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-4685-OUT,E-2053-A;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32065,y:32765,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32065,y:32923,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:8922,x:30962,y:32619,varname:node_8922,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6228,x:30704,y:32632,varname:node_6228,prsc:2;n:type:ShaderForge.SFN_Add,id:2441,x:31188,y:32534,varname:node_2441,prsc:2|A-1451-OUT,B-8922-U;n:type:ShaderForge.SFN_Append,id:1202,x:31628,y:32571,varname:node_1202,prsc:2|A-2441-OUT,B-3017-OUT;n:type:ShaderForge.SFN_Add,id:3017,x:31188,y:32744,varname:node_3017,prsc:2|A-8922-V,B-4135-OUT;n:type:ShaderForge.SFN_Multiply,id:1451,x:31029,y:32366,varname:node_1451,prsc:2|A-3797-OUT,B-6228-T;n:type:ShaderForge.SFN_ValueProperty,id:3797,x:30771,y:32365,ptovrint:False,ptlb:U_Speed,ptin:_U_Speed,varname:node_3797,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:4135,x:30985,y:32904,varname:node_4135,prsc:2|A-6228-T,B-6044-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6044,x:30647,y:32966,ptovrint:False,ptlb:V_Speed,ptin:_V_Speed,varname:node_6044,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:6330,x:32609,y:32776,varname:node_6330,prsc:2|A-2393-OUT,B-797-A,C-5032-OUT,D-6074-A,E-167-A;n:type:ShaderForge.SFN_DepthBlend,id:5032,x:32401,y:33018,varname:node_5032,prsc:2|DIST-8462-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8462,x:32216,y:33036,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:node_8462,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:2703,x:31055,y:32135,varname:node_2703,prsc:2|A-9003-T,B-1825-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1825,x:30764,y:32172,ptovrint:False,ptlb:V2_Speed,ptin:_V2_Speed,varname:_V_Speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:1154,x:31224,y:31750,varname:node_1154,prsc:2|A-881-OUT,B-7508-U;n:type:ShaderForge.SFN_Multiply,id:881,x:31023,y:31648,varname:node_881,prsc:2|A-6803-OUT,B-9003-T;n:type:ShaderForge.SFN_ValueProperty,id:6803,x:30760,y:31625,ptovrint:False,ptlb:U2_Speed,ptin:_U2_Speed,varname:_U_Speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:7508,x:30998,y:31835,varname:node_7508,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:9003,x:30740,y:31848,varname:node_9003,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:167,x:32106,y:31915,ptovrint:False,ptlb:Tex2,ptin:_Tex2,varname:_MainTex_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-1021-OUT;n:type:ShaderForge.SFN_Append,id:4601,x:31675,y:31863,varname:node_4601,prsc:2|A-1154-OUT,B-4188-OUT;n:type:ShaderForge.SFN_Add,id:4188,x:31233,y:32049,varname:node_4188,prsc:2|A-7508-V,B-2703-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:1021,x:31926,y:31863,ptovrint:False,ptlb:Tex2_One_UV,ptin:_Tex2_One_UV,varname:node_1021,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-4601-OUT,B-4817-OUT;n:type:ShaderForge.SFN_TexCoord,id:4664,x:31449,y:32118,varname:node_4664,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Append,id:4940,x:31698,y:32140,varname:node_4940,prsc:2|A-4664-Z,B-4664-W;n:type:ShaderForge.SFN_SwitchProperty,id:8283,x:31851,y:32553,ptovrint:False,ptlb:MainTex_One_UV,ptin:_MainTex_One_UV,varname:node_8283,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-1202-OUT,B-5471-OUT;n:type:ShaderForge.SFN_TexCoord,id:5625,x:31406,y:32811,varname:node_5625,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Append,id:8210,x:31598,y:32811,varname:node_8210,prsc:2|A-5625-U,B-5625-V;n:type:ShaderForge.SFN_Add,id:4817,x:31851,y:32012,varname:node_4817,prsc:2|A-4601-OUT,B-4940-OUT;n:type:ShaderForge.SFN_Add,id:5471,x:31784,y:32766,varname:node_5471,prsc:2|A-1202-OUT,B-8210-OUT;n:type:ShaderForge.SFN_Tex2d,id:5498,x:32086,y:32216,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_5498,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:4685,x:32327,y:32367,varname:node_4685,prsc:2|A-167-RGB,B-5498-RGB;proporder:6074-797-3797-6044-8283-167-6803-1825-1021-5498-8462;pass:END;sub:END;*/

Shader "Teon2/Effects/Add_UV2" {
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
        //_Depth ("Depth", Float ) = 0
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
            ColorMask RGB
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
            uniform half _U_Speed;
            uniform half _V_Speed;
            //uniform half _Depth;
            uniform half _V2_Speed;
            uniform half _U2_Speed;
            uniform sampler2D _Tex2; uniform half4 _Tex2_ST;
            uniform fixed _Tex2_One_UV;
            uniform fixed _MainTex_One_UV;
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
            half4 frag(VertexOutput i) : COLOR {//, half facing : VFACE
               /* half isFrontFace = ( facing >= 0 ? 1 : 0 );
                half faceSign = ( facing >= 0 ? 1 : -1 );
                half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
////// Lighting:
////// Emissive:
                //half4 node_6228 = _Time;
                half2 node_1202 = half2(((_U_Speed*TEON_TIME_Y)+i.uv0.r), (i.uv0.g+(TEON_TIME_Y*_V_Speed)));
                //half2 _MainTex_One_UV_var = lerp( node_1202, (node_1202+half2(i.uv1.r,i.uv1.g)), _MainTex_One_UV );
                half2 _MainTex_One_UV_var = lerp( node_1202, (node_1202 + i.uv1.xy), _MainTex_One_UV );
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_MainTex_One_UV_var, _MainTex));
                //half4 node_9003 = _Time;
                half2 node_4601 = half2(((_U2_Speed*TEON_TIME_Y)+i.uv0.r), (i.uv0.g+(TEON_TIME_Y*_V2_Speed)));
                //half2 _Tex2_One_UV_var = lerp( node_4601, (node_4601+half2(i.uv1.b,i.uv1.a)), _Tex2_One_UV );
                half2 _Tex2_One_UV_var = lerp( node_4601, (node_4601 + i.uv1.zw), _Tex2_One_UV );
                half4 _Tex2_var = tex2D(_Tex2,TRANSFORM_TEX(_Tex2_One_UV_var, _Tex2));
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                //half3 emissive = ((_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*(_Tex2_var.rgb*_Mask_var.rgb)*i.vertexColor.a)*_TintColor.a*saturate((sceneZ-partZ)/_Depth)*_MainTex_var.a*_Tex2_var.a);
                half3 emissive = ((_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*(_Tex2_var.rgb*_Mask_var.rgb)*i.vertexColor.a)*_TintColor.a*_MainTex_var.a*_Tex2_var.a);
                //half3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(emissive, 0);//i.vertexColor.a*_TintColor.a*_MainTex_var.a*_Tex2_var.a);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
