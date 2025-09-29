// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_LightWave.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Light_Water2
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_LightWave : CameraFilterBase
    {
        [Range(0f, 10f)]
        public float Speed = 0.2f;
        [Range(0f, 10f)]
        public float Speed_X = 0.2f;
        [Range(0f, 1f)]
        public float Speed_Y = 0.3f;
        [Range(0f, 10f)]
        public float Intensity = 2.4f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_LightWater";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", Speed);
            Mat.SetFloat("_Value2", Speed_X);
            Mat.SetFloat("_Value3", Speed_Y);
            Mat.SetFloat("_Value4", Intensity);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Speed", ref Speed, 0f, 10f);
            Slider("Speed_X", ref Speed_X, 0f, 10f);
            Slider("Speed_Y", ref Speed_Y, 0f, 1f);
            Slider("Intensity", ref Intensity, 0f, 10f);
            GUILayout.EndVertical();
        }
#endif
    }
}
