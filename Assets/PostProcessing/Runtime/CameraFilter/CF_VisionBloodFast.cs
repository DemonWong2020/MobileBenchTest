// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_VisionBloodFast.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Vision_Blood_Fast
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_VisionBloodFast : CameraFilterBase
    {
        [Range(0.01f, 1f)]
        public float HoleSize = 0.6f;
        [Range(-1f, 1f)]
        public float HoleSmooth = 0.3f;
        [Range(-2f, 2f)]
        public float Color1 = 0.2f;
        [Range(-2f, 2f)]
        public float Color2 = 0.9f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_VisionBlood";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", HoleSize);
            Mat.SetFloat("_Value2", HoleSmooth);
            Mat.SetFloat("_Value3", Color1);
            Mat.SetFloat("_Value4", Color2);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("HoleSize", ref HoleSize, 0.01f, 1f);
            Slider("HoleSmooth", ref HoleSmooth, -1f, 1f);
            Slider("Color1", ref Color1, -2f, 2f);
            Slider("Color2", ref Color2, -2f, 2f);
            GUILayout.EndVertical();
        }
#endif
    }
}
