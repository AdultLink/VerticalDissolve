using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrinterController : MonoBehaviour {

	// Use this for initialization
	public Transform movingFrame;
	public DissolveControl printDissolveControl;
	public float printTime;
	public float eraseTime;
	public float waitTimeAfterPrinting;
	public float waitTimeAfterErasing;
	private float printSpeed;
	private float eraseSpeed;
	public Transform targetMax;
	public Transform targetMin;
	private float timePrintStarted = 0f;
	private float progress = 0f;
	private float timeErasingStarted = 0f;
	private Vector3 movementVector;
	private float movementRangeMag;
	void Start () {
		movementVector = targetMax.position - targetMin.position;
		movementRangeMag = movementVector.magnitude;
		movingFrame.position = targetMin.position;
		printDissolveControl.setFill(progress);
		StartCoroutine("doLoop");
	}

	IEnumerator doLoop() {
		while (true) {

			//WAIT AFTER ERASING (ALSO INITIAL DELAY)
			yield return new WaitForSeconds(waitTimeAfterErasing);

			//PRINTING
			timePrintStarted = Time.time;

			while (Time.time - timePrintStarted < printTime) {
				printSpeed = movementRangeMag * (Time.deltaTime / printTime);
				progress += printSpeed;
				progress = Mathf.Clamp(progress, 0f, 1f);
				movingFrame.position = movementVector * progress + targetMin.position;
				printDissolveControl.setFill(progress);
				yield return new WaitForFixedUpdate();
			}
			
			//WAITING AFTER PRINTING
			yield return new WaitForSeconds(waitTimeAfterPrinting);

			//ERASING
			timeErasingStarted = Time.time;
			while (Time.time - timeErasingStarted < eraseTime) {
				eraseSpeed = movementRangeMag * (Time.deltaTime / eraseTime);
				progress -= eraseSpeed;
				progress = Mathf.Clamp(progress, 0f, 1f);
				movingFrame.position = movementVector * progress + targetMin.position;
				printDissolveControl.setFill(progress);
				yield return new WaitForFixedUpdate();
			}
		}
		
	}
}
