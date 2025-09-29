using NUnit.Framework;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

[ExecuteInEditMode]
public class LightMapSaver : MonoBehaviour
{
    [System.Serializable]
    public struct RendererData
    {
        public MeshRenderer meshRenderer;
        public int lightmapIndex;
        public Vector4 lightmapScaleOffset;
    }

    public List<Texture2D> lightmaps;
    public List<Texture2D> shadowmask;
    public List<RendererData> renderersData = new List<RendererData>();

    public bool saveLightmaps = false;
    
    // Use this for initialization
    void Start()
    {
        if(Application.isPlaying)
        {
            List<LightmapData> lightmapList = new List<LightmapData>();
            int startIndex = 0;
            for (int i = 0; i < lightmaps.Count; i++)
            {
                LightmapData data = new LightmapData()
                { lightmapColor = lightmaps[i], shadowMask = shadowmask[i] };
                lightmapList.Add(data);
            }
            LightmapSettings.lightmapsMode = LightmapsMode.NonDirectional;
            LightmapSettings.lightmaps = lightmapList.ToArray();
            for(int i = 0; i < renderersData.Count; i++)
            {
                var data = renderersData[i];
                var meshRender = data.meshRenderer;
                meshRender.lightmapIndex = data.lightmapIndex;
                meshRender.lightmapScaleOffset = data.lightmapScaleOffset;
                }
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(saveLightmaps)
        {
            SaveLightmaps();
            saveLightmaps = false;
        }
    }

    private void SaveLightmaps()
    {
        lightmaps.Clear();
        shadowmask.Clear();
        renderersData.Clear();

        var lightmapData = LightmapSettings.lightmaps;

        var meshRenders = GetComponentsInChildren<MeshRenderer>();
        List<int> lightmapIndiecs = new List<int>();

        foreach (var meshRender in meshRenders)
        {
            if (meshRender.lightmapIndex != -1)
            {
                var meshIndex = meshRender.lightmapIndex;
                if (!lightmapIndiecs.Contains(meshIndex))
                {
                    lightmapIndiecs.Add(meshIndex);
                }

                var data = new RendererData()
                {
                    meshRenderer = meshRender,
                    lightmapIndex = FindIndex(lightmapIndiecs, meshIndex),
                    lightmapScaleOffset = meshRender.lightmapScaleOffset
                };
                renderersData.Add(data);
                
            }
        }

        lightmapIndiecs.Sort();

        for (int i = 0; i < lightmapIndiecs.Count; i++)
        {
            var lightmapIndex = lightmapIndiecs[i];
            var lightmapDataItem = lightmapData[lightmapIndex];

            if (lightmaps == null)
            {
                Debug.LogError("Lightmaps array is null.");
                return;
            }

            lightmaps.Add(lightmapDataItem.lightmapColor);
            if (shadowmask != null)
            {
                shadowmask.Add(lightmapDataItem.shadowMask);
            }
        }
    }

    private int FindIndex(List<int> list, int value)
    {
        for (int i = 0; i < list.Count; i++)
        {
            if (list[i] == value)
            {
                return i;
            }
        }
        return -1; // Not found
    }
}
