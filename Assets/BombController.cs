using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BombController : MonoBehaviour {

	// Use this for initialization
	public ParticleSystem explosionPS;
	public Material fuseMat;
	public Material plateMat;
	public Material mainMat;
	public float fuseStartingValue = 1.6f;
	public float fuseTargetValue = 0.88f;
	public float fuseDuration = 5f;
	public float dissolveStartingValue = -0.15f;
	public float dissolveTargetValue = 1.6f;
	public float dissolveDuration = 0.5f;
	private float fuseAmount;
	private float dissolveAmount;
	private float fuseProgress;
	private float dissolveProgress;
	public float restoreTime = 2f;
	private float restoreAmount;
	public float waitTime;
	private bool running = false;
	public float minRimlightScale = 0f;
	public float maxRimlightScale = 0.4f;
	private float rimlightValueRange;
	public float minFreq = 2f;
	public float maxFreq = 8f;

	private void Start() {
		rimlightValueRange = Mathf.Abs(maxRimlightScale - minRimlightScale);
		fuseProgress = fuseStartingValue;
		dissolveProgress = dissolveStartingValue;
	}
	IEnumerator loop() {
		//FUSE RUNNING
		running = true;
		float timeStarted = Time.time;
		while (fuseProgress > fuseTargetValue) {
			fuseAmount = Time.deltaTime * (Mathf.Abs(fuseTargetValue - fuseStartingValue) / fuseDuration);
			fuseProgress -= fuseAmount;
			fuseProgress = Mathf.Clamp(fuseProgress, Mathf.Min(fuseTargetValue, fuseStartingValue), Mathf.Max(fuseTargetValue, fuseStartingValue));
			float normalizedProgress = 1f - (Mathf.Abs(fuseProgress - fuseTargetValue) / (Mathf.Abs(fuseTargetValue - fuseStartingValue)));
			mainMat.SetFloat("_Rimlightscale", rimlightValueRange / 2f * Mathf.Sin((minFreq + normalizedProgress * (maxFreq - minFreq)) * (Time.time - timeStarted)) + minRimlightScale);
			fuseMat.SetFloat("_Fill", fuseProgress);
			yield return new WaitForEndOfFrame();
		}
		//PLAY EXPLOSION PS
		explosionPS.Play();
		//DISSOLVING
		mainMat.SetFloat("_Rimlightscale", maxRimlightScale);
		while (dissolveProgress < dissolveTargetValue) {
			dissolveAmount = Time.deltaTime * (Mathf.Abs(dissolveTargetValue - dissolveStartingValue) / dissolveDuration);
			dissolveProgress += dissolveAmount;
			dissolveProgress = Mathf.Clamp(dissolveProgress, Mathf.Min(dissolveStartingValue, dissolveTargetValue), Mathf.Max(dissolveStartingValue, dissolveTargetValue));
			plateMat.SetFloat("_Fill", dissolveProgress);
			mainMat.SetFloat("_Fill", dissolveProgress);
			yield return new WaitForEndOfFrame();
		}

		yield return new WaitForSeconds(waitTime);

		//RESTORING MAIN AND PLATE
		mainMat.SetFloat("_Rimlightscale", minRimlightScale);
		while (dissolveProgress > dissolveStartingValue) {
			dissolveAmount = Time.deltaTime * (Mathf.Abs(dissolveTargetValue - dissolveStartingValue) / dissolveDuration);
			dissolveProgress -= dissolveAmount;
			dissolveProgress = Mathf.Clamp(dissolveProgress, Mathf.Min(dissolveStartingValue, dissolveTargetValue), Mathf.Max(dissolveStartingValue, dissolveTargetValue));
			plateMat.SetFloat("_Fill", dissolveProgress);
			mainMat.SetFloat("_Fill", dissolveProgress);
			yield return new WaitForEndOfFrame();
		}

		//RESTORING FUSE
		while (fuseProgress < fuseStartingValue) {
			fuseAmount = Time.deltaTime * (Mathf.Abs(fuseTargetValue - fuseStartingValue) / (fuseDuration/10f));
			fuseProgress += fuseAmount;
			fuseProgress = Mathf.Clamp(fuseProgress, Mathf.Min(fuseTargetValue, fuseStartingValue), Mathf.Max(fuseTargetValue, fuseStartingValue));
			fuseMat.SetFloat("_Fill", fuseProgress);
			yield return new WaitForEndOfFrame();
		}
		running = false;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Q) && !running) {
			StartCoroutine("loop");
		}
	}

	private void OnApplicationQuit() {
		fuseMat.SetFloat("_Fill", fuseStartingValue);
		mainMat.SetFloat("_Fill", dissolveStartingValue);
		mainMat.SetFloat("_Rimlightscale", minRimlightScale);
		plateMat.SetFloat("_Fill", dissolveStartingValue);
	}
}
