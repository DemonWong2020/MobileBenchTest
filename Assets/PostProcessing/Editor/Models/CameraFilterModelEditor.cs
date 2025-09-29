// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CameraFilterModelEditor.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-15
// Purpose: 
// **********************************************************************
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PostProcessing;

namespace UnityEditor.PostProcessing
{
    [PostProcessingModelEditor(typeof(CameraFilterModel))]
    public class CameraFilterModelEditor : PostProcessingModelEditor
    {
        private Vector2 mScrollPos;
        private CameraFilterModel mCameraFilterModel;
        public override void OnEnable()
        {
            base.OnEnable();
            mCameraFilterModel = target as CameraFilterModel;
        }

        public override void OnInspectorGUI()
        {
            GUILayout.BeginVertical();
            mCameraFilterModel.AutoDisable = EditorGUILayout.ToggleLeft("自动禁用", mCameraFilterModel.AutoDisable);
            GUILayout.Label("启用组件 ----- 越靠前越早渲染");
            mScrollPos = GUILayout.BeginScrollView(mScrollPos, EditorStyles.helpBox);

            for (int i = 0; i < mCameraFilterModel.filterList.Count; ++i)
            {
                mCameraFilterModel.filterList[i].OnGUI();
            }

            GUILayout.EndScrollView();
            GUILayout.EndHorizontal();
        }
    }
}
