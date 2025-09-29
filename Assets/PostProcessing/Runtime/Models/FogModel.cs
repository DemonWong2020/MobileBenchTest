using System;

namespace UnityEngine.PostProcessing
{
    [Serializable]
    public class FogModel : PostProcessingModel
    {
        [Serializable]
        public struct Settings
        {
            public Color fogColor;
            public float fogDensity;
            public Vector2 speed;
            public float digRadius;
            [Range(0, 1)]
            public float disturbance;
            
            public Texture2D disturbanceTex;

            public static Settings defaultSettings
            {
                get
                {
                    return new Settings
                    {
                        fogColor = Color.white,
                        fogDensity = 20f,
                        speed = Vector2.zero,
                        digRadius = 0.2f,
                        disturbance = 0.2f,
                        disturbanceTex = null,
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
