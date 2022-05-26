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
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            int _Sides;
            float _Radius;
            float _Rotation;

            struct v2f
            {
                float4 vertex:    SV_POSITION;
                float4 position:  TEXCOORD1;
                float2 uv:        TEXCOORD0;
                float4 screenPos: TEXCOORD2;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv       = v.texcoord;
                output.screenPos = ComputeScreenPos(output.vertex);
                return output;
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
                float rad = UNITY_TWO_PI / float(sides);
                float edge = radius * smoothing;
                float dist = cos((floor(0.5 + (theta / rad)) * rad) - theta) * length(pos);
                return 1 - smoothstep(radius, radius + edge, dist);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 pos = i.screenPos.xy * _ScreenParams.xy;
                float2 center = _ScreenParams.xy / 2;
                fixed3 colour = polygon(pos, center, _Radius, _Sides, _Rotation, 0.02) * fixed3(1, 1, 0);
                colour += circle(pos, center, _Radius, 5, 0.01) * fixed3(1, 1, 1);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
