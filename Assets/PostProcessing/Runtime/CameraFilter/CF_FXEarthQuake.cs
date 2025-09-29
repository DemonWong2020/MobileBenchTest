// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_FXEarthQuake.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_FX_EarthQuake
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_FXEarthQuake : CameraFilterBase
    {
        [Range(0f, 100f)]
        public float Speed = 15f;
        [Range(0f, 0.2f)]
        public float X = 0.008f;
        [Range(0f, 0.2f)]
        public float Y = 0.008f;
        [Range(0f, 0.2f)]
        private float Value4 = 1f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_FXEarthQuake";
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
            Mat.SetFloat("_Value2", X);
            Mat.SetFloat("_Value3", Y);
            Mat.SetFloat("_Value4", Value4);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Speed", ref Speed, 0f, 100f);
            Slider("X", ref X, 0f, 0.2f);
            Slider("Y", ref Y, 0f, 0.2f);
            Slider("Value4", ref Value4, 0f, 0.2f);
            GUILayout.EndVertical();
        }
#endif
    }
}
