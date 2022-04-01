Shader "Custom/ImageShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle] _BlackWhite ("B/W",Int) = 0
        _Bright ("Bright",Range(0,10)) = 1
        _Threshold ("Threshold",Range(0,1) ) = 0
    }
    SubShader
    {
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            int _BlackWhite;
            float _Bright;
            float _Threshold;

            float4 frag (v2f i) : COLOR
            {
                float4 color = tex2D(_MainTex, i.uv);
                color.rgb = _Bright * color.rgb;

                if(_BlackWhite){
                    //color.rgb = color.r;
                    //color.rgb = (color.r+color.g+color.b)/3.0;
                    color.rgb = 0.3*color.r + 0.59*color.g + 0.11*color.b;
            
                    if(color.r > _Threshold){
                        color.rgb = 1.0;
                    }else{
                        color.rgb = 0;
                    }
                }
                return color;
            }
            ENDCG
        }
    }
}
