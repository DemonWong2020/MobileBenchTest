using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Runtime.Serialization;
using UnityEditor;
using UnityEditor.IMGUI.Controls;
using UnityEngine;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

public static class EditorUtils
{
    private static GUIStyle mHeader;

    private static GUIStyle mBlocker;

    private static GUIStyle mBlockButton;

    private static BoxBoundsHandle mBoxBoundsHandle = new BoxBoundsHandle();

    private static SphereBoundsHandle mSphereBoundsHandle = new SphereBoundsHandle();

    private static Dictionary<string, GUIContent> mGUIContentCache;

    static EditorUtils()
    {
        if(Application.isBatchMode)
        {
            return;
        }

        mHeader = new GUIStyle(EditorStyles.helpBox) { richText = true, alignment = TextAnchor.MiddleCenter, fontSize = 20 };

        mBlocker = new GUIStyle(EditorStyles.helpBox) { richText = true, alignment = TextAnchor.MiddleCenter, fontSize = 40 };

        mBlockButton = new GUIStyle(GUI.skin.button) { richText = true, alignment = TextAnchor.MiddleCenter, fontSize = 20 };

        mGUIContentCache = new Dictionary<string, GUIContent>();
    }

    public static bool DrawBlockerButton(string text, int height = 400)
    {
        return GUILayout.Button(text, mBlockButton, GUILayout.Height(height));
    }

    public static void DrawSelectAssetLabelButton(string format, string text, string assetPath)
    {
        if(string.IsNullOrEmpty(text))
        {
            text = assetPath + "(Missing)";
        }

        if (GUILayout.Button(string.Format(format, text), EditorStyles.label))
        {
            Selection.activeObject = (AssetDatabase.LoadAssetAtPath(assetPath, typeof(Object)));
        }
    }

    public static void DrawHeader(string text)
    {
        GUILayout.Label(text, mHeader);
    }

    public static void DrawBlocker(string text)
    {
        GUILayout.Label(text, mBlocker, GUILayout.Height(300));
    }

    public static void DrawHorizontalLine()
    {
        EditorGUILayout.TextField(string.Empty, GUI.skin.horizontalSlider);
    }

    public static void DrawVerticalLine()
    {
        EditorGUILayout.TextField(string.Empty, GUI.skin.verticalSlider, GUILayout.MaxWidth(5));
    }

    public static Texture2D HorizontalFlipTexture(Texture2D texture)
    {
        //得到图片的宽高
        int width = texture.width;
        int height = texture.height;

        Texture2D flipTexture = new Texture2D(width, height);

        for (int i = 0; i < width; i++)
        {
            flipTexture.SetPixels(i, 0, 1, height, texture.GetPixels(width - i - 1, 0, 1, height));
        }
        flipTexture.Apply();

        return flipTexture;
    }

    // 垂直翻转
    public static Texture2D VerticalFlipTexture(Texture2D texture)
    {
        //得到图片的宽高
        int width = texture.width;
        int height = texture.height;

        Texture2D flipTexture = new Texture2D(width, height);
        for (int i = 0; i < height; i++)
        {
            flipTexture.SetPixels(0, i, width, 1, texture.GetPixels(0, height - i - 1, width, 1));
        }
        flipTexture.Apply();

        return flipTexture;
    }

    public static string GetGameObjectPath(Transform transform)
    {
        string path = transform.name;
        while (transform.parent != null)
        {
            transform = transform.parent;
            path = transform.name + "/" + path;
        }
        return path;
    }

    public static string GetCurrentScenePath(out string sceneName)
    {
        var scene = SceneManager.GetActiveScene();
        var path = Path.GetDirectoryName(scene.path);
        sceneName = scene.name;
        return path;
    }

    public static Object FindObjectFromInstanceID(int iid)
    {
        return (Object)typeof(Object)
                .GetMethod("FindObjectFromInstanceID", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static)
                .Invoke(null, new object[] { iid });
    }

    public static bool Header(string title, SerializedProperty group, Action resetAction)
    {
        var rect = GUILayoutUtility.GetRect(16f, 22f, FxStyles.mHeader);
        GUI.Box(rect, title, FxStyles.mHeader);

        var display = group == null || group.isExpanded;

        var foldoutRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
        var e = Event.current;

        var popupRect = new Rect(rect.x + rect.width - FxStyles.mPaneOptionsIcon.width - 5f, rect.y + FxStyles.mPaneOptionsIcon.height / 2f + 1f, FxStyles.mPaneOptionsIcon.width, FxStyles.mPaneOptionsIcon.height);
        GUI.DrawTexture(popupRect, FxStyles.mPaneOptionsIcon);

        if (e.type == EventType.Repaint)
            FxStyles.mHeaderFoldout.Draw(foldoutRect, false, false, display, false);

        if (e.type == EventType.MouseDown)
        {
            //if (popupRect.Contains(e.mousePosition))
            //{
            //    var popup = new GenericMenu();
            //    popup.AddItem(GetContent("Reset"), false, () => resetAction());
            //    popup.AddSeparator(string.Empty);
            //    popup.AddItem(GetContent("Copy Settings"), false, () => CopySettings(group));

            //    if (CanPaste(group))
            //        popup.AddItem(GetContent("Paste Settings"), false, () => PasteSettings(group));
            //    else
            //        popup.AddDisabledItem(GetContent("Paste Settings"));

            //    popup.ShowAsContext();
            //}
            //else 
            if (rect.Contains(e.mousePosition) && group != null)
            {
                display = !display;

                if (group != null)
                    group.isExpanded = !group.isExpanded;

                e.Use();
            }
        }

        return display;
    }

    public static GUIContent GetContent(string textAndTooltip)
    {
        if (string.IsNullOrEmpty(textAndTooltip))
            return GUIContent.none;

        GUIContent content;

        if (!mGUIContentCache.TryGetValue(textAndTooltip, out content))
        {
            var s = textAndTooltip.Split('|');
            content = new GUIContent(s[0]);

            if (s.Length > 1 && !string.IsNullOrEmpty(s[1]))
                content.tooltip = s[1];

            mGUIContentCache.Add(textAndTooltip, content);
        }

        return content;
    }

    public static bool Header(string title, SerializedProperty group, SerializedProperty enabledField, Action resetAction)
    {
        var field = ReflectionUtils.GetFieldInfoFromPath(enabledField.serializedObject.targetObject, enabledField.propertyPath);
        object parent = null;
        PropertyInfo prop = null;

        if (field != null && field.IsDefined(typeof(GetSetAttribute), false))
        {
            var attr = (GetSetAttribute)field.GetCustomAttributes(typeof(GetSetAttribute), false)[0];
            parent = ReflectionUtils.GetParentObject(enabledField.propertyPath, enabledField.serializedObject.targetObject);
            prop = parent.GetType().GetProperty(attr.mName);
        }

        var display = group == null || group.isExpanded;
        var enabled = enabledField.boolValue;

        var rect = GUILayoutUtility.GetRect(16f, 22f, FxStyles.mHeader);
        GUI.Box(rect, title, FxStyles.mHeader);

        var toggleRect = new Rect(rect.x + 4f, rect.y + 4f, 13f, 13f);
        var e = Event.current;

        var popupRect = new Rect(rect.x + rect.width - FxStyles.mPaneOptionsIcon.width - 5f, rect.y + 2, FxStyles.mPaneOptionsIcon.width, FxStyles.mPaneOptionsIcon.height);
        GUI.DrawTexture(popupRect, FxStyles.mPaneOptionsIcon);

        if (e.type == EventType.Repaint)
            FxStyles.mHeaderCheckbox.Draw(toggleRect, false, false, enabled, false);

        if (e.type == EventType.MouseDown)
        {
            const float kOffset = 2f;
            toggleRect.x -= kOffset;
            toggleRect.y -= kOffset;
            toggleRect.width += kOffset * 2f;
            toggleRect.height += kOffset * 2f;

            if (toggleRect.Contains(e.mousePosition))
            {
                enabledField.boolValue = !enabledField.boolValue;

                if (prop != null)
                    prop.SetValue(parent, enabledField.boolValue, null);

                e.Use();
            }
            else if (popupRect.Contains(e.mousePosition))
            {
                var popup = new GenericMenu();
                popup.AddItem(GetContent("Reset"), false, () => resetAction());
                popup.AddSeparator(string.Empty);
                //popup.AddItem(GetContent("Copy Settings"), false, () => CopySettings(group));

                if (CanPaste(group))
                    popup.AddItem(GetContent("Paste Settings"), false, () => PasteSettings(group));
                else
                    popup.AddDisabledItem(GetContent("Paste Settings"));

                popup.ShowAsContext();
            }
            else if (rect.Contains(e.mousePosition) && group != null)
            {
                display = !display;
                group.isExpanded = !group.isExpanded;
                e.Use();
            }
        }

        return display;
    }

    static bool CanPaste(SerializedProperty settings)
    {
        var data = EditorGUIUtility.systemCopyBuffer;

        if (string.IsNullOrEmpty(data))
            return false;

        var parts = data.Split('|');

        if (string.IsNullOrEmpty(parts[0]))
            return false;

        var field = ReflectionUtils.GetFieldInfoFromPath(settings.serializedObject.targetObject, settings.propertyPath);
        return parts[0] == field.FieldType.ToString();
    }

    static void PasteSettings(SerializedProperty settings)
    {
        Undo.RecordObject(settings.serializedObject.targetObject, "Paste effect settings");
        var field = ReflectionUtils.GetFieldInfoFromPath(settings.serializedObject.targetObject, settings.propertyPath);
        var json = EditorGUIUtility.systemCopyBuffer.Substring(field.FieldType.ToString().Length + 1);
        var obj = JsonUtility.FromJson(json, field.FieldType);
        var parent = ReflectionUtils.GetParentObject(settings.propertyPath, settings.serializedObject.targetObject);
        field.SetValue(parent, obj, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, CultureInfo.CurrentCulture);
    }

    public static void BoxBoundsHandle(Vector3 center, Quaternion rotation, Vector3 size, ref Vector3 boxSize) { BoxBoundsHandle(center, rotation, size, ref boxSize, PrimitiveBoundsHandle.Axes.All); }
    public static void BoxBoundsHandle(Vector3 center, Quaternion rotation, Vector3 size, ref Vector3 boxSize, PrimitiveBoundsHandle.Axes handleAxes) { BoxBoundsHandle(center, rotation, size, ref boxSize, handleAxes, mBoxBoundsHandle.wireframeColor, mBoxBoundsHandle.handleColor); }
    public static void BoxBoundsHandle(Vector3 center, Quaternion rotation, Vector3 size, ref Vector3 boxSize, PrimitiveBoundsHandle.Axes handleAxes, Color wireframeColor, Color handleColor)
    {
        Matrix4x4 trs = Matrix4x4.TRS(center, rotation, size);

        using (new Handles.DrawingScope(trs))
        {
            mBoxBoundsHandle.axes = handleAxes;
            mBoxBoundsHandle.size = boxSize;
            mBoxBoundsHandle.handleColor = handleColor;
            mBoxBoundsHandle.wireframeColor = wireframeColor;
            mBoxBoundsHandle.DrawHandle();
            boxSize = mBoxBoundsHandle.size;
        }
    }

    public static void SphereBoundsHandle(Vector3 center, Quaternion rotation, Vector3 size, ref float radius) { SphereBoundsHandle(center, rotation, size, ref radius, PrimitiveBoundsHandle.Axes.All); }
    public static void SphereBoundsHandle(Vector3 center, Quaternion rotation, Vector3 size, ref float radius, PrimitiveBoundsHandle.Axes handleAxes) { SphereBoundsHandle(center, rotation, size, ref radius, handleAxes, mBoxBoundsHandle.handleColor, mBoxBoundsHandle.wireframeColor); }
    public static void SphereBoundsHandle(Vector3 center, Quaternion rotation, Vector3 size, ref float radius, PrimitiveBoundsHandle.Axes handleAxes, Color handleColor, Color wireframeColor)
    {
        Matrix4x4 trs = Matrix4x4.TRS(center, rotation, size);

        using (new Handles.DrawingScope(trs))
        {
            mSphereBoundsHandle.radius = radius;

            mSphereBoundsHandle.axes = handleAxes;
            mSphereBoundsHandle.wireframeColor = wireframeColor;
            mSphereBoundsHandle.handleColor = handleColor;

            mSphereBoundsHandle.DrawHandle();

            radius = mSphereBoundsHandle.radius;
        }
    }

    public static List<GameObject> GetAllChildren(this GameObject Go)
    {
        List<GameObject> list = new List<GameObject>();
        for (int i = 0; i < Go.transform.childCount; i++)
        {
            list.Add(Go.transform.GetChild(i).gameObject);
        }
        return list;
    }

    public static string GetParentFullPath(this GameObject obj)
    {
        string path = string.Empty;
        while (obj.transform.parent != null)
        {
            if (obj.transform.parent.gameObject.transform.parent == null)
            {
                break;
            }

            obj = obj.transform.parent.gameObject;
            path = "/" + obj.name + path;
        }
        return path;
    }

    public static void DrawJsonCPath()
    {
        GUILayout.BeginVertical(EditorStyles.helpBox);
        GUILayout.BeginHorizontal();
        GUILayout.Label("JSONC文件夹路径：", GUILayout.Width(120));
        var newPath = EditorGUILayout.TextField(EditorSaveData.mJsonCPath);
        GUILayout.EndHorizontal();
        if (string.IsNullOrEmpty(newPath))
        {
            EditorGUILayout.HelpBox(@"JSONC文件夹路径不能为空！！！！路径为策划配置表目录下teon2-asset\Data\data的完整路径", MessageType.Warning);
        }
        else if (!EditorSaveData.mJsonCPath.Equals(newPath))
        {
            EditorSaveData.mJsonCPath = newPath.TrimEnd();
            PlayerPrefs.SetString(EditorSaveData.AssetJsonCPath, EditorSaveData.mJsonCPath);
            PlayerPrefs.Save();
        }
        GUILayout.EndVertical();
    }

    public static void DrawJsonPath()
    {
        GUILayout.BeginVertical(EditorStyles.helpBox);
        GUILayout.BeginHorizontal();
        GUILayout.Label("Json文件夹路径：", GUILayout.Width(120));
        var newPath = EditorGUILayout.TextField(EditorSaveData.mJsonPath);
        GUILayout.EndHorizontal();
        if (string.IsNullOrEmpty(newPath))
        {
            EditorGUILayout.HelpBox(@"Json文件夹路径不能为空！！！！路径为策划配置表目录下teon2-asset\Data\Json的完整路径", MessageType.Warning);
        }
        else if (!EditorSaveData.mJsonPath.Equals(newPath))
        {
            EditorSaveData.mJsonPath = newPath.TrimEnd();
            PlayerPrefs.SetString(EditorSaveData.AssetJsonPath, EditorSaveData.mJsonPath);
            PlayerPrefs.Save();
        }
        GUILayout.EndVertical();
    }

    public static Quaternion QuaternionFromMatrix(this Matrix4x4 m)
    {
        // Adapted from: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
        //Quaternion q = new Quaternion();
        //q.w = Mathf.Sqrt(Mathf.Max(0, 1 + m[0, 0] + m[1, 1] + m[2, 2])) / 2;
        //q.x = Mathf.Sqrt(Mathf.Max(0, 1 + m[0, 0] - m[1, 1] - m[2, 2])) / 2;
        //q.y = Mathf.Sqrt(Mathf.Max(0, 1 - m[0, 0] + m[1, 1] - m[2, 2])) / 2;
        //q.z = Mathf.Sqrt(Mathf.Max(0, 1 - m[0, 0] - m[1, 1] + m[2, 2])) / 2;
        //q.x *= Mathf.Sign(q.x * (m[2, 1] - m[1, 2]));
        //q.y *= Mathf.Sign(q.y * (m[0, 2] - m[2, 0]));
        //q.z *= Mathf.Sign(q.z * (m[1, 0] - m[0, 1]));
        //return q;
        Vector4 ret = m * new Vector4(0, 0, 0, 1);
        return new Quaternion(ret.x, ret.y, ret.z, ret.w);
    }

    public static Vector3 PositionFromMatrix(this Matrix4x4 m)
    {
        return m.GetColumn(3);
    }

    public static Texture2D ToSize(this Texture2D src, int width, int height)
    {
        var ret = new Texture2D(width, height, src.format, false);

        for(int i = 0; i <height; ++i)
        {
            for(int j = 0; j <width; ++j)
            {
                Color pixel = src.GetPixelBilinear((float)j / (float)width, (float)i / (float)height);
                ret.SetPixel(j, i, pixel);
            }
        }
        ret.Apply();
        return ret;
    }
}
