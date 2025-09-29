// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32716,y:32678,varname:node_4795,prsc:2|emission-2393-OUT,alpha-798-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32235,y:32601,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-872-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32495,y:32793,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-9549-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32235,y:32772,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32235,y:32930,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:798,x:32507,y:32954,varname:node_798,prsc:2|A-6074-A,B-2053-A,C-797-A,D-6258-R;n:type:ShaderForge.SFN_DepthBlend,id:9549,x:32235,y:32446,varname:node_9549,prsc:2|DIST-2774-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2774,x:32045,y:32480,ptovrint:False,ptlb:Depth,ptin:_Depth,varname:node_2774,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:7949,x:31030,y:32632,varname:node_7949,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6505,x:31030,y:32422,varname:node_6505,prsc:2;n:type:ShaderForge.SFN_Add,id:8365,x:31288,y:32562,varname:node_8365,prsc:2|A-5299-OUT,B-7949-U;n:type:ShaderForge.SFN_Time,id:8774,x:31050,y:32907,varname:node_8774,prsc:2;n:type:ShaderForge.SFN_Add,id:4440,x:31288,y:32778,varname:node_4440,prsc:2|A-7949-V,B-8771-OUT;n:type:ShaderForge.SFN_Append,id:7196,x:31536,y:32622,varname:node_7196,prsc:2|A-8365-OUT,B-4440-OUT;n:type:ShaderForge.SFN_Multiply,id:5299,x:31232,y:32402,varname:node_5299,prsc:2|A-236-OUT,B-6505-T;n:type:ShaderForge.SFN_ValueProperty,id:236,x:31030,y:32329,ptovrint:False,ptlb:U_Speed,ptin:_U_Speed,varname:node_236,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:8771,x:31255,y:32964,varname:node_8771,prsc:2|A-8774-T,B-1873-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1873,x:31050,y:33083,ptovrint:False,ptlb:V_Speed,ptin:_V_Speed,varname:node_1873,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:872,x:32028,y:32618,ptovrint:False,ptlb:One_UV,ptin:_One_UV,varname:node_872,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7196-OUT,B-6376-OUT;n:type:ShaderForge.SFN_TexCoord,id:7611,x:31497,y:32853,varname:node_7611,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Append,id:2150,x:31668,y:32873,varname:node_2150,prsc:2|A-7611-U,B-7611-V;n:type:ShaderForge.SFN_Add,id:6376,x:31875,y:32737,varname:node_6376,prsc:2|A-7196-OUT,B-2150-OUT;n:type:ShaderForge.SFN_Tex2d,id:6258,x:32235,y:33157,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_7530,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:6074-797-236-1873-872-6258-2774;pass:END;sub:END;*/

Shader "Teon2/Effects/Alpha_Blend_UV" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 0
        [MaterialToggle] _One_UV ("One_UV", Float ) = 0
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
            #include "UnityCG.cginc"
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
            half4 frag(VertexOutput i) : COLOR { //, half facing : VFACE
                /*half isFrontFace = ( facing >= 0 ? 1 : 0 );
                half faceSign = ( facing >= 0 ? 1 : -1 );
                half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
////// Lighting:
////// Emissive:
                half4 node_6505 = _Time;
                half4 node_8774 = _Time;
                half2 node_7196 = half2(((_U_Speed*node_6505.g)+i.uv0.r),(i.uv0.g+(node_8774.g*_V_Speed)));
                //half2 _One_UV_var = lerp( node_7196, (node_7196+half2(i.uv1.r,i.uv1.g)), _One_UV );
                half2 _One_UV_var = lerp( node_7196, (node_7196 + i.uv1), _One_UV );
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_One_UV_var, _MainTex));
                //half3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*saturate((sceneZ-partZ)/_Depth));
                half3 emissive = _MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb;
                //half3 finalColor = emissive;
                half4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                fixed4 finalRGBA = fixed4(emissive,(_MainTex_var.a*i.vertexColor.a*_TintColor.a*_Mask_var.r));
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
