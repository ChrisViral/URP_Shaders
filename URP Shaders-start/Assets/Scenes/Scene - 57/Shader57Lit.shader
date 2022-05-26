Shader "NiksShaders/Shader57Lit"
{

    Properties
    {
        [NoScaleOffset] _BaseMap("Texture", 2D)            = "white"  { }
        _Colour("Colour", Color)                           = (1, 1, 1, 1)
        [IntRange] _LevelCount("Level Count", Range(2, 10)) = 3
    }

    Subshader
    {
        Tags
        {
            "RenderType"="Opaque"
            "RenderPipeline"="UniversalPipeline"
        }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            CBUFFER_START(UnityPerMaterial)
            int _LevelCount;
            half4 _Colour;
            sampler2D _BaseMap;
            CBUFFER_END

            half4 LightingRamp(float3 normal)
            {
                Light light = GetMainLight();
                half normalDot = dot(normal, light.direction);
                half diff = (normalDot / 2) + 0.5;
                diff *= diff;
                half3 ramp = floor(diff * _LevelCount) / _LevelCount;
                half3 colour = _Colour * light.color.rgb * ramp;
                return half4(colour, 1);
            }

            struct Attributes
            {
                float4 positionOS: POSITION;
                float3 normal:     NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS: SV_POSITION;
                float3 normal:      NORMAL;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normal      = IN.normal;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return LightingRamp(IN.normal);
            }
            ENDHLSL
        }
    }
}
