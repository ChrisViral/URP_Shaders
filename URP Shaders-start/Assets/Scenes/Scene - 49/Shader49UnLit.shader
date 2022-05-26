Shader "NiksShaders/Shader49Unlit"
{
    Properties
    {
        _Scale("Scale", Range(0.1, 3)) = 0.3
        [NoScaleOffset] _BaseMap("MaBase Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Assets/hlsl/noiseSimplex.hlsl"

            struct Attributes
            {
                float4 positionOS: POSITION;
                float3 normal:     NORMAL;
                float2 texcoord:   TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS: SV_POSITION;
                float2 uv:          TEXCOORD0;
                float4 noise:       TEXCOORD1;
                float3 screenPos:   TEXCOORD2;
            };

            CBUFFER_START(UnityPerMaterial)
            float _Scale;
            sampler2D _BaseMap;
            CBUFFER_END

            float random(float3 pos)
            {
                float3 scale = float3(12.9898, 78.233, 151.7182);
                return frac(sin(dot(pos, scale)) * 43758.5453);
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.noise = -turbulence((0.5 * IN.normal) + _Time.y);
                float3 size = 100;
                float b = _Scale * pnoise((0.05 * IN.positionOS.xyz) + _Time.y, size) * 0.5;
                float displacement = b - (_Scale * OUT.noise.x);
                float3 newPosition = IN.positionOS.xyz + (IN.normal * displacement);
                OUT.positionHCS = TransformObjectToHClip(newPosition);
                OUT.screenPos = ComputeNormalizedDeviceCoordinatesWithZ(OUT.positionHCS.xyz);
                OUT.uv = IN.texcoord;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float3 fragCoord = float3(IN.screenPos.xy * _ScreenParams.xy, 0);
                float rand       = random(fragCoord) / 100;
                float2 uv        = float2(0, (1.3 * IN.noise.x) + rand);
                half3 colour     = tex2D(_BaseMap, uv).rgb;
                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}
