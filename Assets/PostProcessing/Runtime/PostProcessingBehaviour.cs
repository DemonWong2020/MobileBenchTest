using System;
using System.Collections.Generic;
using UnityEngine.Rendering;
using static UnityEngine.PlayerLoop.PostLateUpdate;

namespace UnityEngine.PostProcessing
{
#if UNITY_5_4_OR_NEWER
    [ImageEffectAllowedInSceneView]
#endif
    [RequireComponent(typeof(Camera)), DisallowMultipleComponent, ExecuteInEditMode]
    [AddComponentMenu("Effects/Post-Processing Behaviour", -1)]
    public class PostProcessingBehaviour : MonoBehaviour
    {
        // Inspector fields
        public PostProcessingProfile profile;

        // Internal helpers
        private Dictionary<Type, KeyValuePair<CameraEvent, CommandBuffer>> mCommandBuffers;
        private List<PostProcessingComponentBase> mComponents;
        private Dictionary<PostProcessingComponentBase, bool> mComponentStates;

        private MaterialFactory mMaterialFactory;
        private RenderTextureFactory mRenderTextureFactory;
        private PostProcessingContext mContext;
        private Camera mCamera;

        // Effect components
        private AmbientOcclusionComponent mAmbientOcclusion;
        private BloomComponent mBloom;
        private GrabComponent mGrab;
        private DepthModeComponent mDepthMode;
        private FogComponent mFog;
        private GreyComponent mGrey;
        private CameraFilterComponent mCameraFilter;

#if UNITY_EDITOR
        private DebugViewComponent mDebugView;
#endif

        private bool mRenderingInSceneView = false;

        private RenderTexture mTargetTexture;

        void OnEnable()
        {
            mCommandBuffers = new Dictionary<Type, KeyValuePair<CameraEvent, CommandBuffer>>();
            mMaterialFactory = new MaterialFactory();
            mRenderTextureFactory = new RenderTextureFactory();
            if (null == mCamera)
            {
                mCamera = GetComponent<Camera>();
            }

            mContext = new PostProcessingContext()
            {
                profile = profile,
                renderTextureFactory = mRenderTextureFactory,
                materialFactory = mMaterialFactory,
                camera = mCamera
            };

            // Keep a list of all post-fx for automation purposes
            mComponents = new List<PostProcessingComponentBase>();

            // Component list
            mAmbientOcclusion = AddComponent(new AmbientOcclusionComponent());
            mBloom = AddComponent(new BloomComponent());
            //mGrab = AddComponent(new GrabComponent());
            mDepthMode = AddComponent(new DepthModeComponent());
            mFog = AddComponent(new FogComponent());
            mGrey = AddComponent(new GreyComponent());

            mCameraFilter = AddComponent(new CameraFilterComponent());
#if UNITY_EDITOR
            mDebugView = AddComponent(new DebugViewComponent());
#endif
            // Prepare state observers
            mComponentStates = new Dictionary<PostProcessingComponentBase, bool>();

            foreach (var component in mComponents)
                mComponentStates.Add(component, false);

            //Update GlobalSettings


#if !UNITY_EDITOR
            mCameraFilter.Init(mContext, profile.cameraFilterModel);
            mAmbientOcclusion.Init(mContext, profile.ambientOcclusion);
            mBloom.Init(mContext, profile.bloom);
            //mGrab.Init(mContext, profile.grab);
            mDepthMode.Init(mContext, profile.depthMode);
            mFog.Init(mContext, profile.fogModel);
            mGrey.Init(mContext, profile.greyMode);
            
#endif

            if (Application.isPlaying)
            {
#if !UNITY_EDITOR
            EnableBloom(PerformScript.EnableBloom);
#endif
            }

            Debug.Log("PostProcessingBehaviour EnableBloom: " + PerformScript.EnableBloom + " ScreenWidth " + PerformScript.ScreenWidth + " ScreenHeight " + PerformScript.ScreenHeight);
            int width = (int)PerformScript.ScreenWidth;
            int height = (int)PerformScript.ScreenHeight;
            SetScreenResolution(width, height);
        }

        void OnPreCull()
        {
            // All the per-frame initialization logic has to be done in OnPreCull instead of Update
            // because [ImageEffectAllowedInSceneView] doesn't trigger Update events...

            if (profile == null || mCamera == null)
                return;

#if UNITY_EDITOR
            //only for editor sceneview
            mCamera = GetComponent<Camera>();
            // Track the scene view camera to disable some effects we don't want to see in the
            // scene view
            // Currently disabled effects :
            //  - Temporal Antialiasing
            //  - Depth of Field
            //  - Motion blur
            mRenderingInSceneView = UnityEditor.SceneView.currentDrawingSceneView != null
                && UnityEditor.SceneView.currentDrawingSceneView.camera == mCamera;

            var context = mContext.Reset();
            context.profile = profile;
            context.renderTextureFactory = mRenderTextureFactory;
            context.materialFactory = mMaterialFactory;
            context.camera = mCamera;

            // Prepare components
            mCameraFilter.Init(mContext, profile.cameraFilterModel);
            mAmbientOcclusion.Init(mContext, profile.ambientOcclusion);
            mBloom.Init(mContext, profile.bloom);
            //mGrab.Init(mContext, profile.grab);
            mDepthMode.Init(mContext, profile.depthMode);
            mFog.Init(mContext, profile.fogModel);
            mGrey.Init(mContext, profile.greyMode);
            mDebugView.Init(mContext, profile.debugViewModel);
            if (Application.isPlaying)
            {
                EnableBloom(PerformScript.EnableBloom);
            }
#endif
            // Prepare context
            //var context = m_Context.Reset();
            //context.profile = profile;
            //context.renderTextureFactory = m_RenderTextureFactory;
            //context.materialFactory = m_MaterialFactory;
            //context.camera = m_Camera;

            CheckObservers();

            // Find out which camera flags are needed before rendering begins
            // Note that motion vectors will only be available one frame after being enabled
            var flags = mContext.camera.depthTextureMode;
            foreach (var component in mComponents)
            {
                if (component.active)
                    flags |= component.GetCameraFlags();
            }

            mContext.camera.depthTextureMode = flags;
        }

        void OnPreRender()
        {
            if (null != mTargetTexture && !mRenderingInSceneView)
            {
                mContext.camera.targetTexture = mTargetTexture;
            }

            //    //TryExecuteCommandBuffer(mGrab);
            //    TryExecuteCommandBuffer(mAmbientOcclusion);

            //    if (!mRenderingInSceneView)
            //    {
            //        //SceneView不执行镜头滤镜
            //        TryExecuteCommandBuffer(mCameraFilter);
            //    }
        }

        void OnPostRender()
        {
            if (null != mTargetTexture && !mRenderingInSceneView)
            {
                mContext.camera.targetTexture = null;
            }
        }

        // Classic render target pipeline for RT-based effects
        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (profile == null || mCamera == null)
            {
                Graphics.Blit(source, destination);
                return;
            }

#if UNITY_EDITOR
            if (mDebugView.active)
            {
                Graphics.Blit(source, destination);
                return;
            }
#endif

            // Uber shader setup
            bool uberActive = false;

            var uberMaterial = mMaterialFactory.Get("Hidden/Post FX/Uber Shader");
            uberMaterial.shaderKeywords = null;

            var src = source;
            var dst = destination;

            if (mBloom.active)
            {
                uberActive = true;
                mBloom.Prepare(src, uberMaterial, Texture2D.whiteTexture);
            }

            if (!mRenderingInSceneView && TryPrepareUberImageEffect(mFog, uberMaterial))
            {
                uberActive = true;
            }

            if (mGrey.active)
            {
                uberActive = true;
                mGrey.Prepare(uberMaterial);
            }

            if (uberActive)
            {
                if (!GraphicsUtils.isLinearColorSpace)
                    uberMaterial.EnableKeyword("UNITY_COLORSPACE_GAMMA");

                Graphics.Blit(src, dst, uberMaterial, 0);
            }
            else
            {
                Graphics.Blit(source, destination);
            }

            mRenderTextureFactory.ReleaseAll();
        }

        void OnDisable()
        {
            if (Application.isPlaying)
            {

            }
            // Clear command buffers
            foreach (var cb in mCommandBuffers.Values)
            {
                mCamera.RemoveCommandBuffer(cb.Key, cb.Value);
                cb.Value.Dispose();
            }

            mCommandBuffers.Clear();

            // Clear components
            if (profile != null)
                DisableComponents();

            mComponents.Clear();

            // Factories
            mMaterialFactory.Dispose();
            mRenderTextureFactory.Dispose();
            GraphicsUtils.Dispose();
        }

#if UNITY_EDITOR
        private void LateUpdate()
        {
            if (null != mDebugView && mDebugView.active)
            {
                mDebugView.LateUpdate();
            }
        }
#endif

        #region State management

        List<PostProcessingComponentBase> mComponentsToEnable = new List<PostProcessingComponentBase>();
        List<PostProcessingComponentBase> mComponentsToDisable = new List<PostProcessingComponentBase>();

        void CheckObservers()
        {
            foreach (var cs in mComponentStates)
            {
                var component = cs.Key;
                if (null != component.GetModel())
                {
                    var state = component.GetModel().enabled;

                    if (state != cs.Value)
                    {
                        if (state) mComponentsToEnable.Add(component);
                        else mComponentsToDisable.Add(component);
                    }
                }
            }

            for (int i = 0; i < mComponentsToDisable.Count; i++)
            {
                var c = mComponentsToDisable[i];
                mComponentStates[c] = false;
                c.OnDisable();
            }

            for (int i = 0; i < mComponentsToEnable.Count; i++)
            {
                var c = mComponentsToEnable[i];
                mComponentStates[c] = true;
                c.OnEnable();
            }

            mComponentsToDisable.Clear();
            mComponentsToEnable.Clear();
        }

        void DisableComponents()
        {
            foreach (var component in mComponents)
            {
                var model = component.GetModel();
                if (model != null && model.enabled)
                    component.OnDisable();
            }
        }

        void DestroyComponents()
        {
            if (null != mComponents)
            {
                foreach (var component in mComponents)
                {
                    if (component != null)
                        component.OnDestroy();
                }
            }
        }

        private void OnDestroy()
        {
            DestroyComponents();
        }

        #endregion

        #region Command buffer handling & rendering helpers
        // Placeholders before the upcoming Scriptable Render Loop as command buffers will be
        // executed on the go so we won't need of all that stuff
        CommandBuffer AddCommandBuffer<T>(CameraEvent evt, string name)
            where T : PostProcessingModel
        {
            var cb = new CommandBuffer { name = name };
            var kvp = new KeyValuePair<CameraEvent, CommandBuffer>(evt, cb);
            mCommandBuffers.Add(typeof(T), kvp);
            mCamera.AddCommandBuffer(evt, kvp.Value);
            return kvp.Value;
        }

        void RemoveCommandBuffer<T>()
            where T : PostProcessingModel
        {
            KeyValuePair<CameraEvent, CommandBuffer> kvp;
            var type = typeof(T);

            if (!mCommandBuffers.TryGetValue(type, out kvp))
                return;

            mCamera.RemoveCommandBuffer(kvp.Key, kvp.Value);
            mCommandBuffers.Remove(type);
            kvp.Value.Dispose();
        }

        CommandBuffer GetCommandBuffer<T>(CameraEvent evt, string name)
            where T : PostProcessingModel
        {
            CommandBuffer cb;
            KeyValuePair<CameraEvent, CommandBuffer> kvp;

            if (!mCommandBuffers.TryGetValue(typeof(T), out kvp))
            {
                cb = AddCommandBuffer<T>(evt, name);
            }
            else if (kvp.Key != evt)
            {
                RemoveCommandBuffer<T>();
                cb = AddCommandBuffer<T>(evt, name);
            }
            else cb = kvp.Value;

            return cb;
        }

        void TryExecuteCommandBuffer<T>(PostProcessingComponentCommandBuffer<T> component)
            where T : PostProcessingModel
        {
            if (component.active)
            {
                var cb = GetCommandBuffer<T>(component.GetCameraEvent(), component.GetName());
                cb.Clear();
                component.PopulateCommandBuffer(cb);
            }
            else RemoveCommandBuffer<T>();
        }

        bool TryPrepareUberImageEffect<T>(PostProcessingComponentRenderTexture<T> component, Material material)
            where T : PostProcessingModel
        {
            if (!component.active)
                return false;

            component.Prepare(material);
            return true;
        }

        T AddComponent<T>(T component)
            where T : PostProcessingComponentBase
        {
            mComponents.Add(component);
            return component;
        }

        #endregion

        private void EnableGrey(bool enable)
        {
            mGrey.model.enabled = enable;
        }

        private void EnableBloom(bool enable)
        {
            if (null != mBloom)
            {
                mBloom.model.enabled = enable;
            }
        }

        private void OnUpdateFilter(int[] filters, bool[] enables)
        {
            profile.cameraFilterModel.UpdateFilter(filters, enables);
        }

        public void SetScreenResolution(int width, int height)
        {
            if (null != mTargetTexture)
            {
                RenderTexture.ReleaseTemporary(mTargetTexture);
                mTargetTexture = null;
            }

            if (width != -1 || height != -1)
            {
                mTargetTexture = RenderTexture.GetTemporary(width, height, 24,
                                 RenderTextureFormat.Default);
            }
        }
    }
}
