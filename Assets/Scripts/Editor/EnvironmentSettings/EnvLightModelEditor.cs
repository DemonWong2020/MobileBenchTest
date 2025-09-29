// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     Env_LightModelEditor.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose: 
// **********************************************************************
using UnityEngine;
using UnityEditor;

[ScriptableDataSettingModelEditor(typeof(EnvLightModel))]
public class EnvLightModelEditor : ScriptableDataSettingModelEditor
{
    struct Env_LightModelSettings
    {
        public SerializedProperty mAlwaysOneLight;
        public SerializedProperty mDefaultLight;
        public SerializedProperty mDynLights;
        public SerializedProperty mMainLight;

    }

    Env_LightModelSettings mSettings;

    public override void OnEnable()
    {
        base.OnEnable();
        mSettings = new Env_LightModelSettings
        {
            mAlwaysOneLight = FindSetting((EnvLightModel.Settings x) => x.mAlwaysOneLight),
            mDefaultLight = FindSetting((EnvLightModel.Settings x) => x.mDefaultLight),
            mDynLights = FindSetting((EnvLightModel.Settings x) => x.mDynLights),
            mMainLight = FindSetting((EnvLightModel.Settings x) => x.mMainLight)
        };
    }

    public override void OnInspectorGUI()
    {
        EditorGUILayout.PropertyField(mSettings.mAlwaysOneLight);
        if (mSettings.mAlwaysOneLight.boolValue)
        {
            EditorGUILayout.PropertyField(mSettings.mDefaultLight);
        }
        else
        {
            EditorGUILayout.PropertyField(mSettings.mDynLights);
        }
        EditorGUILayout.PropertyField(mSettings.mMainLight);
    }
}
