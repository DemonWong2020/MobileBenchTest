using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class DynamicGridEditor : EditorWindow
{
    private Dictionary<Vector2Int, string> gridData = new Dictionary<Vector2Int, string>();
    private Vector2 scrollPosition;
    private Vector2Int gridSize = new Vector2Int(10, 10); // 初始网格尺寸

    [MenuItem("Window/Dynamic Grid Editor")]
    public static void ShowWindow()
    {
        GetWindow<DynamicGridEditor>("Dynamic Grid Editor");
    }

    private void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();

        if (GUILayout.Button("Add Row"))
        {
            AddRow();
        }

        if (GUILayout.Button("Add Column"))
        {
            AddColumn();
        }

        EditorGUILayout.EndHorizontal();

        // 网格视图
        scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition, GUILayout.Width(position.width), GUILayout.Height(position.height - 50));

        for (int y = 0; y < gridSize.y; y++)
        {
            EditorGUILayout.BeginHorizontal();
            for (int x = 0; x < gridSize.x; x++)
            {
                Vector2Int coord = new Vector2Int(x, y);
                string value = gridData.ContainsKey(coord) ? gridData[coord] : "";

                value = EditorGUILayout.TextField(value, GUILayout.Width(60));
                gridData[coord] = value;
            }
            EditorGUILayout.EndHorizontal();
        }

        EditorGUILayout.EndScrollView();
    }

    private void AddRow()
    {
        for (int x = 0; x < gridSize.x; x++)
        {
            Vector2Int coord = new Vector2Int(x, gridSize.y);
            gridData[coord] = ""; // 新增行初始化为空白
        }
        gridSize.y += 1; // 增加行数
        Repaint();
    }

    private void AddColumn()
    {
        for (int y = 0; y < gridSize.y; y++)
        {
            Vector2Int coord = new Vector2Int(gridSize.x, y);
            gridData[coord] = ""; // 新增列初始化为空白
        }
        gridSize.x += 1; // 增加列数
        Repaint();
    }
}