// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32735,y:32708,varname:node_4795,prsc:2|emission-6330-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32065,y:32531,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6357-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32392,y:32741,varname:node_2393,prsc:2|A-8515-OUT,B-2053-RGB,C-797-RGB,D-6074-A,E-2053-A;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32065,y:32765,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32065,y:32923,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:8922,x:30963,y:32509,varname:node_8922,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6228,x:30963,y:32320,varname:node_6228,prsc:2;n:type:ShaderForge.SFN_Time,id:2858,x:30933,y:32773,varname:node_2858,prsc:2;n:type:ShaderForge.SFN_Add,id:2441,x:31173,y:32424,varname:node_2441,prsc:2|A-1451-OUT,B-8922-U;n:type:ShaderForge.SFN_Append,id:1202,x:31433,y:32529,varname:node_1202,prsc:2|A-2441-OUT,B-3017-OUT;n:type:ShaderForge.SFN_Add,id:3017,x:31189,y:32634,varname:node_3017,prsc:2|A-8922-V,B-4135-OUT;n:type:ShaderForge.SFN_Multiply,id:1451,x:31139,y:32173,varname:node_1451,prsc:2|A-3797-OUT,B-6228-T;n:type:ShaderForge.SFN_ValueProperty,id:3797,x:30940,y:32186,ptovrint:False,ptlb:U_Speed,ptin:_U_Speed,varname:_U_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:4135,x:31132,y:32935,varname:node_4135,prsc:2|A-2858-T,B-6044-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6044,x:30933,y:32995,ptovrint:False,ptlb:V_Speed,ptin:_V_Speed,varname:_V_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:6330,x:32556,y:32843,varname:node_6330,prsc:2|A-2393-OUT,B-797-A,C-5032-OUT;n:type:ShaderForge.SFN_DepthBlend,id:5032,x:32145,y:33116,varname:node_5032,prsc:2|DIST-8462-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8462,x:31915,y:33132,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:_Depth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:1770,x:30902,y:33117,varname:node_1770,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_SwitchProperty,id:6357,x:31870,y:32521,ptovrint:False,ptlb:One_UV,ptin:_One_UV,varname:node_6357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-1202-OUT,B-4405-OUT;n:type:ShaderForge.SFN_Add,id:4405,x:31649,y:33143,varname:node_4405,prsc:2|A-7176-OUT,B-1202-OUT;n:type:ShaderForge.SFN_Append,id:7176,x:31115,y:33138,varname:node_7176,prsc:2|A-1770-U,B-1770-V;n:type:ShaderForge.SFN_Tex2d,id:7530,x:32080,y:32251,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_7530,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:8515,x:32234,y:32438,varname:node_8515,prsc:2|A-7530-RGB,B-6074-RGB;proporder:6074-797-3797-6044-6357-7530-8462;pass:END;sub:END;*/

Shader "Teon2/Effects/Add_UV" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        [MaterialToggle] _One_UV ("One_UV", Float ) = 0
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
            uniform fixed _One_UV;
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
            half4 frag(VertexOutput i) : COLOR {//, half facing : VFACE
               /* half isFrontFace = ( facing >= 0 ? 1 : 0 );
                half faceSign = ( facing >= 0 ? 1 : -1 );
                half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
////// Lighting:
////// Emissive:
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                //half4 node_6228 = _Time;
                //half4 node_2858 = _Time;
                half2 node_1202 = half2(((_U_Speed*TEON_TIME_Y)+i.uv0.r),(i.uv0.g+(TEON_TIME_Y*_V_Speed)));
                //half2 _One_UV_var = lerp( node_1202, (half2(i.uv1.r,i.uv1.g)+node_1202), _One_UV );
                half2 _One_UV_var = lerp( node_1202, (i.uv1 + node_1202), _One_UV );
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_One_UV_var, _MainTex));
                //half3 emissive = (((_Mask_var.rgb*_MainTex_var.rgb)*i.vertexColor.rgb*_TintColor.rgb*_MainTex_var.a*i.vertexColor.a)*_TintColor.a*saturate((sceneZ-partZ)/_Depth));
                half3 emissive = ((_Mask_var.rgb*_MainTex_var.rgb)*i.vertexColor.rgb*_TintColor.rgb*_MainTex_var.a*i.vertexColor.a)*_TintColor.a;
                //half3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(emissive,_MainTex_var.a*i.vertexColor.a*_TintColor.a);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
