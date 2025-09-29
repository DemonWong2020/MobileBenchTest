// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ExMeshRendererEditor.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2023-01-09
// Purpose: 
// **********************************************************************
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(MeshRenderer))]
public class ExMeshRendererEditor : DecoratorEditor
{
    public ExMeshRendererEditor()
     : base("MeshRendererEditor")
    {

    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        EditorGUI.BeginChangeCheck();   
        var mr = target as MeshRenderer;
        mr.sortingOrder = EditorGUILayout.IntField("Sorting Order : ", mr.sortingOrder);

        mr.lightmapIndex = EditorGUILayout.IntField("Lightmap Index : ", mr.lightmapIndex);
        mr.lightmapScaleOffset = EditorGUILayout.Vector4Field("Lightmap Scale Offset : ", mr.lightmapScaleOffset);

        if(EditorGUI.EndChangeCheck())
        {
            EditorUtility.SetDirty(mr);
        }
    }
}
