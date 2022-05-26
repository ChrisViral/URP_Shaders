Shader "NiksShaders/Shader22Unlit"
{
    Properties
    {
        _AxisColour("Axis Colour", Color)   = (0.8, 0.8, 0.8, 1)
        _SweepColour("Sweep Colour", Color) = (0.1, 0.3, 1, 1)
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
            half4 _AxisColour;
            half4 _SweepColour;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS: POSITION;
                float2 texcoord  : TEXCOORD0;
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

            float sweep(float2 pos, float2 center, float radius, float lineWidth, float smoothing)
            {
                pos             -= center;
                float theta      = _Time.z;
                float2 sweepLine = float2(cos(theta), -sin(theta)) * radius;
                float height     = clamp(dot(pos, sweepLine) / dot(sweepLine, sweepLine), 0, 1);
                float len        = length(pos - (sweepLine * height));
                float edge       = lineWidth * smoothing;

                float gradient = 0;
                const float GRADIENT_ANGLE = PI / 2;
                if (length(pos) < radius)
                {
                    float angle = fmod(theta + atan2(pos.y, pos.x), TWO_PI);
                    gradient    = (clamp(GRADIENT_ANGLE - angle, 0, GRADIENT_ANGLE) / GRADIENT_ANGLE) / 2;
                }

                return gradient + 1 - smoothstep(lineWidth, lineWidth + edge, len);
            }

            float circle(float2 pos, float2 center, float radius, float lineWidth, float smoothing)
            {
                float len = length(pos - center);
                float halfLineWidth = lineWidth / 2;
                float edge = halfLineWidth * smoothing;
                return smoothstep(radius - halfLineWidth - edge, radius - halfLineWidth,        len)
                     - smoothstep(radius + halfLineWidth,        radius + halfLineWidth + edge, len);
            }

            float onLine(float x, float y, float lineWidth, float smoothing)
            {
                float halfLineWidth = lineWidth / 2;
                float edge = halfLineWidth * smoothing;
                return smoothstep(x - halfLineWidth - edge, x - halfLineWidth, y) - smoothstep(x + halfLineWidth, x + halfLineWidth + edge, y);
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
                float2 center = 0.5;
                half3 colour = onLine(IN.uv.y, 0.5, 0.002, 0.5) * _AxisColour.rgb;
                colour      += onLine(IN.uv.x, 0.5, 0.002, 0.5) * _AxisColour.rgb;

                colour      += circle(IN.uv, center, 0.3, 0.002, 0.5) * _AxisColour.rgb;
                colour      += circle(IN.uv, center, 0.2, 0.002, 0.5) * _AxisColour.rgb;
                colour      += circle(IN.uv, center, 0.1, 0.002, 0.5) * _AxisColour.rgb;

                colour      += sweep(IN.uv, center, 0.3, 0.002, 0.5) * _SweepColour.rgb;

                colour += polygon(IN.uv, float2(0.9 - (sin(_Time.w) / 20),            0.5), 0.005, 3, 0.0,      0.2) * _AxisColour.rgb;
                colour += polygon(IN.uv, float2(0.1 - (sin(_Time.w + PI) / 20), 0.5), 0.005, 3, PI, 0.2) * _AxisColour.rgb;

                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}
