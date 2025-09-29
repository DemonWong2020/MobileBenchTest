// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32535,y:32628,varname:node_4795,prsc:2|emission-134-OUT,custl-2393-OUT,alpha-127-OUT,clip-6017-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:31649,y:32340,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5595-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32038,y:32479,varname:node_2393,prsc:2|A-6074-RGB,B-797-RGB,C-5477-RGB;n:type:ShaderForge.SFN_Color,id:797,x:31649,y:32548,ptovrint:True,ptlb:MainColor,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:8804,x:30957,y:32704,ptovrint:False,ptlb:DissolveTex,ptin:_DissolveTex,varname:node_8804,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Divide,id:2336,x:31382,y:32930,varname:node_2336,prsc:2|A-8804-R,B-2521-OUT;n:type:ShaderForge.SFN_Slider,id:4134,x:30813,y:32959,ptovrint:False,ptlb:DissolveItensity,ptin:_DissolveItensity,varname:node_4134,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Step,id:8965,x:31655,y:33026,varname:node_8965,prsc:2|A-2336-OUT,B-4208-OUT;n:type:ShaderForge.SFN_Slider,id:1150,x:31133,y:33177,ptovrint:False,ptlb:DissolveRange,ptin:_DissolveRange,varname:node_1150,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:134,x:31836,y:32729,varname:node_134,prsc:2|A-8309-RGB,B-8965-OUT;n:type:ShaderForge.SFN_Color,id:8309,x:31273,y:32751,ptovrint:False,ptlb:DissolveColor,ptin:_DissolveColor,varname:node_8309,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Clamp01,id:6017,x:31895,y:32992,varname:node_6017,prsc:2|IN-2336-OUT;n:type:ShaderForge.SFN_Multiply,id:7148,x:32042,y:32816,varname:node_7148,prsc:2|A-4815-OUT,B-6017-OUT;n:type:ShaderForge.SFN_DepthBlend,id:3722,x:32251,y:33072,varname:node_3722,prsc:2|DIST-1158-OUT;n:type:ShaderForge.SFN_Multiply,id:127,x:32337,y:32876,varname:node_127,prsc:2|A-3722-OUT,B-7148-OUT;n:type:ShaderForge.SFN_RemapRange,id:4208,x:31463,y:33098,varname:node_4208,prsc:2,frmn:0,frmx:1,tomn:0.5,tomx:1|IN-1150-OUT;n:type:ShaderForge.SFN_VertexColor,id:5477,x:31649,y:32170,varname:node_5477,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:1158,x:32058,y:33072,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:node_1158,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:4815,x:32042,y:32626,varname:node_4815,prsc:2|A-5477-A,B-6074-A,C-797-A;n:type:ShaderForge.SFN_TexCoord,id:3858,x:30801,y:33090,varname:node_3858,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_SwitchProperty,id:2521,x:31194,y:32980,ptovrint:False,ptlb:ParticalControl,ptin:_ParticalControl,varname:node_2521,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-4134-OUT,B-6841-OUT;n:type:ShaderForge.SFN_Step,id:6841,x:30970,y:33066,varname:node_6841,prsc:2|A-8804-R,B-3858-U;n:type:ShaderForge.SFN_TexCoord,id:61,x:30981,y:32158,varname:node_61,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:5440,x:30968,y:32307,varname:node_5440,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:2750,x:30991,y:32495,ptovrint:False,ptlb:U_Speed,ptin:_U_Speed,varname:node_2750,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:282,x:30991,y:32613,ptovrint:False,ptlb:V_Speed,ptin:_V_Speed,varname:_U_Speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Append,id:8976,x:31190,y:32533,varname:node_8976,prsc:2|A-2750-OUT,B-282-OUT;n:type:ShaderForge.SFN_Add,id:5595,x:31429,y:32251,varname:node_5595,prsc:2|A-61-UVOUT,B-4888-OUT;n:type:ShaderForge.SFN_Multiply,id:4888,x:31242,y:32346,varname:node_4888,prsc:2|A-5440-T,B-8976-OUT;proporder:6074-797-2750-282-8804-8309-4134-1150-1158-2521;pass:END;sub:END;*/

Shader "Teon2/Effects/Alpha_Blend_Dissolve" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("MainColor", Color) = (1,1,1,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        _DissolveTex ("DissolveTex", 2D) = "white" {}
        [HDR]_DissolveColor ("DissolveColor", Color) = (1,1,1,1)
        _DissolveItensity ("DissolveItensity", Range(0, 2)) = 0
        _DissolveRange ("DissolveRange", Range(0.5, 1)) = 0  // Range(0.5, 1)) = 0
        //_Depth ("Depth", Float ) = 0
        [MaterialToggle] _ParticalControl ("ParticalControl", Float ) = 0
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
            #include "UnityCG.cginc"
            #include "../../Include/CGDefine.cginc"
            //#pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            //uniform sampler2D _CameraDepthTexture;
            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform half4 _TintColor;
            uniform sampler2D _DissolveTex; uniform half4 _DissolveTex_ST;
            uniform half _DissolveItensity;
            uniform half _DissolveRange;
            uniform half4 _DissolveColor;
            //uniform half _Depth;
            uniform fixed _ParticalControl;
            uniform half _U_Speed;
            uniform half _V_Speed;
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
              /*  half isFrontFace = ( facing >= 0 ? 1 : 0 );
                half faceSign = ( facing >= 0 ? 1 : -1 );
                half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
                half4 _DissolveTex_var = tex2D(_DissolveTex,TRANSFORM_TEX(i.uv0, _DissolveTex));
                half node_2336 = (_DissolveTex_var.r/lerp( _DissolveItensity, i.uv1.r, _ParticalControl ));
                half node_6017 = saturate(node_2336);
                clip(node_6017 - 0.5);
////// Lighting:
////// Emissive:
                //half3 emissive = (_DissolveColor.rgb*step(node_2336,(_DissolveRange*0.5+0.5)));
                half3 emissive = (_DissolveColor.rgb*step(node_2336,(_DissolveRange)));
                //half4 node_5440 = _Time;
                half2 node_5595 = (i.uv0+(TEON_TIME_Y*half2(_U_Speed,_V_Speed)));
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_5595, _MainTex));
                half3 finalColor = emissive + (_MainTex_var.rgb*_TintColor.rgb*i.vertexColor.rgb);
                //fixed4 finalRGBA = fixed4(finalColor,(saturate((sceneZ-partZ)/_Depth)*((i.vertexColor.a*_MainTex_var.a*_TintColor.a)*node_6017)));
                fixed4 finalRGBA = fixed4(finalColor,((i.vertexColor.a*_MainTex_var.a*_TintColor.a)*node_6017));
                   UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
