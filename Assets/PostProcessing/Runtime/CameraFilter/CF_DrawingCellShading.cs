// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_DrawingCellShading.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Drawing_CellShading
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_DrawingCellShading : CameraFilterBase
    {
        [Range(0, 1)]
        public float EdgeSize = 0.1f;
        [Range(0, 10)]
        public float ColorLevel = 4f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_DrawingCellShading";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_EdgeSize", EdgeSize);
            Mat.SetFloat("_ColorLevel", ColorLevel);
            Mat.SetVector("_ScreenResolution", new Vector2(Screen.width, Screen.height));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("EdgeSize", ref EdgeSize, 0, 1);
            Slider("ColorLevel", ref ColorLevel, 0, 10);
            GUILayout.EndVertical();
        }
#endif
    }
}
