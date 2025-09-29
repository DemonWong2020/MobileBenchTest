// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     EnvShadowModelEditor.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2023-07-27
// Purpose: 
// **********************************************************************
using UnityEditor;
using UnityEngine;

[ScriptableDataSettingModelEditor(typeof(EnvShadowModel))]
public class EnvShadowModelEditor : ScriptableDataSettingModelEditor
{
    struct Env_ShadowModelSettings
    {
        public SerializedProperty mShaodowSetting;
        public SerializedProperty mMainLight;

    }

    Env_ShadowModelSettings mSettings;

    public override void OnEnable()
    {
        base.OnEnable();
        mSettings = new Env_ShadowModelSettings
        {
            mShaodowSetting = FindSetting((EnvShadowModel.Settings x) => x.mShaodowSetting),
            mMainLight = FindSetting((EnvShadowModel.Settings x) => x.mMainLight)
        };
    }

    public override void OnInspectorGUI()
    {
        EditorGUILayout.PropertyField(mSettings.mShaodowSetting);
        EditorGUILayout.PropertyField(mSettings.mMainLight);
    }
}