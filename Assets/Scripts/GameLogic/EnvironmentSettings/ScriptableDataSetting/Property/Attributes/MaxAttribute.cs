// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     MaxAttribute.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Max Data Drawer 
// **********************************************************************
using UnityEngine;

public sealed class MaxAttribute : PropertyAttribute
{
    public readonly float mMax;

    public MaxAttribute(float max)
    {
        mMax = max;
    }
}
