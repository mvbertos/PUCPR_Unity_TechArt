Shader "Custom/KernelShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Enum(None,0,BlurMedia,1,BlurNitido,2,BlurCruz,3,Laplace,4,LaplaceDiad,5,Sharpening,6,EmbossL,7)]_Kernel("Kernel",int) =0
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
            
            int _Kernel;
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
            float4 processKernel(float2 neighbors[9],float3x3 filter){
                float4 newColor = float4(0,0,0,0);
                float4 texColor;
                float2 uv;

                for(int y = 0 ; y<3; y++){
                    for(int x = 0;x<3; x++){
                        uv = neighbors[y*3+x];
                        texColor = tex2D(_MainTex,uv);
                        newColor += filter[y][x]*texColor;
                    }
                }
                return newColor;
            }

            float4 frag (v2f i) : SV_Target
            {
                if(_Kernel ==0){
                    return tex2D(_MainTex,i.uv);
                }else if(_Kernel ==1 ){
                    float3x3 filter = float3x3(
                    0.11,0.11,0.11,
                    0.11,0.11,0.11,
                    0.11,0.11,0.11
                    );

                    return processKernel(i.neighbors,filter);
                }else if(_Kernel ==2){
                    float3x3 filter = float3x3(
                    0.0625,0.125,0.0625,
                    0.125,0.25,0.125,
                    0.0625,0.125,0.0625
                    );
                    
                    return processKernel(i.neighbors,filter);
                }
                else if(_Kernel ==3){
                    float3x3 filter = float3x3(
                    0,0.2,0,
                    0.2,0.2,0.2,
                    0,0.2,0
                    );
                    
                    return processKernel(i.neighbors,filter);
                }
                else if(_Kernel ==4){
                    float3x3 filter = float3x3(
                    0,1.0,0,
                    1.0,-4,1.0,
                    0,1.0,0
                    );
                    
                    return processKernel(i.neighbors,filter);
                }
                 else if(_Kernel ==5){
                    float3x3 filter = float3x3(
                    0.5,1.0,0.5,
                    1.0,-6.0,1.0,
                    0.5,1.0,0.5
                    );
                    
                    return processKernel(i.neighbors,filter);
                }
                 else if(_Kernel ==6){
                    float3x3 filter = float3x3(
                    0,-1.0,0,
                    -1.0,5,-1.0,
                    0,-1.0,0
                    );
                    
                    return processKernel(i.neighbors,filter);
                } else if(_Kernel ==7){
                    float3x3 filter = float3x3(
                    -2,-2.0,0,
                    -2,6,0,
                    0,0,0
                    );
                    
                    return processKernel(i.neighbors,filter);
                }


                return float4(0,0,0,0);
            }  
            ENDCG
        }
    }
}
