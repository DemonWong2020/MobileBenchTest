// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CameraFilterComponent.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-14
// Purpose: 
// **********************************************************************
using System.Collections;
using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    public class CameraFilterComponent : PostProcessingComponentCommandBuffer<CameraFilterModel>
    {
        protected static readonly int SrcTexture = Shader.PropertyToID("_SrcTexture");
        protected static readonly int TargetTexture = Shader.PropertyToID("_TargetTexture");

        public override bool active
        {
            get
            {
                return model.enabled
                       && !context.interrupted;
            }
        }

        public override CameraEvent GetCameraEvent()
        {
            return CameraEvent.BeforeImageEffectsOpaque;
        }

        public override string GetName()
        {
            return "Camera-Filter";
        }

        public override void Init(PostProcessingContext pcontext, CameraFilterModel pmodel)
        {
            base.Init(pcontext, pmodel);
            pmodel.Init(this, OnDelayEnd);
        }

        public override void PopulateCommandBuffer(CommandBuffer cb)
        {
            var blitMat = context.materialFactory.Get("Hidden/CF_Blit");
            cb.GetTemporaryRT(SrcTexture, context.width, context.height);
            cb.GetTemporaryRT(TargetTexture, context.width, context.height);
            cb.Blit(BuiltinRenderTextureType.CameraTarget, SrcTexture, blitMat);

            var len = model.filterList.Count;
            int workFiliter = 0;
            for (int i = 0; i < len; ++i)
            {
                if (model.filterList[i].enable)
                {
                    bool switchCase = workFiliter % 2 == 0;
                    //相互交换减少创建新的贴图
                    var src = switchCase ? SrcTexture : TargetTexture;
                    var dst = switchCase ? TargetTexture : SrcTexture;
                    model.filterList[i].PopulateCommandBuffer(cb, src, dst);
                    ++workFiliter;
                }
            }

            if (workFiliter % 2 == 0)
            {
                cb.Blit(SrcTexture, BuiltinRenderTextureType.CameraTarget);
            }
            else
            {
                cb.Blit(TargetTexture, BuiltinRenderTextureType.CameraTarget);
            }

            cb.ReleaseTemporaryRT(SrcTexture);
            cb.ReleaseTemporaryRT(TargetTexture);
        }

        private void OnDelayEnd(CameraFilterBase cameraFilter)
        {
            bool enable = false;
            //检查所有滤镜是否都结束
            var len = model.filterList.Count;
            for (int i = 0; i < len; ++i)
            {
                var filter = model.filterList[i];
                if (filter.enable)
                {
                    enable = true;
                }
            }
            model.enabled = enable;
        }

        public override void OnDisable()
        {
            base.OnDisable();
            if (model.AutoDisable)
            {
                var len = model.filterList.Count;
                for (int i = 0; i < len; ++i)
                {
                    var filter = model.filterList[i];
                    filter.enable = false;
                }
                model.enabled = false;
            }
        }
    }
}
