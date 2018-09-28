using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class TMP_culling : MonoBehaviour {

	// Use this for initialization
	private TextMeshPro tmp;
	void Start () {
		tmp = GetComponent<TextMeshPro>();
		tmp.enableCulling = true;
	}
	
}
