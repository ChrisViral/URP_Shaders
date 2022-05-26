Shader "NiksShaders/Shader2Unlit"
{
    Properties
    {
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

            struct Attributes
            {
                float4 positionOS: POSITION;
            };

            struct Varyings
            {
                float4 positionHCS: SV_POSITION;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                return OUT;
            }

            half4 frag() : SV_Target
            {
                half3 colour = half3((sin(_Time.y) + 1) / 2, 0, (cos(_Time.y) + 1) / 2);
                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}
