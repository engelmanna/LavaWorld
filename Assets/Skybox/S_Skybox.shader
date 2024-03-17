Shader "LavaWorld/Skybox"
{
    Properties
    {
        [HDR] _SColor("SkyColor", Color) = (1, 1, 1, 1)
        [HDR]_HColor("HorizonColor", Color) = (0.5, 0.5, 0.5, 1)
        _HFade("HorizonFade",float) = 20
        _SOffset("SkyOffset",float) = 0
        _SPow("SkyPower",float) = 1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Background"
            "Queue"="Background"
        }
        LOD 100

        Pass
        {
            // Render State
            Cull Back
            Blend One Zero
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _SColor;
            float4 _HColor;
            float _HFade;
            float _SOffset;
            float _SPow;
            CBUFFER_END

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.viewDir = normalize(ObjSpaceViewDir(v.vertex));;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float gLerp = saturate(-i.viewDir.y * _HFade);
                float sLerp = pow(saturate(-i.viewDir.y * _SOffset),_SPow);

                float4 skyCol = lerp(_HColor, _SColor,sLerp);
                float4 col = lerp(unity_FogColor,skyCol,gLerp);
               
                return col;
            }
            ENDCG
        }
    }
}
