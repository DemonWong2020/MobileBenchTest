// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ExSkinnedMeshRendererEditor.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-12-11
// Purpose: 
// **********************************************************************
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(SkinnedMeshRenderer))]
public class ExSkinnedMeshRendererEditor : DecoratorEditor
{
    private int mBoneCount;
    private Mesh mesh;
    private Vector3[] verts;
    private Vector3[] normals;
    private float normalsLength = 0.01f;

    public ExSkinnedMeshRendererEditor()
       : base("SkinnedMeshRendererEditor")
    {

    }

    private void OnEnable()
    {
        var skinned = target as SkinnedMeshRenderer;
        mBoneCount = skinned.bones.Length;
        mesh = skinned.sharedMesh;
    }

    //private void OnSceneGUI()
    //{
    //    if (mesh == null)
    //    {
    //        return;
    //    }
    //    var skinned = target as SkinnedMeshRenderer;
    //    Handles.matrix = skinned.transform.localToWorldMatrix;
    //    Handles.color = Color.blue;
    //    verts = mesh.vertices;
    //    normals = mesh.normals;
    //    int len = mesh.vertexCount;

    //    for (int i = 0; i < len; i++)
    //    {
    //        Handles.ArrowHandleCap(0, verts[i], Quaternion.LookRotation(normals[i], Vector3.up), normalsLength, EventType.Repaint);
    //    }
    //}


    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        var skin = target as SkinnedMeshRenderer;
        skin.sortingOrder = EditorGUILayout.IntField("Sorting Order : ", skin.sortingOrder);

        EditorGUILayout.IntField("骨骼总数", mBoneCount);

        //normalsLength = EditorGUILayout.FloatField("Normals length", normalsLength);

        EditorGUILayout.Vector3Field("Bound Size", skin.bounds.size);
    }
}
