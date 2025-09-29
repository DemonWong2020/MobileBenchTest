// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     Env_LightModel.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2022-07-05
// Purpose: 
// **********************************************************************
using System;
using UnityEngine;

[Serializable]
public class EnvLightModel : ScriptableDataSettingModel
{
    [Serializable]
    public struct LightSetting
    {
        public Color mLightColor;
        public float mSpeedMul;
        public bool mFOW;
        public float mDrakPower;
        public float mMinDark;
        public Color mFogColor;
        public float mStayTime;

        public static LightSetting Default
        {
            get
            {
                return new LightSetting
                {
                    mLightColor = Color.white,
                    mSpeedMul = 1f,
                    mFOW = false,
                    mDrakPower = 1,
                    mMinDark = 1,
                    mFogColor = new Color(0.05f, 0.05f, 0.05f, 0.05f),
                    mStayTime = 100f,
                };
            }
        }
    }

    [Serializable]
    public struct Settings
    {
        public bool mAlwaysOneLight;
        public LightSetting mDefaultLight;
        public LightSetting[] mDynLights;
        public Light mMainLight;

        public static Settings defaultSettings
        {
            get
            {
                return new Settings
                {
                    mAlwaysOneLight = true,
                    mDefaultLight = LightSetting.Default,
                    mDynLights = new LightSetting[1] { LightSetting.Default },
                    mMainLight = null
                };
            }
        }
    }

    [SerializeField]
    Settings mSettings = Settings.defaultSettings;
    public Settings pSettings
    {
        get { return mSettings; }
        set { mSettings = value; }
    }

    public override void Reset()
    {
        mSettings = Settings.defaultSettings;
    }
}
