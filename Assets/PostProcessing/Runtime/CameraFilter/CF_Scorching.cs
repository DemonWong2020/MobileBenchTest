// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_Scorching.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2025-02-05
// Purpose:      炎热效果滤镜
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_Scorching : CameraFilterBase
    {
        [Range(0, 10)]
        public float WaveSpeed = 1.0f;            // 热浪速度
        [Range(0, 1)]
        public float WaveStrength = 0.141f;           // 热浪强度
        [Range(0, 1)]
        public float Distortion = 0.1f;           // 扭曲程度
        [Range(0, 1)]
        public float DistortionWave = 0f;       // 扭曲波动
        [Range(0, 1)]
        public float Fade = 0.121f;                 // 淡化程度
        [Range(-2, 2)]
        public float ColorSaturate = -1.76f;        // 颜色饱和度
        
        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_Scorching";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_WaveSpeed", WaveSpeed);
            Mat.SetFloat("_WaveStrength", WaveStrength);
            Mat.SetFloat("_Distortion", Distortion);
            Mat.SetFloat("_DistortionWave", DistortionWave);
            Mat.SetFloat("_Fade", Fade);

            Mat.SetFloat("_ColorSaturate", ColorSaturate);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

        protected override void UpdateDelayState()
        {
            base.UpdateDelayState();
            Fade = Mathf.Lerp(mDelayFrom, mDelayTo, mDelayTime / DelayShowTime);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Wave Speed", ref WaveSpeed, 0, 10);
            Slider("Wave Strength", ref WaveStrength, 0, 1);
            Slider("Distortion", ref Distortion, 0, 1);
            Slider("Distortion Wave", ref DistortionWave, 0, 1);
            Slider("Fade", ref Fade, 0, 1);
            Slider("Color Saturate", ref ColorSaturate, -2, 2);
            GUILayout.EndVertical();
        }
#endif
    }
}