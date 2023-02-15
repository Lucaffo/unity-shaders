Shader "Unlit/Esercizio 12 - Shader"
{
    Properties
    {
        _ColorA ("ColorA", Color) = (1, 1, 1, 1)
        _ColorB ("ColorB", Color) = (1, 1, 1, 1)
        _ColorC ("ColorC", Color) = (1, 1, 1, 1)
        _CutLevel ("CutLevel", Range(0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        
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
            
            float4 _ColorA;
            float4 _ColorB;
            float4 _ColorC;
            float _CutLevel;
            
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
                float cutLevel = 0.0;
                
                RemapFloat(_CutLevel, float2(0, 1), float2(-1, 1), cutLevel);
                float4 upperColor = lerp(_ColorA, _ColorC, i.uv.y + cutLevel);
                
                RemapFloat(_CutLevel, float2(0, 1), float2(1, -1), cutLevel);
                float4 underColor = lerp(_ColorC, _ColorB, i.uv.y + cutLevel);
                
                return upperColor * underColor;
            }
            
            ENDCG
        }
    }
}
