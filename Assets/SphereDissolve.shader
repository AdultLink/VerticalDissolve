// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/SphereDissolve"
{
	Properties
	{
		_Position("Position", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 2.16
		[Toggle]_Invert("Invert", Float) = 0
		_Borderradius("Border radius", Range( 0 , 2)) = 0
		[HDR]_Bordercolor("Border color", Color) = (0.8602941,0.2087478,0.2087478,0)
		_Bordernoisescale("Border noise scale", Range( 0 , 20)) = 0
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		[NoScaleOffset]_Set1_albedo("Set1_albedo", 2D) = "white" {}
		[HDR]_Set1_albedo_tint("Set1_albedo_tint", Color) = (1,1,1,1)
		[NoScaleOffset][Normal]_Set1_normal("Set1_normal", 2D) = "bump" {}
		[NoScaleOffset]_Set1_emission("Set1_emission", 2D) = "black" {}
		[HDR]_Set1_emission_tint("Set1_emission_tint", Color) = (1,1,1,1)
		[NoScaleOffset]_Set1_metallic("Set1_metallic", 2D) = "white" {}
		_Set1_metallic_multiplier("Set1_metallic_multiplier", Range( 0 , 1)) = 0
		_Set1_smoothness("Set1_smoothness", Range( 0 , 1)) = 0
		_Set1_tiling("Set1_tiling", Vector) = (1,1,0,0)
		_Set1_offset("Set1_offset", Vector) = (0,0,0,0)
		[NoScaleOffset]_Set2_albedo("Set2_albedo", 2D) = "white" {}
		[HDR]_Set2_albedo_tint("Set2_albedo_tint", Color) = (1,1,1,1)
		[NoScaleOffset][Normal]_Set2_normal("Set2_normal", 2D) = "bump" {}
		[NoScaleOffset]_Set2_emission("Set2_emission", 2D) = "black" {}
		[HDR]_Set2_emission_tint("Set2_emission_tint", Color) = (1,1,1,1)
		[NoScaleOffset]_Set2_metallic("Set2_metallic", 2D) = "white" {}
		_Set2_metallic_multiplier("Set2_metallic_multiplier", Range( 0 , 1)) = 0
		_Set2_smoothness("Set2_smoothness", Range( 0 , 1)) = 0
		_Set2_tiling("Set2_tiling", Vector) = (1,1,0,0)
		_Set2_offset("Set2_offset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Set1_normal;
		uniform float2 _Set1_tiling;
		uniform float2 _Set1_offset;
		uniform float3 _Position;
		uniform float _Bordernoisescale;
		uniform float3 _Noisespeed;
		uniform float _Radius;
		uniform float _Invert;
		uniform sampler2D _Set2_normal;
		uniform float2 _Set2_tiling;
		uniform float2 _Set2_offset;
		uniform float4 _Set1_albedo_tint;
		uniform sampler2D _Set1_albedo;
		uniform sampler2D _Set2_albedo;
		uniform float4 _Set2_albedo_tint;
		uniform float4 _Set1_emission_tint;
		uniform sampler2D _Set1_emission;
		uniform sampler2D _Set2_emission;
		uniform float4 _Set2_emission_tint;
		uniform float4 _Bordercolor;
		uniform float _Borderradius;
		uniform float _Set1_metallic_multiplier;
		uniform sampler2D _Set1_metallic;
		uniform sampler2D _Set2_metallic;
		uniform float _Set2_metallic_multiplier;
		uniform float _Set1_smoothness;
		uniform float _Set2_smoothness;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord90 = i.uv_texcoord * _Set1_tiling + _Set1_offset;
			float2 Set1_UVs150 = uv_TexCoord90;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = distance( _Position , ase_worldPos );
			float simplePerlin3D26 = snoise( ( _Bordernoisescale * ( ase_worldPos + ( _Noisespeed * _Time.y ) ) ) );
			float temp_output_39_0 = ( simplePerlin3D26 + _Radius );
			float temp_output_14_0 = ( 1.0 - saturate( ( temp_output_15_0 / temp_output_39_0 ) ) );
			float temp_output_5_0 = step( temp_output_14_0 , 0.5 );
			float Inverting152 = lerp(0.0,1.0,_Invert);
			float temp_output_4_0 = step( 0.5 , temp_output_14_0 );
			float Set1Mask51 = ( ( temp_output_5_0 * ( 1.0 - Inverting152 ) ) + ( Inverting152 * temp_output_4_0 ) );
			float Set2Mask52 = ( ( temp_output_5_0 * Inverting152 ) + ( ( 1.0 - Inverting152 ) * temp_output_4_0 ) );
			float2 uv_TexCoord96 = i.uv_texcoord * _Set2_tiling + _Set2_offset;
			float2 Set2_UVs136 = uv_TexCoord96;
			float3 Normal146 = ( ( UnpackNormal( tex2D( _Set1_normal, Set1_UVs150 ) ) * Set1Mask51 ) + ( Set2Mask52 * UnpackNormal( tex2D( _Set2_normal, Set2_UVs136 ) ) ) );
			o.Normal = Normal146;
			float4 Albedo145 = ( ( _Set1_albedo_tint * tex2D( _Set1_albedo, Set1_UVs150 ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_albedo, Set2_UVs136 ) * _Set2_albedo_tint ) );
			o.Albedo = Albedo145.rgb;
			float Border49 = ( temp_output_5_0 - step( ( 1.0 - saturate( ( temp_output_15_0 / ( _Borderradius + temp_output_39_0 ) ) ) ) , 0.5 ) );
			float4 Emission147 = ( ( _Set1_emission_tint * tex2D( _Set1_emission, Set1_UVs150 ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_emission, Set2_UVs136 ) * _Set2_emission_tint ) + ( _Bordercolor * Border49 ) );
			o.Emission = Emission147.rgb;
			float4 Metallic148 = ( ( _Set1_metallic_multiplier * tex2D( _Set1_metallic, Set1_UVs150 ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_metallic, Set2_UVs136 ) * _Set2_metallic_multiplier ) );
			o.Metallic = Metallic148.r;
			float Smoothness149 = ( ( _Set1_smoothness * Set1Mask51 ) + ( Set2Mask52 * _Set2_smoothness ) );
			o.Smoothness = Smoothness149;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "AdultLink.SphereDissolveEditor"
}
/*ASEBEGIN
Version=15301
546;92;871;480;5569.454;-50.58191;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;156;-5851.975,8.967629;Float;False;3278.017;1071.061;Generate masks;42;51;121;155;115;123;153;52;124;122;120;154;116;49;24;152;100;113;114;23;4;5;42;41;89;40;28;13;26;39;27;29;10;15;33;32;14;3;31;11;12;18;19;Generate masks;0.5808823,1,0.6878296,1;0;0
Node;AmplifyShaderEditor.Vector3Node;41;-5775.405,536.848;Float;False;Property;_Noisespeed;Noise speed;6;0;Create;True;0;0;False;0;0,0,0;0,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;42;-5772.861,697.7377;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-5594.66,414.4891;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-5538.473,674.1424;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-5619.015,292.731;Float;False;Property;_Bordernoisescale;Border noise scale;5;0;Create;True;0;0;False;0;0;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-5362.332,649.9314;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-5199.902,627.3973;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-5043.937,623.5068;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-5207.776,120.7038;Float;False;Property;_Position;Position;0;0;Create;True;0;0;False;0;0,0,0;0,2.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;13;-5006.707,710.9443;Float;False;Property;_Radius;Radius;1;0;Create;True;0;0;False;0;2.16;12.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4658.244,408.4404;Float;False;Property;_Borderradius;Border radius;3;0;Create;True;0;0;False;0;0;0.35;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;15;-4924.822,383.6677;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-4803.902,629.516;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-4497.627,607.0211;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-4365.112,420.3314;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-4218.953,854.5629;Float;False;Constant;_Float1;Float 1;24;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-4215.953,936.5608;Float;False;Constant;_Float2;Float 2;24;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;100;-4035.391,871.5526;Float;False;Property;_Invert;Invert;2;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-4599.479,174.2675;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-4340.18,605.8641;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-4438.646,162.9549;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-4136.508,596.9493;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-4167.878,299.8589;Float;False;Constant;_Falloffvalue;Falloff value;1;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;151;-3287.734,-658.0956;Float;False;688.7347;609.4233;Tiling and offset;8;136;150;90;92;91;96;94;95;Tiling and offset;1,0.5441177,0.5441177,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-3504.173,345.4399;Float;False;152;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;-3501.989,574.5967;Float;False;152;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-3849.435,871.2891;Float;False;Inverting;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;120;-3301.877,655.8195;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-4238.359,164.1958;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;95;-3256.785,-190.0811;Float;False;Property;_Set2_offset;Set2_offset;26;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;92;-3256.315,-466.3335;Float;False;Property;_Set1_offset;Set1_offset;16;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;94;-3255.485,-326.5807;Float;False;Property;_Set2_tiling;Set2_tiling;25;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;91;-3255.015,-602.8333;Float;False;Property;_Set1_tiling;Set1_tiling;15;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;4;-3850.522,574.4989;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;155;-3284.217,223.8895;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;5;-3858.55,339.7068;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-3137.401,106.5201;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-3061.315,-571.6338;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-3139.82,299.6936;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-3141.144,561.5071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;158;-2433.56,2610.159;Float;False;1098.332;696.0189;Normal;10;142;146;55;141;56;60;61;59;58;57;Normal;0.8409737,0.5882353,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;160;-3740.258,2540.56;Float;False;1130.028;860.3873;Metallic;12;67;148;68;66;137;138;62;65;64;126;125;63;Metallic;0.5441177,0.792495,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-3061.785,-295.3812;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;159;-2431.612,986.0506;Float;False;1390.691;1274.019;Emission;15;147;84;50;139;35;34;140;79;82;80;78;88;83;87;81;Emission;1,0.9860041,0.4926471,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;157;-3753.321,1193.716;Float;False;1168.703;1070.7;Albedo;12;144;145;9;143;8;7;54;2;97;53;99;1;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-3145.406,707.2241;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-3858.723,103.6228;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-3706.61,1482.276;Float;False;150;0;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-2835.659,-297.784;Float;False;Set2_UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;-2826.065,-575.149;Float;False;Set1_UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-3702.337,2732.15;Float;False;150;0;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-2387.927,3104.73;Float;False;136;0;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-2394.927,2725.731;Float;False;150;0;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-2366.71,1292.938;Float;False;150;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-3625.686,81.36038;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;161;-4842.865,1290.13;Float;False;860.3872;434.3546;Comment;8;128;134;131;132;135;149;133;127;Smoothness;1,0.5588235,0.9148071,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-3702.337,3108.15;Float;False;136;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-2996.362,626.8904;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-3627.609,1882.276;Float;False;136;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-2983.909,107.9556;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-2364.71,1539.938;Float;False;136;0;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-4703.746,1526.452;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-2175.218,1933.305;Float;False;Property;_Bordercolor;Border color;4;1;[HDR];Create;True;0;0;False;0;0.8602941,0.2087478,0.2087478,0;0,0.881138,2.323001,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-3516.449,2707.524;Float;True;Property;_Set1_metallic;Set1_metallic;12;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;128;-4705.885,1448.053;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-2156.499,2114.735;Float;False;49;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-4787.752,1606.796;Float;False;Property;_Set2_smoothness;Set2_smoothness;24;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-4793.229,1365.877;Float;False;Property;_Set1_smoothness;Set1_smoothness;14;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-3511.727,3086.174;Float;True;Property;_Set2_metallic;Set2_metallic;22;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;125;-3458.06,2626.381;Float;False;Property;_Set1_metallic_multiplier;Set1_metallic_multiplier;13;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-1827.221,1348.865;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;-2152.833,1724.165;Float;False;Property;_Set2_emission_tint;Set2_emission_tint;21;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;-2171.727,1088.547;Float;False;Property;_Set1_emission_tint;Set1_emission_tint;11;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;-3411.414,2909.481;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-1825.249,1444.007;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-3419.321,3004.623;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-2180.606,1515.634;Float;True;Property;_Set2_emission;Set2_emission;20;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;126;-3463.327,3295.568;Float;False;Property;_Set2_metallic_multiplier;Set2_metallic_multiplier;23;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;-2199.222,2701.858;Float;True;Property;_Set1_normal;Set1_normal;9;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-2860.018,101.7682;Float;False;Set1Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-2094.186,2903.816;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;99;-3380.529,2056.116;Float;False;Property;_Set2_albedo_tint;Set2_albedo_tint;18;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-3528.36,1459.61;Float;True;Property;_Set1_albedo;Set1_albedo;7;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-2876.439,620.5188;Float;False;Set2Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-3355.833,1773.61;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-3482.779,76.24486;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-2189.151,1269.52;Float;True;Property;_Set1_emission;Set1_emission;10;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;97;-3405.217,1273.798;Float;False;Property;_Set1_albedo_tint;Set1_albedo_tint;8;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;-2194.5,3080.509;Float;True;Property;_Set2_normal;Set2_normal;19;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-3448.24,1855.161;Float;True;Property;_Set2_albedo;Set2_albedo;17;1;[NoScaleOffset];Create;True;0;0;False;0;None;019d98742919c3248be0a995d4730f22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;53;-3347.927,1678.468;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-2102.093,2998.958;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-3141.596,2843.874;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-4492.009,1369.22;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-3137.03,3069.628;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-4488.442,1589.974;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-3113.738,1837.566;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-3118.305,1611.813;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1607.921,1498.039;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1615.637,1251.814;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1906.936,2015.879;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1864.566,2837.161;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1859.999,3062.914;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-4336.177,1468.165;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1691.737,2940.105;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-2949.183,1718.615;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2970.042,2947.101;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-1412.121,1475.936;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-2422.663,403.7738;Float;False;149;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;-2399.517,164.5215;Float;False;146;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-2402.747,246.6179;Float;False;147;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-2397.251,323.6499;Float;False;148;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-2400.787,80.88277;Float;False;145;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-1572.658,2936.207;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-1280.89,1471.429;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-2821.673,1714.033;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-4214.241,1463.037;Float;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-2847.752,2943.213;Float;False;Metallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-2152.703,195.3187;Float;False;True;2;Float;AdultLink.SphereDissolveEditor;0;0;Standard;AdultLink/SphereDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;41;0
WireConnection;89;1;42;0
WireConnection;40;0;27;0
WireConnection;40;1;89;0
WireConnection;28;0;29;0
WireConnection;28;1;40;0
WireConnection;26;0;28;0
WireConnection;15;0;10;0
WireConnection;15;1;27;0
WireConnection;39;0;26;0
WireConnection;39;1;13;0
WireConnection;12;0;15;0
WireConnection;12;1;39;0
WireConnection;18;0;19;0
WireConnection;18;1;39;0
WireConnection;100;0;113;0
WireConnection;100;1;114;0
WireConnection;31;0;15;0
WireConnection;31;1;18;0
WireConnection;11;0;12;0
WireConnection;32;0;31;0
WireConnection;14;0;11;0
WireConnection;152;0;100;0
WireConnection;120;0;154;0
WireConnection;33;0;32;0
WireConnection;4;0;3;0
WireConnection;4;1;14;0
WireConnection;155;0;153;0
WireConnection;5;0;14;0
WireConnection;5;1;3;0
WireConnection;116;0;5;0
WireConnection;116;1;155;0
WireConnection;90;0;91;0
WireConnection;90;1;92;0
WireConnection;115;0;153;0
WireConnection;115;1;4;0
WireConnection;123;0;5;0
WireConnection;123;1;154;0
WireConnection;96;0;94;0
WireConnection;96;1;95;0
WireConnection;122;0;120;0
WireConnection;122;1;4;0
WireConnection;23;0;33;0
WireConnection;23;1;3;0
WireConnection;136;0;96;0
WireConnection;150;0;90;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;121;0;116;0
WireConnection;121;1;115;0
WireConnection;62;1;138;0
WireConnection;63;1;137;0
WireConnection;81;1;139;0
WireConnection;61;1;142;0
WireConnection;51;0;121;0
WireConnection;1;1;144;0
WireConnection;52;0;124;0
WireConnection;49;0;24;0
WireConnection;80;1;140;0
WireConnection;57;1;141;0
WireConnection;2;1;143;0
WireConnection;66;0;125;0
WireConnection;66;1;62;0
WireConnection;66;2;65;0
WireConnection;132;0;134;0
WireConnection;132;1;128;0
WireConnection;67;0;64;0
WireConnection;67;1;63;0
WireConnection;67;2;126;0
WireConnection;131;0;127;0
WireConnection;131;1;135;0
WireConnection;7;0;54;0
WireConnection;7;1;2;0
WireConnection;7;2;99;0
WireConnection;8;0;97;0
WireConnection;8;1;1;0
WireConnection;8;2;53;0
WireConnection;82;0;79;0
WireConnection;82;1;81;0
WireConnection;82;2;88;0
WireConnection;83;0;87;0
WireConnection;83;1;80;0
WireConnection;83;2;78;0
WireConnection;35;0;34;0
WireConnection;35;1;50;0
WireConnection;56;0;61;0
WireConnection;56;1;59;0
WireConnection;60;0;58;0
WireConnection;60;1;57;0
WireConnection;133;0;132;0
WireConnection;133;1;131;0
WireConnection;55;0;56;0
WireConnection;55;1;60;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;84;0;83;0
WireConnection;84;1;82;0
WireConnection;84;2;35;0
WireConnection;146;0;55;0
WireConnection;147;0;84;0
WireConnection;145;0;9;0
WireConnection;149;0;133;0
WireConnection;148;0;68;0
WireConnection;0;0;162;0
WireConnection;0;1;164;0
WireConnection;0;2;166;0
WireConnection;0;3;165;0
WireConnection;0;4;163;0
ASEEND*/
//CHKSM=39C60C1B365FD0D903EA42E29CAADEB317F8A43A