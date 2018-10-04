using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Highlight : MonoBehaviour {

		// Use this for initialization
	public float minValue = 0f;
	public float maxValue = 1f;
	public float freq = 0.5f;
	public Material[] mat;
	private float scale = 0f;
	private float range;
	void Start () {
		setValue();
		range = maxValue - minValue;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Space)) {
			keyPressed();
		}
		scale = (range / 2f) * (Mathf.Sin(freq * Time.time) + 1f ) + minValue;
		setValue();
	}

	private void setValue() {
		for (int i = 0; i < mat.Length; i++) {
			mat[i].SetFloat("_Rimlightscale", scale);
		}
	}

	private void keyPressed() {
		for (int i = 0; i < mat.Length; i++) {
			mat[i].SetFloat("_Enablerimlight", 1f - mat[i].GetFloat("_Enablerimlight"));
		}
	}

	private void OnApplicationQuit() {
		for (int i = 0; i < mat.Length; i++) {
			mat[i].SetFloat("_Enablerimlight", 0f);
		}
	}
}
