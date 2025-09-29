using UnityEngine.PostProcessing;

namespace UnityEditor.PostProcessing
{
    using Settings = GrabModel.Settings;

    [PostProcessingModelEditor(typeof(GrabModel))]
    public class GrabModelEditor : PostProcessingModelEditor
    {
        SerializedProperty m_Resoultion;
        SerializedProperty m_Radius;
        SerializedProperty m_CameraEvent;

        public override void OnEnable()
        {
            m_Resoultion = FindSetting((Settings x) => x.resolution);
            //m_Radius = FindSetting((Settings x) => x.smooth);
            m_CameraEvent = FindSetting((Settings x) => x.cameraEvent);
        }

        public override void OnInspectorGUI()
        {
            //EditorGUILayout.HelpBox("Nothing to configure !", MessageType.Info);
            EditorGUILayout.PropertyField(m_Resoultion);
            //EditorGUILayout.PropertyField(m_Radius);
            EditorGUILayout.PropertyField(m_CameraEvent);
        }
    }
}
