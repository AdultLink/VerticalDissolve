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
	private MaterialProperty _Tintinsidecolor = null;
	private MaterialProperty _Fillcolor = null;

	//BORDER SETTINGS
	private MaterialProperty _Borderwidth = null;
	private MaterialProperty _Bordercolor = null;
	private MaterialProperty _Bordernoisescale = null;
	private MaterialProperty _Bordernoisespeed = null;
	private MaterialProperty _Layernoise = null;
	private MaterialProperty _Wave1_amplitude = null;
	private MaterialProperty _Wave1_frequency = null;
	private MaterialProperty _Wave1_offset = null;
	private MaterialProperty _Wave2_amplitude = null;
	private MaterialProperty _Wave2_frequency = null;
	private MaterialProperty _Wave2_offset = null;

	//RIMLIGHT SETTINGS
	private MaterialProperty _Enable_rimlight = null;
	private MaterialProperty _Rimlight_color = null;
	private MaterialProperty _Rimlight_power  = null;
	private MaterialProperty _Rimlight_scale  = null;
	private MaterialProperty _Rimlight_bias  = null;
	
	//TEXTURE SETTINGS
	private MaterialProperty _Maintiling = null;
	private MaterialProperty _Mainoffset = null;
	private MaterialProperty _Albedo = null;
	private MaterialProperty _Normal = null;
		//EMISSION
	private MaterialProperty _Activateemission = null;
	private MaterialProperty _Emission = null;
	private MaterialProperty _Emission_color = null;
	private MaterialProperty _Emission_texspeed = null;
	private MaterialProperty _Emission_textiling = null;
		//SEC EMISSION
	private MaterialProperty _Activatesecondaryemission = null;
	private MaterialProperty _Secondaryemission = null;
	private MaterialProperty _Secondaryemission_color = null;
	private MaterialProperty _Secondaryemission_texspeed = null;
	private MaterialProperty _Secondaryemission_textiling = null;
	private MaterialProperty _Secondaryemission_desaturation = null;
		//EMISSION NOISE
	private MaterialProperty _Secondaryemissionnoise = null;
	private MaterialProperty _Secondaryemissionnoise_opacity = null;
	private MaterialProperty _Secondaryemissionnoise_texspeed = null;
	private MaterialProperty _Secondaryemissionnoise_textiling = null;
	private MaterialProperty _Secondaryemissionnoise_desaturation = null;
	private MaterialProperty _Specular = null;
	private MaterialProperty _Smoothness = null;
	private MaterialProperty _Occlusion = null;
	private MaterialProperty _Bordertexture = null;

	//SWITCHES
	protected static bool ShowMainSettings = true;
	protected static bool ShowBorderSettings = true;
	protected static bool ShowBorderWaveSettings = true;
	protected static bool ShowTextureSettings = true;
	protected static bool ShowRimlightSettings = true;
	protected static bool ShowEmissionSettings = true;
	protected static bool ShowSecondaryEmissionSettings = true;
	protected static bool ShowEmissionNoiseSettings = true;
 	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
		_properties = properties;
		_materialEditor = materialEditor;
		EditorGUI.BeginChangeCheck();
		DrawGUI();
	}

	void GetProperties() {

		//MAIN SETTINGS
		_Fill = FindProperty("_Fill", _properties);
		_Invert = FindProperty("_Invertmask", _properties);
		_Worldcoordinates = FindProperty("_Worldcoordinates", _properties);
		_Tintinsidecolor = FindProperty("_Tintinsidecolor", _properties);
		_Fillcolor = FindProperty("_Fillcolor", _properties);

		//BORDER SETTINGS
		
		_Borderwidth = FindProperty("_Borderwidth", _properties);
		_Bordercolor = FindProperty("_Bordercolor", _properties);
		_Bordernoisescale = FindProperty("_Noisescale", _properties);
		_Bordernoisespeed = FindProperty("_Noisespeed", _properties);
		_Layernoise = FindProperty("_Layernoise", _properties);
		_Wave1_amplitude = FindProperty("_Wave1amplitude", _properties);
		_Wave1_frequency = FindProperty("_Wave1frequency", _properties);
		_Wave1_offset = FindProperty("_Wave1offset", _properties);
		_Wave2_amplitude = FindProperty("_Wave2amplitude", _properties);
		_Wave2_frequency = FindProperty("_Wave2Frequency", _properties);
		_Wave2_offset = FindProperty("_Wave2offset", _properties);
		_Bordertexture = FindProperty("_Bordertexture", _properties);

		//RIMLIGHT SETTINGS
		_Enable_rimlight = FindProperty("_Enablerimlight", _properties);
		_Rimlight_color = FindProperty("_Rimlightcolor", _properties);
		_Rimlight_power = FindProperty("_Rimlightpower", _properties);
		_Rimlight_scale = FindProperty("_Rimlightscale", _properties);
		_Rimlight_bias = FindProperty("_Rimlightbias", _properties);

		//TEXTURE SETTINGS
		_Maintiling = FindProperty("_Maintiling", _properties);
		_Mainoffset = FindProperty("_Mainoffset", _properties);
		_Albedo = FindProperty("_Albedo", _properties);
		_Normal = FindProperty("_Normal", _properties);
			//EMISSION
		_Activateemission = FindProperty("_Activateemission", _properties);
		_Emission = FindProperty("_Emission", _properties);
		_Emission_color = FindProperty("_Basecolor", _properties);
		_Emission_texspeed = FindProperty("_Emissiontexspeed", _properties);
		_Emission_textiling = FindProperty("_Emissiontextiling", _properties);
			//SEC EMISSION
		_Activatesecondaryemission = FindProperty("_Activatesecondaryemission", _properties);
		_Secondaryemission = FindProperty("_Secondaryemission" , _properties);
		_Secondaryemission_color = FindProperty("_Secondaryemissioncolor", _properties);
		_Secondaryemission_texspeed = FindProperty("_Secondaryemissionspeed", _properties);
		_Secondaryemission_textiling = FindProperty("_Secondaryemissiontiling", _properties);
		_Secondaryemission_desaturation = FindProperty("_SecondaryEmissionDesaturation", _properties);
			//EMISSION NOISE
		_Secondaryemissionnoise = FindProperty("_Secondaryemissionnoise", _properties);
		_Secondaryemissionnoise_texspeed = FindProperty("_Noisetexspeed", _properties);
		_Secondaryemissionnoise_textiling = FindProperty("_Noisetextiling", _properties);
		_Secondaryemissionnoise_desaturation = FindProperty("_SecondaryEmissionDesaturation", _properties);
		_Secondaryemissionnoise_opacity = FindProperty("_Noisetexopacity", _properties);

		_Specular = FindProperty("_Specular", _properties);
		_Smoothness = FindProperty("_Smoothness", _properties);
		_Occlusion = FindProperty("_Occlusion", _properties);
	}

	static Texture2D bannerTexture = null;
    static GUIStyle title = null;
    static GUIStyle linkStyle = null;
    static string repoURL = "https://github.com/adultlink/verticaldissolve";

	void DrawBanner()
    {
        if (bannerTexture == null)
            bannerTexture = Resources.Load<Texture2D>("VerticalDissolveBanner");

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
            EditorGUI.LabelField(rect, "VerticalDissolve", title);

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
		ShowMainSettings = EditorGUILayout.Foldout(ShowMainSettings, "Main settings");
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
		ShowRimlightSettings = EditorGUILayout.Foldout(ShowRimlightSettings, "Rim light");
		if (ShowRimlightSettings){
			DrawRimlightSettings();
		}
		endFoldout();

		startFoldout();
		ShowTextureSettings = EditorGUILayout.Foldout(ShowTextureSettings, "Textures");
		if (ShowTextureSettings){
			DrawTextureSettings();
		}
		endFoldout();
    }

	void DrawMainSettings() {
		//MAIN SETTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Fill, "Fill amount");
		_materialEditor.ShaderProperty(_Invert, "Invert");
		_materialEditor.ShaderProperty(_Worldcoordinates, "Use world coords");
		_materialEditor.ShaderProperty(_Tintinsidecolor, "Tint inside");
		_materialEditor.ShaderProperty(_Fillcolor, "Tint color");
	}

	void DrawBorderSettings() {
		//BORDER SETTTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Bordercolor, "Color");
		_materialEditor.ShaderProperty(_Borderwidth, "Width");
		_materialEditor.ShaderProperty(_Bordernoisescale, "Noise scale");
		_materialEditor.ShaderProperty(_Bordernoisespeed, "Noise speed");
		_materialEditor.ShaderProperty(_Layernoise, "Layer noise");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Texture"), _Bordertexture);

		startFoldout();
		ShowBorderWaveSettings = EditorGUILayout.Foldout(ShowBorderWaveSettings, "Wave settings");
		if (ShowBorderWaveSettings){
			_materialEditor.SetDefaultGUIWidths();
			_materialEditor.ShaderProperty(_Wave1_amplitude, "[Axis 1] Amplitude");
			_materialEditor.ShaderProperty(_Wave1_frequency, "[Axis 1] Frequency");
			_materialEditor.ShaderProperty(_Wave1_offset, "[Axis 1] Offset");
			_materialEditor.ShaderProperty(_Wave2_amplitude, "[Axis 2] Amplitude");
			_materialEditor.ShaderProperty(_Wave2_frequency, "[Axis 2] Frequency");
			_materialEditor.ShaderProperty(_Wave2_offset, "[Axis 2] Offset");
		}
		endFoldout();
	}

	void DrawRimlightSettings() {
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Enable_rimlight, "Enable");
		_materialEditor.ShaderProperty(_Rimlight_color, "Color");
		_materialEditor.ShaderProperty(_Rimlight_power, "Power");
		_materialEditor.ShaderProperty(_Rimlight_scale, "Scale");
		_materialEditor.ShaderProperty(_Rimlight_bias, "Bias");
	}

	void DrawTextureSettings() {
		_materialEditor.ShaderProperty(_Maintiling, "Tiling");
		_materialEditor.ShaderProperty(_Mainoffset, "Offset");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Albedo"), _Albedo);
		_materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), _Normal);
		_materialEditor.TexturePropertySingleLine(new GUIContent("Specular"), _Specular);
		_materialEditor.ShaderProperty(_Smoothness, "Smoothness");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Occlusion"), _Occlusion);

		startFoldout();
		ShowEmissionSettings = EditorGUILayout.Foldout(ShowEmissionSettings, "Emission");
		if (ShowEmissionSettings){
			_materialEditor.ShaderProperty(_Activateemission, "Enable emission");
			_materialEditor.TexturePropertySingleLine(new GUIContent("Emission"), _Emission);
			_materialEditor.ShaderProperty(_Emission_color, "Tint");
			_materialEditor.ShaderProperty(_Emission_texspeed, "Scroll speed");
			_materialEditor.ShaderProperty(_Emission_textiling, "Tiling");
		}
		endFoldout();

		startFoldout();
		ShowSecondaryEmissionSettings = EditorGUILayout.Foldout(ShowSecondaryEmissionSettings, "Secondary emission");
		if (ShowSecondaryEmissionSettings){
			_materialEditor.ShaderProperty(_Activatesecondaryemission, "Enable secondary emission");
			_materialEditor.TexturePropertySingleLine(new GUIContent("Secondary emission"), _Secondaryemission);
			_materialEditor.ShaderProperty(_Secondaryemission_color, "Tint");
			_materialEditor.ShaderProperty(_Secondaryemission_texspeed, "Scroll speed");
			_materialEditor.ShaderProperty(_Secondaryemission_textiling, "Tiling");
			_materialEditor.ShaderProperty(_Secondaryemission_desaturation, "Desaturate");
			
			startFoldout();
			ShowEmissionNoiseSettings = EditorGUILayout.Foldout(ShowEmissionNoiseSettings, "Emission noise");
			if (ShowEmissionNoiseSettings){
				_materialEditor.TexturePropertySingleLine(new GUIContent("Noise"), _Secondaryemissionnoise);
				_materialEditor.ShaderProperty(_Secondaryemissionnoise_texspeed, "Scroll speed");
				_materialEditor.ShaderProperty(_Secondaryemissionnoise_textiling, "Tiling");
				_materialEditor.ShaderProperty(_Secondaryemissionnoise_desaturation, "Desaturate");
				_materialEditor.ShaderProperty(_Secondaryemissionnoise_opacity, "Opacity");
			}
			endFoldout();
		}
		endFoldout();

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