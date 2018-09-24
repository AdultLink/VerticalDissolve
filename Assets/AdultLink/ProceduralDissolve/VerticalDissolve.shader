// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/VerticalDissolve"
{
	Properties
	{
		_FillPercentage("Fill Percentage", Float) = 1
		[HDR]_Borderwidth("Border width", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_Bordercolor("Border color", Color) = (0,0,0,0)
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		_Noisescale("Noise scale", Range( 0 , 20)) = 0
		_Wave1amplitude("Wave1 amplitude", Range( 0 , 1)) = 0
		_Wave1frequency("Wave1 frequency", Range( 0 , 50)) = 0
		_Wave1offset("Wave1 offset", Float) = 0
		_Wave2amplitude("Wave2 amplitude", Range( 0 , 1)) = 0
		_Wave2Frequency("Wave2 Frequency", Range( 0 , 50)) = 0
		_Wave2offset("Wave 2 offset", Float) = 0
		_Basetex("Base tex", 2D) = "white" {}
		[HDR]_Basecolor("Base color", Color) = (0.7941176,0.1868512,0.1868512,1)
		_Basetexspeed("Base tex speed", Vector) = (0,0,0,0)
		_Basetextiling("Base tex tiling", Vector) = (0,0,0,0)
		_Foamtex("Foam tex", 2D) = "black" {}
		_Foamtexspeed("Foam tex speed", Vector) = (0,0,0,0)
		_Foamtextiling("Foam tex tiling", Vector) = (0,0,0,0)
		_Noisetex("Noise tex", 2D) = "black" {}
		[HDR]_Noisecolor("Noise color", Color) = (0,0.9485294,0.04579093,1)
		_Noisetexspeed("Noise tex speed", Vector) = (0,0,0,0)
		_Noisetextiling("Noise tex tiling", Vector) = (0,0,0,0)
		[HDR]_Fresnelcolor("Fresnel color", Color) = (0,0.8344827,1,0)
		[HDR]_Fillcolor("Fill color", Color) = (1,0.5514706,0.5514706,1)
		[Toggle]_Worldcoordinates("World coordinates", Float) = 1
		[Toggle]_Layernoise("Layer noise", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform float4 _Fresnelcolor;
		uniform float _Wave1amplitude;
		uniform float _Noisescale;
		uniform float _Worldcoordinates;
		uniform float3 _Noisespeed;
		uniform float _Layernoise;
		uniform float _Wave1frequency;
		uniform float _Wave1offset;
		uniform float _Wave2Frequency;
		uniform float _Wave2offset;
		uniform float _Wave2amplitude;
		uniform float _FillPercentage;
		uniform float _Borderwidth;
		uniform float4 _Bordercolor;
		uniform float4 _Basecolor;
		uniform sampler2D _Basetex;
		uniform float2 _Basetexspeed;
		uniform float2 _Basetextiling;
		uniform sampler2D _Noisetex;
		uniform float2 _Noisetexspeed;
		uniform float2 _Noisetextiling;
		uniform float4 _Noisecolor;
		uniform sampler2D _Foamtex;
		uniform float2 _Foamtexspeed;
		uniform float2 _Foamtextiling;
		uniform float4 _Fillcolor;
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
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV94 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode94 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV94, 3.53 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 Components205 = lerp(ase_vertex3Pos,ase_worldPos,_Worldcoordinates);
			float simplePerlin3D36 = snoise( ( _Noisescale * ( Components205 + ( _Noisespeed * _Time.y ) ) ) );
			float Noise210 = simplePerlin3D36;
			float temp_output_208_0 = ( Noise210 * _Layernoise );
			float3 break213 = Components205;
			float temp_output_2_0 = ( ( _Wave1amplitude * sin( ( Noise210 + (( temp_output_208_0 + break213.x )*_Wave1frequency + _Wave1offset) ) ) ) + break213.y + ( sin( ( (( break213.z + temp_output_208_0 )*_Wave2Frequency + _Wave2offset) + Noise210 ) ) * _Wave2amplitude ) );
			float temp_output_10_0 = (-1.0 + (_FillPercentage - 0.0) * (1.0 - -1.0) / (1.0 - 0.0));
			float temp_output_8_0 = step( temp_output_2_0 , temp_output_10_0 );
			float OpacityMask121 = temp_output_8_0;
			float Border120 = ( temp_output_8_0 - step( ( (0.0 + (max( (float)0 , _Borderwidth ) - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) + temp_output_2_0 ) , temp_output_10_0 ) );
			float ColorMask156 = ( OpacityMask121 - Border120 );
			float4 Rimlight167 = ( _Fresnelcolor * fresnelNode94 * ColorMask156 );
			float4 ColoredBorder169 = ( _Bordercolor * Border120 );
			float2 uv_TexCoord85 = i.uv_texcoord * _Basetextiling;
			float2 panner82 = ( 1.0 * _Time.y * _Basetexspeed + uv_TexCoord85);
			float TexDesaturation138 = 1.0;
			float3 desaturateInitialColor51 = tex2D( _Basetex, panner82 ).rgb;
			float desaturateDot51 = dot( desaturateInitialColor51, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar51 = lerp( desaturateInitialColor51, desaturateDot51.xxx, TexDesaturation138 );
			float3 BaseTex132 = desaturateVar51;
			float2 uv_TexCoord88 = i.uv_texcoord * _Noisetextiling;
			float2 panner89 = ( 1.0 * _Time.y * _Noisetexspeed + uv_TexCoord88);
			float3 desaturateInitialColor81 = tex2D( _Noisetex, panner89 ).rgb;
			float desaturateDot81 = dot( desaturateInitialColor81, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar81 = lerp( desaturateInitialColor81, desaturateDot81.xxx, TexDesaturation138 );
			float3 NoiseTex130 = desaturateVar81;
			float2 uv_TexCoord57 = i.uv_texcoord * _Foamtextiling;
			float2 panner60 = ( 1.0 * _Time.y * _Foamtexspeed + uv_TexCoord57);
			float3 desaturateInitialColor64 = tex2D( _Foamtex, panner60 ).rgb;
			float desaturateDot64 = dot( desaturateInitialColor64, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar64 = lerp( desaturateInitialColor64, desaturateDot64.xxx, TexDesaturation138 );
			float3 FoamTex128 = desaturateVar64;
			float4 Textures126 = ( ( _Basecolor * float4( BaseTex132 , 0.0 ) ) + ( float4( NoiseTex130 , 0.0 ) * _Noisecolor ) + ( float4( FoamTex128 , 0.0 ) * float4(1,0.9724138,0,1) ) );
			float4 switchResult157 = (((i.ASEVFace>0)?(( Rimlight167 + ColoredBorder169 + ( ColorMask156 * Textures126 ) )):(( ColoredBorder169 + ( _Fillcolor * ColorMask156 ) ))));
			o.Emission = switchResult157.rgb;
			o.Alpha = 1;
			clip( OpacityMask121 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
492;92;1020;538;6857.3;2934.364;7.293101;True;False
Node;AmplifyShaderEditor.CommentaryNode;216;-3515.945,213.2181;Float;False;1442.726;501.9253;Noise & vector components;12;210;36;150;148;152;153;151;192;191;196;205;149;Noise & vector components;0.8839757,0.3529412,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;191;-3479.743,466.9677;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;196;-3481.677,282.979;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;152;-3203.031,626.9645;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;151;-3210.281,467.6436;Float;False;Property;_Noisespeed;Noise speed;4;0;Create;True;0;0;False;0;0,0,0;0,-0.02,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ToggleSwitchNode;192;-3225.93,360.759;Float;False;Property;_Worldcoordinates;World coordinates;25;0;Create;True;0;0;False;0;1;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;205;-2989.016,363.8282;Float;False;Components;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-2963.583,469.7029;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-2770.906,370.6239;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-2921.567,276.6614;Float;False;Property;_Noisescale;Noise scale;5;0;Create;True;0;0;False;0;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-2639.308,348.5089;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;36;-2494.8,343.5616;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-3502.086,-1133.415;Float;False;2950.501;1149.412;Generate masks;39;43;13;156;154;120;155;121;14;8;12;9;10;26;31;215;29;213;2;35;27;76;203;214;24;33;209;211;212;208;77;204;34;30;32;22;201;25;11;200;Generate masks;0.5514706,1,0.7216026,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;-2300.555,343.5431;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-3464.781,-529.6622;Float;False;210;Noise;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-3453.014,-448.6769;Float;False;Property;_Layernoise;Layer noise;26;1;[Toggle];Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-3291.615,-617.0412;Float;False;205;Components;0;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;213;-2986.229,-556.0615;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-3263.113,-525.8329;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3060.915,-918.2988;Float;False;Property;_Wave1frequency;Wave1 frequency;7;0;Create;True;0;0;False;0;0;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2964.015,-842.5298;Float;False;Property;_Wave1offset;Wave1 offset;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3045.309,-202.8532;Float;False;Property;_Wave2Frequency;Wave2 Frequency;10;0;Create;True;0;0;False;0;0;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;-2730.71,-270.8935;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2954.172,-127.1365;Float;False;Property;_Wave2offset;Wave 2 offset;11;0;Create;True;0;0;False;0;0;8.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-2742.359,-774.8506;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;-2582.289,-101.5245;Float;False;210;Noise;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;76;-2584.902,-219.3317;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;77;-2618.093,-887.1571;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-2602.365,-969.0615;Float;False;210;Noise;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-2349.184,-219.3566;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-2352.037,-881.3869;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2367.356,-108.2253;Float;False;Property;_Wave2amplitude;Wave2 amplitude;9;0;Create;True;0;0;False;0;0;0.207;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2375.368,-971.7976;Float;False;Property;_Wave1amplitude;Wave1 amplitude;6;0;Create;True;0;0;False;0;0;0.288;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;22;-2226.156,-879.8253;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-2225.677,-216.8035;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;200;-2045.258,-1073.648;Float;False;Constant;_Int0;Int 0;26;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2067.383,-996.2264;Float;False;Property;_Borderwidth;Border width;1;1;[HDR];Create;True;3;Option1;0;Option2;1;Option3;2;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;142;-3326.649,-2624.733;Float;False;1725.212;1215.049;Textures;24;130;81;80;141;89;87;88;86;128;64;140;53;60;57;59;78;132;51;139;50;82;83;85;84;Textures;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2074.159,-215.4875;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2076.931,-904.64;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;201;-1898.259,-1014.647;Float;False;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;78;-3244.434,-2119.314;Float;False;Property;_Foamtextiling;Foam tex tiling;18;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;86;-3217.419,-1729.251;Float;False;Property;_Noisetextiling;Noise tex tiling;22;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;84;-3254.455,-2502.693;Float;False;Property;_Basetextiling;Base tex tiling;15;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-1729.586,-557.1367;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2070.186,-109.4536;Float;False;Property;_FillPercentage;Fill Percentage;0;0;Create;True;0;0;False;0;1;0.643;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-1733.51,-839.9042;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;87;-2970.281,-1625.834;Float;False;Property;_Noisetexspeed;Noise tex speed;21;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;59;-3015.24,-1985.16;Float;False;Property;_Foamtexspeed;Foam tex speed;17;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-3040.063,-2521.644;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-3023.641,-2138.063;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;83;-3026.977,-2381.377;Float;False;Property;_Basetexspeed;Base tex speed;14;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-2994.755,-1747.489;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;89;-2733.26,-1746.587;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;82;-2763.847,-2520.232;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-1772.891,-281.5659;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;60;-2746.847,-2137.137;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;137;265.4702,-1523.356;Float;False;Constant;_Desaturation;Desaturation;23;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1509.045,-625.2965;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;12;-1372.001,-554.853;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-2443.448,-1934.99;Float;False;138;TexDesaturation;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-2483.256,-1749.387;Float;True;Property;_Noisetex;Noise tex;19;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-2470.709,-2513.592;Float;True;Property;_Basetex;Base tex;12;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;530.6575,-1523.355;Float;False;TexDesaturation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-2421.112,-2312.611;Float;False;138;TexDesaturation;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;53;-2497.024,-2134.619;Float;True;Property;_Foamtex;Foam tex;16;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;8;-1377.678,-302.5978;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-2420.885,-1554.4;Float;False;138;TexDesaturation;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;145;-1449.34,-2134.218;Float;False;892.4351;924.1381;Texture mix;11;126;70;55;47;143;144;91;131;129;133;40;Texture mix;0.4705882,0.7371198,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;51;-2124.788,-2508.765;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DesaturateOpNode;64;-2156.05,-2130.279;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1125.503,-515.9561;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;81;-2144.294,-1743.04;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-1884.788,-2508.765;Float;False;BaseTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-971.1277,-522.067;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-1141.258,-234.6537;Float;False;120;Border;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1900.05,-2130.279;Float;False;FoamTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-1338.024,-1760.031;Float;False;130;NoiseTex;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-1891.175,-1749.496;Float;False;NoiseTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1335.661,-1889.592;Float;False;132;BaseTex;0;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;91;-1369.313,-1680.244;Float;False;Property;_Noisecolor;Noise color;20;1;[HDR];Create;True;0;0;False;0;0,0.9485294,0.04579093,1;0,0.9485294,0.04579091,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;-1391.844,-2060.867;Float;False;Property;_Basecolor;Base color;13;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1868512,0.1868512,1;0.375,0.6637931,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;144;-1361.593,-1409.384;Float;False;Constant;_Foamcolor;Foam color;23;0;Create;True;0;0;False;0;1,0.9724138,0,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1343.973,-1496.342;Float;False;128;FoamTex;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-1142.56,-308.1923;Float;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;172;-460.8037,-2129.568;Float;False;620.0854;313.1589;Border;4;16;122;15;169;Border;0.7867647,0.3471021,0.4471633,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;166;-1436.129,-2838.241;Float;False;982.5768;520.1836;Rim light;5;167;95;94;97;123;Rim light;0.9720081,1,0.4926471,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1088.257,-1908.206;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-1094.85,-1532.712;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;154;-940.1492,-304.3412;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1086.918,-1754.532;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-917.736,-1777.489;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;97;-1330.672,-2764.188;Float;False;Property;_Fresnelcolor;Fresnel color;23;1;[HDR];Create;True;0;0;False;0;0,0.8344827,1,0;0.5882352,0.7614604,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;94;-1380.845,-2593.607;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-805.4197,-308.3976;Float;False;ColorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-410.1472,-1901.06;Float;False;120;Border;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1121.169,-2458.421;Float;False;156;ColorMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-433.785,-2073.982;Float;False;Property;_Bordercolor;Border color;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.5352939,1.632568,2.08,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-799.2352,-1782.907;Float;False;Textures;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-195.7048,-2029.36;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-357.881,-1059.502;Float;False;156;ColorMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-318.589,-1400.548;Float;False;126;Textures;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-324.8639,-1484.515;Float;False;156;ColorMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-899.133,-2563.954;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;161;-363.2381,-1235.286;Float;False;Property;_Fillcolor;Fill color;24;1;[HDR];Create;True;0;0;False;0;1,0.5514706,0.5514706,1;0,0.2843275,0.3585,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-131.0531,-1159.486;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-688.1255,-2569.181;Float;False;Rimlight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-162.4882,-1646.131;Float;False;167;Rimlight;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-118.0173,-1479.824;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-351.2538,-1314.339;Float;False;169;ColoredBorder;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-199.7108,-1568.851;Float;False;169;ColoredBorder;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;169;-60.68007,-2033.663;Float;False;ColoredBorder;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;31.71109,-1310.568;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;52.02136,-1587.206;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;190.7694,-1217.865;Float;False;121;OpacityMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;157;211.3543,-1396.102;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;411.9955,-1441.628;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/VerticalDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;192;0;196;0
WireConnection;192;1;191;0
WireConnection;205;0;192;0
WireConnection;153;0;151;0
WireConnection;153;1;152;0
WireConnection;149;0;205;0
WireConnection;149;1;153;0
WireConnection;150;0;148;0
WireConnection;150;1;149;0
WireConnection;36;0;150;0
WireConnection;210;0;36;0
WireConnection;213;0;212;0
WireConnection;208;0;211;0
WireConnection;208;1;209;0
WireConnection;203;0;213;2
WireConnection;203;1;208;0
WireConnection;204;0;208;0
WireConnection;204;1;213;0
WireConnection;76;0;203;0
WireConnection;76;1;27;0
WireConnection;76;2;35;0
WireConnection;77;0;204;0
WireConnection;77;1;24;0
WireConnection;77;2;33;0
WireConnection;34;0;76;0
WireConnection;34;1;215;0
WireConnection;32;0;214;0
WireConnection;32;1;77;0
WireConnection;22;0;32;0
WireConnection;30;0;34;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;25;0;26;0
WireConnection;25;1;22;0
WireConnection;201;0;200;0
WireConnection;201;1;11;0
WireConnection;2;0;25;0
WireConnection;2;1;213;1
WireConnection;2;2;29;0
WireConnection;43;0;201;0
WireConnection;85;0;84;0
WireConnection;57;0;78;0
WireConnection;88;0;86;0
WireConnection;89;0;88;0
WireConnection;89;2;87;0
WireConnection;82;0;85;0
WireConnection;82;2;83;0
WireConnection;10;0;9;0
WireConnection;60;0;57;0
WireConnection;60;2;59;0
WireConnection;13;0;43;0
WireConnection;13;1;2;0
WireConnection;12;0;13;0
WireConnection;12;1;10;0
WireConnection;80;1;89;0
WireConnection;50;1;82;0
WireConnection;138;0;137;0
WireConnection;53;1;60;0
WireConnection;8;0;2;0
WireConnection;8;1;10;0
WireConnection;51;0;50;0
WireConnection;51;1;139;0
WireConnection;64;0;53;0
WireConnection;64;1;140;0
WireConnection;14;0;8;0
WireConnection;14;1;12;0
WireConnection;81;0;80;0
WireConnection;81;1;141;0
WireConnection;132;0;51;0
WireConnection;120;0;14;0
WireConnection;128;0;64;0
WireConnection;130;0;81;0
WireConnection;121;0;8;0
WireConnection;47;0;40;0
WireConnection;47;1;133;0
WireConnection;143;0;129;0
WireConnection;143;1;144;0
WireConnection;154;0;121;0
WireConnection;154;1;155;0
WireConnection;55;0;131;0
WireConnection;55;1;91;0
WireConnection;70;0;47;0
WireConnection;70;1;55;0
WireConnection;70;2;143;0
WireConnection;156;0;154;0
WireConnection;126;0;70;0
WireConnection;15;0;16;0
WireConnection;15;1;122;0
WireConnection;95;0;97;0
WireConnection;95;1;94;0
WireConnection;95;2;123;0
WireConnection;163;0;161;0
WireConnection;163;1;162;0
WireConnection;167;0;95;0
WireConnection;99;0;124;0
WireConnection;99;1;127;0
WireConnection;169;0;15;0
WireConnection;164;0;171;0
WireConnection;164;1;163;0
WireConnection;49;0;168;0
WireConnection;49;1;170;0
WireConnection;49;2;99;0
WireConnection;157;0;49;0
WireConnection;157;1;164;0
WireConnection;0;2;157;0
WireConnection;0;10;125;0
ASEEND*/
//CHKSM=FF8725DBDBC55281AB358A31D1BF0EF708E9ABF2