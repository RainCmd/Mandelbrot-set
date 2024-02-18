Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Trans("变换", Vector) = (0, 0, 1, 1)
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            float4 _Trans;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _Trans.zw + _Trans.xy;
                return o;
            }

            fixed map(fixed v, fixed mmin, fixed mmax)
            {
                v = clamp(v, mmin, mmax * 2 - mmin);
                return sin((v - mmin) / (mmax - mmin) * 3.1415926 * .5);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float len = dot(i.uv, i.uv);
                int idx = 0;
                float2 v = i.uv;
                while(idx++ < 256)
                {
                    float x = v.x * v.x - v.y * v.y + i.uv.x;
                    v.y = 2 * v.x * v.y + i.uv.y;
                    v.x = x;
                }
                len /= dot(v, v);
                return fixed4(map(len, 2, 3), map(len, 1, 2), map(len, 0, 1), 1);
            }
            ENDCG
        }
    }
}
