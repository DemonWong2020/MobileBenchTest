Shader "Teon2/Scenes/Transparent/Glass Reflective with LightColor" 
{
    Properties 
    {
        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
        _Shininess ("Shininess", Range (0.01, 1)) = 0.078125
        _ReflectColor ("Reflection Color", Color) = (1, 1, 1, 0.5)
        _Cube ("Reflection Cubemap", Cube) = "white" {}
        [Header(Clip Parameter)]
        _Clip("Clip", Range(0, 1)) = 0.5
    }
    SubShader 
    {
        Tags 
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
        }
        
        CGPROGRAM
            #pragma surface surf BlinnPhong decal:add nolightmap
            #include "../../Include/CGDefine.cginc"
            #include "../../Include/LightMode.cginc"

            samplerCUBE _Cube;
            fixed4 _ReflectColor;
            half _Shininess;

            struct Input {
                float3 worldRefl;
                float3 worldNormal;
                float3 viewDir;
            };

            void surf (Input IN, inout SurfaceOutput o) {
                o.Albedo = 0;
                o.Gloss = 1;
                o.Specular = _Shininess;
                
                half3 _LightDir = normalize(_WorldSpaceLightPos0);
                half3 _HalfView = normalize(IN.viewDir + _LightDir);
                half _NDotH = max(dot(IN.worldNormal, _HalfView), 0.0001);
                fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
                o.Emission = reflcol * (_LightColor0);
                o.Alpha = reflcol.a * _ReflectColor.a;
            }
        ENDCG
    }
    FallBack "Transparent/VertexLit"
}