// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32903,y:32690,varname:node_4013,prsc:2|diff-9566-OUT,emission-3011-OUT,alpha-827-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32138,y:32280,ptovrint:False,ptlb:Main_Color,ptin:_Main_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Fresnel,id:1249,x:32210,y:32803,varname:node_1249,prsc:2|EXP-9561-OUT;n:type:ShaderForge.SFN_Slider,id:4495,x:31476,y:32814,ptovrint:False,ptlb:Fresnel_Range,ptin:_Fresnel_Range,varname:node_4495,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:9561,x:31823,y:32814,varname:node_9561,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-4495-OUT;n:type:ShaderForge.SFN_Power,id:9686,x:32385,y:32803,varname:node_9686,prsc:2|VAL-1249-OUT,EXP-8953-OUT;n:type:ShaderForge.SFN_Vector1,id:8953,x:32210,y:32936,varname:node_8953,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:3011,x:32559,y:32814,varname:node_3011,prsc:2|A-9686-OUT,B-5042-OUT,C-3370-RGB;n:type:ShaderForge.SFN_Slider,id:8508,x:31942,y:33018,ptovrint:False,ptlb:Fresnel_Itensity,ptin:_Fresnel_Itensity,varname:node_8508,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Color,id:3370,x:32295,y:33191,ptovrint:False,ptlb:Fresnel_Color,ptin:_Fresnel_Color,varname:node_3370,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2879,x:32138,y:32441,ptovrint:False,ptlb:Main_Texture,ptin:_Main_Texture,varname:node_2879,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9566,x:32387,y:32368,varname:node_9566,prsc:2|A-1304-RGB,B-2879-RGB;n:type:ShaderForge.SFN_RemapRange,id:5042,x:32315,y:32995,varname:node_5042,prsc:2,frmn:0,frmx:1,tomn:0,tomx:20|IN-8508-OUT;n:type:ShaderForge.SFN_Multiply,id:827,x:32615,y:32680,varname:node_827,prsc:2|A-1304-A,B-2879-A,C-3370-A;proporder:2879-1304-3370-8508-4495;pass:END;sub:END;*/

Shader "Teon2/Effects/Alpha_Blend_Rim" 
{
    Properties 
    {
        _Main_Texture ("Main_Texture", 2D) = "white" {}
        [HDR]_Main_Color ("Main_Color", Color) = (1,1,1,1)
        [HDR]_Fresnel_Color ("Fresnel_Color", Color) = (1,1,1,1)
        _Fresnel_Itensity ("Fresnel_Itensity", Range(0, 1)) = 0
        _Fresnel_Range ("Fresnel_Range", Range(0, 1)) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader 
    {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass 
        {
            //Name "FORWARD"
            //Tags {
            //    "LightMode"="ForwardBase"
            //}
            Offset -1, -1
            Cull Off
            ZWrite Off
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#define UNITY_PASS_FORWARDBASE
            #include "../../Include/CGDefine.cginc"
            //#pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            //uniform half4 _LightColor0;
            uniform float4 _Main_Color;
            uniform float _Fresnel_Range;
            uniform float _Fresnel_Itensity;
            uniform float4 _Fresnel_Color;
            uniform sampler2D _Main_Texture; uniform float4 _Main_Texture_ST;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = TRANSFORM_TEX(v.texcoord0, _Main_Texture);
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                //float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            float4 frag(VertexOutput i, float facing : VFACE) : COLOR //
            {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 normal = normalize(i.normalDir * faceSign);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                //half3 lightColor = _LightColor0.rgb;
////// Lighting:
                //half attenuation = 1;
                //half3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normal, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * _LightColor0;
                float3 indirectDiffuse = UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _Main_Texture_var = tex2D(_Main_Texture, i.uv0) * _Main_Color;
                //float3 diffuseColor = (_Main_Color.rgb*_Main_Texture_var.rgb);
                float3 diffuse = (directDiffuse + indirectDiffuse) * _Main_Texture_var;
////// Emissive:
                float3 emissive = (pow(pow(1.0-max(0,dot(normal, viewDirection)), (_Fresnel_Range)),10.0) * (_Fresnel_Itensity * 20.0) * _Fresnel_Color.rgb);
/// Final Color:
                float3 finalColor = diffuse + emissive;
                fixed4 finalRGBA = fixed4(finalColor,(_Main_Color.a*_Main_Texture_var.a*_Fresnel_Color.a));
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}