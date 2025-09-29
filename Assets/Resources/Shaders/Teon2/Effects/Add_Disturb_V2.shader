// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32748,y:32609,varname:node_4795,prsc:2|emission-2393-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32235,y:32601,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4834-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32539,y:32779,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-4325-OUT,E-2717-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32235,y:32772,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32235,y:32930,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:6080,x:30857,y:32583,varname:node_6080,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6113,x:30857,y:32394,varname:node_6113,prsc:2;n:type:ShaderForge.SFN_Time,id:4880,x:30827,y:32847,varname:node_4880,prsc:2;n:type:ShaderForge.SFN_Add,id:1082,x:31067,y:32498,varname:node_1082,prsc:2|A-309-OUT,B-6080-U;n:type:ShaderForge.SFN_Append,id:2708,x:31327,y:32603,varname:node_2708,prsc:2|A-1082-OUT,B-356-OUT;n:type:ShaderForge.SFN_Add,id:356,x:31083,y:32708,varname:node_356,prsc:2|A-6080-V,B-7424-OUT;n:type:ShaderForge.SFN_Multiply,id:309,x:31033,y:32247,varname:node_309,prsc:2|A-4892-OUT,B-6113-T;n:type:ShaderForge.SFN_ValueProperty,id:4892,x:30829,y:32247,ptovrint:False,ptlb:MU_Speed,ptin:_MU_Speed,varname:_U_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:7424,x:31026,y:33009,varname:node_7424,prsc:2|A-4880-T,B-2029-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2029,x:30827,y:33069,ptovrint:False,ptlb:MV_Speed,ptin:_MV_Speed,varname:_V_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_DepthBlend,id:4325,x:32254,y:33097,varname:node_4325,prsc:2|DIST-9888-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9888,x:32052,y:33097,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:_Depth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:6703,x:31240,y:32913,varname:node_6703,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_SwitchProperty,id:8616,x:31764,y:32595,ptovrint:False,ptlb:One_UV,ptin:_One_UV,varname:node_6357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-2708-OUT,B-1496-OUT;n:type:ShaderForge.SFN_Add,id:1496,x:31616,y:32785,varname:node_1496,prsc:2|A-1787-OUT,B-2708-OUT;n:type:ShaderForge.SFN_Append,id:1787,x:31453,y:32934,varname:node_1787,prsc:2|A-6703-U,B-6703-V;n:type:ShaderForge.SFN_Tex2d,id:1724,x:31676,y:32074,ptovrint:False,ptlb:Disturb_Tex,ptin:_Disturb_Tex,varname:node_1724,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-3635-OUT;n:type:ShaderForge.SFN_TexCoord,id:3589,x:30841,y:32059,varname:node_3589,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Tex2d,id:7986,x:32235,y:32346,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_7986,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2717,x:32452,y:32465,varname:node_2717,prsc:2|A-7986-RGB,B-6074-RGB,C-6074-A,D-2053-A,E-797-A;n:type:ShaderForge.SFN_Time,id:6971,x:30841,y:31769,varname:node_6971,prsc:2;n:type:ShaderForge.SFN_Add,id:9674,x:31259,y:32006,varname:node_9674,prsc:2|A-4285-OUT,B-3589-U;n:type:ShaderForge.SFN_Add,id:314,x:31269,y:32163,varname:node_314,prsc:2|A-2822-OUT,B-3589-V;n:type:ShaderForge.SFN_Append,id:3635,x:31457,y:32074,varname:node_3635,prsc:2|A-9674-OUT,B-314-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2963,x:30841,y:31688,ptovrint:False,ptlb:DU_Speed,ptin:_DU_Speed,varname:node_2963,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:2539,x:30841,y:31966,ptovrint:False,ptlb:DV_Speed,ptin:_DV_Speed,varname:_U_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:2822,x:31024,y:31932,varname:node_2822,prsc:2|A-6971-T,B-2539-OUT;n:type:ShaderForge.SFN_Multiply,id:4285,x:31024,y:31734,varname:node_4285,prsc:2|A-2963-OUT,B-6971-T;n:type:ShaderForge.SFN_Add,id:4834,x:32051,y:32554,varname:node_4834,prsc:2|A-9118-OUT,B-8616-OUT;n:type:ShaderForge.SFN_Multiply,id:9118,x:31890,y:32108,varname:node_9118,prsc:2|A-7812-OUT,B-1724-R;n:type:ShaderForge.SFN_Slider,id:7812,x:31485,y:31931,ptovrint:False,ptlb:Disturb_Itensity,ptin:_Disturb_Itensity,varname:node_7812,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:6074-797-4892-2029-8616-1724-2963-2539-7812-7986-9888;pass:END;sub:END;*/

Shader "Teon2/Effects/Add_Disturb" {
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
            ColorMask RGB
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
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
            uniform sampler2D _Mask; uniform half4 _Mask_ST;
            uniform half _DU_Speed;
            uniform half _DV_Speed;
            uniform half _Disturb_Itensity;
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
                /*half isFrontFace = ( facing >= 0 ? 1 : 0 );
                half faceSign = ( facing >= 0 ? 1 : -1 );
                half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
////// Lighting:
////// Emissive:
                //half4 node_6971 = _Time;
                half2 node_3635 = half2(((_DU_Speed*TEON_TIME_Y)+i.uv0.r),((TEON_TIME_Y*_DV_Speed)+i.uv0.g));
                half4 _Disturb_Tex_var = tex2D(_Disturb_Tex,TRANSFORM_TEX(node_3635, _Disturb_Tex));
                //half4 node_6113 = _Time;
                //half4 node_4880 = _Time;
                half2 node_2708 = half2(((_MU_Speed*TEON_TIME_Y)+i.uv0.r),(i.uv0.g+(TEON_TIME_Y*_MV_Speed)));
                half2 node_4834 = ((_Disturb_Itensity*_Disturb_Tex_var.r)+lerp( node_2708, (i.uv1+node_2708), _One_UV ));
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_4834, _MainTex));
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                //half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*saturate((sceneZ-partZ)/_Depth)*(_Mask_var.rgb*_MainTex_var.rgb*_MainTex_var.a*i.vertexColor.a*_TintColor.a));
                half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*(_Mask_var.rgb*_MainTex_var.rgb*_MainTex_var.a*i.vertexColor.a*_TintColor.a));
                //half3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(emissive, 0);//_MainTex_var.a*i.vertexColor.a*_TintColor.a);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
