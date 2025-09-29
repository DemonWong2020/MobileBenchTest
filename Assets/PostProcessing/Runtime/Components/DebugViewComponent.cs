// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     DebugViewComponent.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-09-10
// Purpose: 
// **********************************************************************
#if UNITY_EDITOR
using UnityEditor;

namespace UnityEngine.PostProcessing
{
    public class DebugViewComponent : PostProcessingComponentRenderSettings<DebugViewModel>
    {
        private DebugViewModel.EViewType mViewType;

        public override bool active
        {
            get
            {
                if (null == model)
                {
                    return false;
                }
                return model.enabled && !context.interrupted && model.settings.mViewType != DebugViewModel.EViewType.None;
            }
        }

        public override void Init(PostProcessingContext pcontext, DebugViewModel pmodel)
        {
            base.Init(pcontext, pmodel);
            UpdateView();
            mViewType = model.settings.mViewType;
        }

        public override void OnDisable()
        {
            base.OnDisable();
            context.camera.ResetReplacementShader();
        }

        public override void LateUpdate()
        {
            base.LateUpdate();
            if (mViewType != model.settings.mViewType)
            {
                mViewType = model.settings.mViewType;
                UpdateView();
            }
        }

        public override void OnEnable()
        {
            base.OnEnable();
            UpdateView();
        }

        public void UpdateView()
        {
            if (active && model.settings.mViewType == DebugViewModel.EViewType.OverDraw)
            {
                Shader overdrawShader = EditorGUIUtility.LoadRequired("SceneView/SceneViewShowOverdraw.shader") as Shader;
                context.camera.SetReplacementShader(overdrawShader, "");
                context.camera.clearFlags = CameraClearFlags.SolidColor;
            }
            else
            {
                context.camera.ResetReplacementShader();
            }
        }
    }
}
#endif