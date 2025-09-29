using UnityEditor;
using UnityEngine;
using UnityEngine.PostProcessing;

namespace UnityEditor.PostProcessing
{
    using Settings = DepthModeModel.Settings;

    [PostProcessingModelEditor(typeof(DepthModeModel))]
    public class DepthModeEditor : PostProcessingModelEditor
    {
        SerializedProperty mDepthMode;

        public override void OnEnable()
        {
            mDepthMode = FindSetting((Settings x) => x.depthMode);
        }

        public override void OnInspectorGUI()
        {
            mDepthMode.enumValueIndex = (int)(DepthTextureMode)EditorGUILayout.EnumPopup("Depth Mode", (DepthTextureMode)mDepthMode.enumValueIndex);
        }
    }
}
