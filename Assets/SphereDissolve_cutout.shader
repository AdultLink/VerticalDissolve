// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/SphereDissolve_cutout"
{
	Properties
	{
		_Position("Position", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 2
		[Toggle]_Invert("Invert", Float) = 0
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		_Borderradius("Border radius", Range( 0 , 2)) = 1
		_Bordernoisescale("Border noise scale", Range( 0 , 20)) = 0
		[HDR]_Bordercolor("Border color", Color) = (0.8602941,0.2087478,0.2087478,0)
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Albedo_tint("Albedo_tint", Color) = (1,1,1,1)
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Emission("Emission", 2D) = "black" {}
		[HDR]_Emission_tint("Emission_tint", Color) = (1,1,1,1)
		[NoScaleOffset]_Metallic("Metallic", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Offset("Offset", Vector) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Metallic_multiplier("Metallic_multiplier", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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

		uniform sampler2D _Normal;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float4 _Albedo_tint;
		uniform sampler2D _Albedo;
		uniform float4 _Emission_tint;
		uniform sampler2D _Emission;
		uniform float4 _Bordercolor;
		uniform float3 _Position;
		uniform float _Bordernoisescale;
		uniform float3 _Noisespeed;
		uniform float _Radius;
		uniform float _Borderradius;
		uniform sampler2D _Metallic;
		uniform float _Metallic_multiplier;
		uniform float _Smoothness;
		uniform float _Invert;
		uniform float _Cutoff = 0.5;


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
			float2 uv_TexCoord90 = i.uv_texcoord * _Tiling + _Offset;
			float2 UVs116 = uv_TexCoord90;
			float3 Normal112 = UnpackNormal( tex2D( _Normal, UVs116 ) );
			o.Normal = Normal112;
			float4 Albedo111 = ( _Albedo_tint * tex2D( _Albedo, UVs116 ) );
			o.Albedo = Albedo111.rgb;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = distance( _Position , ase_worldPos );
			float simplePerlin3D26 = snoise( ( _Bordernoisescale * ( ase_worldPos + ( _Noisespeed * _Time.y ) ) ) );
			float temp_output_39_0 = ( simplePerlin3D26 + _Radius );
			float temp_output_5_0 = step( ( 1.0 - saturate( ( temp_output_15_0 / temp_output_39_0 ) ) ) , 0.5 );
			float temp_output_32_0 = saturate( ( temp_output_15_0 / ( _Borderradius + temp_output_39_0 ) ) );
			float Border49 = ( temp_output_5_0 - step( ( 1.0 - temp_output_32_0 ) , 0.5 ) );
			float4 Emission113 = ( ( _Emission_tint * tex2D( _Emission, UVs116 ) ) + ( _Bordercolor * Border49 ) );
			o.Emission = Emission113.rgb;
			float4 Metallic114 = ( tex2D( _Metallic, UVs116 ) * _Metallic_multiplier );
			o.Metallic = Metallic114.r;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float Mask51 = lerp(temp_output_5_0,step( temp_output_32_0 , 0.5 ),_Invert);
			clip( Mask51 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "AdultLink.SphereDissolveEditor_cutout"
}
/*ASEBEGIN
Version=15301
2002;62;1196;628;4269.998;2559.819;5.914066;True;False
Node;AmplifyShaderEditor.CommentaryNode;129;-2258.5,-1435.216;Float;False;3099.936;883.2822;Generate masks;28;13;26;89;41;42;27;28;40;29;19;10;49;51;24;107;5;23;103;3;33;14;11;32;12;31;18;15;39;Generate masks;0.5294118,1,0.7079109,1;0;0
Node;AmplifyShaderEditor.Vector3Node;41;-2091.748,-891.8731;Float;False;Property;_Noisespeed;Noise speed;3;0;Create;True;0;0;False;0;0,0,0;0,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;42;-2084.498,-732.5516;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1886.183,-864.354;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-1911.123,-1019.458;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-1868.63,-1110.768;Float;False;Property;_Bordernoisescale;Border noise scale;5;0;Create;True;0;0;False;0;0;0.8;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-1691.986,-936.5969;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1521.341,-939.2094;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1319.532,-726.863;Float;False;Property;_Radius;Radius;1;0;Create;True;0;0;False;0;2;5.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-1377.419,-944.2044;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1473.152,-1343.139;Float;False;Property;_Borderradius;Border radius;4;0;Create;True;0;0;False;0;1;0.27;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-1429.076,-1240.831;Float;False;Property;_Position;Position;0;0;Create;True;0;0;False;0;0,0,0;0,2.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1040.143,-812.6942;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-845.0703,-1063.763;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;15;-1179.374,-1041.769;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-761.4924,-833.3544;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-711.7442,-1256.466;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;128;158.787,-1836.2;Float;False;677.4695;320.2025;Tiling and offset;4;90;91;92;116;Tiling and offset;1,0.2867647,0.2867647,1;0;0
Node;AmplifyShaderEditor.SaturateNode;32;-545.7906,-1253.898;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-577.9045,-829.6157;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-386.5242,-831.4263;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-319.5171,-1252.374;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-272.1339,-1024.529;Float;False;Constant;_Falloffvalue;Falloff value;1;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;185.2063,-1780.859;Float;False;Property;_Tiling;Tiling;13;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;92;183.9062,-1644.361;Float;False;Property;_Offset;Offset;14;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;23;55.21357,-1274.999;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;378.9063,-1749.66;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;126;369.5547,-400.7828;Float;False;1128.171;782.5915;Emission;9;50;35;34;87;80;118;113;84;83;Emission;0.9780933,1,0.6029412,1;0;0
Node;AmplifyShaderEditor.StepOpNode;5;53.82954,-813.4396;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;407.8982,-1167.627;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;419.1901,-102.0103;Float;False;116;0;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;127;-622.7074,312.3804;Float;False;920.4142;396.5326;Metallic;5;114;66;109;62;117;Metallic;0.6039216,0.8509804,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;124;-622.9887,-240.2213;Float;False;939.5658;466.5543;Albedo;5;111;8;1;108;120;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;619.9968,-1756.017;Float;False;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;80;605.5719,-124.3641;Float;True;Property;_Emission;Emission;10;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;641.2567,-301.1236;Float;False;Property;_Emission_tint;Emission_tint;11;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;50;656.9729,252.3072;Float;False;49;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;597.5194,82.11358;Float;False;Property;_Bordercolor;Border color;6;1;[HDR];Create;True;0;0;False;0;0.8602941,0.2087478,0.2087478,0;2.323001,0.3844966,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;120;-573.8642,32.18737;Float;False;116;0;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;125;365.2448,489.553;Float;False;727.9135;283.8756;Normal;3;112;61;119;Normal;0.837931,0.6544118,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;583.9369,-1172.127;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-576.0142,417.2635;Float;False;116;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;872.8234,60.74459;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-374.9383,602.3381;Float;False;Property;_Metallic_multiplier;Metallic_multiplier;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;108;-357.4915,-175.2306;Float;False;Property;_Albedo_tint;Albedo_tint;8;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;119;391.0406,584.4268;Float;False;116;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;961.0938,-141.8481;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;62;-393.0638,394.3764;Float;True;Property;_Metallic;Metallic;12;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-393.0667,9.799554;Float;True;Property;_Albedo;Albedo;7;1;[NoScaleOffset];Create;True;0;0;False;0;None;312c93ed564bd8840ab4818e3db14d8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;103;53.0334,-1041.552;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-82.93117,400.1154;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-55.14249,5.194085;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;1141.551,38.13773;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;61;576.4774,562.0017;Float;True;Property;_Normal;Normal;9;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;c208f128e624c474bb2241affee1c866;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;107;398.8982,-940.0134;Float;False;Property;_Invert;Invert;2;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;866.386,561.7689;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;66.126,394.9311;Float;False;Metallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;86.28178,0.8526516;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;588.3358,-939.8363;Float;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;1259.125,32.20097;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;1056.301,-908.106;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;961.6654,-979.8983;Float;False;Property;_Smoothness;Smoothness;17;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;1052.451,-1278.097;Float;False;111;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;1053.819,-1052.181;Float;False;114;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;1052.819,-1125.181;Float;False;113;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;1052.939,-1201.249;Float;False;112;0;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1291.127,-1172.427;Float;False;True;2;Float;AdultLink.SphereDissolveEditor_cutout;0;0;Standard;AdultLink/SphereDissolve_cutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;15;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;41;0
WireConnection;89;1;42;0
WireConnection;40;0;27;0
WireConnection;40;1;89;0
WireConnection;28;0;29;0
WireConnection;28;1;40;0
WireConnection;26;0;28;0
WireConnection;39;0;26;0
WireConnection;39;1;13;0
WireConnection;18;0;19;0
WireConnection;18;1;39;0
WireConnection;15;0;10;0
WireConnection;15;1;27;0
WireConnection;12;0;15;0
WireConnection;12;1;39;0
WireConnection;31;0;15;0
WireConnection;31;1;18;0
WireConnection;32;0;31;0
WireConnection;11;0;12;0
WireConnection;14;0;11;0
WireConnection;33;0;32;0
WireConnection;23;0;33;0
WireConnection;23;1;3;0
WireConnection;90;0;91;0
WireConnection;90;1;92;0
WireConnection;5;0;14;0
WireConnection;5;1;3;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;116;0;90;0
WireConnection;80;1;118;0
WireConnection;49;0;24;0
WireConnection;35;0;34;0
WireConnection;35;1;50;0
WireConnection;83;0;87;0
WireConnection;83;1;80;0
WireConnection;62;1;117;0
WireConnection;1;1;120;0
WireConnection;103;0;32;0
WireConnection;103;1;3;0
WireConnection;66;0;62;0
WireConnection;66;1;109;0
WireConnection;8;0;108;0
WireConnection;8;1;1;0
WireConnection;84;0;83;0
WireConnection;84;1;35;0
WireConnection;61;1;119;0
WireConnection;107;0;5;0
WireConnection;107;1;103;0
WireConnection;112;0;61;0
WireConnection;114;0;66;0
WireConnection;111;0;8;0
WireConnection;51;0;107;0
WireConnection;113;0;84;0
WireConnection;0;0;121;0
WireConnection;0;1;130;0
WireConnection;0;2;122;0
WireConnection;0;3;123;0
WireConnection;0;4;110;0
WireConnection;0;10;115;0
ASEEND*/
//CHKSM=2416159E8B95CCA076DA28F113EC9F084E45A796