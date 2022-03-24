Shader "Custom/HSVShader"
{
    Properties
    {
        _Hue("Hue", Range(0,360)) = 50
        _Saturation("Saturation",Range(0,1)) = 1
        _Value("Value",Range(0,1)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Hue;
            float _Saturation;
            float _Value;
            struct VertexOutput{
                float4 position:SV_POSITION;
                float4 colorRGB:TEXCOORD0;
            };

            VertexOutput vert (float4 vertexPos:POSITION)
            {
                //Update color value
                float4 colorRGB = float4(0.0,1.0,0.0,1.0);
                if(_Saturation == 0.0){
                    colorRGB.rgb = _Value;
                }else{
                    int Hi;
                    float hue,f,p,q,t;
                    if(_Hue == 360.0){
                        _Hue = 0.0;
                    }
                    hue = _Hue/60.0;
                    Hi = int(hue);
                    f = hue - Hi;
                    p = _Value * (1.0 - _Saturation);
                    q = _Value * (1.0 - f * _Saturation);
                    t = _Value * (1.0 - (1.0 - f) * _Saturation);
                    if( Hi == 0){
                        colorRGB.r = _Value;
                        colorRGB.g = t;
                        colorRGB.b = p;
                    }else if( Hi == 1){
                        colorRGB.r = q;
                        colorRGB.g = _Value;
                        colorRGB.b = p;
                    }else if( Hi == 2){
                        colorRGB.r = p;
                        colorRGB.g = _Value;
                        colorRGB.b = t;
                    }else if( Hi == 3){
                        colorRGB.r = p;
                        colorRGB.g = q;
                        colorRGB.b = _Value;
                    }else if( Hi == 4){
                        colorRGB.r = t;
                        colorRGB.g = p;
                        colorRGB.b = _Value;
                    }else if( Hi == 5){
                        colorRGB.r = _Value;
                        colorRGB.g = p;
                        colorRGB.b = q;
                    }
                }
                VertexOutput output;
                output.colorRGB = colorRGB;
                output.position = UnityObjectToClipPos(vertexPos);
                return output;
            }

            float4 frag (VertexOutput input) : COLOR
            {
                //set color
                return input.colorRGB;
            }
            ENDCG
        }
    }
}
