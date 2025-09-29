// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ScriptableDataSettingBehaviour.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scriptable Settings Object Behaviour
// **********************************************************************
using System.Collections.Generic;
using UnityEngine;

public abstract class ScriptableDataSettingBehaviour : MonoBehaviour
{
    [SerializeField]
    //Components
    public List<ScriptableDataSettingComponentBase> mSettingList = 
        new List<ScriptableDataSettingComponentBase>(5);

    public void Start()
    {
        InitSettingList();

        ApplySettings();
    }

    public virtual void LateUpdate()
    {
        UpdateDynamicComponent();
    }

    protected virtual void InitSettingList()
    {

    }

    protected virtual void ApplySettings()
    {
        for (int i = 0; i < mSettingList.Count; ++i)
        {
            mSettingList[i].ApplySetting();
        }
    }

    protected virtual void UpdateDynamicComponent()
    {
        for (int i = 0; i < mSettingList.Count; ++i)
        {
            if (mSettingList[i].IsDyn)
            {
                mSettingList[i].LateUpdate();
            }
        }
    }

    protected T AddComponent<T>(T component)
         where T : ScriptableDataSettingComponentBase
    {
        mSettingList.Add(component);
        return component;
    }

    private void OnDestroy()
    {
        for (int i = 0; i < mSettingList.Count; ++i)
        {
            mSettingList[i].OnDestroy();
        }
    }
}
