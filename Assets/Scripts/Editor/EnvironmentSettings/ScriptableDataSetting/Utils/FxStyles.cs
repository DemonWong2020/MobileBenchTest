// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     FxStyles.cs
// Author:       Demon
// UnityVersion：2019.4.6f1
// Date:         2020-08-26
// Purpose:      Editor Styles Define
// **********************************************************************
using UnityEngine;
using UnityEditor;

public static class FxStyles
{
    public static GUIStyle mTickStyleRight;
    public static GUIStyle mTickStyleLeft;
    public static GUIStyle mTickStyleCenter;

    public static GUIStyle mPreSlider;
    public static GUIStyle mPreSliderThumb;
    public static GUIStyle mPreButton;
    public static GUIStyle mPreDropdown;

    public static GUIStyle mPreLabel;
    public static GUIStyle mHueCenterCursor;
    public static GUIStyle mHueRangeCursor;

    public static GUIStyle mCenteredBoldLabel;
    public static GUIStyle mWheelThumb;
    public static Vector2 mWheelThumbSize;

    public static GUIStyle mHeader;
    public static GUIStyle mHeaderCheckbox;
    public static GUIStyle mHeaderFoldout;

    public static Texture2D mPlayIcon;
    public static Texture2D mCheckerIcon;
    public static Texture2D mPaneOptionsIcon;

    public static GUIStyle mCenteredMiniLabel;

    static FxStyles()
    {
        mTickStyleRight = new GUIStyle("Label")
        {
            alignment = TextAnchor.MiddleRight,
            fontSize = 9
        };

        mTickStyleLeft = new GUIStyle("Label")
        {
            alignment = TextAnchor.MiddleLeft,
            fontSize = 9
        };

        mTickStyleCenter = new GUIStyle("Label")
        {
            alignment = TextAnchor.MiddleCenter,
            fontSize = 9
        };

        mPreSlider = new GUIStyle("PreSlider");
        mPreSliderThumb = new GUIStyle("PreSliderThumb");
        mPreButton = new GUIStyle("PreButton");
        mPreDropdown = new GUIStyle("preDropdown");

        mPreLabel = new GUIStyle("ShurikenLabel");

        mHueCenterCursor = new GUIStyle("ColorPicker2DThumb")
        {
            normal = { background = (Texture2D)EditorGUIUtility.LoadRequired("Builtin Skins/DarkSkin/Images/ShurikenPlus.png") },
            fixedWidth = 6,
            fixedHeight = 6
        };

        mHueRangeCursor = new GUIStyle(mHueCenterCursor)
        {
            normal = { background = (Texture2D)EditorGUIUtility.LoadRequired("Builtin Skins/DarkSkin/Images/CircularToggle_ON.png") }
        };

        mWheelThumb = new GUIStyle("ColorPicker2DThumb");

        mCenteredBoldLabel = new GUIStyle(GUI.skin.GetStyle("Label"))
        {
            alignment = TextAnchor.UpperCenter,
            fontStyle = FontStyle.Bold
        };

        mCenteredMiniLabel = new GUIStyle(EditorStyles.centeredGreyMiniLabel)
        {
            alignment = TextAnchor.UpperCenter
        };

        mWheelThumbSize = new Vector2(
                !Mathf.Approximately(mWheelThumb.fixedWidth, 0f) ? mWheelThumb.fixedWidth : mWheelThumb.padding.horizontal,
                !Mathf.Approximately(mWheelThumb.fixedHeight, 0f) ? mWheelThumb.fixedHeight : mWheelThumb.padding.vertical
                );

        mHeader = new GUIStyle("ShurikenModuleTitle")
        {
            font = (new GUIStyle("Label")).font,
            border = new RectOffset(15, 7, 4, 4),
            fixedHeight = 22,
            contentOffset = new Vector2(20f, -2f)
        };

        mHeaderCheckbox = new GUIStyle("ShurikenCheckMark");
        mHeaderFoldout = new GUIStyle("Foldout");

        mPlayIcon = (Texture2D)EditorGUIUtility.LoadRequired("Builtin Skins/DarkSkin/Images/IN foldout act.png");
        mCheckerIcon = (Texture2D)EditorGUIUtility.LoadRequired("Icons/CheckerFloor.png");

        if (EditorGUIUtility.isProSkin)
        {
            mPaneOptionsIcon = (Texture2D)EditorGUIUtility.LoadRequired("Builtin Skins/DarkSkin/Images/pane options.png");
        }
        else
        {
            mPaneOptionsIcon = (Texture2D)EditorGUIUtility.LoadRequired("Builtin Skins/LightSkin/Images/pane options.png");
        }
    }
}
