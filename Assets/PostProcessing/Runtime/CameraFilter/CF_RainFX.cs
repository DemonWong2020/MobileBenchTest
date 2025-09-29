// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CFRainFX.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-18
// Purpose:      CameraFilterPack_Rain_RainFX
// **********************************************************************
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CF_RainFX : CameraFilterBase
    {
        private readonly static int TexParamHash = Shader.PropertyToID("_MainTex2");
        private readonly static int Tex2ParamHash = Shader.PropertyToID("_MainTex3");

        [Range(-8f, 8f)]
        public float Speed = 1f;
        [Range(0f, 1f)]
        public float Fade = 1f;

        [HideInInspector]
        public int Count = 0;
        private Vector4[] Coord = new Vector4[4];
        public static Color ChangeColorRGB;
        private Texture2D Texture;
        private Texture2D Texture2;

        private AnimationCurve mCurve;

        public override string ShaderName
        {
            get
            {
                return "Hidden/CF_RainFX";
            }
        }

        protected override void Internal_Init()
        {
            Mat = Context.materialFactory.Get(ShaderName);

            Texture = Resources.Load("CameraFilterPack_RainFX_Anm2") as Texture2D;
            Mat.SetTexture(TexParamHash, Texture);

            Texture2 = Resources.Load("CameraFilterPack_RainFX_Anm") as Texture2D;
            Mat.SetTexture(Tex2ParamHash, Texture2);

            mCurve = new AnimationCurve();
            mCurve.AddKey(0, 0.01f);
            mCurve.AddKey(64, 5f);
            mCurve.AddKey(128, 80f);
            mCurve.AddKey(255, 255f);
            mCurve.AddKey(300, 255f);
        }

        protected override void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            Mat.SetFloat("_TimeX", mTimeX);
            Mat.SetFloat("_Value", Fade);
            Mat.SetFloat("_Speed", Speed);
            Mat.SetVector("_ScreenResolution", new Vector4(Context.width, Context.height, 0.0f, 0.0f));

            for (int c = 0; c < 4; c++)
            {
                Coord[c].z += 0.5f;
                if (Coord[c].w == -1)
                {
                    Coord[c].x = -5.0f;
                }

                if (Coord[c].z > 254)
                {
                    Coord[c] = new Vector4(Random.Range(0f, 0.9f), Random.Range(0.2f, 1.1f), 0, Random.Range(0, 3));
                }

                Mat.SetVector("Coord" + (c + 1).ToString(), new Vector4(Coord[c].x, Coord[c].y, (int)mCurve.Evaluate(Coord[c].z), Coord[c].w));
            }
            Mat.SetTexture(TexParamHash, Texture);
            Mat.SetTexture(Tex2ParamHash, Texture2);

            cb.Blit(srcTexture, dstTexture, Mat);
        }

#if UNITY_EDITOR
        protected override void Internal_DrawGUI()
        {
            GUILayout.BeginVertical();
            Slider("Speed", ref Speed, -8f, 8f);
            Slider("Fade", ref Fade, 0f, 1f);
            GUILayout.EndVertical();
        }
#endif
    }
}
