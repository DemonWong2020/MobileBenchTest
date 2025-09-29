// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_FXDrunk.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_FX_Drunk
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_FXDrunk : CameraFilterBase
    {
        [Range(0, 20)]
        public float Value = 6.0f;
        [Range(0, 10)]
        public float Speed = 1.0f;
        [Range(0, 1)]
        public float Wavy = 1f;
        [Range(0, 1)]
        public float Distortion = 0f;
        [Range(0, 1)]
        public float DistortionWave = 0f;
        [Range(0, 1)]
        public float Fade = 1.0f;
        [Range(-2, 2)]
        public float ColoredSaturate = 1.0f;
        [Range(-1, 2)]
        public float ColoredChange = 0.0f;
        [Range(-1, 1)]
        public float ChangeRed = 0.0f;
        [Range(-1, 1)]
        public float ChangeGreen = 0.0f;
        [Range(-1, 1)]
        public float ChangeBlue = 0.0f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_FXDrunk";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", Value);
            Mat.SetFloat("_Speed", Speed);
            Mat.SetFloat("_Distortion", Distortion);
            Mat.SetFloat("_DistortionWave", DistortionWave);
            Mat.SetFloat("_Wavy", Wavy);
            Mat.SetFloat("_Fade", Fade);

            Mat.SetFloat("_ColoredChange", ColoredChange);
            Mat.SetFloat("_ChangeRed", ChangeRed);
            Mat.SetFloat("_ChangeGreen", ChangeGreen);
            Mat.SetFloat("_ChangeBlue", ChangeBlue);

            Mat.SetFloat("_Colored", ColoredSaturate);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Value", ref Value, 0, 20);
            Slider("Speed", ref Speed, 0, 10);
            Slider("Wavy", ref Wavy, 0, 1);
            Slider("Distortion", ref Distortion, 0, 1);
            Slider("DistortionWave", ref DistortionWave, 0, 1);
            Slider("Fade", ref Fade, 0, 1);
            Slider("ColoredSaturate", ref ColoredSaturate, -2, 2);
            Slider("ColoredChange", ref ColoredChange, -1, 2);
            Slider("ChangeRed", ref ChangeRed, -1, 1);
            Slider("ChangeGreen", ref ChangeGreen, -1, 1);
            Slider("ChangeBlue", ref ChangeBlue, -1, 1);
            GUILayout.EndVertical();
        }
#endif
    }
}
