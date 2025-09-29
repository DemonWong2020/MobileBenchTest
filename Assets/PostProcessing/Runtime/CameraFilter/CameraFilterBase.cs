// **********************************************************************
// Copyright(C) by Lakoo
// FileName:     CameraFilterBase.cs
// Author:       Demon
// UnityVersion：2019.4.39f1
// Date:         2024-11-14
// Purpose: 
// **********************************************************************
using UnityEngine.Rendering;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace UnityEngine.PostProcessing
{
    [System.Serializable]
    public class CameraFilterBase
    {
        public const float DelayShowTime = 0.5f;
        public delegate void OnDelayEnd(CameraFilterBase cameraFilter);
        public virtual string ShaderName { get; }
        protected PostProcessingContext Context;

        public Material Mat;
        public bool mIsDelayShow = false;
        public float mFromValue = 0f;
        public float mToValue = 1f;

        public OnDelayEnd mCallback;

        protected bool mEnable = false;
        public bool enable
        {
            get
            {
                if (mIsDelayShow)
                {
                    if (mDelayShow || mEnable)
                    {
                        return true;
                    }
                }
                else
                {
                    if (mEnable)
                    {
                        return true;
                    }
                }
                return false;
            }
            set
            {
                if (mEnable != value)
                {
                    mEnable = value;
                    mDelayShow = mIsDelayShow ? true : false;
                    if (mDelayShow)
                    {
                        mDelayFrom = mEnable ? mFromValue : mToValue;
                        mDelayTo = mEnable ? mToValue : mFromValue;
                        mDelayTime = 0;
                    }

                    if (value)
                    {
                        OnEnable();
                    }
                    else
                    {
                        OnDisable();
                    }
                }
            }
        }

        public bool mDelayShow = false;
        protected float mDelayFrom = 0f;
        protected float mDelayTo = 0f;
        protected float mDelayTime = 0f;

        public int order = 0;

        protected float mTimeX = 0;

        public void Init(PostProcessingContext context, OnDelayEnd callback)
        {
            Context = context;
            mCallback = callback;
            if (null != Context)
            {
                Internal_Init();
            }
        }

        protected virtual void OnEnable()
        {
            mTimeX = 0;
        }

        protected virtual void OnDisable()
        {

        }

        public void PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {
            if ((!enable && !mDelayShow) || null == Mat)
            {
                return;
            }

            if (mDelayShow)
            {
                UpdateDelayState();
            }

            mTimeX += Time.deltaTime;
            if (mTimeX > 100)
            {
                mTimeX = 0;
            }

            Internal_PopulateCommandBuffer(cb, srcTexture, dstTexture);
        }

        protected virtual void Internal_Init()
        {

        }

        protected virtual void Internal_PopulateCommandBuffer(CommandBuffer cb, int srcTexture, int dstTexture)
        {

        }

        protected virtual void UpdateDelayState()
        {
            mDelayTime += Time.deltaTime;
            if (mDelayTime >= DelayShowTime)
            {
                mDelayShow = false;
                mCallback?.Invoke(this);
            }
        }

#if UNITY_EDITOR
        private bool mFolderOut = false;
        protected const int FolderSpace = 50;

        public void OnGUI()
        {
            if (enable)
            {
                EditorGUILayout.BeginHorizontal();
                var newEnable = EditorGUILayout.Toggle(string.Empty, enable, GUILayout.MaxWidth(30));
                if (newEnable != enable)
                {
                    Undo.RecordObject(Context.profile, "Switch CameraFilter");
                    enable = newEnable;
                    EditorUtility.SetDirty(Context.profile);
                }
                GUILayout.Space(10);
                mFolderOut = EditorGUILayout.Foldout(mFolderOut, GetType().Name, true);
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                GUILayout.Label("Order", GUILayout.Width(40));
                if (GUILayout.Button("-", GUILayout.Width(25)))
                {
                    Undo.RecordObject(Context.profile, "Update CameraFilter Order");
                    --order;
                    EditorUtility.SetDirty(Context.profile);
                }
                GUILayout.Label($"{order}", new GUIStyle() { normal = new GUIStyleState() { textColor = Color.white }, alignment = TextAnchor.UpperCenter }, GUILayout.Width(25));
                if (GUILayout.Button("+", GUILayout.Width(25)))
                {
                    Undo.RecordObject(Context.profile, "Update CameraFilter Order");
                    ++order;
                    EditorUtility.SetDirty(Context.profile);
                }
                if (GUILayout.Button("Reset", GUILayout.Width(60)))
                {
                    Undo.RecordObject(Context.profile, "Update CameraFilter Order");
                    order = 0;
                    EditorUtility.SetDirty(Context.profile);
                }
                EditorGUILayout.EndHorizontal();
                if (mFolderOut)
                {
                    ToggleLeft("延时激活", ref mIsDelayShow);
                    if (mIsDelayShow)
                    {
                        Slider("淡入初始值", ref mFromValue, 0f, 1f);
                        Slider("淡出初始值", ref mToValue, 0f, 1f);
                    }
                    Internal_DrawGUI();
                }
            }
            else
            {
                var newEnable = EditorGUILayout.ToggleLeft(GetType().Name, enable);
                if (newEnable != enable)
                {
                    Undo.RecordObject(Context.profile, "Switch CameraFilter");
                    enable = newEnable;
                    EditorUtility.SetDirty(Context.profile);
                }
            }
        }

        protected virtual void Internal_DrawGUI()
        {

        }

        //Utils
        protected void ToggleLeft(string displayName, ref bool value)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Space(FolderSpace);
            var newValue = EditorGUILayout.Toggle(displayName, value);
            if (newValue != value)
            {
                Undo.RecordObject(Context.profile, displayName);
                value = newValue;
                EditorUtility.SetDirty(Context.profile);
            }
            GUILayout.EndHorizontal();
        }

        protected void Slider(string displayName, ref float value, float minVal, float maxVal)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Space(FolderSpace);
            var newValue = EditorGUILayout.Slider(displayName, value, minVal, maxVal);
            if (newValue != value)
            {
                Undo.RecordObject(Context.profile, displayName);
                value = newValue;
                EditorUtility.SetDirty(Context.profile);
            }
            GUILayout.EndHorizontal();
        }

        protected void ColorFiled(string displayName, ref Color value)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Space(FolderSpace);
            var newValue = EditorGUILayout.ColorField(displayName, value);
            if (newValue != value)
            {
                Undo.RecordObject(Context.profile, displayName);
                value = newValue;
                EditorUtility.SetDirty(Context.profile);
            }
            GUILayout.EndHorizontal();
        }
#endif
    }
}
