// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ScriptableDataSettingModel.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scriptable Data Setting Model For Edit Some Behaviour Settings
// **********************************************************************
using UnityEngine;

[SerializeField]
public abstract class ScriptableDataSettingModel
{
    [SerializeField]
    bool mEnable;

    public bool Enable
    {
        get { return mEnable; }
        set
        {
            if(mEnable != value)
            {
                mEnable = value;

                if(value)
                {
                    OnValidate();
                }
            }
        }
    }

    public abstract void Reset();

    public virtual void OnValidate()
    {

    }
}
