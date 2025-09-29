using TMPro;
using UnityEditor;
using UnityEngine;

public class RootNodeSizeEditor : EditorWindow
{
    [MenuItem("Window/Root Node Size")]
    public static void ShowWindow()
    {
        GetWindow<RootNodeSizeEditor>("Root Node Size");
    }

    void OnGUI()
    {
        if (Selection.activeGameObject != null)
        {
            GameObject rootNode = GetRootNode(Selection.activeGameObject);
            Bounds bounds = CalculateBounds(rootNode);
            GUILayout.Label("Root Node Max Size: " + bounds + " \n" + bounds.min + " " + bounds.max + " \n" + bounds.center + " " + bounds.size + " \n" + bounds.extents);
        }
        else
        {
            GUILayout.Label("No GameObject Selected");
        }
    }

    GameObject GetRootNode(GameObject obj)
    {
        Transform parentTransform = obj.transform.parent;
        while (parentTransform != null)
        {
            obj = parentTransform.gameObject;
            parentTransform = obj.transform.parent;
        }
        return obj;
    }

    Bounds CalculateBounds(GameObject obj)
    {
        Renderer[] renderers = obj.GetComponentsInChildren<Renderer>();
        if (renderers.Length == 0)
        {
            return new Bounds(Vector3.zero, Vector3.zero);
        }

        Bounds bounds = renderers[0].bounds;
        foreach (Renderer renderer in renderers)
        {
            bounds.Encapsulate(renderer.bounds);
        }
        return bounds;
    }
}