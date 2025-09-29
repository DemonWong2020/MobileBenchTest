using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    public sealed class FogComponent : PostProcessingComponentRenderTexture<FogModel>
    {
        static class Uniforms
        {
            internal const string FOG_KEY_WORD = "FOG_ON";

            internal static readonly int _FogColor = Shader.PropertyToID("_FogColor");
            internal static readonly int _FogDensity = Shader.PropertyToID("_FogDensity");
            internal static readonly int _FogSpeed = Shader.PropertyToID("_FogSpeed");
            internal static readonly int _DigRadius = Shader.PropertyToID("_DigRadius");
            internal static readonly int _Disturbance = Shader.PropertyToID("_Disturbance");
            internal static readonly int _DisturbanceTex = Shader.PropertyToID("_DisturbanceTex");
        }

        public override bool active
        {
            get
            {
                return model.enabled
                       && !context.interrupted;
            }
        }

        public override DepthTextureMode GetCameraFlags()
        {
            return DepthTextureMode.Depth;
        }

        public override void Prepare(Material material)
        {
            base.Prepare(material);

            material.EnableKeyword(Uniforms.FOG_KEY_WORD);
            material.SetColor(Uniforms._FogColor, model.settings.fogColor);
            material.SetFloat(Uniforms._FogDensity, model.settings.fogDensity);
            material.SetVector(Uniforms._FogSpeed, model.settings.speed);
            material.SetFloat(Uniforms._DigRadius, model.settings.digRadius);
            material.SetFloat(Uniforms._Disturbance, model.settings.disturbance);
            material.SetTexture(Uniforms._DisturbanceTex, model.settings.disturbanceTex);
        }
    }
}
