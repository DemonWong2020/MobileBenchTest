// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_DistortionWaveHorizontal.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Distortion_Wave_Horizontal
// **********************************************************************
using System.Collections;
using UnityEngine;

using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_DistortionWaveHorizontal : CameraFilterBase
    {
        [Range(1, 100)]
        public float WaveIntensity = 32f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_DistortionWaveHorizontal";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_WaveIntensity", WaveIntensity);
            Mat.SetVector("_ScreenResolution", new Vector2(Context.width, Context.height));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("WaveIntensity", ref WaveIntensity, 1, 100);
            GUILayout.EndVertical();
        }
#endif
    }
}
