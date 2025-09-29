// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32773,y:32290,varname:node_4795,prsc:2|emission-6693-OUT,alpha-6903-OUT;n:type:ShaderForge.SFN_Tex2d,id:8199,x:32291,y:32208,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-3305-OUT;n:type:ShaderForge.SFN_Multiply,id:6693,x:32551,y:32400,varname:node_6693,prsc:2|A-8199-RGB,B-4653-RGB,C-9350-RGB;n:type:ShaderForge.SFN_VertexColor,id:4653,x:32291,y:32379,varname:node_4653,prsc:2;n:type:ShaderForge.SFN_Color,id:9350,x:32291,y:32537,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:3038,x:30856,y:32578,varname:node_3038,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6705,x:30828,y:32389,varname:node_6705,prsc:2;n:type:ShaderForge.SFN_Time,id:5032,x:30826,y:32842,varname:node_5032,prsc:2;n:type:ShaderForge.SFN_Add,id:836,x:31066,y:32493,varname:node_836,prsc:2|A-8358-OUT,B-3038-U;n:type:ShaderForge.SFN_Append,id:6141,x:31326,y:32598,varname:node_6141,prsc:2|A-836-OUT,B-9562-OUT;n:type:ShaderForge.SFN_Add,id:9562,x:31082,y:32703,varname:node_9562,prsc:2|A-3038-V,B-5644-OUT;n:type:ShaderForge.SFN_Multiply,id:8358,x:31032,y:32242,varname:node_8358,prsc:2|A-1845-OUT,B-6705-T;n:type:ShaderForge.SFN_ValueProperty,id:1845,x:30828,y:32242,ptovrint:False,ptlb:MU_Speed,ptin:_MU_Speed,varname:_U_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:5644,x:31025,y:33004,varname:node_5644,prsc:2|A-5032-T,B-6309-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6309,x:30826,y:33064,ptovrint:False,ptlb:MV_Speed,ptin:_MV_Speed,varname:_V_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_DepthBlend,id:2234,x:32310,y:32704,varname:node_2234,prsc:2|DIST-987-OUT;n:type:ShaderForge.SFN_ValueProperty,id:987,x:32108,y:32704,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:_Depth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:9129,x:31263,y:32814,varname:node_9129,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_SwitchProperty,id:5622,x:31763,y:32590,ptovrint:False,ptlb:One_UV,ptin:_One_UV,varname:node_6357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-6141-OUT,B-5781-OUT;n:type:ShaderForge.SFN_Add,id:5781,x:31749,y:32912,varname:node_5781,prsc:2|A-3208-OUT,B-6141-OUT;n:type:ShaderForge.SFN_Append,id:3208,x:31476,y:32835,varname:node_3208,prsc:2|A-9129-U,B-9129-V;n:type:ShaderForge.SFN_Add,id:3305,x:32065,y:32396,varname:node_3305,prsc:2|A-945-OUT,B-5622-OUT;n:type:ShaderForge.SFN_Multiply,id:6903,x:32551,y:32563,varname:node_6903,prsc:2|A-8199-A,B-4653-A,C-9350-A,D-2659-R,E-2234-OUT;n:type:ShaderForge.SFN_Tex2d,id:7429,x:31677,y:32032,ptovrint:False,ptlb:Disturb_Tex,ptin:_Disturb_Tex,varname:node_1724,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-9853-OUT;n:type:ShaderForge.SFN_TexCoord,id:2903,x:30842,y:32017,varname:node_2903,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:709,x:30816,y:31758,varname:node_709,prsc:2;n:type:ShaderForge.SFN_Add,id:3861,x:31260,y:31964,varname:node_3861,prsc:2|A-4393-OUT,B-2903-U;n:type:ShaderForge.SFN_Add,id:2278,x:31270,y:32121,varname:node_2278,prsc:2|A-8184-OUT,B-2903-V;n:type:ShaderForge.SFN_Append,id:9853,x:31458,y:32032,varname:node_9853,prsc:2|A-3861-OUT,B-2278-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3721,x:30842,y:31646,ptovrint:False,ptlb:DU_Speed,ptin:_DU_Speed,varname:node_2963,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:4863,x:30842,y:31924,ptovrint:False,ptlb:DV_Speed,ptin:_DV_Speed,varname:_U_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:8184,x:31025,y:31890,varname:node_8184,prsc:2|A-709-T,B-4863-OUT;n:type:ShaderForge.SFN_Multiply,id:4393,x:31025,y:31692,varname:node_4393,prsc:2|A-3721-OUT,B-709-T;n:type:ShaderForge.SFN_Multiply,id:945,x:31891,y:32066,varname:node_945,prsc:2|A-5921-OUT,B-7429-R;n:type:ShaderForge.SFN_Slider,id:5921,x:31486,y:31889,ptovrint:False,ptlb:Disturb_Itensity,ptin:_Disturb_Itensity,varname:node_7812,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:2659,x:32310,y:32865,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_2659,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:8199-9350-1845-6309-5622-7429-3721-4863-5921-2659-987;pass:END;sub:END;*/

Shader "Teon2/Effects/Alpha_Blend_Disturb" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _MU_Speed ("MU_Speed", Float ) = 0
        _MV_Speed ("MV_Speed", Float ) = 0
        [MaterialToggle] _One_UV ("One_UV", Float ) = 0
        _Disturb_Tex ("Disturb_Tex", 2D) = "white" {}
        _DU_Speed ("DU_Speed", Float ) = 0
        _DV_Speed ("DV_Speed", Float ) = 0
        _Disturb_Itensity ("Disturb_Itensity", Range(0, 1)) = 0
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
            uniform half _MU_Speed;
            uniform half _MV_Speed;
            //uniform half _Depth;
            uniform fixed _One_UV;
            uniform sampler2D _Disturb_Tex; uniform half4 _Disturb_Tex_ST;
            uniform half _DU_Speed;
            uniform half _DV_Speed;
            uniform half _Disturb_Itensity;
            uniform sampler2D _Mask; uniform half4 _Mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half2 texcoord1 : TEXCOORD1;
                half4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half2 uv1 : TEXCOORD1;
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
                //half4 node_709 = _Time;
                half2 node_9853 = half2(((_DU_Speed*TEON_TIME_Y)+i.uv0.r), ((TEON_TIME_Y*_DV_Speed)+i.uv0.g));
                half4 _Disturb_Tex_var = tex2D(_Disturb_Tex,TRANSFORM_TEX(node_9853, _Disturb_Tex));
                //half4 node_6705 = _Time;
                //half4 node_5032 = _Time;
                half2 node_6141 = half2(((_MU_Speed*TEON_TIME_Y)+i.uv0.r), (i.uv0.g+(TEON_TIME_Y*_MV_Speed)));
                half2 node_3305 = ((_Disturb_Itensity*_Disturb_Tex_var.r)+lerp( node_6141, (i.uv1 + node_6141), _One_UV ));
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_3305, _MainTex));
                half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb);
                //half3 finalColor = emissive;
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                //fixed4 finalRGBA = fixed4(finalColor,(_MainTex_var.a*i.vertexColor.a*_TintColor.a*_Mask_var.r*saturate((sceneZ-partZ)/_Depth)));
                fixed4 finalRGBA = fixed4(emissive, (_MainTex_var.a*i.vertexColor.a*_TintColor.a*_Mask_var.r));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
