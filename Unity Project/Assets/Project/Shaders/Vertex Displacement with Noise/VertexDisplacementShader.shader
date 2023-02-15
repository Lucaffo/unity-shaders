Shader "Unlit/Esercizio 16 - Shader"
{
    Properties
    {
        _MainTex ("MainTexture", 2D) = "white" {}
        _MainColor ("MainColor", color) = (1, 1, 1, 1)
        _DisplacementTexture ("DisplacementTexture", 2D) = "white" {}
        _DisplacementScrolling ("DisplacementScrolling", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAl;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 normal : NORMAl;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _MainColor;

            sampler2D _DisplacementTexture;
            float4 _DisplacementTexture_ST;

            float _DisplacementScrolling;

            float remap(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert (appdata v)
            {
                v2f o;
                float2 scrollingUV = float2(0, sin(_Time.y * _DisplacementScrolling));
                float4 displacementColor = tex2Dlod(_DisplacementTexture, float4(v.uv + scrollingUV, 0, 0));
                float dis = remap(length(displacementColor), float2(0.0, 1.0), float2(-0.5, 2.0));
                o.vertex = UnityObjectToClipPos(v.vertex + v.normal * dis);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _MainColor;
                return col;
            }
            ENDCG
        }
    }
}
