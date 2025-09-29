// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     MinDrawer.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      MinAttribute Editor
// **********************************************************************
using UnityEngine;
using UnityEditor;

[CustomPropertyDrawer(typeof(MinAttribute))]
sealed class MinDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        var attribute = (MinAttribute)base.attribute;

        if (property.propertyType == SerializedPropertyType.Integer)
        {
            int v = EditorGUI.IntField(position, label, property.intValue);
            property.intValue = (int)Mathf.Max(v, attribute.mMin);
        }
        else if (property.propertyType == SerializedPropertyType.Float)
        {
            float v = EditorGUI.FloatField(position, label, property.floatValue);
            property.floatValue = Mathf.Max(v, attribute.mMin);
        }
        else
        {
            EditorGUI.LabelField(position, label.text, "Use Min with float or int.");
        }
    }
}
