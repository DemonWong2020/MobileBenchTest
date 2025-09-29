// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     ScriptableDataSettingModelEditorAttribute.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Scriptable Setting Model Editor Attribute
// **********************************************************************
using System;

public class ScriptableDataSettingModelEditorAttribute : Attribute
{
    public readonly Type mType;

    public ScriptableDataSettingModelEditorAttribute(Type type)
    {
        mType = type;
    }
}
