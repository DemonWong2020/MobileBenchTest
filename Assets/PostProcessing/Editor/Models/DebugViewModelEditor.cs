// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     DebugViewModelEditor.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-09-10
// Purpose: 
// **********************************************************************
using UnityEngine;
using UnityEngine.PostProcessing;

namespace UnityEditor.PostProcessing
{
    using Settings = DebugViewModel.Settings;

    [PostProcessingModelEditor(typeof(DebugViewModel))]
    public class DebugViewModelEditor : PostProcessingModelEditor
    {
        SerializedProperty mViewType;

        public override void OnEnable()
        {
            mViewType = FindSetting((Settings x) => x.mViewType);
        }

        public override void OnInspectorGUI()
        {
            int viewType = (int)(DebugViewModel.EViewType)EditorGUILayout.EnumPopup("Debug View Mode", (DebugViewModel.EViewType)mViewType.enumValueIndex);

            if(mViewType.enumValueIndex != viewType)
            {
                mViewType.enumValueIndex = viewType;
            }
        }
    }
}