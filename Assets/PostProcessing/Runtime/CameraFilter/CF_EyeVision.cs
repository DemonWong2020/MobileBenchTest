// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_EyeVision.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_EyesVision_1
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_EyeVision : CameraFilterBase
    {
        private readonly static int TexParamHash = Shader.PropertyToID("_MainTex2");

        [Range(1, 32)]
        public float _EyeWave = 15f;
        [Range(0, 10)]
        public float _EyeSpeed = 1f;
        [Range(0, 8)]
        public float _EyeMove = 2.0f;
        [Range(0, 1)]
        public float _EyeBlink = 1.0f;
        private Texture2D Texture;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_EyesVision";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
            Texture = Resources.Load("CameraFilterPack_eyes_vision_1") as Texture2D;
            Mat.SetTexture(TexParamHash, Texture);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", _EyeWave);
            Mat.SetFloat("_Value2", _EyeSpeed);
            Mat.SetFloat("_Value3", _EyeMove);
            Mat.SetFloat("_Value4", _EyeBlink);

            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("_EyeWave", ref _EyeWave, 1, 32);
            Slider("_EyeSpeed", ref _EyeSpeed, 0, 10);
            Slider("_EyeMove", ref _EyeMove, 0, 8);
            Slider("_EyeBlink", ref _EyeBlink, 0, 1);
            GUILayout.EndVertical();
        }
#endif
    }
}
