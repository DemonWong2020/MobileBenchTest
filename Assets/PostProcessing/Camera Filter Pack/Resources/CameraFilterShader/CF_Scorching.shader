Shader "Hidden/CF_Scorching" 
{
    Properties 
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Value ("_Value", Range(0.0, 20.0)) = 6.0
    }
    SubShader 
    {
        Pass
        {
            Cull Off ZWrite Off ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
            #include "CameraFilter.cginc"

            float _WaveSpeed;
            float _WaveStrength;
            float _Distortion;
            float _DistortionWave;
            float _Fade;
            float _ColorSaturate;

            float4 frag(v2f i) : SV_Target
            {
                float2 uvst = i.texcoord;
                float t = _TimeX * _WaveSpeed;
                float drunk = sin(t * 2.0);
                float unitDrunk1 = (sin(t * 1.2) + 1.0) / 2.0;
                float unitDrunk2 = (sin(t * 1.8) + 1.0) / 2.0;

                float2 normalizedCoord = fmod((uvst + (float2(0, drunk) / _ScreenResolution.x)), 1.0);
                normalizedCoord.x = pow(normalizedCoord.x, lerp(1.25, 0.85, unitDrunk1));
                normalizedCoord.y = pow(normalizedCoord.y, lerp(0.85, 1.25, unitDrunk2));

                float2 normalizedCoord2 = fmod((uvst + (float2(drunk, 0) / _ScreenResolution.x)), 1.0);	
                normalizedCoord2.x = pow(normalizedCoord2.x, lerp(0.95, 1.1, unitDrunk2));
                normalizedCoord2.y = pow(normalizedCoord2.y, lerp(1.1, 0.95, unitDrunk1));

                normalizedCoord = lerp(uvst, normalizedCoord, _WaveStrength);
                normalizedCoord2 = lerp(uvst, normalizedCoord2, _WaveStrength);
                float4 color = tex2D(_MainTex, normalizedCoord);	
                _Distortion *= _Fade;
                _DistortionWave *= _Fade;
                float dist = (color.x * 0.5 * normalizedCoord.x) * _Distortion;
                float4 color2 = tex2D(_MainTex, normalizedCoord2 + float2(dist, dist));
                dist += (color.x * color2.y * 0.5 * normalizedCoord2.x) * _Distortion;

                float y =
                0.7 * sin((uvst.y + _TimeX) * 4.0) * 0.038 +
                0.3 * sin((uvst.y + _TimeX) * 8.0) * 0.010 +
                0.05 * sin((uvst.y + _TimeX) * 40.0) * 0.05;

                float x =
                0.5 * sin((uvst.y + _TimeX) * 5.0) * 0.1 +
                0.2 * sin((uvst.x + _TimeX) * 10.0) * 0.05 +
                0.2 * sin((uvst.x + _TimeX) * 30.0) * 0.02;

                float4 color3 = tex2D(_MainTex, uvst);
                uvst.x += _DistortionWave * x;
                uvst.y += _DistortionWave * y;
                float4 MemoColor = tex2D(_MainTex, uvst + dist);
                float4 finalColor = lerp(lerp(color, color2, lerp(_ColorSaturate - 0.2, _ColorSaturate + 0.2, unitDrunk1)), color3, 0.6);
                finalColor = lerp(MemoColor, finalColor, _Fade);
                return finalColor;
            }

            ENDCG
        }
    }
}