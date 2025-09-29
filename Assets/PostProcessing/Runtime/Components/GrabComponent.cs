using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    public class GrabComponent : PostProcessingComponentCommandBuffer<GrabModel>
    {
        static class Uniforms
        {
            internal static readonly int _GrabTexture = Shader.PropertyToID("_GlobalGrabTexture");
            internal static readonly int _ScreenCopy1 = Shader.PropertyToID("_ScreenCopy1");
            internal static readonly int _ScreenCopy2 = Shader.PropertyToID("_ScreenCopy2");
            internal static readonly string _BlitShader = "Hidden/BlurBlit";
        }

        public override bool active
        {
            get
            {
                return model.enabled
                       && !context.interrupted;
            }
        }

        public override string GetName()
        {
            return "Grab";
        }

        public override CameraEvent GetCameraEvent()
        {
            return model.settings.cameraEvent;
        }

        public override void PopulateCommandBuffer(CommandBuffer cb)
        {
            var settings = model.settings;

            int w = context.width;
            int h = context.height;

            switch(model.settings.resolution)
            {
                case GrabModel.EResolution.Low:
                    w /= 4; h /= 4;
                    break;
                case GrabModel.EResolution.Middle:
                    w /= 2; h /= 2;
                    break;
            }

            //var mat = context.materialFactory.Get(Uniforms._BlitShader);
            //mat.SetFloat("_Smooth", model.settings.smooth);

            cb.GetTemporaryRT(Uniforms._ScreenCopy1, w, h, 16, FilterMode.Bilinear);
            //cb.GetTemporaryRT(Uniforms._ScreenCopy2, w, h, 16, FilterMode.Bilinear);

            cb.Blit(BuiltinRenderTextureType.CurrentActive, Uniforms._ScreenCopy1);
            //cb.Blit(Uniforms._ScreenCopy1, Uniforms._ScreenCopy2, mat);
            //cb.Blit(Uniforms._ScreenCopy2, Uniforms._ScreenCopy1, mat, 1);
            cb.SetGlobalTexture(Uniforms._GrabTexture, Uniforms._ScreenCopy1);
            cb.ReleaseTemporaryRT(Uniforms._ScreenCopy1);
            //cb.ReleaseTemporaryRT(Uniforms._ScreenCopy2);
        }
    }

}
