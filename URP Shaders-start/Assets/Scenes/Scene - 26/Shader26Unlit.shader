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
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _BrickColour;
            fixed4 _MortarColour;
            int _TileCount;

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

            fixed4 frag(v2f_img i) : SV_Target
            {
                fixed3 colour = lerp(_BrickColour.rgb, _MortarColour.rgb, brick(frac(i.uv * _TileCount), 0.05, 0.2));
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}