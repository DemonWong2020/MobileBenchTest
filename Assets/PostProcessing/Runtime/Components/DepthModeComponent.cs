using UnityEngine;
using UnityEngine.Rendering;
using System.Collections;

namespace UnityEngine.PostProcessing
{
    /// <summary>
    /// 自定义组件
    /// </summary>
    public class DepthModeComponent : PostProcessingComponentRenderSettings<DepthModeModel>
    {
        private bool mIsSupportDepth = false;

        public override bool active
        {
            get
            {
                return model.enabled && mIsSupportDepth
                       && !context.interrupted;
            }
        }

        public override void OnEnable()
        {
            base.OnEnable();
            mIsSupportDepth = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth);
        }
     
        public override DepthTextureMode GetCameraFlags()
        {
            return active ? model.settings.depthMode : DepthTextureMode.None;
        }
    }
}
