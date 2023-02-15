Shader "Unlit/HealthBar"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_HealthValue ("HealthValue", Range(0.0, 1.0)) = 0.5
		
		_MinHealthCutLevel ("MinHealthCutLevel", Range(0.0, 1.0)) = 0.2
		_MinHealthColor ("MinHealthColor", color) = (1, 0, 0, 1)
		
		_MidHealthCutLevel ("MidHealthCutLevel", Range(0.0, 1.0)) = 0.2
		_MidHealthColor ("MidHealthColor", color) = (1, 1, 0, 0)
		
		_MaxHealthCutLevel ("MaxHealthCutLevel", Range(0.0, 1.0)) = 0.2
		_MaxHealthColor ("MaxHealthColor", color) = (0, 1, 0, 1)
		
		_MinHealthBlinkFrequency ("MinHealthBlinkFrequency", float) = 2.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _HealthValue;

			float _MinHealthCutLevel;
			float _MidHealthCutLevel;
			float _MaxHealthCutLevel;
			
			float4 _MinHealthColor;
			float4 _MidHealthColor;
			float4 _MaxHealthColor;

			float _MinHealthBlinkFrequency;
			
			#include "UnityCG.cginc"

			float remap(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				if(_HealthValue >= _MaxHealthCutLevel)
				{
					return _MaxHealthColor;
				}

				if(_HealthValue >= _MidHealthCutLevel && _HealthValue < _MaxHealthCutLevel)
				{
					float t = remap(_HealthValue, float2(_MidHealthCutLevel, _MaxHealthCutLevel), float2(0.0, 1.0));
					return lerp(_MidHealthColor, _MaxHealthColor, t);
				}

				if(_HealthValue >= _MinHealthCutLevel && _HealthValue < _MidHealthCutLevel)
				{
					float t = remap(_HealthValue, float2(_MinHealthCutLevel, _MidHealthCutLevel), float2(0.0, 1.0));
					return lerp(_MinHealthColor, _MidHealthColor, t);
				}

				if(_HealthValue < _MinHealthCutLevel)
				{
					return lerp(_MinHealthColor, float4(1, 1, 1, 1), (sin(_Time.y * _MinHealthBlinkFrequency) + 1) / 2);
				}

				return _MinHealthColor;
			}
			ENDCG
		}
	}
}