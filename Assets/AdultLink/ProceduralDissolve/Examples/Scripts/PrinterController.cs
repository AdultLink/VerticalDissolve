using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PrintingStatus {
	printing,
	waitingAfterPrinting,
	erasing,
	waitingAfterErasing,
}

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
	private PrintingStatus printingStatus = PrintingStatus.waitingAfterErasing;
	private float timeWaitStarted = 0f;
	private float timeErasingStarted = 0f;
	private Vector3 movementVector;
	private float movementRangeMag;
	void Start () {
		movementVector = targetMax.position - targetMin.position;
		movementRangeMag = movementVector.magnitude;
		movingFrame.position = targetMin.position;
		printDissolveControl.setFill(progress);
	}
	
	// Update is called once per frame
	void Update () {
		switch (printingStatus){
			case PrintingStatus.printing:
				if (Time.time - timePrintStarted < printTime) {
					printSpeed = movementRangeMag * (Time.deltaTime / printTime);
					progress += printSpeed;
					progress = Mathf.Clamp(progress, 0f, 1f);
					movingFrame.position = movementVector * progress + targetMin.position;
					printDissolveControl.setFill(progress);
				}
				else {
					timeWaitStarted = Time.time;
					printingStatus = PrintingStatus.waitingAfterPrinting;
				}
				break;
			case PrintingStatus.waitingAfterPrinting:
				if (Time.time - timeWaitStarted > waitTimeAfterPrinting) {
					printingStatus = PrintingStatus.erasing;
					timeErasingStarted = Time.time;
				}
				break;
			case PrintingStatus.erasing:
				if (Time.time - timeErasingStarted < eraseTime) {
					eraseSpeed = movementRangeMag * (Time.deltaTime / eraseTime);
					progress -= eraseSpeed;
					progress = Mathf.Clamp(progress, 0f, 1f);
					movingFrame.position = movementVector * progress + targetMin.position;
					printDissolveControl.setFill(progress);
				}
				else {
					timeWaitStarted = Time.time;
					printingStatus = PrintingStatus.waitingAfterErasing;
				}
				break;
			case PrintingStatus.waitingAfterErasing:
				if (Time.time - timeWaitStarted > waitTimeAfterErasing) {
						printingStatus = PrintingStatus.printing;
						timePrintStarted = Time.time;
					}
				break;
			default:
				Debug.Log("PrintingStatus defaulted");
				break;
		}

		if (Input.GetKeyDown(KeyCode.Space)) {
			timePrintStarted = Time.time;
			printingStatus = PrintingStatus.printing;
		}

	}
}
