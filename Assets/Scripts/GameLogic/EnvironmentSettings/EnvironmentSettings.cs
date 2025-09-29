// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     EnvironmentSettings.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-25
// Purpose:      Environment Settings
// **********************************************************************
using UnityEngine;

public class EnvironmentSettings : ScriptableDataSettingBehaviour
{
    [SerializeField]
    public EnvLightModel mLightModel;

    private EnvLightComponent mLightComponent;
    public EnvLightComponent pLightComponent { get { return mLightComponent; } }

    [SerializeField]
    public EnvShadowModel mShadowModel;

    private EnvShadowComponent mShadowComponent;
    public EnvShadowComponent pShadowComponent { get { return mShadowComponent; } }

    protected override void InitSettingList()
    {
        base.InitSettingList();
  
        mLightComponent = AddComponent(new EnvLightComponent(transform));
        mLightComponent.Init(mLightModel);

        mShadowComponent = AddComponent(new EnvShadowComponent(transform));
        mShadowComponent.Init(mShadowModel);
    }
}
