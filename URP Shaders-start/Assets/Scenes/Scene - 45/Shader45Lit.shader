Shader "NiksShaders/Shader45Lit"
{
    Properties
    {
        _Radius("Radius", Float) = 1
    }

    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 vertex: SV_POSITION;
                fixed4 diff:   COLOR0; // diffuse lighting color
            };

            float _Radius;
            float _Delta;

            v2f vert(appdata_base v)
            {
                v2f output;
                float delta      = (_CosTime.w + 1) / 2;
                float3 normal    = normalize(v.vertex.xyz);
                float4 spherical = float4(normal * _Radius * 0.01, v.vertex.w);
                float4 pos       = lerp(spherical, v.vertex, delta);
                output.vertex    = UnityObjectToClipPos(pos);

                //Lighting
                half3 actualNormal = lerp(normal, v.normal, delta);
                output.diff = max(0.1, dot(UnityObjectToWorldNormal(actualNormal), _WorldSpaceLightPos0.xyz)) * _LightColor0;
                return output;
            }

            float4 frag (v2f i) : COLOR
            {
                fixed3 colour = 1 * i.diff;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

