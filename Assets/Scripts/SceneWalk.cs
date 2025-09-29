// **********************************************************************
// Copyright (c) Lakoo
// File     : SceneWalk.cs
// Author   : Demon
// Created  : 2020-9-15
// Purpose  : 
// **********************************************************************
using UnityEngine;

public class SceneWalk : MonoBehaviour
{

    private static Vector3 CAMERA_CENTER_NERA_POS = new Vector3(9.879326f, 11.3795719f, 9.867317f);
    private static Vector3 CAMERA_CENTER_FAR_POS = new Vector3(12.75621f, 14.5f, 12.7420654f);
    private static Vector3 CAMERA_ROT = new Vector3(36.6299973f, 225.000046f, 0f);

    private const float LOW_MOVE_SPEED_RATIO = 2.368f;
    private const float HIGH_MOVE_SPEED_RATIO = 3.7632f;

    private static readonly int ACTION_STATE = Animator.StringToHash("ActionState");

    private static SceneWalk _instance;
    public static SceneWalk instance
    {
        get { return _instance; }
    }

    /////////////////////////////////////////////////////
    private Camera mSceneCamera;
    private GameObject mPlayer;
    private CharacterController mPlayerController;
    private Animation mPlayerAnimator;
    //private PlayerInput mInput;
    private Vector3 mDir = Vector3.forward;
    private Vector3 mMovement = Vector3.zero;
    public bool mIsHighSpeed = false;
    public float mAnimationTime = 640;
    private bool mIsNear = true;
    private Vector3 mCameraCurrentPos;
    private Vector3 mCameraTargetPos;

    private int mState = 0;
    /////////////////////////////////////////////////////
    public void Awake()
    {
        _instance = this;
        mSceneCamera = transform.Find("Camera").GetComponent<Camera>();
        mPlayer = transform.Find("Obj").gameObject;
        mPlayerAnimator = mPlayer.GetComponentInChildren<Animation>();
        mPlayerController = mPlayer.GetComponentInChildren<CharacterController>();
        mCameraTargetPos = mCameraCurrentPos = CAMERA_CENTER_NERA_POS;

        QualitySettings.shadowDistance = 40;
    }


    public void Update()
    {
        Vector2 moveMoment = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        ProcessWalk(moveMoment);

        if (mMovement == Vector3.zero)
        {
            if (mState != 0)
            {
                mPlayerAnimator.CrossFade("idle_barehand_1");
                mState = 0;
            }
        }
        else
        {
            if(mState != 1)
            {
                mPlayerAnimator.CrossFade("walk_barehand_1");
                mState = 1;
            }
        }

        mCameraCurrentPos = Vector3.Lerp(mCameraCurrentPos, mCameraTargetPos, Time.deltaTime * 2);

        var playerPos = mPlayer.transform.localPosition;
        var moveSpeed = mMovement * (mIsHighSpeed ? (1f / (mAnimationTime / 1000f)) * HIGH_MOVE_SPEED_RATIO : (1f / (mAnimationTime / 1000f)) * LOW_MOVE_SPEED_RATIO);
        var moveDistance = moveSpeed * Time.deltaTime;
        if (mMovement == Vector3.zero)
        {
            mPlayerController.Move(Vector3.zero);
        }
        else
        {
            mPlayerController.Move(moveDistance);
        }

        var curPos = mPlayerController.transform.localPosition;
        curPos.y = GetTerrainHeight() - transform.position.y;
        mPlayer.transform.localPosition = curPos;
        mSceneCamera.transform.localPosition = curPos + mCameraCurrentPos;
        mSceneCamera.transform.localEulerAngles = CAMERA_ROT;
        mPlayerAnimator.transform.forward = mDir;
    }

    public void ProcessWalk(Vector2 tDir)
    {
        mMovement = Vector3.forward;
        mMovement.x = -tDir.x;
        mMovement.y = 0.0f;
        mMovement.z = -tDir.y;
        mMovement = mMovement.normalized;

        if (mMovement != Vector3.zero && mDir != mMovement)
        {
            mDir = mMovement;
        }
    }

    private float GetTerrainHeight()
    {
        if(Physics.Raycast(mPlayer.transform.position + Vector3.up, Vector3.down, out RaycastHit hitInfo, float.MaxValue, LayerMask.GetMask("Terrain")))
        {
            return hitInfo.point.y + 0.05f;
        }
        return -1;
    }

    private void OnGUI()
    {
        var width = GUILayout.MaxWidth(Screen.width * 0.1f);
        var height = GUILayout.MaxHeight(Screen.height * 0.1f);
        if (GUILayout.Button("切换镜头", width, height))
        {
            mIsNear = !mIsNear;
            mCameraTargetPos = mIsNear ? CAMERA_CENTER_NERA_POS : CAMERA_CENTER_FAR_POS;
        }
    }
}
