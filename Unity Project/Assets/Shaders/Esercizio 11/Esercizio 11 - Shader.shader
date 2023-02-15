Shader "Unlit/Esercizio 11 - Shader"
{
    Properties
    {
        _MaskTex ("MaskTex", 2D) = "white" {}
        _PrimaryColor ("PrimaryColor", Color) = (1, 1, 1, 1)
        _SecondaryColor ("SecondaryColor", Color) = (1, 1, 1, 1)
        _TransitionWidth ("TransitionWidth", Range(0, 0.3)) = 0.15
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
            
            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float4 _PrimaryColor;
            float4 _SecondaryColor;
            float _TransitionWidth;
            
            void RemapFloat(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float cutLevel = (sin(_Time.y) + 1) / 2;
                
                float mask = tex2D(_MaskTex, i.uv).r;
                float2 inRange = float2(cutLevel, cutLevel + _TransitionWidth);
                
                RemapFloat(mask, inRange, float2(0, 1), mask);
                mask = saturate(mask);
                
                return lerp(_PrimaryColor, _SecondaryColor, mask);
            }
            
            ENDCG
        }
    }
}
