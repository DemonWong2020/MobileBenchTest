// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_DistortionAspiration.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Distortion_Aspiration
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_DistortionAspiration : CameraFilterBase
    {
        [Range(0f, 1f)]
        public float Value = 0.8f;
        [Range(-1f, 1f)]
        public float PosX = 0.5f;
        [Range(-1f, 1f)]
        public float PosY = 0.5f;
        [Range(0f, 10f)]
        private float Value4 = 1f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_DistortionAspiration";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", 1 - Value);
            Mat.SetFloat("_Value2", PosX);
            Mat.SetFloat("_Value3", PosY);
            Mat.SetFloat("_Value4", Value4);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));

            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Value", ref Value, 0f, 1f);
            Slider("PosX", ref PosX, -1f, 1f);
            Slider("PosY", ref PosY, -1f, 1f);
            Slider("Value4", ref Value4, 0f, 10f);
            GUILayout.EndVertical();
        }
#endif
    }
}
