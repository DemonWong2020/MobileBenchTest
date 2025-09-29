// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32689,y:32573,varname:node_4795,prsc:2|emission-2393-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:31791,y:32538,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2393,x:32474,y:32702,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-9023-RGB,E-6584-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:31791,y:32709,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:31791,y:32867,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:9023,x:31791,y:32337,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_9023,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:6584,x:32214,y:32458,varname:node_6584,prsc:2|A-6074-A,B-2053-A,C-797-A,D-9023-A,E-5769-OUT;n:type:ShaderForge.SFN_DepthBlend,id:5769,x:31779,y:32179,varname:node_5769,prsc:2|DIST-8590-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8590,x:31531,y:32179,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:node_8590,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;proporder:6074-797-9023-8590;pass:END;sub:END;*/

Shader "Teon2/Effects/Add_Mask" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
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
            #include "UnityCG.cginc"
            //#pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            //uniform sampler2D _CameraDepthTexture;
            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform half4 _TintColor;
            uniform sampler2D _Mask; uniform half4 _Mask_ST;
            //uniform half _Depth;
            struct VertexInput {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 vertexColor : COLOR;
                //half4 projPos : TEXCOORD1;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
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
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                //half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*_Mask_var.rgb*(_MainTex_var.a*i.vertexColor.a*_TintColor.a*_Mask_var.a*saturate((sceneZ-partZ)/_Depth)));
                half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*_Mask_var.rgb*(_MainTex_var.a*i.vertexColor.a*_TintColor.a*_Mask_var.a));
                //half3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(emissive, _MainTex_var.a*i.vertexColor.a*_TintColor.a*_Mask_var.a);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
