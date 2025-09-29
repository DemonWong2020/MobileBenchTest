// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CameraFilterModel.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-14
// Purpose: 
// **********************************************************************
using System;
using System.Collections.Generic;

namespace UnityEngine.PostProcessing
{
    [Serializable]
    public class CameraFilterModel : PostProcessingModel
    {
        private CameraFilterComponent mCameraFilterComponent;
        public PostProcessingContext context
        {
            get
            {
                return mCameraFilterComponent?.context;
            }
        }

        [Serializable]
        public class Settings
        {
            public CF_BloodOnScreen mBloodOnScreen;
            public CF_BlurFocus mBlurFocus;
            public CF_DistortionAspiration mDistortionAspiration;
            public CF_DistortionDream mDistortionDream;
            public CF_DistortionNoise mDistortionNoise;
            public CF_DistortionWaveHorizontal mDistortionWaveHorizontal;
            public CF_DrawingBluePrint mDrawingBluePrint;
            public CF_DrawingCellShading mDrawingCellShading;
            public CF_DrawingPaper mDrawingPaper;
            public CF_EyeVision mEyeVision;
            public CF_FXDrunk mFXDrunk;
            public CF_FXEarthQuake mFXEarthQuake;
            public CF_LightWave mLightWave;
            public CF_RainFX mRainFX;
            public CF_VHSTracking mVHSTracking;
            public CF_VisionBloodFast mVisionBloodFast;
            public CF_VisionWarp mVisionWarp;
            public CF_Scorching mScorching;

            public static Settings defaultSettings
            {
                get
                {
                    return new Settings
                    {
                        mBloodOnScreen = new CF_BloodOnScreen(),
                        mBlurFocus = new CF_BlurFocus(),
                        mDistortionAspiration = new CF_DistortionAspiration(),
                        mDistortionDream = new CF_DistortionDream(),
                        mDistortionNoise = new CF_DistortionNoise(),
                        mDistortionWaveHorizontal = new CF_DistortionWaveHorizontal(),
                        mDrawingBluePrint = new CF_DrawingBluePrint(),
                        mDrawingCellShading = new CF_DrawingCellShading(),
                        mDrawingPaper = new CF_DrawingPaper(),
                        mEyeVision = new CF_EyeVision(),
                        mFXDrunk = new CF_FXDrunk(),
                        mFXEarthQuake = new CF_FXEarthQuake(),
                        mLightWave = new CF_LightWave(),
                        mRainFX = new CF_RainFX(),
                        mVHSTracking = new CF_VHSTracking(),
                        mVisionBloodFast = new CF_VisionBloodFast(),
                        mVisionWarp = new CF_VisionWarp(),
                        mScorching = new CF_Scorching(),
                    };
                }
            }
        }

        [SerializeField]
        public bool AutoDisable = false;

        [SerializeField]
        Settings m_Settings = Settings.defaultSettings;
        public Settings settings
        {
            get { return m_Settings; }
            set { m_Settings = value; }
        }

        public List<CameraFilterBase> filterList = new List<CameraFilterBase>();

        public void Init(CameraFilterComponent component, CameraFilterBase.OnDelayEnd callback)
        {
            mCameraFilterComponent = component;

            filterList.Clear();
            filterList.Add(settings.mBloodOnScreen);
            filterList.Add(settings.mBlurFocus);
            filterList.Add(settings.mDistortionAspiration);
            filterList.Add(settings.mDistortionDream);
            filterList.Add(settings.mDistortionNoise);
            filterList.Add(settings.mDistortionWaveHorizontal);
            filterList.Add(settings.mDrawingBluePrint);
            filterList.Add(settings.mDrawingCellShading);
            filterList.Add(settings.mDrawingPaper);
            filterList.Add(settings.mEyeVision);
            filterList.Add(settings.mFXDrunk);
            filterList.Add(settings.mFXEarthQuake);
            filterList.Add(settings.mLightWave);
            filterList.Add(settings.mRainFX);
            filterList.Add(settings.mVHSTracking);
            filterList.Add(settings.mVisionBloodFast);
            filterList.Add(settings.mVisionWarp);
            filterList.Add(settings.mScorching);

            var len = filterList.Count;
            for(int i = 0; i < len; ++i)
            {
                filterList[i].Init(mCameraFilterComponent.context, callback);
            }

            SortList();
        }

        public override void Reset()
        {
            m_Settings = Settings.defaultSettings;

            AutoDisable = false;

            filterList.Clear();
            filterList.Add(settings.mBloodOnScreen);
            filterList.Add(settings.mBlurFocus);
            filterList.Add(settings.mDistortionAspiration);
            filterList.Add(settings.mDistortionDream);
            filterList.Add(settings.mDistortionNoise);
            filterList.Add(settings.mDistortionWaveHorizontal);
            filterList.Add(settings.mDrawingBluePrint);
            filterList.Add(settings.mDrawingCellShading);
            filterList.Add(settings.mDrawingPaper);
            filterList.Add(settings.mEyeVision);
            filterList.Add(settings.mFXDrunk);
            filterList.Add(settings.mFXEarthQuake);
            filterList.Add(settings.mLightWave);
            filterList.Add(settings.mRainFX);
            filterList.Add(settings.mVHSTracking);
            filterList.Add(settings.mVisionBloodFast);
            filterList.Add(settings.mVisionWarp);
            filterList.Add(settings.mScorching);
        }

        public void UpdateFilter(int[] filters, bool[] enables)
        {
           
        }

        private void SortList()
        {
            var enableList = new List<CameraFilterBase>();
            var disableList = new List<CameraFilterBase>();

            var len = filterList.Count;
            for (int i = 0; i < len; ++i)
            {
                if (filterList[i].enable)
                {
                    enableList.Add(filterList[i]);
                }
                else
                {
                    disableList.Add(filterList[i]);
                }
            }

            enableList.Sort((a, b) =>
            {
                return a.order > b.order ? -1 : 1;
            });

            disableList.Sort((a, b) =>
            {
                return a.order > b.order ? -1 : 1;
            });

            filterList.Clear();

            filterList.AddRange(enableList);
            filterList.AddRange(disableList);
        }
    }
}
