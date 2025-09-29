// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     DebugViewModel.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-09-10
// Purpose: 
// **********************************************************************
#if UNITY_EDITOR
using System;

namespace UnityEngine.PostProcessing
{
    [Serializable]
    public class DebugViewModel : PostProcessingModel
    {
        public enum EViewType
        {
            None,
            OverDraw,
        }

        [Serializable]
        public struct Settings
        {
            public EViewType mViewType;

            public static Settings defaultSettings
            {
                get
                {
                    return new Settings() { mViewType = EViewType.None, };
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
#endif