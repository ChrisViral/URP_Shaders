Shader "NiksShaders/BasicDiffuse"
{
    Properties
    {
        _Colour("Colour", Color)       = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" { }
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        fixed4 _Colour;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            // Albedo comes from a texture tinted by color
            fixed4 colour = tex2D(_MainTex, IN.uv_MainTex) * _Colour;
            OUT.Albedo    = colour.rgb;
            OUT.Alpha     = colour.a;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
