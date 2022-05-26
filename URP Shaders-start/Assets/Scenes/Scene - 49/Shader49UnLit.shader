Shader "NiksShaders/Shader49Unlit"
{
    Properties
    {
        _Scale("Scale", Range(0.1, 3)) = 0.3
        _MainTex("Main Texture", 2D) = "white" { }
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

            float _Scale;
            sampler2D _MainTex;

            struct v2f
            {
                float4 pos:       SV_POSITION;
                float4 screenPos: TEXCOORD2;
                float2 uv:        TEXCOORD0;
                float4 noise:     TEXCOORD1;
            };

            float random(float3 pos, float seed)
            {
                return frac((sin(dot(pos + seed, float3(12.9898, 78.233, 151.7182))) * 43758.5453) + seed);
            }

            v2f vert(appdata_base v)
            {
                v2f output;
                output.noise       = float4(-turbulence((v.normal / 2) + _Time.y), 0, 0, 0);
                float b            = (_Scale / 2) * pnoise((v.vertex / 20) + _Time.y, 100);
                float displacement = b - (_Scale * output.noise.x);
                float3 pos = v.vertex + (v.normal * displacement);
                output.pos = UnityObjectToClipPos(pos);
                output.uv  = v.texcoord;
                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // get a random offset
                float3 fragCoord = float3(i.screenPos.xy * _ScreenParams, 0);
                // lookup vertically in the texture, using noise and offset
                // to get the right RGB colour
                float2 uv = float2(0, (1.3 * i.noise.x) + (0.01 * random(fragCoord, _Time.x)));
                return fixed4(tex2D(_MainTex, uv).rgb, 1);
            }
            ENDCG
        }
    }
}

