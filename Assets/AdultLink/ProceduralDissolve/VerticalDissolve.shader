// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/VerticalDissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Fillpercentage("Fill percentage", Float) = 1
		[HDR]_Borderwidth("Border width", Float) = 0
		[HDR]_Bordercolor("Border color", Color) = (0,0,0,0)
		[HDR]_Fillcolor("Fill color", Color) = (1,0.5514706,0.5514706,1)
		_Noisescale("Noise scale", Range( 0 , 20)) = 0
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		[Toggle]_Layernoise("Layer noise", Float) = 0
		[Toggle]_Worldcoordinates("World coordinates", Float) = 1
		[Toggle]_Invertmask("Invert mask", Float) = 0
		[HDR]_Fresnelcolor("Fresnel color", Color) = (0,0.8344827,1,0)
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
		_Albedo("Albedo", 2D) = "black" {}
		_Bordertexture("Border texture", 2D) = "white" {}
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Fresnelcolor;
		uniform float _Borderwidth;
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
		uniform float _Fillpercentage;
		uniform float _Invertmask;
		uniform float4 _Bordercolor;
		uniform sampler2D _Bordertexture;
		uniform float4 _Bordertexture_ST;
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
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
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
			float temp_output_10_0 = (-1.0 + (_Fillpercentage - 0.0) * (1.0 - -1.0) / (1.0 - 0.0));
			float temp_output_12_0 = step( ( (0.0 + (max( (float)0 , _Borderwidth ) - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) + temp_output_2_0 ) , temp_output_10_0 );
			float temp_output_228_0 = ( 1.0 - _Invertmask );
			float temp_output_8_0 = step( temp_output_2_0 , temp_output_10_0 );
			float ColorMask156 = ( ( temp_output_12_0 * temp_output_228_0 ) + ( _Invertmask * ( 1.0 - temp_output_8_0 ) ) );
			float4 Rimlight167 = ( _Fresnelcolor * fresnelNode94 * ColorMask156 );
			float2 uv_Bordertexture = i.uv_texcoord * _Bordertexture_ST.xy + _Bordertexture_ST.zw;
			float Border120 = ( temp_output_8_0 - temp_output_12_0 );
			float4 ColoredBorder169 = ( _Bordercolor * tex2D( _Bordertexture, uv_Bordertexture ) * Border120 );
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
			float OpacityMask121 = ( ( temp_output_8_0 * temp_output_228_0 ) + ( ( 1.0 - temp_output_12_0 ) * _Invertmask ) );
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
555;92;957;538;874.542;2044.625;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;216;-1996.014,213.2181;Float;False;1442.726;501.9253;Noise & vector components;12;210;36;150;148;152;153;151;192;191;196;205;149;Noise & vector components;0.8839757,0.3529412,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;196;-1961.746,282.979;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;191;-1959.812,466.9677;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;152;-1683.099,626.9645;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;192;-1705.998,360.759;Float;False;Property;_Worldcoordinates;World coordinates;8;0;Create;True;0;0;False;0;1;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;151;-1690.349,467.6436;Float;False;Property;_Noisespeed;Noise speed;6;0;Create;True;0;0;False;0;0,0,0;0,-0.02,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;205;-1469.083,363.8282;Float;False;Components;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-1443.65,469.7029;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-1250.972,370.6239;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-1401.633,276.6614;Float;False;Property;_Noisescale;Noise scale;5;0;Create;True;0;0;False;0;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-1119.374,348.5089;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;36;-974.866,343.5616;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-4001.928,-1137.416;Float;False;3443.058;1150.14;Generate masks;47;121;222;156;223;225;226;227;229;120;14;224;12;228;230;221;13;8;10;2;43;9;29;25;201;22;26;31;11;30;200;32;34;215;76;214;77;24;27;33;204;35;203;213;208;211;212;209;Generate masks;0.5514706,1,0.7216026,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-3964.624,-533.663;Float;False;210;Noise;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;-780.6204,343.5431;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-3952.856,-452.6778;Float;False;Property;_Layernoise;Layer noise;7;1;[Toggle];Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-3791.458,-621.0421;Float;False;205;Components;0;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;213;-3486.072,-560.0624;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-3762.956,-529.8337;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3463.857,-846.5306;Float;False;Property;_Wave1offset;Wave1 offset;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3545.152,-206.854;Float;False;Property;_Wave2Frequency;Wave2 Frequency;15;0;Create;True;0;0;False;0;0;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3560.758,-922.2997;Float;False;Property;_Wave1frequency;Wave1 frequency;12;0;Create;True;0;0;False;0;0;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;-3230.552,-274.8944;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3454.015,-131.1373;Float;False;Property;_Wave2offset;Wave 2 offset;16;0;Create;True;0;0;False;0;0;8.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-3242.201,-778.8514;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;76;-3084.745,-223.3326;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;-3082.132,-105.5253;Float;False;210;Noise;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;77;-3117.936,-891.158;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-3102.208,-973.0624;Float;False;210;Noise;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;142;-3326.649,-2624.733;Float;False;1725.212;1215.049;Textures;24;130;81;80;141;89;87;88;86;128;64;140;53;60;57;59;78;132;51;139;50;82;83;85;84;Textures;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-2851.88,-885.3878;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-2849.027,-223.3575;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;78;-3244.434,-2119.314;Float;False;Property;_Foamtextiling;Foam tex tiling;23;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;22;-2725.999,-883.8262;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;84;-3254.455,-2502.693;Float;False;Property;_Basetextiling;Base tex tiling;20;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;86;-3217.419,-1729.251;Float;False;Property;_Noisetextiling;Noise tex tiling;27;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;26;-2875.21,-975.7985;Float;False;Property;_Wave1amplitude;Wave1 amplitude;11;0;Create;True;0;0;False;0;0;0.288;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-2725.52,-220.8044;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;200;-2545.101,-1077.649;Float;False;Constant;_Int0;Int 0;26;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2867.198,-112.2262;Float;False;Property;_Wave2amplitude;Wave2 amplitude;14;0;Create;True;0;0;False;0;0;0.207;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2567.226,-1000.227;Float;False;Property;_Borderwidth;Border width;2;1;[HDR];Create;True;3;Option1;0;Option2;1;Option3;2;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;83;-3026.977,-2381.377;Float;False;Property;_Basetexspeed;Base tex speed;19;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;9;-2570.029,-113.4544;Float;False;Property;_Fillpercentage;Fill percentage;1;0;Create;True;0;0;False;0;1;0.643;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-3023.641,-2138.063;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;87;-2970.281,-1625.834;Float;False;Property;_Noisetexspeed;Noise tex speed;26;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-3040.063,-2521.644;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2576.773,-908.6409;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;201;-2398.102,-1018.648;Float;False;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2574.001,-219.4884;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-2994.755,-1747.489;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;59;-3015.24,-1985.16;Float;False;Property;_Foamtexspeed;Foam tex speed;22;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;89;-2733.26,-1746.587;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-2272.734,-285.5668;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;849.6599,-1011.761;Float;False;Constant;_Desaturation;Desaturation;23;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;82;-2763.847,-2520.232;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-2233.353,-843.905;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-2229.429,-561.1376;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;60;-2746.847,-2137.137;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-2008.888,-629.2974;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;-2470.709,-2513.592;Float;True;Property;_Basetex;Base tex;17;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;1114.846,-1011.76;Float;False;TexDesaturation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-1596.376,-252.1689;Float;False;Property;_Invertmask;Invert mask;9;1;[Toggle];Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-2421.112,-2312.611;Float;False;138;TexDesaturation;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-2420.885,-1554.4;Float;False;138;TexDesaturation;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;8;-1877.521,-306.5987;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;53;-2497.024,-2134.619;Float;True;Property;_Foamtex;Foam tex;21;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;80;-2483.256,-1749.387;Float;True;Property;_Noisetex;Noise tex;24;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;140;-2443.448,-1934.99;Float;False;138;TexDesaturation;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;81;-2144.294,-1743.04;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;12;-1871.844,-558.8539;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;51;-2124.788,-2508.765;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;230;-1438.939,-152.9909;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;64;-2156.05,-2130.279;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;145;-1449.34,-2134.218;Float;False;892.4351;924.1381;Texture mix;11;126;70;55;47;143;144;91;131;129;133;40;Texture mix;0.4705882,0.7371198,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;228;-1316.084,-243.6793;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;-1369.313,-1680.244;Float;False;Property;_Noisecolor;Noise color;25;1;[HDR];Create;True;0;0;False;0;0,0.9485294,0.04579093,1;0,0.9485294,0.04579091,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1343.973,-1496.342;Float;False;128;FoamTex;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-1094.603,-169.0119;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-1391.844,-2060.867;Float;False;Property;_Basecolor;Base color;18;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1868512,0.1868512,1;0.375,0.6637931,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;131;-1338.024,-1760.031;Float;False;130;NoiseTex;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-1099.772,-267.3804;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-1891.175,-1749.496;Float;False;NoiseTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1900.05,-2130.279;Float;False;FoamTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-1884.788,-2508.765;Float;False;BaseTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;144;-1361.593,-1409.384;Float;False;Constant;_Foamcolor;Foam color;23;0;Create;True;0;0;False;0;1,0.9724138,0,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1335.661,-1889.592;Float;False;132;BaseTex;0;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;172;-460.8037,-2129.568;Float;False;756.2512;499.8379;Border;5;122;233;16;169;15;Border;0.7867647,0.3471021,0.4471633,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;-939.0378,-211.7667;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1086.918,-1754.532;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-1094.85,-1532.712;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1569.885,-619.9456;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;166;-1436.129,-2838.241;Float;False;982.5768;520.1836;Rim light;5;167;95;94;97;123;Rim light;0.9720081,1,0.4926471,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1088.257,-1908.206;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-343.5511,-2073.386;Float;False;Property;_Bordercolor;Border color;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.5352939,1.632568,2.08,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-819.7045,-217.1938;Float;False;ColorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;97;-1330.672,-2764.188;Float;False;Property;_Fresnelcolor;Fresnel color;10;1;[HDR];Create;True;0;0;False;0;0,0.8344827,1,0;0.5882352,0.7614604,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-1427.771,-626.8671;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-917.736,-1777.489;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1121.169,-2458.421;Float;False;156;ColorMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;94;-1380.845,-2593.607;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-279.7126,-1715.663;Float;False;120;Border;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;233;-427.13,-1905.337;Float;True;Property;_Bordertexture;Border texture;29;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;162;-173.1782,-643.9207;Float;False;156;ColorMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-133.8862,-984.9666;Float;False;126;Textures;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-899.133,-2563.954;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;229;-1443.654,-509.2114;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-140.1611,-1068.934;Float;False;156;ColorMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;161;-178.5353,-819.7047;Float;False;Property;_Fillcolor;Fill color;4;1;[HDR];Create;True;0;0;False;0;1,0.5514706,0.5514706,1;0,0.2843275,0.3585,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-78.27098,-2027.164;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-799.2352,-1782.907;Float;False;Textures;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-688.1255,-2569.181;Float;False;Rimlight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-15.00811,-1153.27;Float;False;169;ColoredBorder;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-1099.166,-497.4688;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-1097.817,-405.694;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;169;56.75369,-2031.467;Float;False;ColoredBorder;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;22.21445,-1230.55;Float;False;167;Rimlight;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;66.68534,-1064.243;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-166.5511,-898.7576;Float;False;169;ColoredBorder;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;53.64954,-743.9047;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;222;-931.0853,-453.5736;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;236.724,-1171.625;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;216.4137,-894.9866;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;157;396.0571,-980.5207;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-812.2444,-458.7562;Float;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;375.4721,-802.2837;Float;False;121;OpacityMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;231;247.6633,-1412.055;Float;True;Property;_Albedo;Albedo;28;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;596.6983,-1026.047;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/VerticalDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;32;0;214;0
WireConnection;32;1;77;0
WireConnection;34;0;76;0
WireConnection;34;1;215;0
WireConnection;22;0;32;0
WireConnection;30;0;34;0
WireConnection;57;0;78;0
WireConnection;85;0;84;0
WireConnection;25;0;26;0
WireConnection;25;1;22;0
WireConnection;201;0;200;0
WireConnection;201;1;11;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;88;0;86;0
WireConnection;89;0;88;0
WireConnection;89;2;87;0
WireConnection;10;0;9;0
WireConnection;82;0;85;0
WireConnection;82;2;83;0
WireConnection;43;0;201;0
WireConnection;2;0;25;0
WireConnection;2;1;213;1
WireConnection;2;2;29;0
WireConnection;60;0;57;0
WireConnection;60;2;59;0
WireConnection;13;0;43;0
WireConnection;13;1;2;0
WireConnection;50;1;82;0
WireConnection;138;0;137;0
WireConnection;8;0;2;0
WireConnection;8;1;10;0
WireConnection;53;1;60;0
WireConnection;80;1;89;0
WireConnection;81;0;80;0
WireConnection;81;1;141;0
WireConnection;12;0;13;0
WireConnection;12;1;10;0
WireConnection;51;0;50;0
WireConnection;51;1;139;0
WireConnection;230;0;8;0
WireConnection;64;0;53;0
WireConnection;64;1;140;0
WireConnection;228;0;221;0
WireConnection;225;0;221;0
WireConnection;225;1;230;0
WireConnection;224;0;12;0
WireConnection;224;1;228;0
WireConnection;130;0;81;0
WireConnection;128;0;64;0
WireConnection;132;0;51;0
WireConnection;223;0;224;0
WireConnection;223;1;225;0
WireConnection;55;0;131;0
WireConnection;55;1;91;0
WireConnection;143;0;129;0
WireConnection;143;1;144;0
WireConnection;14;0;8;0
WireConnection;14;1;12;0
WireConnection;47;0;40;0
WireConnection;47;1;133;0
WireConnection;156;0;223;0
WireConnection;120;0;14;0
WireConnection;70;0;47;0
WireConnection;70;1;55;0
WireConnection;70;2;143;0
WireConnection;95;0;97;0
WireConnection;95;1;94;0
WireConnection;95;2;123;0
WireConnection;229;0;12;0
WireConnection;15;0;16;0
WireConnection;15;1;233;0
WireConnection;15;2;122;0
WireConnection;126;0;70;0
WireConnection;167;0;95;0
WireConnection;226;0;8;0
WireConnection;226;1;228;0
WireConnection;227;0;229;0
WireConnection;227;1;221;0
WireConnection;169;0;15;0
WireConnection;99;0;124;0
WireConnection;99;1;127;0
WireConnection;163;0;161;0
WireConnection;163;1;162;0
WireConnection;222;0;226;0
WireConnection;222;1;227;0
WireConnection;49;0;168;0
WireConnection;49;1;170;0
WireConnection;49;2;99;0
WireConnection;164;0;171;0
WireConnection;164;1;163;0
WireConnection;157;0;49;0
WireConnection;157;1;164;0
WireConnection;121;0;222;0
WireConnection;0;0;231;0
WireConnection;0;2;157;0
WireConnection;0;10;125;0
ASEEND*/
//CHKSM=83BDAF46C19E85A8427CB139E308E52F3F2E6BF3