Shader "Custom/PalletTextureShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _HUE01 ("HUE01", Range(0.0,360.0)) = 1.0
        _SATURATION01("Saturation", Range(0,1)) = 1
        _VALUE01("Value",Range(0,1)) = 1

        _HUE02 ("HUE02", Range(0.0,360.0)) = 1.0
        _SATURATION02("Saturation", Range(0,1)) = 1
        _VALUE02("Value",Range(0,1)) = 1

        _HUE03 ("HUE03", Range(0.0,360.0)) = 1.0
        _SATURATION03("Saturation", Range(0,1)) = 1
        _VALUE03("Value",Range(0,1)) = 1

        _HUE04 ("HUE04", Range(0.0,360.0)) = 1.0
        _SATURATION04("Saturation", Range(0,1)) = 1
        _VALUE04("Value",Range(0,1)) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform float4 _MainTex_TexelSize;
            float _HUE01;
            float _SATURATION01;
            float _VALUE01;

            float _HUE02;
            float _SATURATION02;
            float _VALUE02;

            float _HUE03;
            float _SATURATION03;
            float _VALUE03;

            float _HUE04;
            float _SATURATION04; 
            float _VALUE04;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 neighbors[9]:TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                for(int y = 0 ; y<3; y++){
                    for(int x = 0;x<3; x++){
                        o.neighbors[y*3+x] = v.uv+_MainTex_TexelSize * float2(x-1,y-1);
                    }
                }
                return o;
            }

            sampler2D _MainTex;
            
            float4 processKernel(float2 neighbors[9],float4 palletColor[4]){
                float4 newColor = float4(0,0,0,0);
                float4 texColor;
                float2 uv;

                for(int y = 0 ; y<3; y++){
                    for(int x = 0;x<3; x++){
                        uv = neighbors[y*3+x];
                        texColor = tex2D(_MainTex,uv);
                        float val1 = 0.0;
                        float val2 = 0.0;
                        float val3 = 0.0;
                        float val4 = 0.0;
                        //if texcolor is closer of one of the palletcolors, set newcolor as the closer palletColor
                        val1 = distance(texColor,palletColor[0]); 
                        val2 = distance(texColor,palletColor[1]);
                        val3 = distance(texColor,palletColor[2]); 
                        val4 = distance(texColor,palletColor[3]);

                        
                        if(val1 < val2 && val1 < val3 && val1 < val4){ 
                            newColor += palletColor[0];
                        }if(val2 < val1 && val2 < val3 && val2 < val4){
                            newColor += palletColor[1];
                        }
                        if(val3 < val4 && val3 < val1 && val3 < val2){
                            newColor += palletColor[2];
                        }
                        if(val4 < val3 && val4 < val1 && val4 < val2){
                            newColor += palletColor[3];
                        }
                        
                    }
                }
                return newColor;
            }

            
            float4 HueToColor(float color,float saturation, float value){
                int Hi;
                float hue,f,p,q,t;
                float4 colorRGB = float4(0,0,0,0);
                if(color == 360.0){
                    color = 0;
                }

                hue = color/60.0;
                Hi = int(hue);
                f = hue - Hi;
                p = value * (1.0 - saturation);
                q = value * (1.0 - f * saturation);
                t = value * (1.0 - (1.0 - f) * saturation);
                if( Hi == 0){
                    colorRGB.r = value;
                    colorRGB.g = t;
                    colorRGB.b = p;
                }else if( Hi == 1){
                    colorRGB.r = q;
                    colorRGB.g = value;
                    colorRGB.b = p;
                }else if( Hi == 2){
                    colorRGB.r = p;
                    colorRGB.g = value;
                    colorRGB.b = t;
                }else if( Hi == 3){
                    colorRGB.r = p;
                    colorRGB.g = q;
                    colorRGB.b = value;
                }else if( Hi == 4){
                    colorRGB.r = t;
                    colorRGB.g = p;
                    colorRGB.b = value;
                }else if( Hi == 5){
                    colorRGB.r = value;
                    colorRGB.g = p;
                    colorRGB.b = q;
                }
                return colorRGB;
            } 


            float4 frag (v2f i) : SV_Target
            {
                float4 newColor;
                float4 texColor =  float4(0,0,0,0);
                float4 Pallet[4] = {
                    float4(HueToColor(_HUE01,_SATURATION01,_VALUE01)),
                    float4(HueToColor(_HUE02,_SATURATION02,_VALUE02)),
                    float4(HueToColor(_HUE03,_SATURATION03,_VALUE03)),
                    float4(HueToColor(_HUE04,_SATURATION04,_VALUE04))
                }; 


                return processKernel(i.neighbors,Pallet);
            }
            ENDCG
        }
    }
}
