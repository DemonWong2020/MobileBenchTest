using System;
using System.Collections.Generic;

namespace UnityEngine.PostProcessing
{
    using UnityObject = Object;

    public sealed class MaterialFactory : IDisposable
    {
        Dictionary<string, Material> mMaterials;

        public MaterialFactory()
        {
            mMaterials = new Dictionary<string, Material>();
        }

        public Material Get(string shaderName)
        {
            Material material;

            if (!mMaterials.TryGetValue(shaderName, out material))
            {
                var shader = Shader.Find(shaderName);

                if (shader == null)
                    throw new ArgumentException(string.Format("Shader not found ({0})", shaderName));

                material = new Material(shader)
                {
                    name = string.Format("PostFX - {0}", shaderName.Substring(shaderName.LastIndexOf("/") + 1)),
                    hideFlags = HideFlags.DontSave
                };

                mMaterials.Add(shaderName, material);
            }

            return material;
        }

        public void Dispose()
        {
            var enumerator = mMaterials.GetEnumerator();
            while (enumerator.MoveNext())
            {
                var material = enumerator.Current.Value;
                GraphicsUtils.Destroy(material);
            }

            mMaterials.Clear();
        }
    }
}
