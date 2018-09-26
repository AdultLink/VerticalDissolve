using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingpongDissolve : MonoBehaviour {

	// Use this for initialization
	public float minValue;
	public float maxValue;
	public float freq;
	public Material mat;
	private float fill = 0f;
	private float range;
	void Start () {
		range = maxValue - minValue;
	}
	
	// Update is called once per frame
	void Update () {
		fill = (range / 2f) * (Mathf.Sin(freq * Time.time) + 1f ) + minValue;
		mat.SetFloat("_Fillpercentage", fill);
	}
}
