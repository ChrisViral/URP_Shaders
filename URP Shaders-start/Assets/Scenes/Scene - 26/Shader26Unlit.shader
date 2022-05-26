Shader "NiksShaders/Shader26Unlit"
{
    Properties
    {
        _BrickColour("Brick Colour", Color)   = (0.9, 0.3, 0.4, 1)
        _MortarColour("Mortar Colour", Color) = (0.7, 0.7, 0.7, 1)
        _TileCount("Tile Count", Int)         = 10
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
            half4 _BrickColour;
            half4 _MortarColour;
            int _TileCount;
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
                OUT.uv          = IN.texcoord;
                return OUT;
            }

            float brick(float2 pos, float height, float smoothing)
            {
                float halfHeight = height / 2;
                float edge = halfHeight * smoothing;
                float result = 1 - smoothstep(halfHeight, halfHeight + edge, pos.y);
                result += smoothstep(1 - halfHeight - edge, 1 - halfHeight, pos.y);
                result += smoothstep(0.5 - halfHeight - edge, 0.5 - halfHeight, pos.y);
                result -= smoothstep(0.5 + halfHeight, 0.5 + halfHeight + edge, pos.y);

                if (pos.y > 0.5)
                {
                    pos.x = frac(pos.x + 0.5);
                }

                result += smoothstep(-halfHeight - edge, -halfHeight, pos.x);
                result -= smoothstep(halfHeight, halfHeight + edge, pos.x);
                result += smoothstep(1 - halfHeight - edge, 1 - halfHeight, pos.x);
                return saturate(result);
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half3 colour = lerp(_BrickColour.rgb, _MortarColour.rgb, brick(frac(IN.uv * _TileCount), 0.05, 0.2));
                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}