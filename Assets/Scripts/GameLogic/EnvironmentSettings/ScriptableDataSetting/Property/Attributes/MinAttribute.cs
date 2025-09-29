// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     MinAttribute.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Min Data Drawer 
// **********************************************************************
using UnityEngine;

public sealed class MinAttribute : PropertyAttribute
{
    public readonly float mMin;

    public MinAttribute(float min)
    {
        mMin = min;
    }
}
