// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     GetSetAttribute.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Get Set Data Drawer 
// **********************************************************************
using UnityEngine;

public sealed class GetSetAttribute : PropertyAttribute
{
    public readonly string mName;
    public bool mDirty;

    public GetSetAttribute(string name)
    {
        this.mName = name;
    }
}
