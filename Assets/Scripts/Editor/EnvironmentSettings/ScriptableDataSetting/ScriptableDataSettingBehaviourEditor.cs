// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ScriptableDataSettingBehaviourEditor.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scriptable Data Setting Behaviour Editor
// **********************************************************************
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(ScriptableDataSettingBehaviour))]
public class ScriptableDataSettingBehaviourEditor : Editor
{
    protected Dictionary<ScriptableDataSettingModelEditor, ScriptableDataSettingModel> mCustomEditors = new Dictionary<ScriptableDataSettingModelEditor, ScriptableDataSettingModel>();

    void OnEnable()
    {
        if(null == target)
        {
            return;
        }

        // Aggregate custom post-fx editors
        var assembly = GetAssembly();

        var editorTypes = assembly.GetTypes()
            .Where(x => x.IsDefined(typeof(ScriptableDataSettingModelEditorAttribute), false));

        var customEditors = new Dictionary<Type, ScriptableDataSettingModelEditor>();
        foreach (var editor in editorTypes)
        {
            var attr = (ScriptableDataSettingModelEditorAttribute)editor.GetCustomAttributes(typeof(ScriptableDataSettingModelEditorAttribute), false)[0];
            var effectType = attr.mType;

            var editorInst = (ScriptableDataSettingModelEditor)Activator.CreateInstance(editor);
            editorInst.mAttachInspector = this;
            customEditors.Add(effectType, editorInst);
        }

        var baseType = target.GetType();
        var property = serializedObject.GetIterator();

        while (property.Next(true))
        {
            if (!property.hasChildren)
                continue;

            var type = baseType;
            var srcObject = ReflectionUtils.GetFieldValueFromPath(serializedObject.targetObject, ref type, property.propertyPath);

            if (srcObject == null)
                continue;

            ScriptableDataSettingModelEditor editor;
            if (customEditors.TryGetValue(type, out editor))
            {
                var effect = (ScriptableDataSettingModel)srcObject;

                mCustomEditors.Add(editor, effect);
                editor.mTarget = effect;
                editor.mSerializedProperty = property.Copy();
                editor.OnPreEnable();
            }
        }
    }

    void OnDisable()
    {
        if (mCustomEditors != null)
        {
            foreach (var editor in mCustomEditors.Keys)
                editor.OnDisable();

            mCustomEditors.Clear();
        }
    }

    protected virtual Assembly GetAssembly()
    {
        return null;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        // Handles undo/redo events first (before they get used by the editors' widgets)
        var e = Event.current;
        if (e.type == EventType.ValidateCommand && e.commandName == "UndoRedoPerformed")
        {
            foreach (var editor in mCustomEditors)
                editor.Value.OnValidate();
        }

        foreach (var editor in mCustomEditors)
        {
            EditorGUI.BeginChangeCheck();

            editor.Key.OnGUI();

            if (EditorGUI.EndChangeCheck())
                editor.Value.OnValidate();
        }

        serializedObject.ApplyModifiedProperties();
    }
}
