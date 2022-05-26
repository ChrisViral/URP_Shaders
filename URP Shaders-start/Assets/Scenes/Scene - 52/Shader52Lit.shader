Shader "NiksShaders/Shader52Lit"
{
    Properties
    {
        _MainTex("Texture", 2D)  = "white" { }
        _NormalMap("Normal", 2D) = "bump" { }
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            OUT.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
        }
        ENDCG
    }
    Fallback "Diffuse"
}
