using UnityEngine.PostProcessing;

namespace UnityEditor.PostProcessing
{
    using Settings = FogModel.Settings;

    [PostProcessingModelEditor(typeof(FogModel))]
    public class FogModelEditor : PostProcessingModelEditor
    {
        SerializedProperty fogColor;
        SerializedProperty fogDensity;
        SerializedProperty speed;
        SerializedProperty digRadius;
        SerializedProperty disturbance;
        SerializedProperty disturbanceTex;

        public override void OnEnable()
        {
            fogColor = FindSetting((Settings x) => x.fogColor);
            fogDensity = FindSetting((Settings x) => x.fogDensity);
            speed = FindSetting((Settings x) => x.speed);
            digRadius = FindSetting((Settings x) => x.digRadius);
            disturbance = FindSetting((Settings x) => x.disturbance);
            disturbanceTex = FindSetting((Settings x) => x.disturbanceTex);
        }

        public override void OnInspectorGUI()
        {
            EditorGUILayout.PropertyField(fogColor);
            EditorGUILayout.PropertyField(fogDensity);
            EditorGUILayout.PropertyField(speed);
            EditorGUILayout.PropertyField(digRadius);
            EditorGUILayout.PropertyField(disturbance);
            EditorGUILayout.PropertyField(disturbanceTex);
        }
    }
}
