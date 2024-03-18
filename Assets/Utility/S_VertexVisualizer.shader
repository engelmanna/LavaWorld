Shader "Unlit/S_VertexVisualizer"
{
    Properties
    {
        _Mode("Viz Mode", Integer) = 1
        _cMult("ChannelMult",Color) = (1, 1, 1, 1)
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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            int _Mode;
            float4 _cMult;

            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = i.color;
                if (_Mode == 1) {
                    col = fixed4(i.uv, 0, 1);
                }
                return col * _cMult;
            }
            ENDCG
        }
    }
}
