using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class DynamicGridEditor : MonoBehaviour
{
    public GameObject nodePrefab;
    public Canvas canvas;

    public Dictionary<Vector2Int, GameObject> gridNodes;

    void Start()
    {
        gridNodes = new Dictionary<Vector2Int, GameObject>();

        CreateInitialNode(Vector2.zero, Vector2Int.zero);
    }

    public void CreateInitialNode(Vector2 position, Vector2Int coord)
    {
        CreateNode(position, coord);
    }

    private void CreateNode(Vector2 position, Vector2Int coord)
    {
        if (gridNodes.ContainsKey(coord))
            return; // 如果节点已存在，不重复创建

        GameObject node = Instantiate(nodePrefab, canvas.transform);
        (node.transform as RectTransform).anchoredPosition = position;

        gridNodes[coord] = node;
        CreateNeighborButtons(gameObject, position, coord);
    }

    private void CreateNeighborButtons(GameObject node, Vector2 position, Vector2Int coord)
    {
        Vector2Int[] offsets = new Vector2Int[]
        {
            new Vector2Int(1, 0), new Vector2Int(0, 1), new Vector2Int(-1, 1),
            new Vector2Int(-1, 0), new Vector2Int(0, -1), new Vector2Int(1, -1),
            new Vector2Int(1, 1),  new Vector2Int(-1, -1)
        };

        foreach (var offset in offsets)
        {
            Vector2Int neighborCoord = coord + offset;
            Vector2 buttonPosition = position + new Vector2(offset.x * 160, offset.y * 30);

            CreateButton(node, buttonPosition, neighborCoord);
        }
    }

    private void CreateButton(GameObject parentNode, Vector2 position, Vector2Int coord)
    {
        if(gridNodes.ContainsKey(coord))
            return; // 如果按钮已存在，不重复创建

        GameObject node = Instantiate(nodePrefab, canvas.transform);
        (node.transform as RectTransform).anchoredPosition = position;
        node.GetComponent<Button>().onClick.AddListener(() => OnAddNode(node, position, coord));

        var buttonText = node.GetComponentInChildren<TextMeshProUGUI>();
        buttonText.text = "+";

        gridNodes.Add(coord, node);
    }

    private void OnAddNode(GameObject node, Vector2 position, Vector2Int coord)
    {
        CreateNeighborButtons(node, position, coord);
    }
}