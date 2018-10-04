using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DissolveControl : MonoBehaviour {

	public float minValue;
	public float maxValue;
	private float valueRange;
	public bool autoUpdate = false;
	public Material mat;
	[Range(0f, 1f)]
	public float fill;
	// Use this for initialization
	void Start () {
		valueRange = maxValue - minValue;
	}
	
	// Update is called once per frame
	void Update () {
		if (autoUpdate) {
			setFill(fill);
		}
	}

	public void setFill(float _fillPercentage) {
		fill = Mathf.Clamp(fill, 0f, 1f);
		mat.SetFloat("_Fill", minValue + valueRange * _fillPercentage);
	}
}
