// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:8105,x:32940,y:32741,varname:node_8105,prsc:2|emission-244-OUT,alpha-3286-OUT,clip-8034-OUT,voffset-8009-OUT;n:type:ShaderForge.SFN_Color,id:493,x:31303,y:32574,ptovrint:False,ptlb:Dark_Color,ptin:_Dark_Color,varname:_SmokeColor_copy,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:947,x:31303,y:32333,ptovrint:False,ptlb:Dark_Tex,ptin:_Dark_Tex,varname:node_947,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:7683,x:31693,y:32321,varname:node_7683,prsc:2|A-947-RGB,B-493-RGB;n:type:ShaderForge.SFN_TexCoord,id:8731,x:31305,y:33045,varname:node_8731,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Tex2d,id:1198,x:31305,y:32804,ptovrint:False,ptlb:Dissolve_Tex,ptin:_Dissolve_Tex,varname:node_1198,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-2936-OUT;n:type:ShaderForge.SFN_Step,id:8034,x:32452,y:33028,varname:node_8034,prsc:2|A-1198-R,B-8731-U;n:type:ShaderForge.SFN_Lerp,id:3313,x:32629,y:32487,varname:node_3313,prsc:2|A-9947-OUT,B-6369-OUT,T-3453-OUT;n:type:ShaderForge.SFN_Step,id:3453,x:32078,y:32519,varname:node_3453,prsc:2|A-1198-R,B-8731-V;n:type:ShaderForge.SFN_Lerp,id:6369,x:32452,y:32653,varname:node_6369,prsc:2|A-3200-RGB,B-120-RGB,T-7833-OUT;n:type:ShaderForge.SFN_Multiply,id:2230,x:31826,y:33254,varname:node_2230,prsc:2|A-1198-R,B-9334-OUT;n:type:ShaderForge.SFN_Color,id:3200,x:32235,y:32569,ptovrint:False,ptlb:Range_Color,ptin:_Range_Color,varname:node_3200,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Color,id:120,x:32235,y:32742,ptovrint:False,ptlb:Main_Color,ptin:_Main_Color,varname:node_120,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Step,id:7833,x:32093,y:33010,varname:node_7833,prsc:2|A-2230-OUT,B-8731-Z;n:type:ShaderForge.SFN_Clamp01,id:9947,x:31901,y:32321,varname:node_9947,prsc:2|IN-7683-OUT;n:type:ShaderForge.SFN_Slider,id:1044,x:31186,y:33276,ptovrint:False,ptlb:Dissolve_Range,ptin:_Dissolve_Range,varname:node_1044,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:9334,x:31565,y:33270,varname:node_9334,prsc:2,frmn:0,frmx:1,tomn:0.9,tomx:2|IN-1044-OUT;n:type:ShaderForge.SFN_Multiply,id:8009,x:32290,y:33155,varname:node_8009,prsc:2|A-1198-RGB,B-8731-W,C-5099-OUT;n:type:ShaderForge.SFN_NormalVector,id:5099,x:32083,y:33214,prsc:2,pt:False;n:type:ShaderForge.SFN_Add,id:2936,x:31068,y:32845,varname:node_2936,prsc:2|A-1042-OUT,B-4564-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4564,x:30620,y:32927,varname:node_4564,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:8685,x:30621,y:32653,varname:node_8685,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:9962,x:30621,y:32543,ptovrint:False,ptlb:U,ptin:_U,varname:node_9962,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:5969,x:30888,y:32573,varname:node_5969,prsc:2|A-9962-OUT,B-8685-T;n:type:ShaderForge.SFN_ValueProperty,id:2742,x:30621,y:32829,ptovrint:False,ptlb:V,ptin:_V,varname:_node_9962_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:6311,x:30888,y:32734,varname:node_6311,prsc:2|A-8685-T,B-2742-OUT;n:type:ShaderForge.SFN_Append,id:1042,x:31053,y:32634,varname:node_1042,prsc:2|A-5969-OUT,B-6311-OUT;n:type:ShaderForge.SFN_VertexColor,id:9364,x:32452,y:32865,varname:node_9364,prsc:2;n:type:ShaderForge.SFN_DepthBlend,id:7179,x:32661,y:33481,varname:node_7179,prsc:2|DIST-3473-OUT;n:type:ShaderForge.SFN_Slider,id:4427,x:32083,y:33484,ptovrint:False,ptlb:Detph,ptin:_Detph,varname:node_4427,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:3286,x:32772,y:32933,varname:node_3286,prsc:2|A-9364-A,B-7179-OUT;n:type:ShaderForge.SFN_RemapRange,id:3473,x:32439,y:33481,varname:node_3473,prsc:2,frmn:0,frmx:1,tomn:0,tomx:10|IN-4427-OUT;n:type:ShaderForge.SFN_Multiply,id:244,x:32759,y:32771,varname:node_244,prsc:2|A-3313-OUT,B-9364-RGB;proporder:947-493-1198-120-3200-9962-2742-1044-4427;pass:END;sub:END;*/

Shader "Teon2/Effects/Bomb" {
    Properties {
        _Dark_Tex ("Dark_Tex", 2D) = "white" {}
        [HDR]_Dark_Color ("Dark_Color", Color) = (1,1,1,1)
        _Dissolve_Tex ("Dissolve_Tex", 2D) = "white" {}
        [HDR]_Main_Color ("Main_Color", Color) = (1,1,1,1)
        [HDR]_Range_Color ("Range_Color", Color) = (1,1,1,1)
        _U ("U", Float ) = 0
        _V ("V", Float ) = 0
        _Dissolve_Range ("Dissolve_Range", Range(0, 1)) = 0
        //_Detph ("Detph", Range(0, 1)) = 0
        //[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            
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
            uniform half4 _Dark_Color;
            uniform sampler2D _Dark_Tex; uniform half4 _Dark_Tex_ST;
            uniform sampler2D _Dissolve_Tex; uniform half4 _Dissolve_Tex_ST;
            uniform half4 _Range_Color;
            uniform half4 _Main_Color;
            uniform half _Dissolve_Range;
            uniform half _U;
            uniform half _V;
            //uniform half _Detph;
            struct VertexInput {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 texcoord0 : TEXCOORD0;
                half4 texcoord1 : TEXCOORD1;
                half4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 uv1 : TEXCOORD1;
                //half4 posWorld : TEXCOORD2;
                //half3 normalDir : TEXCOORD3;
                half4 vertexColor : COLOR;
                //half4 projPos : TEXCOORD4;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                //o.normalDir = UnityObjectToWorldNormal(v.normal);
                //half4 node_8685 = _Time;
                half2 node_2936 = (TEON_TIME_Y * half2((_U),(_V))+o.uv0);
                half4 _Dissolve_Tex_var = tex2Dlod(_Dissolve_Tex,half4(TRANSFORM_TEX(node_2936, _Dissolve_Tex),0.0,0));
                v.vertex.xyz += (_Dissolve_Tex_var.rgb*o.uv1.a*v.normal);
                //o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                //o.projPos = ComputeScreenPos (o.pos);
                //COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            half4 frag(VertexOutput i) : COLOR { //, half facing : VFACE
                //half isFrontFace = ( facing >= 0 ? 1 : 0 );
                //half faceSign = ( facing >= 0 ? 1 : -1 );
                //i.normalDir = normalize(i.normalDir);
                //i.normalDir *= faceSign;
                //half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                //half3 normalDirection = i.normalDir;
                /*half sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                half partZ = max(0,i.projPos.z - _ProjectionParams.g);*/
                //half4 node_8685 = _Time;
                half2 node_2936 = (TEON_TIME_Y * half2((_U),(_V)) + i.uv0);
                half4 _Dissolve_Tex_var = tex2D(_Dissolve_Tex,TRANSFORM_TEX(node_2936, _Dissolve_Tex));
                clip(step(_Dissolve_Tex_var.r,i.uv1.r) - 0.5);
////// Lighting:
////// Emissive:
                half4 _Dark_Tex_var = tex2D(_Dark_Tex,TRANSFORM_TEX(i.uv0, _Dark_Tex));
                half3 emissive = (lerp(saturate((_Dark_Tex_var.rgb*_Dark_Color.rgb)),lerp(_Range_Color.rgb,_Main_Color.rgb,step((_Dissolve_Tex_var.r*(_Dissolve_Range*1.1+0.9)),i.uv1.b)),step(_Dissolve_Tex_var.r,i.uv1.g))*i.vertexColor.rgb);
                //half3 finalColor = emissive;
                //fixed4 finalRGBA = fixed4(finalColor,(i.vertexColor.a*saturate((sceneZ-partZ)/(_Detph*10.0+0.0))));
                fixed4 finalRGBA = fixed4(emissive,(i.vertexColor.a));
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#define UNITY_PASS_SHADOWCASTER
            #include "../../Include/CGDefine.cginc"
            #include "Lighting.cginc"
            //#pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            //#pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _Dissolve_Tex; uniform half4 _Dissolve_Tex_ST;
            uniform half _U;
            uniform half _V;
            struct VertexInput {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 texcoord0 : TEXCOORD0;
                half4 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                half2 uv0 : TEXCOORD1;
                half4 uv1 : TEXCOORD2;
                half4 posWorld : TEXCOORD3;
                half3 normalDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                //half4 node_8685 = _Time;
                half2 node_2936 = (TEON_TIME_Y * half2((_U),(_V))+o.uv0);
                half4 _Dissolve_Tex_var = tex2Dlod(_Dissolve_Tex,half4(TRANSFORM_TEX(node_2936, _Dissolve_Tex),0.0,0));
                v.vertex.xyz += (_Dissolve_Tex_var.rgb*o.uv1.a*v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            half4 frag(VertexOutput i) : COLOR { //, half facing : VFACE
                //half isFrontFace = ( facing >= 0 ? 1 : 0 );
                //half faceSign = ( facing >= 0 ? 1 : -1 );
                //i.normalDir = normalize(i.normalDir);
                //i.normalDir *= faceSign;
                //half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                //half3 normalDirection = i.normalDir;
                //half4 node_8685 = _Time;
                half2 node_2936 = (TEON_TIME_Y * half2((_U),(_V))+i.uv0);
                half4 _Dissolve_Tex_var = tex2D(_Dissolve_Tex,TRANSFORM_TEX(node_2936, _Dissolve_Tex));
                clip(step(_Dissolve_Tex_var.r,i.uv1.r) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
