// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     EnvShadowComponent.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2023-07-27
// Purpose: 
// **********************************************************************
using UnityEngine;
using UnityEngine.Rendering;

public class EnvShadowComponent : DynamicScriptableDataSettingComponent<EnvShadowModel>
{
    public override bool Active
    {
        get { return mModel.Enable; }
    }

    private const int SHADOW_TEXTURE_SIZE = 2048;

    private Material mBlurShadowMat;

    private RenderTexture mRealShadow;
    private RenderTexture mBlurShadow;
    private RenderTexture mMixShadow;

    private CommandBuffer mCommandBuffer;

    public EnvShadowComponent(Transform trans)
        : base(trans)
    {

    }

    public override void Init(EnvShadowModel pModel)
    {
        base.Init(pModel);

        var shader = Shader.Find("Teon2/Shadow/Blur");
        mBlurShadowMat = new Material(shader);
        mBlurShadowMat.hideFlags = HideFlags.HideAndDontSave;
        InitLightEvent();
    }

    private void OnChangeScene()
    {
        if (null != mCommandBuffer)
        {
            mModel.pSettings.mMainLight.RemoveCommandBuffer(LightEvent.AfterShadowMap, mCommandBuffer);
            mCommandBuffer.Clear();
            mCommandBuffer.Release();
            mCommandBuffer = null;
        }

        mBlurShadowMat = null;
    }

    public override void OnDestroy()
    {
        base.OnDestroy();

        if (null != mRealShadow)
        {
            RenderTexture.ReleaseTemporary(mRealShadow);
            mRealShadow = null;
        }

        if (null != mBlurShadow)
        {
            RenderTexture.ReleaseTemporary(mBlurShadow);
            mBlurShadow = null;
        }

        if (null != mMixShadow)
        {
            RenderTexture.ReleaseTemporary(mMixShadow);
            mMixShadow = null;
        }
    }

#if UNITY_EDITOR
    public override void LateUpdate()
    {
        base.LateUpdate();
        if (null != mBlurShadowMat)
        {
            mBlurShadowMat.SetFloat("_MainAlpha", mModel.pSettings.mShaodowSetting.mMainShadowAtten);
            mBlurShadowMat.SetFloat("_AttenAlpha", mModel.pSettings.mShaodowSetting.mAttenShadowAtten);
            mBlurShadowMat.SetVector("_ShadowOffset", mModel.pSettings.mShaodowSetting.mShadowOffset);
            Shader.SetGlobalColor("_ShadowColor", mModel.pSettings.mShaodowSetting.mShadowColor);
        }
    }
#endif

    private void InitLightEvent()
    {
        if(null != mModel.pSettings.mMainLight)
        {
            var shadowMap = BuiltinRenderTextureType.CurrentActive;
            mRealShadow = RenderTexture.GetTemporary(SHADOW_TEXTURE_SIZE, SHADOW_TEXTURE_SIZE, 0);
            mCommandBuffer = new CommandBuffer();
            mCommandBuffer.name = "BlurShadow";
            mCommandBuffer.SetShadowSamplingMode(shadowMap, ShadowSamplingMode.RawDepth);
            mCommandBuffer.Blit(shadowMap, mRealShadow);

            mBlurShadowMat.SetFloat("_MainAlpha", mModel.pSettings.mShaodowSetting.mMainShadowAtten);
            mBlurShadowMat.SetFloat("_AttenAlpha", mModel.pSettings.mShaodowSetting.mAttenShadowAtten);
            mBlurShadowMat.SetVector("_ShadowOffset", mModel.pSettings.mShaodowSetting.mShadowOffset);

            //裁剪阴影
            mBlurShadowMat.SetTexture("_MainTex", mRealShadow);
            mBlurShadow = RenderTexture.GetTemporary(SHADOW_TEXTURE_SIZE, SHADOW_TEXTURE_SIZE, 0);
            mCommandBuffer.Blit(mRealShadow, mBlurShadow, mBlurShadowMat, 0);
            //一次模糊
            mBlurShadowMat.SetTexture("_MainTex", mBlurShadow);
            mMixShadow = RenderTexture.GetTemporary(SHADOW_TEXTURE_SIZE, SHADOW_TEXTURE_SIZE, 0);
            mCommandBuffer.Blit(mBlurShadow, mMixShadow, mBlurShadowMat, 1);
            ////二次模糊+主阴影
            mBlurShadowMat.SetTexture("_MainTex", mMixShadow);
            mBlurShadowMat.SetTexture("_MainShadow", mBlurShadow);
            mCommandBuffer.Blit(mMixShadow, mRealShadow, mBlurShadowMat, 2);

            Shader.SetGlobalTexture("_ShadowMap", mRealShadow);//bind shadowmap
            Shader.SetGlobalColor("_ShadowColor", mModel.pSettings.mShaodowSetting.mShadowColor);

            mModel.pSettings.mMainLight.AddCommandBuffer(LightEvent.AfterShadowMap, mCommandBuffer);

            mModel.pSettings.mMainLight.shadowNormalBias = 0;
        }
    }
}