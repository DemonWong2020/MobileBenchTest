// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_BlurFocus.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Blur_Focus
// **********************************************************************
using System.Collections;
using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    public class CF_BlurFocus : CameraFilterBase
    {
        [Range(-1, 1)]
        public float CenterX = 0f;
        [Range(-1, 1)]
        public float CenterY = 0f;
        [Range(0, 10)]
        public float _Size = 5f;
        [Range(0.12f, 64)]
        public float _Eyes = 2f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_BloodOnScree";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_CenterX", CenterX);
            Mat.SetFloat("_CenterY", CenterY);
            float result = Mathf.Round(_Size / 0.2f) * 0.2f;
            Mat.SetFloat("_Size", result);
            Mat.SetFloat("_Circle", _Eyes);
            Mat.SetVector("_ScreenResolution", new Vector2(Context.width, Context.height));
            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("CenterX", ref CenterX, -1f, 1f);
            Slider("CenterY", ref CenterY, -1f, 1f);
            Slider("_Size", ref _Size, 0f, 10f);
            Slider("_Eyes", ref _Eyes, 0.12f, 64);
            GUILayout.EndVertical();
        }
#endif
    }
}
