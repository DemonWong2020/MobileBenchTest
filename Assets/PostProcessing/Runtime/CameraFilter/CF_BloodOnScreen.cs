// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_BloodOnScreen.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_AAA_BloodOnScreen
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_BloodOnScreen : CameraFilterBase
    {
        private readonly static int TexParamHash = Shader.PropertyToID("_MainTex2");

        private Texture2D Texture;

        [Range(0.02f, 1.6f)]
        public float Blood_On_Screen = 1f;

        public Color Blood_Color = Color.red;
        [Range(0, 2f)]
        public float Blood_Intensify = 0.7f;
        [Range(0f, 2f)]
        public float Blood_Darkness = 0.5f;
        [Range(0f, 1f)]
        public float Blood_Distortion_Speed = 0.25f;
        [Range(0, 1f)]
        public float Blood_Fade = 1f;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_BloodOnScreen";
            }
        }

        protected override void Internal_Init()
        {
            Texture = Resources.Load("CameraFilterPack_AAA_BloodOnScreen1") as Texture2D;

            Mat = Context.materialFactory.Get(ShaderName);
            Mat.SetTexture(TexParamHash, Texture);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            //Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", Mathf.Clamp(Blood_On_Screen, 0.02f, 1.6f));
            Mat.SetFloat("_Value2", Mathf.Clamp(Blood_Intensify, 0, 2f));
            Mat.SetFloat("_Value3", Mathf.Clamp(Blood_Darkness, 0, 2f));
            Mat.SetFloat("_Value4", Mathf.Clamp(Blood_Fade, 0, 1f));
            Mat.SetFloat("_Value5", Mathf.Clamp(Blood_Distortion_Speed, 0, 2f));
            Mat.SetColor("_Color2", Blood_Color);

            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Blood_On_Screen", ref Blood_On_Screen, 0.02f, 1.6f);
            ColorFiled("Blood_Color", ref Blood_Color);
            Slider("Blood_Intensify", ref Blood_Intensify, 0f, 2f);
            Slider("Blood_Darkness", ref Blood_Darkness, 0f, 2f);
            Slider("Blood_Distortion_Speed", ref Blood_Distortion_Speed, 0f, 1f);
            Slider("Blood_Fade", ref Blood_Fade, 0f, 1f);
            GUILayout.EndVertical();
        }
#endif
    }
}
