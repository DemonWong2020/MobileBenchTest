// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_VHSTracking.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_VHS_Tracking
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_VHSTracking : CameraFilterBase
    {
        [Range(0f, 2f)]
        public float Tracking = 1f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_VHSTracking";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", Tracking);

            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Tracking", ref Tracking, 0f, 2f);
            GUILayout.EndVertical();
        }
#endif
    }
}
