// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CF_DrawingPaper.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Drawing_Paper3
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_DrawingPaper : CameraFilterBase
    {
        private readonly static int TexParamHash = Shader.PropertyToID("_MainTex2");

        public Color Pencil_Color = new Color(0.0f, 0.0f, 0.0f, 0.0f);
        [Range(0.0001f, 0.0022f)]
        public float Pencil_Size = 0.00125f;
        [Range(0, 2)]
        public float Pencil_Correction = 0.35f;
        [Range(0, 1)]
        public float Intensity = 1.0f;
        [Range(0, 2)]
        public float Speed_Animation = 1f;
        [Range(0, 1)]
        public float Corner_Lose = 1f;
        [Range(0, 1)]
        public float Fade_Paper_to_BackColor = 0f;
        [Range(0, 1)]
        public float Fade_With_Original = 1f;
        public Color Back_Color = new Color(1.0f, 1.0f, 1.0f, 1.0f);
        private Texture2D Texture;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_DrawingPaper";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);
            Texture = Resources.Load("CameraFilterPack_Paper4") as Texture2D;
            Mat.SetTexture(TexParamHash, Texture);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetColor("_PColor", Pencil_Color);
            Mat.SetFloat("_Value1", Pencil_Size);
            Mat.SetFloat("_Value2", Pencil_Correction);
            Mat.SetFloat("_Value3", Intensity);
            Mat.SetFloat("_Value4", Speed_Animation);
            Mat.SetFloat("_Value5", Corner_Lose);
            Mat.SetFloat("_Value6", Fade_Paper_to_BackColor);
            Mat.SetFloat("_Value7", Fade_With_Original);
            Mat.SetColor("_PColor2", Back_Color);

            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            ColorFiled("Pencil_Color", ref Pencil_Color);
            Slider("Pencil_Size", ref Pencil_Size, 0.0001f, 0.0022f);
            Slider("Pencil_Correction", ref Pencil_Correction, 0, 2);
            Slider("Intensity", ref Intensity, 0, 1);
            Slider("Speed_Animation", ref Speed_Animation, 0, 2);
            Slider("Corner_Lose", ref Corner_Lose, 0, 1);
            Slider("Fade_Paper_to_BackColor", ref Fade_Paper_to_BackColor, 0, 1);
            Slider("Fade_With_Original", ref Fade_With_Original, 0, 1);
            ColorFiled("Back_Color", ref Back_Color);
            GUILayout.EndVertical();
        }
#endif
    }
}
