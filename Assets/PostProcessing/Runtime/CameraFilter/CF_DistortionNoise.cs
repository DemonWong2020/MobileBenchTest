// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_DistortionNoise.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Distortion_Noise
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_DistortionNoise : CameraFilterBase
    {
        [Range(0, 3)]
        public float Distortion = 1.0f;

        public override string ShaderName
        {
            get 
            { 
                return "Hidden/CF_DistortionNoise"; 
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Distortion", Distortion);
            Mat.SetVector("_ScreenResolution", new Vector2(Context.width, Context.height));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Distortion", ref Distortion, 0, 3);
            GUILayout.EndVertical();
        }
#endif
    }
}