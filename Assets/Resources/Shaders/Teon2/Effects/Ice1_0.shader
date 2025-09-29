// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// 注意：手动更改此数据可能会妨碍您在 Shader Forge 中打开它
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0.5220588,fgcg:0.5220588,fgcb:0.5220588,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:33385,y:32873,varname:node_4795,prsc:2|normal-8052-OUT,emission-8552-OUT,clip-1961-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32235,y:32601,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-4834-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32850,y:32854,varname:node_2393,prsc:2|A-2717-OUT,B-2053-RGB,C-797-RGB,D-330-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32235,y:32772,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32235,y:32930,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_TexCoord,id:6080,x:30857,y:32583,varname:node_6080,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:6113,x:30857,y:32394,varname:node_6113,prsc:2;n:type:ShaderForge.SFN_Time,id:4880,x:30827,y:32847,varname:node_4880,prsc:2;n:type:ShaderForge.SFN_Add,id:1082,x:31067,y:32498,varname:node_1082,prsc:2|A-309-OUT,B-6080-U;n:type:ShaderForge.SFN_Append,id:2708,x:31327,y:32603,varname:node_2708,prsc:2|A-1082-OUT,B-356-OUT;n:type:ShaderForge.SFN_Add,id:356,x:31083,y:32708,varname:node_356,prsc:2|A-6080-V,B-7424-OUT;n:type:ShaderForge.SFN_Multiply,id:309,x:31033,y:32247,varname:node_309,prsc:2|A-4892-OUT,B-6113-T;n:type:ShaderForge.SFN_ValueProperty,id:4892,x:30829,y:32247,ptovrint:False,ptlb:MU_Speed,ptin:_MU_Speed,varname:_U_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:7424,x:31026,y:33009,varname:node_7424,prsc:2|A-4880-T,B-2029-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2029,x:30827,y:33069,ptovrint:False,ptlb:MV_Speed,ptin:_MV_Speed,varname:_V_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:6703,x:31240,y:32913,varname:node_6703,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_SwitchProperty,id:8616,x:31764,y:32595,ptovrint:False,ptlb:One_UV,ptin:_One_UV,varname:node_6357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-2708-OUT,B-1496-OUT;n:type:ShaderForge.SFN_Add,id:1496,x:31616,y:32785,varname:node_1496,prsc:2|A-1787-OUT,B-2708-OUT;n:type:ShaderForge.SFN_Append,id:1787,x:31453,y:32934,varname:node_1787,prsc:2|A-6703-U,B-6703-V;n:type:ShaderForge.SFN_Tex2d,id:1724,x:31676,y:32074,ptovrint:False,ptlb:Disturb_Tex,ptin:_Disturb_Tex,varname:node_1724,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-3635-OUT;n:type:ShaderForge.SFN_TexCoord,id:3589,x:30841,y:32059,varname:node_3589,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Tex2d,id:7986,x:32235,y:32346,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_7986,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2717,x:32452,y:32465,varname:node_2717,prsc:2|A-7986-RGB,B-6074-RGB,C-6074-A,D-2053-A,E-797-A;n:type:ShaderForge.SFN_Time,id:6971,x:30841,y:31769,varname:node_6971,prsc:2;n:type:ShaderForge.SFN_Add,id:9674,x:31259,y:32006,varname:node_9674,prsc:2|A-4285-OUT,B-3589-U;n:type:ShaderForge.SFN_Add,id:314,x:31269,y:32163,varname:node_314,prsc:2|A-2822-OUT,B-3589-V;n:type:ShaderForge.SFN_Append,id:3635,x:31457,y:32074,varname:node_3635,prsc:2|A-9674-OUT,B-314-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2963,x:30841,y:31688,ptovrint:False,ptlb:DU_Speed,ptin:_DU_Speed,varname:node_2963,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:2539,x:30841,y:31966,ptovrint:False,ptlb:DV_Speed,ptin:_DV_Speed,varname:_U_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:2822,x:31024,y:31932,varname:node_2822,prsc:2|A-6971-T,B-2539-OUT;n:type:ShaderForge.SFN_Multiply,id:4285,x:31024,y:31734,varname:node_4285,prsc:2|A-2963-OUT,B-6971-T;n:type:ShaderForge.SFN_Add,id:4834,x:32051,y:32554,varname:node_4834,prsc:2|A-9118-OUT,B-8616-OUT;n:type:ShaderForge.SFN_Multiply,id:9118,x:31890,y:32108,varname:node_9118,prsc:2|A-7812-OUT,B-1724-R;n:type:ShaderForge.SFN_Slider,id:7812,x:31485,y:31931,ptovrint:False,ptlb:Disturb_Itensity,ptin:_Disturb_Itensity,varname:node_7812,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Fresnel,id:4658,x:31866,y:33233,varname:node_4658,prsc:2|EXP-6775-OUT;n:type:ShaderForge.SFN_RemapRange,id:3695,x:31918,y:33458,varname:node_3695,prsc:2,frmn:0,frmx:1,tomn:0,tomx:20|IN-7990-OUT;n:type:ShaderForge.SFN_Power,id:9226,x:32127,y:33228,varname:node_9226,prsc:2|VAL-4658-OUT,EXP-9794-OUT;n:type:ShaderForge.SFN_Slider,id:7990,x:31379,y:33468,ptovrint:False,ptlb:Fre_Itensity,ptin:_Fre_Itensity,varname:node_7990,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:9794,x:31937,y:33364,varname:node_9794,prsc:2,v1:10;n:type:ShaderForge.SFN_Color,id:5026,x:32154,y:33440,ptovrint:False,ptlb:Fre_Color,ptin:_Fre_Color,varname:node_5026,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_RemapRange,id:6775,x:31625,y:33233,varname:node_6775,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-7236-OUT;n:type:ShaderForge.SFN_Slider,id:7236,x:31209,y:33253,ptovrint:False,ptlb:Fre_Range,ptin:_Fre_Range,varname:node_7236,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Desaturate,id:3078,x:32566,y:32578,varname:node_3078,prsc:2|COL-6074-RGB,DES-7076-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7076,x:32399,y:32705,ptovrint:False,ptlb:Des_Intenity,ptin:_Des_Intenity,varname:node_7076,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Color,id:7340,x:32534,y:32733,ptovrint:False,ptlb:Des_Color,ptin:_Des_Color,varname:node_7340,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:330,x:32824,y:32617,varname:node_330,prsc:2|A-3078-OUT,B-7340-RGB;n:type:ShaderForge.SFN_Lerp,id:8052,x:34004,y:33647,varname:node_8052,prsc:2|A-1727-RGB,B-5741-OUT,T-846-OUT;n:type:ShaderForge.SFN_Tex2d,id:1727,x:33460,y:33559,ptovrint:False,ptlb:Nor_Tex,ptin:_Nor_Tex,varname:node_1727,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:False;n:type:ShaderForge.SFN_RemapRange,id:846,x:33766,y:33712,varname:node_846,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-4862-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4862,x:33449,y:33778,ptovrint:False,ptlb:Nor_Intenity,ptin:_Nor_Intenity,varname:node_4862,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_If,id:7099,x:32943,y:33902,varname:node_7099,prsc:2|A-1961-OUT,B-5509-OUT,GT-6634-OUT,EQ-2821-OUT,LT-2821-OUT;n:type:ShaderForge.SFN_Vector1,id:6634,x:32649,y:34001,varname:node_6634,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:2821,x:32649,y:34080,varname:node_2821,prsc:2,v1:1;n:type:ShaderForge.SFN_RemapRange,id:5509,x:32388,y:34135,varname:node_5509,prsc:2,frmn:0,frmx:1,tomn:0.5,tomx:1|IN-206-OUT;n:type:ShaderForge.SFN_Slider,id:206,x:31998,y:34201,ptovrint:False,ptlb:Diss_Range,ptin:_Diss_Range,varname:node_206,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Divide,id:1961,x:32323,y:33772,varname:node_1961,prsc:2|A-579-OUT,B-9593-OUT;n:type:ShaderForge.SFN_Tex2d,id:5580,x:31928,y:33709,ptovrint:False,ptlb:Diss_Tex,ptin:_Diss_Tex,varname:node_5580,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_SwitchProperty,id:9593,x:32014,y:34023,ptovrint:False,ptlb:Par_Contronl,ptin:_Par_Contronl,varname:node_9593,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-78-OUT,B-9323-U;n:type:ShaderForge.SFN_Slider,id:78,x:31563,y:34018,ptovrint:False,ptlb:Diss_Intenity,ptin:_Diss_Intenity,varname:node_78,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_TexCoord,id:9323,x:31619,y:34137,varname:node_9323,prsc:2,uv:1,uaff:True;n:type:ShaderForge.SFN_Multiply,id:16,x:33120,y:33742,varname:node_16,prsc:2|A-8808-RGB,B-7099-OUT;n:type:ShaderForge.SFN_Color,id:8808,x:32909,y:33676,ptovrint:False,ptlb:Diss_Color,ptin:_Diss_Color,varname:node_8808,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:579,x:32134,y:33745,varname:node_579,prsc:2|A-5580-R,B-5580-A;n:type:ShaderForge.SFN_Vector3,id:5741,x:33724,y:33880,varname:node_5741,prsc:2,v1:0,v2:0,v3:1;n:type:ShaderForge.SFN_Add,id:8552,x:33074,y:32929,varname:node_8552,prsc:2|A-2393-OUT,B-16-OUT,C-9394-OUT;n:type:ShaderForge.SFN_Multiply,id:9394,x:32323,y:33254,varname:node_9394,prsc:2|A-9226-OUT,B-3695-OUT,C-5026-RGB;proporder:6074-797-4892-2029-7340-7076-8616-1727-4862-5026-7990-7236-1724-2963-2539-7812-5580-8808-78-206-9593-7986;pass:END;sub:END;*/

Shader "Teon2/Effects/Ice1.0" 
{
    Properties 
    {
        _MainTex ("MainTex", 2D) = "black" {}
        [HDR]_TintColor ("Color", Color) = (1,1,1,1)
        _MU_Speed ("MU_Speed", Float ) = 0
        _MV_Speed ("MV_Speed", Float ) = 0
        [HDR]_Des_Color ("Des_Color", Color) = (1,1,1,1)
        _Des_Intenity ("Des_Intenity", Float ) = 0
        _Nor_Tex ("Nor_Tex", 2D) = "bump" {}
        _Nor_Intenity ("Nor_Intenity", Float ) = 1
        [HDR]_Fre_Color ("Fre_Color", Color) = (1,1,1,1)
        _Fre_Itensity ("Fre_Itensity", Range(0, 1)) = 0
        _Fre_Range ("Fre_Range", Range(0, 1)) = 0
        _Disturb_Tex ("Disturb_Tex", 2D) = "white" {}
        _DU_Speed ("DU_Speed", Float ) = 0
        _DV_Speed ("DV_Speed", Float ) = 0
        _Disturb_Itensity ("Disturb_Itensity", Range(0, 1)) = 0
        _Diss_Tex ("Diss_Tex", 2D) = "white" {}
        [HDR]_Diss_Color ("Diss_Color", Color) = (1,1,1,1)
        _Diss_Intenity ("Diss_Intenity", Range(0, 2)) = 0
        _Diss_Range ("Diss_Range", Range(0, 1)) = 0
        [MaterialToggle] _Par_Contronl ("Par_Contronl", Float ) = 0
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader 
    {
        Tags 
        {
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
            Blend SrcAlpha One
            Cull Off

            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                //#pragma multi_compile_fog
                #include "../../Include/CGDefine.cginc"
                uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
                uniform half4 _TintColor;
                uniform half _MU_Speed;
                uniform half _MV_Speed;
                uniform sampler2D _Disturb_Tex; uniform half4 _Disturb_Tex_ST;
                uniform sampler2D _Mask; uniform half4 _Mask_ST;
                uniform half _DU_Speed;
                uniform half _DV_Speed;
                uniform half _Disturb_Itensity;
                uniform half _Fre_Itensity;
                uniform half4 _Fre_Color;
                uniform half _Fre_Range;
                uniform half _Des_Intenity;
                uniform half4 _Des_Color;
                uniform sampler2D _Nor_Tex; uniform half4 _Nor_Tex_ST;
                uniform half _Nor_Intenity;
                uniform half _Diss_Range;
                uniform sampler2D _Diss_Tex; uniform half4 _Diss_Tex_ST;
                uniform fixed _Par_Contronl;
                uniform half _Diss_Intenity;
                uniform half4 _Diss_Color;

                struct VertexInput 
                {
                    float4 vertex : POSITION;
                    half3 normal : NORMAL;
                    half4 color : COLOR;
                    half4 tangent : TANGENT;
                    half2 texcoord0 : TEXCOORD0;
                    half4 texcoord1 : TEXCOORD1;
                };

                struct VertexOutput 
                {
                    float4 pos : SV_POSITION;
                    half4 color : COLOR;
                    half2 uv0 : TEXCOORD0;
                    half4 uv1 : TEXCOORD1;
                    half4 posWorld : TEXCOORD2;
                    half3 normalDir : TEXCOORD3;
                    half3 tangentDir : TEXCOORD4;
                    half3 bitangentDir : TEXCOORD5;
                    UNITY_FOG_COORDS(6)
                };

                VertexOutput vert (VertexInput v) 
                {
                    VertexOutput o = (VertexOutput)0;
                    o.color = v.color;
                    o.uv0 = v.texcoord0;
                    o.uv1 = v.texcoord1;
                    o.normalDir = UnityObjectToWorldNormal(v.normal);
                    o.tangentDir = normalize(mul(unity_ObjectToWorld, half4(v.tangent.xyz, 0.0)).xyz);
                    o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                    o.pos = UnityObjectToClipPos( v.vertex );
                    UNITY_TRANSFER_FOG(o, o.pos);
                    return o;
                }

                half4 frag(VertexOutput i, half facing : VFACE) : COLOR 
                {
                    half4 _Diss_Tex_var = tex2D(_Diss_Tex, TRANSFORM_TEX(i.uv0, _Diss_Tex));
                    half node_1961 = ((_Diss_Tex_var.r * _Diss_Tex_var.a) / lerp( _Diss_Intenity, i.uv1.r, _Par_Contronl));
                    clip(node_1961 - 0.5);

                    half isFrontFace = (facing >= 0 ? 1 : 0);
                    half faceSign = (facing >= 0 ? 1 : -1);
                    //i.normalDir = normalize(i.normalDir);
                    half3 normal = normalize(i.normalDir * faceSign);
                    half3x3 tangentTransform = half3x3(i.tangentDir, i.bitangentDir, normal);
                    half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                    //half4 _Nor_Tex_var = tex2D(_Nor_Tex, TRANSFORM_TEX(i.uv0, _Nor_Tex));
                    half3 normalLocal = UnpackNormalWithScale(tex2D(_Nor_Tex, TRANSFORM_TEX(i.uv0, _Nor_Tex)), _Nor_Intenity);//lerp(_Nor_Tex_var.rgb, half3(0,0,1), (_Nor_Intenity * -1.0 + 1.0));
                    half3 normalDirection = normalize(mul(normalLocal, tangentTransform)); // Perturbed normals
                    
    ////// Lighting:
    ////// Emissive:
                    half4 _Mask_var = tex2D(_Mask, TRANSFORM_TEX(i.uv0, _Mask));
                    half2 node_3635 = half2(((_DU_Speed * TEON_TIME_Y) + i.uv0.r),((TEON_TIME_Y * _DV_Speed) + i.uv0.g));
                    half4 _Disturb_Tex_var = tex2D(_Disturb_Tex, TRANSFORM_TEX(node_3635, _Disturb_Tex));
                    half2 node_2708 = half2(((_MU_Speed * TEON_TIME_Y) + i.uv0.r), (i.uv0.g + (TEON_TIME_Y * _MV_Speed)));
                    half2 node_4834 = ((_Disturb_Itensity * _Disturb_Tex_var.r) + node_2708);
                    half4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(node_4834, _MainTex));
                    fixed dissRange = (_Diss_Range * 0.5 + 0.5);
                    half node_7099_if_leA = step(node_1961, dissRange);
                    half node_7099_if_leB = step(dissRange, node_1961);
                    half3 emissive = (_Mask_var.rgb * _MainTex_var.rgb * _MainTex_var.a * _TintColor.a) * 
                                        _TintColor.rgb * lerp(_MainTex_var.rgb, dot(_MainTex_var.rgb, half3(0.3, 0.59, 0.11)), _Des_Intenity) * _Des_Color.rgb
                                        + (_Diss_Color.rgb * lerp((node_7099_if_leA), 1.0, node_7099_if_leA * node_7099_if_leB))
                                        +(pow10(pow(1.0 - max(0, dot(normalDirection, viewDirection)), (_Fre_Range * -1.0 + 1.0))) * (_Fre_Itensity * 20.0) * _Fre_Color.rgb);
                    half4 finalRGBA = saturate(half4(emissive, i.color.a));
                    UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                    return finalRGBA;
                }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
