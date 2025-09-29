// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ScriptableDataSettingComponent.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scriptable Component Base Class, Static & Dynamic
// **********************************************************************
using System;
using UnityEngine;

[Serializable]
public abstract class ScriptableDataSettingComponentBase
{
    public abstract bool Active
    {
        get;
    }

    public virtual bool IsDyn
    {
        get
        {
            return false;
        }
    }

    protected Transform mTransform;

    public ScriptableDataSettingComponentBase(Transform trans)
    {
        mTransform = trans;
    }

    public virtual void OnEnable()
    { }

    public virtual void OnDisable()
    { }

    public virtual void LateUpdate()
    { }

    public virtual void ApplySetting()
    { }

    public virtual void OnDestroy()
    { }

    public abstract ScriptableDataSettingModel GetModel();
}

[Serializable]
public abstract class ScriptableDataSettingComponent<T> : ScriptableDataSettingComponentBase
    where T : ScriptableDataSettingModel
{
    public T mModel;

    public ScriptableDataSettingComponent(Transform trans)
        : base(trans)
    {

    }

    public virtual void Init(T pModel)
    {
        mModel = pModel;
    }

    public override ScriptableDataSettingModel GetModel()
    {
        return mModel;
    }
}

[Serializable]
public abstract class DynamicScriptableDataSettingComponent<T> : ScriptableDataSettingComponent<T> 
    where T : ScriptableDataSettingModel
{
    protected float mTimepass = 0;

    public override bool IsDyn
    {
        get
        {
            return true;
        }
    }

    public DynamicScriptableDataSettingComponent(Transform trans)
      : base(trans)
    {

    }
}
