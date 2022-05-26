Shader "NiksShaders/Shader56Lit"
{
    Properties
    {
        _MainTex("Texture", 2D)                   = "white" { }
        _SpecColor("Specular", Color)             = (1, 1, 1, 1)
        _SpecPower("Specular Power", Range(0, 1)) = 0.5
        _Glossiness("Glossiness", Range(0, 1))    = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong

        sampler2D _MainTex;
        float _SpecPower;
        float _Glossiness;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo   = tex2D(_MainTex, IN.uv_MainTex).rgb;
            OUT.Specular = _SpecPower;
            OUT.Gloss    = _Glossiness;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
