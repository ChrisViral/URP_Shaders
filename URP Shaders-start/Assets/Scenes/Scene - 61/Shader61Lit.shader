Shader "NiksShaders/Shader61Lit"
{
    Properties
    {
        _MainTex("Texture", 2D)               = "white" { }
        _TargetColour("Target Colour", Color) = (1, 1, 1, 1)
        _Radius("Radius", Float)              = 1
        _Position("Position", Vector)         = (0, 0, 0 , 1)
        [MaterialToggle] _UseCircle("Use Circle", Int) = 1
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex;
            fixed4 _TargetColour;
            float _Radius;
            float4 _Position;
            bool _UseCircle;

            struct v2f
            {
                float2 uv:       TEXCOORD0;
                float4 pos:      SV_POSITION;
                fixed3 diff:     COLOR0;
                fixed3 ambient:  COLOR1;
                float4 worldPos: TEXCOORD2;
                SHADOW_COORDS(1)
            };


            v2f vert(appdata_base v)
            {
                v2f output;
                output.pos      = UnityObjectToClipPos(v.vertex);
                output.uv       = v.texcoord;
                half3 normal    = UnityObjectToWorldNormal(v.normal);
                half normalDot  = max(0, dot(normal, _WorldSpaceLightPos0.xyz));
                output.diff     = normalDot * _LightColor0.rgb;
                output.ambient  = ShadeSH9(half4(normal, 1));
                output.worldPos = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_SHADOW(output)
                return output;
            }

            float circle(float2 pos, float2 center, float radius, float width, float smoothing)
            {
                float len = length(pos - center);
                float halfWidth = width / 2;
                float edge = halfWidth * smoothing;
                return smoothstep(radius - halfWidth - edge, radius - halfWidth,        len)
                     - smoothstep(radius + halfWidth,        radius + halfWidth + edge, len);
            }

            float onLine(float a, float b, float width, float smoothing)
            {
                float halfLine = width / 2;
                float edge = halfLine * smoothing;
                return smoothstep(a - halfLine - edge, a - halfLine, b)
                     - smoothstep(a + halfLine, a + halfLine + edge, b);
            }

            float cross(float2 pos, float2 center, float length, float width, float smoothing)
            {
                pos -= center;
                if (pos.x > length || pos.x < -length || pos.y > length || pos.y < -length) return 0;

                float horizontal = onLine(pos.x, 0, width, smoothing);
                float vertical   = onLine(pos.y, 0, width, smoothing);
                return saturate(horizontal + vertical);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float lighting = min(1, (i.diff * SHADOW_ATTENUATION(i)) + i.ambient);
                fixed3 colour  = tex2D(_MainTex, i.uv).rgb * lighting;
                float target   = _UseCircle ? circle(i.worldPos.xz, _Position.xz, _Radius, _Radius * 0.1, 0.01)
                                            : cross(i.worldPos.xz, _Position.xz, _Radius, _Radius * 0.1, 0.01);
                return fixed4(lerp(colour, _TargetColour, target), 1);
            }
            ENDCG
        }

        // shadow casting support
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
