// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     EnvironmentSettingsEditor.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Environment Settings ScriptableDataSettingBehaviourEditor
// **********************************************************************
using System.Reflection;
using UnityEditor;

[CustomEditor(typeof(EnvironmentSettings))]
public class EnvironmentSettingsEditor : ScriptableDataSettingBehaviourEditor
{
    protected override Assembly GetAssembly()
    {
        return Assembly.GetAssembly(typeof(EnvironmentSettingsEditor));
    }
}
