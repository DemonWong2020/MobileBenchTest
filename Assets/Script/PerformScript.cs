using NUnit.Framework;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.PostProcessing;

public class PerformScript : MonoBehaviour
{
    public Camera mainCamera;

    private GameObject cubeObj;
    private GameObject particleObj;

    private Material cubeMaterial;
    private Material particleMaterial;

    private List<GameObject> cubes = new List<GameObject>();
    private List<GameObject> particles = new List<GameObject>();

    public static int CreateTimes = 6;
    public static bool removePostEffect = false;
    public static int FPS = 60;
    public static float ScreenWidth = Screen.width;
    public static float ScreenHeight = Screen.height;
    public static bool EnableBloom = true;

    public static void UpSample()
    {
        ScreenWidth = Screen.width;
        ScreenHeight = Screen.height;

        FPS = 45;
        CreateTimes = 6;
        EnableBloom = true;
    }

    public static void DownSample()
    {
        ScreenWidth = Screen.width * 0.75f;
        ScreenHeight = Screen.height * 0.75f;

        FPS = 45;
        CreateTimes = 6;
        EnableBloom = false;
    }

    public static void DeSample()
    {     
        Debug.Log("DeSample " + ScreenWidth + "    "+ ScreenHeight);
        ScreenWidth = Screen.width * 0.5f;
        ScreenHeight = Screen.height * 0.5f;
        FPS = 30;
        CreateTimes = 6;
        EnableBloom = false;
    }

    public void Start()
    {
        if (removePostEffect)
        {
            var postProcess = mainCamera.GetComponent<PostProcessingBehaviour>();
            if(postProcess != null)
            {
                Destroy(postProcess);
            }
        }

        Application.targetFrameRate = FPS;
        Debug.Log("Target Frame Rate: " + Application.targetFrameRate);
        cubeObj = Resources.Load<GameObject>("Cube");
        particleObj = Resources.Load<GameObject>("Particles");

        cubeMaterial = Resources.Load<Material>("Normal");
        var tex = new Texture2D(4096, 4096);
        for(int x = 0; x < tex.width; x++)
        {
            for(int y = 0; y < tex.height; y++)
            {
                tex.SetPixel(x, y, new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f)));
            }
        }
        tex.Apply();
        cubeMaterial.SetTexture("_MainTex", tex);
        particleMaterial = Resources.Load<Material>("Transparent");
        var alpha = new Texture2D(4096, 4096);
        for (int x = 0; x < tex.width; x++)
        {
            for (int y = 0; y < tex.height; y++)
            {
                alpha.SetPixel(x, y, new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), (Random.Range(0f, 1f) > 0.5f) ? 1 : 0.5f));
            }
        }
        particleMaterial.SetTexture("_MainTex", alpha);
        alpha.Apply();
        StartCoroutine(CreateObjects());
    }

    IEnumerator CreateObjects()
    {
        for(int i = 0; i < CreateTimes; i++)
        {
            for(int j = 0; j < 834; j++)
            {
                var cube = Instantiate(cubeObj, transform);
                cube.GetComponent<Renderer>().material = cubeMaterial;
                cube.transform.localPosition = new Vector3(Random.Range(-10f, 20f), Random.Range(-10f, 20f), Random.Range(-10f, 20f));
                cube.transform.localScale = Vector3.one * Random.Range(0.5f, 3f);
                cube.transform.localEulerAngles = new Vector3(Random.Range(0f, 360f), Random.Range(0f, 360f), Random.Range(0f, 360f));
                cube.GetComponent<Renderer>().material = new Material(cubeMaterial);
                cubes.Add(cube);
            }
            var particle = Instantiate(particleObj);
            particle.GetComponent<Renderer>().material = particleMaterial;
            particle.transform.position = new Vector3(Random.Range(-10f, 10f), Random.Range(-10f, 10f), Random.Range(-10f, 10f));
            particles.Add(particle);
            yield return new WaitForSeconds(0.5f);
        }
    }

    private void Update()
    {
        foreach(var cube in cubes)
        {
            cube.transform.position += new Vector3(Mathf.Sin(Time.time), Mathf.Cos(Time.time), Mathf.Sin(Time.time)) * Time.deltaTime;
            cube.transform.Rotate(new Vector3(15, 30, 45) * Time.deltaTime);
            cube.transform.localScale = Vector3.one * (1 + 0.3f * Mathf.Sin(Time.time * 3));
        }
        foreach(var particle in particles)
        {
            particle.transform.position += new Vector3(Mathf.Cos(Time.time), Mathf.Sin(Time.time), Mathf.Cos(Time.time)) * Time.deltaTime;
            particle.transform.Rotate(new Vector3(0, 30, 0) * Time.deltaTime);
            particle.transform.localScale = Vector3.one * (1 + 0.3f * Mathf.Cos(Time.time * 3));
        }
    }
}

