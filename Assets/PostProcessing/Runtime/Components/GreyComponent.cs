// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     GreyComponent.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-08-02
// Purpose: 
// **********************************************************************
namespace UnityEngine.PostProcessing
{
    public class GreyComponent : PostProcessingComponentRenderTexture<GreyModeModel>
    {
        private float mTimePass;
        private float mGreyBlend = 0;
        private Material mUberMaterial;

        static class Uniforms
        {
            internal const float GREY_DURATION = 0.5f;
            internal const string GREY_KEY_WORD = "GREY_ON";

            internal static readonly int GreyBlend = Shader.PropertyToID("_GreyBlend");
        }

        public override bool active
        {
            get
            {
                return model.enabled
                       && !context.interrupted;
            }
        }

        public override void OnEnable()
        {
            base.OnEnable();

            mTimePass = 0;
            mGreyBlend = 0;
        }

        public override void OnDisable()
        {
            base.OnDisable();

            if(null != mUberMaterial)
            {
                mUberMaterial.DisableKeyword(Uniforms.GREY_KEY_WORD);
                mUberMaterial = null;
            }
        }

        public override void Prepare(Material uberMaterial)
        {
            base.Prepare(uberMaterial);

            mUberMaterial = uberMaterial;

            if (mTimePass < Uniforms.GREY_DURATION)
            {
                mTimePass += Time.deltaTime;

                mGreyBlend = Mathf.Lerp(0, 1, mTimePass / Uniforms.GREY_DURATION);
            }

            uberMaterial.SetFloat(Uniforms.GreyBlend, mGreyBlend);

            uberMaterial.EnableKeyword(Uniforms.GREY_KEY_WORD);
        }
    }
}
