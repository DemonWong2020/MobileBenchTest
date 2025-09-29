using System;
using UnityEngine.Rendering;

namespace UnityEngine.PostProcessing
{
    [Serializable]
    public class GrabModel : PostProcessingModel
    {
        public enum EResolution
        {
            Low,
            Middle,
            High,
        }

        [Serializable]
        public struct Settings
        {
            public EResolution resolution;

            //[Range(0f, 1f)]
            //public float smooth;

            public CameraEvent cameraEvent;

            public static Settings defaultSettings
            {
                get
                {
                    return new Settings
                        {
                            resolution = EResolution.Middle,
                            //smooth = 0,
                            cameraEvent = CameraEvent.AfterForwardOpaque,
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
