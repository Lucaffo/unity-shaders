Shader "Unlit/Esercizio 15 - Shader"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _LineMovementFrequency ("LineMovementFrequency", float) = 0.5
        _LineWidth ("LineWidth", Range(0.0, 0.3)) = 0.05
        _LineColor ("LineColor", Color) = (1, 1, 1, 1)
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

            #include "UnityCG.cginc"
            
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
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LineMovementFrequency;
            float _LineWidth;
            float4 _LineColor;
            
            void RemapFloat(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float level = (sin(_Time.y * _LineMovementFrequency) * 0.5f) + 0.5f;
                
                if(i.uv.x - _LineWidth >= level)
                {
                    return tex2D(_MainTex, i.uv);
                }

                if(i.uv.x + _LineWidth <= level)
                {
                    float4 color = tex2D(_MainTex, i.uv);
                    float luminance = color.r * 0.2126f + color.g * 0.7152f + color.b * 0.0722f;
                    return float4(luminance, luminance, luminance, color.a);
                }
                
                return _LineColor;
            }
            
            ENDCG
        }
    }
}