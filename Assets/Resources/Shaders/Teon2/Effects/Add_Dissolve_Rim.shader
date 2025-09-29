// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33185,y:32587,varname:node_4013,prsc:2|diff-9566-OUT,emission-8936-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32091,y:31975,ptovrint:False,ptlb:Main_Color,ptin:_Main_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Fresnel,id:1249,x:31949,y:33270,varname:node_1249,prsc:2|EXP-9561-OUT;n:type:ShaderForge.SFN_Slider,id:4495,x:31215,y:33281,ptovrint:False,ptlb:Fresnel_Range,ptin:_Fresnel_Range,varname:node_4495,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:9561,x:31562,y:33281,varname:node_9561,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-4495-OUT;n:type:ShaderForge.SFN_Power,id:9686,x:32124,y:33270,varname:node_9686,prsc:2|VAL-1249-OUT,EXP-8953-OUT;n:type:ShaderForge.SFN_Vector1,id:8953,x:31949,y:33403,varname:node_8953,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:3011,x:32298,y:33281,varname:node_3011,prsc:2|A-9686-OUT,B-5042-OUT,C-3370-RGB;n:type:ShaderForge.SFN_Slider,id:8508,x:31681,y:33485,ptovrint:False,ptlb:Fresnel_Itensity,ptin:_Fresnel_Itensity,varname:node_8508,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Color,id:3370,x:32034,y:33658,ptovrint:False,ptlb:Fresnel_Color,ptin:_Fresnel_Color,varname:node_3370,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2879,x:32091,y:32175,ptovrint:False,ptlb:Main_Texture,ptin:_Main_Texture,varname:node_2879,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9566,x:32340,y:32135,varname:node_9566,prsc:2|A-1304-RGB,B-2879-RGB,C-265-RGB,D-9040-OUT;n:type:ShaderForge.SFN_RemapRange,id:5042,x:32054,y:33462,varname:node_5042,prsc:2,frmn:0,frmx:1,tomn:0,tomx:20|IN-8508-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:31566,y:32798,ptovrint:False,ptlb:DissolveTex,ptin:_DissolveTex,varname:node_6074,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9438,x:31784,y:32827,varname:node_9438,prsc:2|A-6074-R,B-6074-A;n:type:ShaderForge.SFN_Slider,id:4076,x:31457,y:33023,ptovrint:False,ptlb:DissolveIntensity,ptin:_DissolveIntensity,varname:node_4076,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_TexCoord,id:1675,x:31580,y:33112,varname:node_1675,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_SwitchProperty,id:3556,x:31799,y:33025,ptovrint:False,ptlb:ParticContro,ptin:_ParticContro,varname:node_3556,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-4076-OUT,B-1675-U;n:type:ShaderForge.SFN_Divide,id:1833,x:31984,y:32872,varname:node_1833,prsc:2|A-9438-OUT,B-3556-OUT;n:type:ShaderForge.SFN_If,id:6850,x:32426,y:32838,varname:node_6850,prsc:2|A-1833-OUT,B-8268-OUT,GT-3836-OUT,EQ-8446-OUT,LT-8446-OUT;n:type:ShaderForge.SFN_RemapRange,id:8268,x:32175,y:33063,varname:node_8268,prsc:2,frmn:0,frmx:1,tomn:0.5,tomx:1|IN-4439-OUT;n:type:ShaderForge.SFN_Slider,id:4439,x:31860,y:33159,ptovrint:False,ptlb:Dissolve_Range,ptin:_Dissolve_Range,varname:node_4439,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:3836,x:32163,y:32906,varname:node_3836,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:8446,x:32145,y:32976,varname:node_8446,prsc:2,v1:1;n:type:ShaderForge.SFN_Color,id:7457,x:32039,y:32619,ptovrint:False,ptlb:DissolveColor,ptin:_DissolveColor,varname:node_7457,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:2722,x:32259,y:32594,varname:node_2722,prsc:2|A-7457-RGB,B-6850-OUT;n:type:ShaderForge.SFN_Multiply,id:8936,x:32887,y:32706,varname:node_8936,prsc:2|A-3199-OUT,B-3011-OUT;n:type:ShaderForge.SFN_OneMinus,id:3199,x:32586,y:32560,varname:node_3199,prsc:2|IN-2722-OUT;n:type:ShaderForge.SFN_Multiply,id:9040,x:32368,y:32289,varname:node_9040,prsc:2|A-1304-A,B-2879-A,C-265-A;n:type:ShaderForge.SFN_VertexColor,id:265,x:32091,y:32362,varname:node_265,prsc:2;proporder:2879-1304-3370-8508-4495-6074-7457-4076-4439-3556;pass:END;sub:END;*/
Shader "Teon2/Effects/Add_Dissolve_Rim" 
{
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR]_MainColor ("MainColor", Color) = (1,1,1,1)
        _DissolveTex ("DissolveTex", 2D) = "white" {}
        [HDR]_DissolveColor ("DissolveColor", Color) = (1,1,1,1)
        _DissolveIntensity ("DissolveIntensity", Range(0, 2)) = 0
        _DissolveRange ("DissolveRange", Range(0.5, 1)) = 0.5 // Range(0.5, 1)) = 0
        [HDR]_Fresnel_Color ("Fresnel_Color", Color) = (1,1,1,1)
        _Fresnel_Itensity ("Fresnel_Itensity", Range(0, 1)) = 0
        _Fresnel_Range ("Fresnel_Range", Range(0, 1)) = 1

        [MaterialToggle] _ParticalControl ("ParticalControl", Float ) = 0
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Blend One One
            Cull back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
            //#pragma multi_compile_fog
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform half4 _MainColor;
            uniform sampler2D _DissolveTex; uniform half4 _DissolveTex_ST;
            uniform half _DissolveIntensity;
            uniform half _DissolveRange;
            uniform half4 _DissolveColor;
            //uniform half _Depth;
            uniform fixed _ParticalControl;

            uniform half _Fresnel_Range;
            uniform half _Fresnel_Itensity;
            uniform half4 _Fresnel_Color;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                half2 texcoord1 : TEXCOORD1;
                half4 vertexColor : COLOR;
                half3 normal : NORMAL;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                half3 worldNormal : NORMAL;
                half2 uv0 : TEXCOORD0;
                half2 uv1 : TEXCOORD1;
                half4 vertexColor : COLOR;
                half3 posWorld : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
              
                return o;
            }

            half4 frag(VertexOutput i) : COLOR 
            { 
                half4 _DissolveTex_var = tex2D(_DissolveTex,TRANSFORM_TEX(i.uv0, _DissolveTex));
                half3 node_332 = ((_DissolveTex_var.rgb*_DissolveTex_var.a)/lerp( _DissolveIntensity, i.uv1.r, _ParticalControl ));
                clip((node_332) - 0.5);
                half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

                half node_4770_if_leA = step(node_332,(_DissolveRange));
                half node_4770_if_leB = step((_DissolveRange),node_332);
                half3 emissive = (_DissolveColor.rgb*lerp((node_4770_if_leA)+(node_4770_if_leB*0.0), 1, node_4770_if_leA*node_4770_if_leB));
                emissive += (pow(pow(1.0-max(0,dot(i.worldNormal, viewDirection)), (_Fresnel_Range)),10.0) * (_Fresnel_Itensity * 20.0) * _Fresnel_Color.rgb);
                half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                half3 finalColor = emissive + (_MainTex_var.rgb*_MainColor.rgb*i.vertexColor.rgb*(_MainTex_var.a*_MainColor.a*i.vertexColor.a));
                fixed4 finalRGBA = fixed4(finalColor, _MainTex_var.a*_MainColor.a*i.vertexColor.a);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
