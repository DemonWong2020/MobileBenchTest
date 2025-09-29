// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32724,y:32693,varname:node_4795,prsc:2|alpha-6273-OUT,refract-6662-OUT;n:type:ShaderForge.SFN_Tex2d,id:6315,x:32021,y:32888,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_6315,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Append,id:8510,x:32267,y:32875,varname:node_8510,prsc:2|A-6315-R,B-6315-G;n:type:ShaderForge.SFN_Vector1,id:6273,x:32497,y:32816,varname:node_6273,prsc:2,v1:0;n:type:ShaderForge.SFN_Multiply,id:6662,x:32519,y:32963,varname:node_6662,prsc:2|A-8510-OUT,B-6315-A,C-8033-OUT,D-1722-A,E-676-OUT;n:type:ShaderForge.SFN_VertexColor,id:1722,x:32306,y:32696,varname:node_1722,prsc:2;n:type:ShaderForge.SFN_Slider,id:8033,x:32128,y:33085,ptovrint:False,ptlb:Itensity,ptin:_Itensity,varname:node_8033,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:676,x:32309,y:33262,varname:node_676,prsc:2,v1:0.1;proporder:6315-8033;pass:END;sub:END;*/

Shader "Teon2/Effects/Alpha_Blend_Refraction" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Itensity ("Itensity", Range(0, 1)) = 0
        //[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ "_LKGrabTexture" }
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
            //#pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _LKGrabTexture;
            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform half _Itensity;
            struct VertexInput 
            {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half4 vertexColor : COLOR;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 vertexColor : COLOR;
                half4 projPos : TEXCOORD1;
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = TRANSFORM_TEX(v.texcoord0, _MainTex);
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                //UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            half4 frag(VertexOutput i) : COLOR //, half facing : VFACE
            {
                //half isFrontFace = ( facing >= 0 ? 1 : 0 );
                //half faceSign = ( facing >= 0 ? 1 : -1 );
                half4 _MainTex_var = tex2D(_MainTex, i.uv0);
                half2 sceneUVs = (i.projPos.xy / i.projPos.w) + (half2(_MainTex_var.r,_MainTex_var.g)*_MainTex_var.a*_Itensity*i.vertexColor.a*0.1);
                half4 sceneColor = tex2D(_LKGrabTexture, sceneUVs);
////// Lighting:
                half3 finalColor = 0;
                  //UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                fixed4 finalRGBA = fixed4(sceneColor.rgb, 1);
              
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}