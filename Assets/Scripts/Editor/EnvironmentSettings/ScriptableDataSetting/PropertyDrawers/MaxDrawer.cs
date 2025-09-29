// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     MaxDrawer.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      MaxAttribute Editor
// **********************************************************************
using UnityEngine;
using UnityEditor;

[CustomPropertyDrawer(typeof(MaxAttribute))]
public class MaxDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        MaxAttribute attribute = (MaxAttribute)base.attribute;

        if (property.propertyType == SerializedPropertyType.Integer)
        {
            int v = EditorGUI.IntField(position, label, property.intValue);
            property.intValue = (int)Mathf.Min(v, attribute.mMax);
        }
        else if (property.propertyType == SerializedPropertyType.Float)
        {
            float v = EditorGUI.FloatField(position, label, property.floatValue);
            property.floatValue = Mathf.Min(v, attribute.mMax);
        }
        else
        {
            EditorGUI.LabelField(position, label.text, "Use Min with float or int.");
        }
    }
}
