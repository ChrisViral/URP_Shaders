Shader "NiksShaders/BasicUnlit"
{
    Properties
    {
        _Colour("Colour", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" { }
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
                float4 vertex: POSITION;
                float2 uv:     TEXCOORD0;
            };

            struct v2f
            {
                float2 uv:     TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv     = TRANSFORM_TEX(v.uv, _MainTex);
                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
