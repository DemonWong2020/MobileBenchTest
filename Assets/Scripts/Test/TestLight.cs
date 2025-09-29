using UnityEditor;
using UnityEngine;


public class TestLight : MonoBehaviour
{
    public Light light;

    public void Start()
    {
        var bakingOutput = light.bakingOutput;
        Debug.Log(light.bakingOutput.lightmapBakeType
            + " " + light.bakingOutput.isBaked
            + " " + light.bakingOutput.mixedLightingMode
            + " " + light.bakingOutput.occlusionMaskChannel);

        bakingOutput.isBaked = true;
        bakingOutput.lightmapBakeType = LightmapBakeType.Mixed;
        bakingOutput.mixedLightingMode = MixedLightingMode.Shadowmask;
        bakingOutput.occlusionMaskChannel = 0;
        bakingOutput.probeOcclusionLightIndex = 0;
        light.bakingOutput = bakingOutput;

        Debug.Log(light.bakingOutput.lightmapBakeType
            + " " + light.bakingOutput.isBaked
            + " " + light.bakingOutput.mixedLightingMode
            + " " + light.bakingOutput.occlusionMaskChannel);

        if (!Shader.IsKeywordEnabled("LIGHTMAP_ON"))
        {
            Shader.EnableKeyword("LIGHTMAP_ON");
        }

        if (!Shader.IsKeywordEnabled("SHADOWS_SCREEN"))
        {
            Shader.EnableKeyword("SHADOWS_SCREEN");
        }

        if (!Shader.IsKeywordEnabled("SHADOWS_SHADOWMASK"))
        {
            Shader.EnableKeyword("SHADOWS_SHADOWMASK");
        }
        Debug.Log(Shader.IsKeywordEnabled("LIGHTMAP_ON")
            + " " + Shader.IsKeywordEnabled("SHADOWS_SCREEN")
            + " " + Shader.IsKeywordEnabled("SHADOWS_SHADOWMASK"));

    }
}