Shader "NiksShaders/Shader40Unlit"
{
    Properties
    {
        [NoScaleOffset] _TextureA("Texture A", 2D)     = "white" { }
        [NoScaleOffset] _TextureB("Texture B", 2D)     = "white" { }
        [NoScaleOffset] _Duration("Duration", Float)   = 6
        [NoScaleOffset] _StartTime("StartTime", Float) = 0
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
            sampler2D _TextureA;
            sampler2D _TextureB;
            float _Duration;
            float _StartTime;
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

            half4 frag(Varyings IN) : COLOR
            {
                float time    = _Time.y - _StartTime;
                float2 pos    = (2 * IN.uv) - 1;
                float len     = length(pos);
                float2 ripple = IN.uv + ((pos / len) * cos((len * 12) - (time * 4)) * 0.03);
                float delta   = saturate(time / _Duration);
                float2 uv     = lerp(ripple, IN.uv, delta);
                half3 colour1 = tex2D(_TextureA, uv).rgb;
                half3 colour2 = tex2D(_TextureB, uv).rgb;
                float fade    = smoothstep(delta * 1.4, delta * 2.5, len);
                half3 colour  = lerp(colour2, colour1, fade);
                return half4(colour, 1);
            }
            ENDHLSL
        }
    }
}
