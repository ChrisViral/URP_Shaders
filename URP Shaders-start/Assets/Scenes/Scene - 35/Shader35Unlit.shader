Shader "NiksShaders/Shader35Unlit"
{
    Properties
    {
        _BaseMap("Main Texture", 2D) = "white" { }
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
            "RenderPipeline"="UniversalPipeline"
        }
        LOD 100

        Pass
        {
            ZWrite Off

            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS: POSITION;
                float2 texcoord:   TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS: SV_POSITION;
                float2 uv:          TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv          = TRANSFORM_TEX(IN.texcoord, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : COLOR
            {
                float2 uv;
                float2 noise = 0;

                // Generate noisy y value
                uv = float2((IN.uv.x * 0.7) - 0.01, frac(IN.uv.y - (_Time.y * 0.27)));
                noise.y += (SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv).a - 0.5) * 2;
                uv = float2((IN.uv.x * 0.45) + 0.033, frac((IN.uv.y * 1.9) - (_Time.y * 0.61)));
                noise.y += (SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv).a - 0.5) * 2;
                uv = float2((IN.uv.x * 0.8) - 0.02, frac((IN.uv.y * 2.5) - (_Time.y * 0.51)));
                noise.y += (SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv).a - 0.5) * 2;
                noise = clamp(noise, -1, 1);

                float perturb = ((1 - IN.uv.y) * 0.35) + 0.02;
                noise = (noise * perturb) + IN.uv - 0.02;

                half4 colour = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, noise);
                colour = half4(colour.r * 2, colour.g * 0.9, (colour.g / colour.r) * 0.2, 1);
                noise = clamp(noise, 0.05, 1);
                colour.a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, noise).b * 2;
                colour.a = colour.a * SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv).b;

                return colour;
            }
            ENDHLSL
        }
    }
}

