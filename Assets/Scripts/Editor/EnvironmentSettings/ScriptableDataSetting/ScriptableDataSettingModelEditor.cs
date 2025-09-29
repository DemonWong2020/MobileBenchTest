// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ScriptableDataSettingModelEditor.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scriptable Setting Model Editor
// **********************************************************************
using System;
using System.Linq.Expressions;
using UnityEditor;
using UnityEngine;

public class ScriptableDataSettingModelEditor
{
    public ScriptableDataSettingModel mTarget { get; set; }
    public SerializedProperty mSerializedProperty { get; set; }

    protected SerializedProperty mSettingsProperty;
    protected SerializedProperty mEnableProperty;

    public Editor mAttachInspector;

    public void OnPreEnable()
    {
        mSettingsProperty = mSerializedProperty.FindPropertyRelative("mSettings");
        mEnableProperty = mSerializedProperty.FindPropertyRelative("mEnable");

        OnEnable();
    }

    public virtual void OnEnable()
    {

    }

    public virtual void OnDisable()
    {

    }

    public void OnGUI()
    {
        GUILayout.Space(5);

        var display = EditorUtils.Header(mSerializedProperty.displayName, mSettingsProperty, mEnableProperty, Reset);

        if (display)
        {
            EditorGUI.indentLevel++;
            using (new EditorGUI.DisabledGroupScope(!mEnableProperty.boolValue))
            {
                OnInspectorGUI();
            }
            EditorGUI.indentLevel--;
        }
    }

    void Reset()
    {
        var obj = mSerializedProperty.serializedObject;
        Undo.RecordObject(obj.targetObject, "Reset");
        mTarget.Reset();
        EditorUtility.SetDirty(obj.targetObject);
    }

    public virtual void OnInspectorGUI()
    {

    }

    public void Repaint()
    {
        mAttachInspector.Repaint();
    }

    protected SerializedProperty FindSetting<T, TValue>(Expression<Func<T, TValue>> expr)
    {
        return mSettingsProperty.FindPropertyRelative(ReflectionUtils.GetFieldPath(expr));
    }

    protected SerializedProperty FindSetting<T, TValue>(SerializedProperty prop, Expression<Func<T, TValue>> expr)
    {
        return prop.FindPropertyRelative(ReflectionUtils.GetFieldPath(expr));
    }
}
