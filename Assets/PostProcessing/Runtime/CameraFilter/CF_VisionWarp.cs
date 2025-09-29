// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_VisionWarp.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Vision_Warp2
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_VisionWarp : CameraFilterBase
    {
        public bool IsLoop = true;

        public float OnceStartVal = 0;
        [Range(0f, 1f)]
        public float Value = 0.5f;
        [Range(0f, 1f)]
        public float Value2 = 0.2f;
        [Range(-1f, 2f)]
        public float Intensity = 1f;
        [Range(0f, 10f)]
        private float Value4 = 1f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_VisionWarp";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
           
            if(!IsLoop)
            {
                mTimeX = mTimeX >= 2f ? 2f : mTimeX;
                Value = Mathf.Lerp(OnceStartVal, 1, mTimeX / 2f);
            }

            Mat.SetFloat("_TimeX", mTimeX + 0.6f);
            Mat.SetFloat("_Value", Value);
            Mat.SetFloat("_Value2", Value2);
            Mat.SetFloat("_Value3", Intensity);
            Mat.SetFloat("_Value4", Value4);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));

            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            ToggleLeft("IsLoop", ref IsLoop);
            if (!IsLoop)
            {
                Slider("OnceStartVal", ref OnceStartVal, 0f, 1f);
            }

            Slider("Value", ref Value, 0f, 1f);
            Slider("Value2", ref Value2, 0f, 1f);
            Slider("Intensity", ref Intensity, -1f, 2f);
            Slider("Value4", ref Value4, 0f, 10f);
            GUILayout.EndVertical();
        }
#endif
    }
}
