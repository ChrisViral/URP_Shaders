Shader "NiksShaders/Shader40Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" { }
        _Duration("Duration", Float) = 6
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

            sampler2D _MainTex;
            float _Duration;

            struct v2f
            {
                float4 vertex:   SV_POSITION;
                float2 uv:       TEXCOORD0;
                float4 position: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.uv       = v.texcoord;
                output.position = v.vertex;
                return output;
            }

            float4 frag(v2f i) : COLOR
            {
                float2 pos = i.position.xy * 2;
                float len = length(pos);
                float2 ripple = i.uv + ((pos / len) * 0.03 * cos((len * 12) - (_Time.y * 4)));
                float theta = fmod(_Time.y, _Duration) * (UNITY_TWO_PI / _Duration);
                float2 uv = lerp(ripple, i.uv, (sin(theta) + 1) / 2);
                fixed3 colour = tex2D(_MainTex, uv).rgb;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

