// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_DistortionDream.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Distortion_Dream2
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_DistortionDream : CameraFilterBase
    {
        [Range(0, 100)]
        public float Distortion = 6.0f;
        [Range(0, 32)]
        public float Speed = 5.0f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_DistortionDream";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Speed", Speed);
            Mat.SetFloat("_Distortion", Distortion);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Distortion", ref Distortion, 0, 100);
            Slider("Speed", ref Speed, 0, 32);
            GUILayout.EndVertical();
        }
#endif
    }
}
