using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingpongDissolve : MonoBehaviour {

	// Use this for initialization
	public float minValue;
	public float maxValue;
	public float freq;
	public Material[] mat;
	private float fill = 0f;
	private float range;
	public float phase = 0f;
	void Start () {
		setValue();
		range = maxValue - minValue;
	}
	
	// Update is called once per frame
	void Update () {
		fill = (range / 2f) * (Mathf.Sin(freq * Time.time + phase) + 1f ) + minValue;
		setValue();
	}

	private void setValue() {
		for (int i = 0; i < mat.Length; i++) {
			mat[i].SetFloat("_Fill", fill);
		}
	}
}
