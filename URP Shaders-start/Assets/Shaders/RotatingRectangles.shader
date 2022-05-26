Shader "NiksShaders/RotatingRectangles"
{
    Properties
    {
        _TileCount("TileCount", int)         = 6
        _BgColour("BackgroundColour", Color) = (0, 0, 0, 1)
        _TileColour("TileColour", Color)     = (1, 1, 0, 1)
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

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv:     TEXCOORD0;
            };

            struct v2f
            {
                float2 uv:     TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            int _TileCount;
            fixed4 _BgColour;
            fixed4 _TileColour;

            v2f vert(appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv = v.uv;
                return output;
            }

            float inRect(float2 pos, float2 anchor, float2 size, float2 center)
            {
                //return 0 if not in rect and 1 if it is
                //step(edge, x) 0.0 is returned if x < edge, and 1.0 is returned otherwise.
                pos -= center;
                float2 halfSize  = size / 2;
                float horizontal = step(-halfSize.x - anchor.x, pos.x) - step(halfSize.x - anchor.x, pos.x);
                float vertical   = step(-halfSize.y - anchor.y, pos.y) - step(halfSize.y - anchor.y, pos.y);
                return horizontal * vertical;
            }

            float2x2 getRotationMatrix(float theta)
            {
                float s = sin(theta);
                float c = cos(theta);
                return float2x2(c, -s, s, c);
            }

            float2x2 getScaleMatrix(float scale)
            {
                return float2x2(scale, 0, 0, scale);
            }

            fixed4 frag(v2f i) : SV_Target
            {
              float2 center     = 0.5;
              float2 pos        = frac(i.uv * _TileCount) - center;
              float2x2 rotation = getRotationMatrix(_Time.y);
              float2x2 scale    = getScaleMatrix(((sin(_Time.y) + 1) / 3.0) + 0.5);
              pos  = mul(rotation, pos);
              pos  = mul(scale, pos);
              pos += center;
              float r = inRect(pos, 0, 0.3, center);
              float3 colour = (_TileColour * r) + (_BgColour * (1 - r));
              return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
