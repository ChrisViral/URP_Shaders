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
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "noiseSimplex.cginc"

            fixed4 _PaleColour;
            fixed4 _DarkColour;
            float _Frequency;
            float _NoiseScale;
            float _RingScale;
            float _Contrast;

            struct v2f
            {
                float4 vertex:   SV_POSITION;
                float4 position: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                return output;
            }

            float4 frag(v2f i) : COLOR
            {
                float3 pos    = i.position.xyz * 2;
                float n = snoise(pos);
                float ring = frac((_Frequency * pos.z) + (_NoiseScale * n));
                ring *= _Contrast * (1 - ring);
                float delta = pow(ring, _RingScale) + n;
                fixed3 colour = lerp(_DarkColour, _PaleColour, delta);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

