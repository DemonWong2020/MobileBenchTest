// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     EnvShadowModel.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2023-07-27
// Purpose: 
// **********************************************************************
using System;
using System.Collections;
using UnityEngine;

[Serializable]
public class EnvShadowModel : ScriptableDataSettingModel
{

    [Serializable]
    public struct ShadowSettings
    {
        public Color mShadowColor;
        public Vector2 mShadowOffset;
        [Range(0, 1)]
        public float mMainShadowAtten;
        [Range(0, 1)]
        public float mAttenShadowAtten;

        public static ShadowSettings Default
        {
            get
            {
                return new ShadowSettings
                {
                    mShadowColor = Color.black,
                    mShadowOffset = new Vector2(3, 3),
                    mMainShadowAtten = 1f,
                    mAttenShadowAtten = 0.16f
                };
            }
        }
    }

    [Serializable]
    public struct Settings
    {
        public ShadowSettings mShaodowSetting;
        public Light mMainLight;

        public static Settings defaultSettings
        {
            get
            {
                return new Settings
                {
                    mShaodowSetting = ShadowSettings.Default,
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