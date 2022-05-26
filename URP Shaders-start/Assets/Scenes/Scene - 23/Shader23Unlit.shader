Shader "NiksShaders/Shader23Unlit"
{
    Properties
    {
        _Sides("Sides", Int)                 = 3
        _Radius("Radius", Float)             = 100
        _Rotation("Rotation", Range(0, 6.3)) = 0
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
            int _Sides;
            float _Radius;
            float _Rotation;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS: POSITION;
            };

            struct Varyings
            {
                float4 positionHCS: SV_POSITION;
                float4 screenPos:  TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS   = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.screenPos = ComputeScreenPos(OUT.positionHCS);
                return OUT;
            }

            float circle(float2 pos, float2 center, float radius, float lineWidth, float smoothing)
            {
                float len = length(pos - center);
                float halfLineWidth = lineWidth / 2;
                float edge = halfLineWidth * smoothing;
                return smoothstep(radius - halfLineWidth - edge, radius - halfLineWidth,        len)
                     - smoothstep(radius + halfLineWidth,        radius + halfLineWidth + edge, len);
            }

            float polygon(float2 pos, float2 center, float radius, int sides, float rotate, float smoothing)
            {
                pos -= center;
                float theta = atan2(pos.y, pos.x) + rotate;
                float rad = TWO_PI / float(sides);
                float edge = radius * smoothing;
                float dist = cos((floor(0.5 + (theta / rad)) * rad) - theta) * length(pos);
                return 1 - smoothstep(radius, radius + edge, dist);
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float2 pos = IN.screenPos.xy * _ScreenParams.xy;
                float2 center = _ScreenParams.xy / 2;
                half3 colour = polygon(pos, center, _Radius, _Sides, _Rotation, 0.02) * half3(1, 1, 0);
                colour += circle(pos, center, _Radius, 5, 0.01) * half3(1, 1, 1);
                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}
