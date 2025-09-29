// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33148,y:32629,varname:node_4013,prsc:2|emission-7161-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32138,y:32280,ptovrint:False,ptlb:Main_Color,ptin:_Main_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Fresnel,id:1249,x:32210,y:32803,varname:node_1249,prsc:2|EXP-9561-OUT;n:type:ShaderForge.SFN_Slider,id:4495,x:31476,y:32814,ptovrint:False,ptlb:Fresnel_Range,ptin:_Fresnel_Range,varname:node_4495,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:9561,x:31823,y:32814,varname:node_9561,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-4495-OUT;n:type:ShaderForge.SFN_Power,id:9686,x:32385,y:32803,varname:node_9686,prsc:2|VAL-1249-OUT,EXP-8953-OUT;n:type:ShaderForge.SFN_Vector1,id:8953,x:32210,y:32936,varname:node_8953,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:3011,x:32640,y:32826,varname:node_3011,prsc:2|A-9686-OUT,B-5042-OUT,C-3370-RGB;n:type:ShaderForge.SFN_Slider,id:8508,x:31942,y:33018,ptovrint:False,ptlb:Fresnel_Itensity,ptin:_Fresnel_Itensity,varname:node_8508,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Color,id:3370,x:32295,y:33191,ptovrint:False,ptlb:Fresnel_Color,ptin:_Fresnel_Color,varname:node_3370,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2879,x:32138,y:32441,ptovrint:False,ptlb:Main_Texture,ptin:_Main_Texture,varname:node_2879,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9566,x:32387,y:32368,varname:node_9566,prsc:2|A-1304-RGB,B-2879-RGB,C-2244-RGB;n:type:ShaderForge.SFN_RemapRange,id:5042,x:32315,y:32995,varname:node_5042,prsc:2,frmn:0,frmx:1,tomn:0,tomx:20|IN-8508-OUT;n:type:ShaderForge.SFN_Multiply,id:827,x:32605,y:32676,varname:node_827,prsc:2|A-1304-A,B-2879-A,C-3370-A,D-2244-A;n:type:ShaderForge.SFN_VertexColor,id:2244,x:32138,y:32611,varname:node_2244,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7161,x:32831,y:32706,varname:node_7161,prsc:2|A-827-OUT,B-3011-OUT,C-9566-OUT;proporder:2879-1304-3370-8508-4495;pass:END;sub:END;*/

Shader "Teon2/Effects/Add_Rim" 
{
    Properties 
    {
        _Main_Texture ("Main_Texture", 2D) = "white" {}
        [HDR]_Main_Color ("Main_Color", Color) = (1,1,1,1)
        [HDR]_Fresnel_Color ("Fresnel_Color", Color) = (1,1,1,1)
        _Fresnel_Itensity ("Fresnel_Itensity", Range(0, 1)) = 0
        _Fresnel_Range ("Fresnel_Range", Range(0, 1)) = 0
    }
    SubShader 
    {
        Tags 
        {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass 
        {
            Blend SrcAlpha One
            ColorMask RGB
            Cull Off
            ZWrite Off
            AlphaToMask On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_particles
            //#pragma multi_compile_fog
            #include "UnityCG.cginc"
            
            uniform half4 _Main_Color;
            uniform half _Fresnel_Range;
            uniform half _Fresnel_Itensity;
            uniform half4 _Fresnel_Color;
            uniform sampler2D _Main_Texture; 
            uniform half4 _Main_Texture_ST;

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
                half4 _Main_Texture_var = tex2D(_Main_Texture, TRANSFORM_TEX(i.uv0, _Main_Texture));
                half3 emissive = ((_Main_Color.a * _Main_Texture_var.a * _Fresnel_Color.a * i.vertexColor.a)
                                * (pow(pow(1.0 - max(0, dot(normal, viewDirection)),(_Fresnel_Range * -1.0 + 1.0)), 10.0)
                                * (_Fresnel_Itensity * 20.0) * _Fresnel_Color.rgb) * (_Main_Color.rgb * _Main_Texture_var.rgb * i.vertexColor.rgb));
                return saturate(fixed4(emissive, _Main_Color.a * _Main_Texture_var.a * _Fresnel_Color.a * i.vertexColor.a));
            }
            ENDCG
        }
    }
}
