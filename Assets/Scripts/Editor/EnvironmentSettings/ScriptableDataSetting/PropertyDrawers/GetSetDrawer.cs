// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     GetSetDrawer.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      GetSetAttribute Editor
// **********************************************************************
using UnityEngine;
using UnityEditor;

[CustomPropertyDrawer(typeof(GetSetAttribute))]
sealed class GetSetDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        var attribute = (GetSetAttribute)base.attribute;

        EditorGUI.BeginChangeCheck();
        EditorGUI.PropertyField(position, property, label);

        if (EditorGUI.EndChangeCheck())
        {
            attribute.mDirty = true;
        }
        else if (attribute.mDirty)
        {
            var parent = ReflectionUtils.GetParentObject(property.propertyPath, property.serializedObject.targetObject);

            var type = parent.GetType();
            var info = type.GetProperty(attribute.mName);

            if (info == null)
                Debug.LogError("Invalid property name \"" + attribute.mName + "\"");
            else
                info.SetValue(parent, fieldInfo.GetValue(parent), null);

            attribute.mDirty = false;
        }
    }
}
