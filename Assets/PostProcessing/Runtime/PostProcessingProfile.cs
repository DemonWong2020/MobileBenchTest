using System;

namespace UnityEngine.PostProcessing
{
    public class PostProcessingProfile : ScriptableObject
    {
        public BloomModel bloom = new BloomModel();
        public GrabModel grab = new GrabModel();
        public FogModel fogModel = new FogModel();
        public GreyModeModel greyMode = new GreyModeModel();
        public AmbientOcclusionModel ambientOcclusion = new AmbientOcclusionModel();
        public CameraFilterModel cameraFilterModel = new CameraFilterModel();
        public DepthModeModel depthMode = new DepthModeModel();
#if UNITY_EDITOR
        public DebugViewModel debugViewModel = new DebugViewModel();
        // Monitor settings
        [Serializable]
        public class MonitorSettings
        {
            // Callback used in the editor to grab the rendered frame and sent it to monitors
            public Action<RenderTexture> onFrameEndEditorOnly;

            // Global
            public int currentMonitorID = 0;
            public bool refreshOnPlay = false;

            // Histogram
            public enum HistogramMode
            {
                Red = 0,
                Green = 1,
                Blue = 2,
                Luminance = 3,
                RGBMerged,
                RGBSplit
            }

            public HistogramMode histogramMode = HistogramMode.Luminance;

            // Waveform
            public float waveformExposure = 0.12f;
            public bool waveformY = false;
            public bool waveformR = true;
            public bool waveformG = true;
            public bool waveformB = true;

            // Parade
            public float paradeExposure = 0.12f;

            // Vectorscope
            public float vectorscopeExposure = 0.12f;
            public bool vectorscopeShowBackground = true;
        }

        public MonitorSettings monitors = new MonitorSettings();
#endif
    }
}
