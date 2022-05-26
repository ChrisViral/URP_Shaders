Shader "NiksShaders/Shader53Lit"
{
    Properties
    {
        _MainTex("Texture", 2D)               = "white" { }
        _NormalMap("Normal", 2D)              = "bump" { }
        _RimColor("Rim Color", Color)         = (0.26, 0.19, 0.16, 0)
        _RimPower("Rim Power", Range(0.5, 8)) = 3
        _RimWidth("Rim Width", Range(0, 1))   = 0.6
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _NormalMap;
        float4 _RimColor;
        float _RimPower;
        float _RimWidth;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            OUT.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            float rim = max(0, _RimWidth - saturate(dot(OUT.Normal, normalize(IN.viewDir))));
            OUT.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }
    Fallback "Diffuse"
}
