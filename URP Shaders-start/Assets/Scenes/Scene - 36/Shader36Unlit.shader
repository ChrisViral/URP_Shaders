Shader "NiksShaders/Shader36Unlit"
{
    Properties
    {
        _PaleColour("Pale Colour", Color) = (0.733, 0.565, 0.365, 1)
        _DarkColour("Dark Colour", Color) = (0.49,  0.286, 0.043, 1)
        _Frequency("Frequency", Float)    = 2
        _NoiseScale("Noise Scale", Float) = 6
        _RingScale("Ring Scale", Float)   = 0
        _Contrast("Contrast", Float)      = 4
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
            #include "Assets/hlsl/noiseSimplex.hlsl"

            CBUFFER_START(UnityPerMaterial)
            half4 _PaleColour;
            half4 _DarkColour;
            float _Frequency;
            float _NoiseScale;
            float _RingScale;
            float _Contrast;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS: POSITION;
            };

            struct Varyings
            {
                float4 positionHCS: SV_POSITION;
                float4 positionOS:  TEXCOORD1;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionOS  = IN.positionOS;
                return OUT;
            }

            float4 frag(Varyings IN) : COLOR
            {
                float3 pos   = IN.positionOS.xyz * 2;
                float n      = snoise(pos);
                float ring   = frac((_Frequency * pos.z) + (_NoiseScale * n));
                ring        *= _Contrast * (1 - ring);
                float delta  = pow(ring, _RingScale) + n;
                half3 colour = lerp(_DarkColour, _PaleColour, delta);
                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}

