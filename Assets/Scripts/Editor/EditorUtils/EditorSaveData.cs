// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     EditorSaveData.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-02-21
// Purpose: 
// **********************************************************************
using UnityEditor;
using UnityEngine;


public static class EditorSaveData
{
    public const string AssetJsonCPath = "AssetCSVPath";
    public const string AssetJsonPath = "AssetJsonPath";

    public static string mJsonCPath = string.Empty;
    public static string pJsonCPath { get { return mJsonCPath; } }

    public static string mJsonPath = string.Empty;
    public static string pJsonPath { get { return mJsonPath; } }

    static EditorSaveData()
    {
        mJsonCPath = PlayerPrefs.GetString(AssetJsonCPath);

        mJsonPath = PlayerPrefs.GetString(AssetJsonPath);
    }
}