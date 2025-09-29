// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     Env_Light.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scene Setting Dynamic Light Color
// **********************************************************************
using System;
using UnityEngine;

public class EnvLightComponent : DynamicScriptableDataSettingComponent<EnvLightModel>
{
    private static readonly int Shader_DrakPower = Shader.PropertyToID("_DrakPower");
    private static readonly int Shader_MinDrak = Shader.PropertyToID("_Min");
    private static readonly int Shader_Main_Color = Shader.PropertyToID("_MainColor");

    public override bool Active
    {
        get { return mModel.Enable; }
    }

    private int mCurrentLightIndex = 0;
    private int mLastLightIndex = 0;
    //tmp Test
    private float mCurrentTime = 0;

    private Color mCurrentUnexploredColor;
    private Color mCurrentExploredColor;
    private float mFadeTimePass = 0;

    private float mCurrenDark;
    private float mTargetDark;
    private float mCurrentMinDark;
    private float mTargetMinDark;
    private Color mCurrentColor;
    private Color mTargetColor;

    public EnvLightComponent(Transform trans)
        : base(trans)
    {

    }

    public override void Init(EnvLightModel pModel)
    {
        base.Init(pModel);

        if (mModel.pSettings.mAlwaysOneLight)
        {
            var setting = mModel.pSettings.mDefaultLight;
            mModel.pSettings.mMainLight.color = setting.mLightColor;
            mTargetDark = setting.mDrakPower;
            mTargetMinDark = setting.mMinDark;
            mTargetColor = setting.mFogColor;
        }
        else
        {
            var setting = mModel.pSettings.mDynLights[mCurrentLightIndex];
            mTargetDark = setting.mDrakPower;
            mTargetMinDark = setting.mMinDark;
            mTargetColor = setting.mFogColor;
        }
    }

    public override void LateUpdate()
    {
        if (mModel.pSettings.mAlwaysOneLight)
        {
            return;
        }
        base.LateUpdate();
        float deltaTime = Time.deltaTime;


        float process;
        EnvLightModel.LightSetting mStartSetting = mModel.pSettings.mDynLights[mCurrentLightIndex];
        EnvLightModel.LightSetting mEndSetting = mModel.pSettings.mDynLights[(mCurrentLightIndex + 1) % mModel.pSettings.mDynLights.Length];


        mCurrentTime += deltaTime * mStartSetting.mSpeedMul;

        process = (mCurrentTime - mStartSetting.mStayTime * mStartSetting.mSpeedMul) / 20f;
        mModel.pSettings.mMainLight.color = Color.Lerp(mStartSetting.mLightColor,
                                             mEndSetting.mLightColor,
                                             process);


        mTargetColor = Color.Lerp(mStartSetting.mFogColor,
                                                   mEndSetting.mFogColor,
                                                    process);
        mTargetDark = Mathf.Lerp(mStartSetting.mDrakPower,
                                     mEndSetting.mDrakPower,
                                     process);

        mTargetMinDark = Mathf.Lerp(mStartSetting.mMinDark,
                                   mEndSetting.mMinDark,
                                   process);


        mCurrenDark = Mathf.Lerp(mCurrenDark, mTargetDark, deltaTime * 2);
        mCurrentMinDark = Mathf.Lerp(mCurrentMinDark, mTargetMinDark, deltaTime * 2);
        mCurrentColor = Color.Lerp(mCurrentColor, mTargetColor, deltaTime * 2);
    }
}
