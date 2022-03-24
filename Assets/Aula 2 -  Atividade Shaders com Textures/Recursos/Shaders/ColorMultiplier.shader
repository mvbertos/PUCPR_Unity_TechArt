Shader "Custom/CustomImageShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _HUE("hue", Range(0,360)) = 50
        _SATURATION("saturation", Range(0,1)) = 1
        _VALUE("value",Range(0,1)) = 1
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float  _HUE;
            float  _SATURATION; 
            float  _VALUE;

            struct VertexOutput{
                float4 position:SV_TARGET;
                float4 colorRGB:Color;
            };

            struct TexturizedOutput{
                float4 colorRGB:Color;
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

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

            TexturizedOutput vert (appdata v)
            {
                TexturizedOutput output;

                //Setup UV
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv = v.uv;

                //Setup Color
                //Update color value
                float4 colorRGB = float4(0.0,1.0,0.0,1.0);

                if(_SATURATION == 0.0){
                    colorRGB.rgb = _VALUE;
                }else{
                    int Hi;
                    float hue,f,p,q,t;
                    if(_HUE == 360.0){
                        _HUE = 0.0;
                    }
                    hue = _HUE/60.0;
                    Hi = int(hue);
                    f = hue - Hi;
                    p = _VALUE * (1.0 - _SATURATION);
                    q = _VALUE * (1.0 - f * _SATURATION);
                    t = _VALUE * (1.0 - (1.0 - f) * _SATURATION);
                    if( Hi == 0){
                        colorRGB.r = _VALUE;
                        colorRGB.g = t;
                        colorRGB.b = p;
                    }else if( Hi == 1){
                        colorRGB.r = q;
                        colorRGB.g = _VALUE;
                        colorRGB.b = p;
                    }else if( Hi == 2){
                        colorRGB.r = p;
                        colorRGB.g = _VALUE;
                        colorRGB.b = t;
                    }else if( Hi == 3){
                        colorRGB.r = p;
                        colorRGB.g = q;
                        colorRGB.b = _VALUE;
                    }else if( Hi == 4){
                        colorRGB.r = t;
                        colorRGB.g = p;
                        colorRGB.b = _VALUE;
                    }else if( Hi == 5){
                        colorRGB.r = _VALUE;
                        colorRGB.g = p;
                        colorRGB.b = q;
                    }
                }

                output.colorRGB = colorRGB;
                
                return output;
            }

            sampler2D _MainTex;

            fixed4 frag (TexturizedOutput i) : Color
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                col.rgb = col.rgb * i.colorRGB;
                return col;
            }
            ENDCG
        }
    }
}
