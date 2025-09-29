// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.2089552,fgcg:0.2089552,fgcb:0.2089552,fgca:1,fgde:0.005,fgrn:0,fgrf:2000,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2432,x:33174,y:33389,varname:node_2432,prsc:2|spec-8291-OUT,gloss-2843-OUT,emission-4105-OUT;n:type:ShaderForge.SFN_Fresnel,id:870,x:31809,y:34162,varname:node_870,prsc:2|EXP-4721-OUT;n:type:ShaderForge.SFN_Multiply,id:7162,x:32319,y:34066,varname:node_7162,prsc:2|A-2547-RGB,B-870-OUT,C-4999-OUT;n:type:ShaderForge.SFN_Color,id:2547,x:31809,y:33998,ptovrint:False,ptlb:Fresnel_Color,ptin:_Fresnel_Color,varname:node_2547,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.4882137,c2:0.6204242,c3:0.6323529,c4:1;n:type:ShaderForge.SFN_Tex2d,id:5840,x:31809,y:33420,ptovrint:False,ptlb:LiangBian,ptin:_LiangBian,varname:node_5840,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:f8590b7c82a56d84dbfb657e40e4db76,ntxv:0,isnm:False|UVIN-9058-OUT;n:type:ShaderForge.SFN_Panner,id:1198,x:30880,y:33699,varname:node_1198,prsc:2,spu:0,spv:1|UVIN-8670-UVOUT,DIST-8321-OUT;n:type:ShaderForge.SFN_Time,id:2859,x:30210,y:33579,varname:node_2859,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7673,x:30435,y:33712,varname:node_7673,prsc:2|A-2859-T,B-4849-OUT;n:type:ShaderForge.SFN_RemapRange,id:8321,x:30654,y:33712,varname:node_8321,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-7673-OUT;n:type:ShaderForge.SFN_TexCoord,id:8670,x:30654,y:33568,varname:node_8670,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_TexCoord,id:639,x:30880,y:33264,varname:node_639,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:9058,x:31578,y:33567,varname:node_9058,prsc:2|A-9780-UVOUT,B-7512-OUT;n:type:ShaderForge.SFN_Tex2d,id:327,x:31178,y:33702,ptovrint:False,ptlb:WenLi,ptin:_WenLi,varname:node_327,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:1af9bf2fd5b071243b6704b330453be1,ntxv:0,isnm:False|UVIN-1198-UVOUT;n:type:ShaderForge.SFN_Multiply,id:7512,x:31388,y:33685,varname:node_7512,prsc:2|A-327-R,B-1808-OUT;n:type:ShaderForge.SFN_Panner,id:9780,x:31388,y:33481,varname:node_9780,prsc:2,spu:0.7,spv:1|UVIN-639-UVOUT,DIST-947-OUT;n:type:ShaderForge.SFN_Multiply,id:2320,x:30654,y:33436,varname:node_2320,prsc:2|A-2859-T,B-1357-OUT;n:type:ShaderForge.SFN_RemapRange,id:947,x:30880,y:33436,varname:node_947,prsc:2,frmn:0,frmx:1,tomn:2,tomx:1|IN-2320-OUT;n:type:ShaderForge.SFN_Add,id:2348,x:32657,y:33496,varname:node_2348,prsc:2|A-314-OUT,B-7162-OUT;n:type:ShaderForge.SFN_Multiply,id:7099,x:32036,y:33395,varname:node_7099,prsc:2|A-3643-OUT,B-5840-RGB,C-8416-RGB;n:type:ShaderForge.SFN_Color,id:6741,x:31626,y:33127,ptovrint:False,ptlb:LB_Color,ptin:_LB_Color,varname:node_6741,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.7205882,c2:0.8728195,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:8416,x:31809,y:33611,ptovrint:False,ptlb:TuoWei,ptin:_TuoWei,varname:node_8416,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ff9252999d2ab264ba225f266f15f70b,ntxv:0,isnm:False|UVIN-9058-OUT;n:type:ShaderForge.SFN_Add,id:314,x:32302,y:33501,varname:node_314,prsc:2|A-7099-OUT,B-1841-OUT;n:type:ShaderForge.SFN_Multiply,id:1841,x:32032,y:33760,varname:node_1841,prsc:2|A-8416-RGB,B-2010-OUT;n:type:ShaderForge.SFN_Color,id:798,x:31571,y:33760,ptovrint:False,ptlb:TW_Color,ptin:_TW_Color,varname:node_798,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.6764706,c2:0.8929007,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:4721,x:31618,y:34196,ptovrint:False,ptlb:Fresnel_Val,ptin:_Fresnel_Val,varname:node_4721,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_ValueProperty,id:1808,x:31178,y:33917,ptovrint:False,ptlb:WenLi_qiangdu,ptin:_WenLi_qiangdu,varname:node_1808,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_ValueProperty,id:4849,x:30220,y:33746,ptovrint:False,ptlb:WenLi_yundong,ptin:_WenLi_yundong,varname:node_4849,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;n:type:ShaderForge.SFN_ValueProperty,id:1357,x:30321,y:33423,ptovrint:False,ptlb:LB/TW_yundong,ptin:_LBTW_yundong,varname:node_1357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.3;n:type:ShaderForge.SFN_Color,id:4430,x:32658,y:33160,ptovrint:False,ptlb:GaoGuang_Color,ptin:_GaoGuang_Color,varname:node_4430,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.3088235,c2:0.7711966,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:8291,x:32884,y:33244,varname:node_8291,prsc:2|A-4430-RGB,B-2086-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2086,x:32658,y:33334,ptovrint:False,ptlb:GaoGuang_qiangdu,ptin:_GaoGuang_qiangdu,varname:node_2086,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_ValueProperty,id:2843,x:32658,y:33423,ptovrint:False,ptlb:GaoGuangFanWei,ptin:_GaoGuangFanWei,varname:node_2843,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Tex2d,id:9190,x:32657,y:33664,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_9190,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:e7a6c3c2462dc4840b8cedb42a8d86b6,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:4105,x:32878,y:33570,varname:node_4105,prsc:2|A-2348-OUT,B-9190-A;n:type:ShaderForge.SFN_Multiply,id:3643,x:31809,y:33219,varname:node_3643,prsc:2|A-6741-RGB,B-1595-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1595,x:31626,y:33343,ptovrint:False,ptlb:LB_ColorVal,ptin:_LB_ColorVal,varname:node_1595,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:2010,x:31809,y:33830,varname:node_2010,prsc:2|A-798-RGB,B-6612-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6612,x:31571,y:33939,ptovrint:False,ptlb:TW_ColorVal,ptin:_TW_ColorVal,varname:node_6612,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:4999,x:31809,y:34322,ptovrint:False,ptlb:FresnelColorVal,ptin:_FresnelColorVal,varname:node_4999,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;proporder:6741-1595-5840-798-6612-8416-1357-327-4849-1808-2547-4999-4721-4430-2086-2843-9190;pass:END;sub:END;*/

Shader "Teon2/Effects/MagicCoverAdd" 
{
     Properties 
     {
        _LB_Color ("LB_Color", Color) = (1,1,1,1)
        _LB_HDR ("LB_HDR", Float ) = 1
        _LiangBian ("LiangBian", 2D) = "white" {}
        _TW_Color ("TW_Color", Color) = (1,1,1,1)
        _TW_HDR ("TW_HDR", Float ) = 1
        _TuoWei ("TuoWei", 2D) = "white" {}
        _LBTW_yundong ("LB/TW_yundong", Float ) = 0.3
        _WenLi ("WenLi", 2D) = "white" {}
        _WenLi_yundong ("WenLi_yundong", Float ) = 0.05
        _WenLi_Itensity ("WenLi_Itensity", Float ) = 0.1
        _Fresnel_Color ("Fresnel_Color", Color) = (1,1,1,1)
        _Fre_Itensity ("Fre_Itensity", Float ) = 1
        _Fre_Range ("Fre_Range", Float ) = 3
        _Mask ("Mask", 2D) = "white" {}
    }

    SubShader 
    {
        Tags 
        {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        LOD 200
        Pass 
        {
            Name "FORWARD"
            Tags 
            {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "../../Include/LightMode.cginc"
            #include "../../Include/CGDefine.cginc"

            uniform half4 _Fresnel_Color;
            uniform sampler2D _LiangBian; uniform half4 _LiangBian_ST;
            uniform sampler2D _WenLi; uniform half4 _WenLi_ST;
            uniform half4 _LB_Color;
            uniform sampler2D _TuoWei; uniform half4 _TuoWei_ST;
            uniform half4 _TW_Color;
            uniform half _Fre_Range;
            uniform half _WenLi_Itensity;
            uniform half _WenLi_yundong;
            uniform half _LBTW_yundong;
            uniform sampler2D _Mask; uniform half4 _Mask_ST;
            uniform half _LB_HDR;
            uniform half _TW_HDR;
            uniform half _Fre_Itensity;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 texcoord0 : TEXCOORD0;
                half4 vertexColor : COLOR;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 posWorld : TEXCOORD1;
                half3 normalDir : TEXCOORD2;
                half4 vertexColor : COLOR;
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(VertexOutput i, half facing : VFACE) : COLOR 
            {
                half faceSign = (facing >= 0 ? 1 : -1);
                half3 normal = normalize(i.normalDir * faceSign);
                half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
////// Lighting:
////// Emissive:
                half2 node_1198 = (i.uv0);
                node_1198.y = node_1198.y + (TEON_TIME_Y * _WenLi_yundong) * 2.0 + -1.0;
                half4 _WenLi_var = tex2D(_WenLi, TRANSFORM_TEX(node_1198, _WenLi));

                half2 node_9058 = ((i.uv0 + ((TEON_TIME_Y * _LBTW_yundong) * -1.0 + 2.0) * half2(0.7, 1)) + (_WenLi_var.r * _WenLi_Itensity));
                half4 _LiangBian_var = tex2D(_LiangBian, TRANSFORM_TEX(node_9058, _LiangBian));
                half4 _TuoWei_var = tex2D(_TuoWei, TRANSFORM_TEX(node_9058, _TuoWei));
                half4 _Mask_var = tex2D(_Mask, TRANSFORM_TEX(i.uv0, _Mask));
                half3 emissive = (((((_LB_Color.rgb * _LB_HDR) * _LiangBian_var.rgb * _TuoWei_var.rgb) +
                                     (_TuoWei_var.rgb * (_TW_Color.rgb * _TW_HDR))) + 
                                     (_Fresnel_Color.rgb * pow(1.0 - max(0, dot(normal, viewDirection)), _Fre_Range) * _Fre_Itensity)) *
                                     _Mask_var.a * i.vertexColor.rgb * (_LB_Color.a * _TW_Color.a * _Fresnel_Color.a * i.vertexColor.a));
                return saturate(fixed4(emissive, 1));
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
