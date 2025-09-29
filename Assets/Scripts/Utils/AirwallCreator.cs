using System;
using System.Collections.Generic;
using UnityEngine;

namespace TerrainTools
{

    public class AirwallCreator : MonoBehaviour
    {
#if UNITY_EDITOR
        [Serializable]
        public enum EColliderType
        {
            Box = 1,
            Sphere = 2,
        }

        public enum EPassableType
        {
            None = 0,           //禁止通行
            PlayerPass = 1,     //玩家能过 魔法过不了
            MagicPass = 2,      //魔法能过 玩家过不了
        }

        [Serializable]
        public class ColliderInfo
        {
            public EColliderType ColliderType = EColliderType.Box;
            public Bounds Bound;
            public float RotY;
            public EPassableType PassableType = EPassableType.None;

            [NonSerialized]
            public bool Hightlight = false;
        }

        [SerializeField]
        public List<ColliderInfo> mColliderInfoList = new List<ColliderInfo>();
#endif
    }
}
