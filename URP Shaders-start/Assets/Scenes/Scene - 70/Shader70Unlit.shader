Shader "NiksShaders/Shader70Unlit"
{
    Properties
    {
        [NoScaleOffset] _MainTex("Main Texture", 2D) = "white" { }
        _TintColour("TintColour", Color)             = (1, 1, 1, 1)
        _TintStrength("TintStrength", Range(0, 1))   = 0.5
        _Brightness("Brightness", Range(0, 3))       = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "RenderPipeline"="UniversalPipeline"
        }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

             #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            sampler2D _MainTex;
            half4 _TintColour;
            float _TintStrength;
            float _Brightness;
            CBUFFER_END


            struct Attributes
            {
                float4 positionOS: POSITION;
                float2 texcoord:   TEXCOORD0;
            };

            struct Varyings
            {
                float2 uv:         TEXCOORD0;
                float4 positionCS: SV_POSITION;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv         = IN.texcoord;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // sample the texture
                half4 texel  = tex2D(_MainTex, IN.uv);
                half grey    = (texel.r + texel.g + texel.b) / 3.0;
                half4 tinted = _TintColour * grey * _Brightness;
                return lerp(texel, tinted, _TintStrength);
            }
            ENDHLSL
        }
    }
}
