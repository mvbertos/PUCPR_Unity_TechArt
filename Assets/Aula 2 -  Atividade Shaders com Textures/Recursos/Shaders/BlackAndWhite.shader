Shader "Custom/BlackAndWhite"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity("Intensity",Range(0,10)) = 5
        _Threshold("Threshold",Range(-1,1)) = 1
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float  _Intensity;
            float _Threshold;

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

            v2f vert (appdata v)
            {
                v2f output;

                //Setup UV
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv = v.uv;

                return output;
              
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : Color
            {
                float4 col = tex2D(_MainTex, i.uv);

                float  avg =  (col.x+col.y+col.z)/3;
                col.rgb = avg * _Intensity;
                
                return col;
            }
            ENDCG
        }
    }
}
