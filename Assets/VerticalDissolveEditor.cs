using UnityEngine;
using UnityEditor;
 
namespace AdultLink
{
public class VerticalDissolveEditor : ShaderGUI
{
	MaterialEditor _materialEditor;
	MaterialProperty[] _properties;

	//MAIN SETTINGS
	private MaterialProperty _Fill = null;
	private MaterialProperty _Invert = null;
	private MaterialProperty _Worldcoordinates = null;

	//BORDER SETTINGS
	private MaterialProperty _Borderwidth = null;
	private MaterialProperty _Bordercolor = null;
	private MaterialProperty _Bordernoisescale = null;
	private MaterialProperty _Noisespeed = null;

	//TEXTURE SETTINGS
	//SET1
	private MaterialProperty Set1_Albedo = null;
	private MaterialProperty Set1_Albedo_tint = null;
	private MaterialProperty Set1_Normal = null;
	private MaterialProperty Set1_Emission = null;
	private MaterialProperty Set1_Emission_tint = null;
	private MaterialProperty Set1_Metallic = null;
	private MaterialProperty Set1_Metallic_multiplier = null;
	private MaterialProperty Set1_Smoothness = null;
	private MaterialProperty Set1_Tiling = null;
	private MaterialProperty Set1_Offset = null;

	//SET2
	private MaterialProperty Set2_Albedo = null;
	private MaterialProperty Set2_Albedo_tint = null;
	private MaterialProperty Set2_Normal = null;
	private MaterialProperty Set2_Emission = null;
	private MaterialProperty Set2_Emission_tint = null;
	private MaterialProperty Set2_Metallic = null;
	private MaterialProperty Set2_Metallic_multiplier = null;
	private MaterialProperty Set2_Smoothness = null;
	private MaterialProperty Set2_Tiling = null;
	private MaterialProperty Set2_Offset = null;


	protected static bool ShowMainSettings = true;
	protected static bool ShowBorderSettings = true;
	protected static bool ShowTextureSettings = true;
	protected static bool ShowTextureSet1Settings = true;
	protected static bool ShowTextureSet2Settings = true;
 	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
		_properties = properties;
		_materialEditor = materialEditor;
		EditorGUI.BeginChangeCheck();
		DrawGUI();
	}

	void GetProperties() {

		//MAIN SETTINGS
		_Invert = FindProperty("_Invert", _properties);

		//BORDER SETTINGS
		_Bordercolor = FindProperty("_Bordercolor", _properties);
		_Bordernoisescale = FindProperty("_Bordernoisescale", _properties);
		_Noisespeed = FindProperty("_Noisespeed", _properties);

		//TEXTURE SETTINGS
		//SET1
		Set1_Albedo = FindProperty("_Set1_albedo", _properties);
		Set1_Albedo_tint = FindProperty("_Set1_albedo_tint", _properties);
		Set1_Normal = FindProperty("_Set1_normal", _properties);
		Set1_Emission = FindProperty("_Set1_emission", _properties);
		Set1_Emission_tint = FindProperty("_Set1_emission_tint", _properties);
		Set1_Metallic = FindProperty("_Set1_metallic", _properties);
		Set1_Metallic_multiplier = FindProperty("_Set1_metallic_multiplier", _properties);
		Set1_Smoothness = FindProperty("_Set1_smoothness", _properties);
		Set1_Tiling = FindProperty("_Set1_tiling", _properties);
		Set1_Offset = FindProperty("_Set1_offset", _properties);

		//SET2
		Set2_Albedo = FindProperty("_Set2_albedo", _properties);
		Set2_Albedo_tint = FindProperty("_Set2_albedo_tint", _properties);
		Set2_Normal = FindProperty("_Set2_normal", _properties);
		Set2_Emission = FindProperty("_Set2_emission", _properties);
		Set2_Emission_tint = FindProperty("_Set2_emission_tint", _properties);
		Set2_Metallic = FindProperty("_Set2_metallic", _properties);
		Set2_Metallic_multiplier = FindProperty("_Set2_metallic_multiplier", _properties);
	    Set2_Smoothness = FindProperty("_Set2_smoothness", _properties);
		Set2_Tiling = FindProperty("_Set2_tiling", _properties);
		Set2_Offset = FindProperty("_Set2_offset", _properties);
	}

	static Texture2D bannerTexture = null;
    static GUIStyle title = null;
    static GUIStyle linkStyle = null;
    static string repoURL = "https://github.com/adultlink/spheredissolve";

	void DrawBanner()
    {
        if (bannerTexture == null)
            bannerTexture = Resources.Load<Texture2D>("SphereDissolveBanner");

        if (title == null)
        {
            title = new GUIStyle();
            title.fontSize = 20;
            title.alignment = TextAnchor.MiddleCenter;
            title.normal.textColor = new Color(1f, 1f, 1f);
        }
		

        if (linkStyle == null) linkStyle = new GUIStyle();

        if (bannerTexture != null)
        {
            GUILayout.Space(4);
            var rect = GUILayoutUtility.GetRect(0, int.MaxValue, 60, 60);
            EditorGUI.DrawPreviewTexture(rect, bannerTexture, null, ScaleMode.ScaleAndCrop);
            //
            EditorGUI.LabelField(rect, "SphereDissolve", title);

            if (GUI.Button(rect, "", linkStyle)) {
                Application.OpenURL(repoURL);
            }
            GUILayout.Space(4);
        }
    }

	void DrawGUI() {
		GetProperties();
		DrawBanner();

		startFoldout();
		ShowMainSettings = EditorGUILayout.Foldout(ShowMainSettings, "General settings");
		if (ShowMainSettings){
			DrawMainSettings();
		}
		endFoldout();

		startFoldout();
		ShowBorderSettings = EditorGUILayout.Foldout(ShowBorderSettings, "Border");
		if (ShowBorderSettings){
			DrawBorderSettings();
		}
		endFoldout();

		startFoldout();
		ShowTextureSettings = EditorGUILayout.Foldout(ShowTextureSettings, "Textures");
		if (ShowTextureSettings){
			startFoldout();
			ShowTextureSet1Settings = EditorGUILayout.Foldout(ShowTextureSet1Settings, "Texture set 1");
			if (ShowTextureSet1Settings){
				DrawTextureSet1Settings();
			}
			endFoldout();
			startFoldout();
			ShowTextureSet2Settings = EditorGUILayout.Foldout(ShowTextureSet2Settings, "Texture set 2");
			if (ShowTextureSet2Settings){
				DrawTextureSet2Settings();
			}
			endFoldout();
		}
		endFoldout();
    }

	void DrawMainSettings() {
		//MAIN SETTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Invert, _Invert.displayName);
	}

	void DrawBorderSettings() {
		//BORDER SETTTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Bordercolor, "Color");
		_materialEditor.ShaderProperty(_Bordernoisescale, "Noise scale");
		_materialEditor.ShaderProperty(_Noisespeed, "Noise speed");
	}
	
	

	void DrawTextureSet1Settings() {
		//TEXTURE SETTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Albedo"), Set1_Albedo);
		_materialEditor.ShaderProperty(Set1_Albedo_tint, "Albedo tint color");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), Set1_Normal);
		_materialEditor.TexturePropertySingleLine(new GUIContent("Emission"), Set1_Emission);
		_materialEditor.ShaderProperty(Set1_Emission_tint, "Emission tint color");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Metallic"), Set1_Metallic);
		_materialEditor.ShaderProperty(Set1_Metallic_multiplier, "Metallic");
		_materialEditor.ShaderProperty(Set1_Smoothness, "Smoothness");
		_materialEditor.ShaderProperty(Set1_Tiling, "Tiling");
		_materialEditor.ShaderProperty(Set1_Offset, "Offset");
	}

	void DrawTextureSet2Settings() {
		//TEXTURE SETTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Albedo"), Set2_Albedo);
		_materialEditor.ShaderProperty(Set2_Albedo_tint, "Albedo tint color");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), Set2_Normal);
		_materialEditor.TexturePropertySingleLine(new GUIContent("Emission"), Set2_Emission);
		_materialEditor.ShaderProperty(Set2_Emission_tint, "Emission tint color");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Metallic"), Set2_Metallic);
		_materialEditor.ShaderProperty(Set2_Metallic_multiplier, "Metallic");
		_materialEditor.ShaderProperty(Set2_Smoothness, "Smoothness");
		_materialEditor.ShaderProperty(Set2_Tiling, "Tiling");
		_materialEditor.ShaderProperty(Set2_Offset, "Offset");
	}
	
	void startFoldout() {
		EditorGUILayout.BeginVertical(EditorStyles.helpBox);
		EditorGUI.indentLevel++;
	}

	void endFoldout() {
		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}

}
}