Shader "LavaWorld/LavaTrailSplat"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
        _Velocity("Velocity",Vector) = (0,0,0,0)
        _Size("Size",float) = 1
    }
    SubShader
    {
        Lighting Off
        Blend One Zero
       
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Velocity;

            float _Size;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed3 frag(v2f i) : SV_Target
            {
                float3 rt = tex2D(_MainTex, (i.uv + _Velocity.xz*.05f)).rgb;
                float dist = saturate(1 - distance((i.uv - .5 ) * 25, 0)+.3)*_Size;
                float2 vel_norm = _Velocity.xz * .5f + .5f;
                float3 vel_color = float3(vel_norm.x, vel_norm.y, max(dist, rt.b));
                float3 splat_color = lerp(rt, vel_color, dist);

                return splat_color * float3(1, 1, .9995f);
            }
            ENDCG
        }
    }
}
