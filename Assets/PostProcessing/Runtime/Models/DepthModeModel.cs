using UnityEngine;
using UnityEngine.Rendering;
using System.Collections;

namespace UnityEngine.PostProcessing
{
   [System.Serializable]
    public class DepthModeModel : PostProcessingModel
    {
        [System.Serializable]
        public struct Settings
        {
            public DepthTextureMode depthMode;

            public static Settings defaultSettings
            {
                get
                {
                    return new Settings
                    {
                        depthMode = DepthTextureMode.None
                    };
                }
            }
        }

        [SerializeField]
        Settings m_Settings = Settings.defaultSettings;

        public Settings settings
        {
            get { return m_Settings; }
            set { m_Settings = value; }
        }

        public override void Reset()
        {
            m_Settings = Settings.defaultSettings;
        }
    }
}
