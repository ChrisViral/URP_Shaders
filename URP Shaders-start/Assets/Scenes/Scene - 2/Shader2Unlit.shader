Shader "NiksShaders/Shader2Unlit"
{
    Properties
    {
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

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed3 colour = fixed3((sin(_Time.y) + 1) / 2, 0, (cos(_Time.y) + 1) / 2);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
