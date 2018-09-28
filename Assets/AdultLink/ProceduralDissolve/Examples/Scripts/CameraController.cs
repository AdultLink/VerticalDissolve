using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace AdultLink {
public class CameraController : MonoBehaviour {

	public float movementSpeed = 1f;
	public float rotationSpeed = 10f;
	public float smoothTime = 0.3f;
	public GameObject lockedIcon;
	public GameObject unlockedIcon;
	public CameraPositions[] cameraPositions;
	private bool lockCursor = true;
	private int positionIndex = 0;
	private Vector3 velocity = Vector3.zero;
	private Vector3 targetPos;
	private Vector3 targetRot;
	private bool freeView = false;
	public Camera cam;

	void Start () {
		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
		setPosition();
		cam.transform.position = targetPos;
		cam.transform.rotation = Quaternion.Euler(targetRot);
	}
	private void Update() {

		//CAMERA STUFF
		if (Input.GetKeyDown(KeyCode.Tab)) {
			freeView = !freeView;
			toggleLockedIcon();
			if (!freeView) {
				setPosition();
				setCursorVisibility(false);
			}
		}

		//FREE VIEW
		if (freeView){
			if (lockCursor){
				cam.transform.position += (cam.transform.right * Input.GetAxis("Horizontal") + cam.transform.forward * Input.GetAxis("Vertical")) * movementSpeed * Time.unscaledDeltaTime;
				cam.transform.eulerAngles += new Vector3(-Input.GetAxis("Mouse Y"), Input.GetAxis("Mouse X"), 0f);
				detectElement();
			}
		}
		//"GALLERY" MODE
		else {
			if (Input.GetKeyDown(KeyCode.LeftArrow)) {
				positionIndex -= 1;
				if (positionIndex < 0){
					positionIndex = cameraPositions.Length-1;
				}
				setPosition();
			}

			if (Input.GetKeyDown(KeyCode.RightArrow)) {
				positionIndex += 1;
				if (positionIndex >= cameraPositions.Length){
					positionIndex = 0;
				}
				setPosition();
			}

			
			setPosition();

			//SMOOTH MOVEMENT TO THE DESIRED POSITION
			cam.transform.position = Vector3.SmoothDamp(cam.transform.position, targetPos, ref velocity, smoothTime*Time.unscaledDeltaTime);
			cam.transform.rotation = Quaternion.RotateTowards(cam.transform.rotation, Quaternion.Euler(targetRot), Time.unscaledDeltaTime* rotationSpeed);

		}

		if (Input.GetKey(KeyCode.Escape)) {
			setCursorVisibility(true);
		}
		if (Input.GetKey(KeyCode.Mouse0)) {
			setCursorVisibility(false);
		}

	}

	private void setPosition() {
			targetPos = cameraPositions[positionIndex].pos;
			targetRot = cameraPositions[positionIndex].rot;
		}

		private void setCursorVisibility(bool visible) {
			lockCursor = !visible;
			Cursor.visible = visible;
			Cursor.lockState = visible ? CursorLockMode.None : CursorLockMode.Locked;
		}

		private void detectElement() {
			RaycastHit hit;
			Ray ray = cam.ScreenPointToRay(Input.mousePosition);
			if (Physics.Raycast(ray, out hit)) {
				if (hit.transform.GetComponent<Index>() != null) {
					positionIndex = hit.transform.GetComponent<Index>().index;
				}
			}
		}

		private void toggleLockedIcon() {
			lockedIcon.SetActive(!lockedIcon.activeInHierarchy);
			unlockedIcon.SetActive(!unlockedIcon.activeInHierarchy);
		}
}

}