Shader "Apperture/DebugMesh"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Mode ("Debug Mode", int) = 0
        _UvCheckerResolution ("UV Checker resolution", float) = 30
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
        Cull Off
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
                float3 normal : NORMAL;
                float3 color : COLOR0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 color : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

            int _Mode;
            float _UvCheckerResolution;
			
			v2f vert (appdata IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.normal = normalize(mul(unity_ObjectToWorld, IN.normal));
                OUT.color = IN.color;
				return OUT;
			}
			
			fixed4 frag (v2f IN) : SV_Target
			{
                if (_Mode == 0) // COLOR_RAW
                {
                    return float4(IN.color, 1);
                }

                if (_Mode == 1) // NORMAL_RAW
                {
                    return float4(IN.normal.xyz, 1);
                }

                if (_Mode == 2) // UV_RAW
                {
                    return float4(IN.uv.x, IN.uv.y, 0, 1);
                }

                if (_Mode == 3) // UV_CHECKER
                {
                    float2 duv = floor(IN.uv * _UvCheckerResolution) / 2; 
                    float checker = frac(duv.x + duv.y) * 2; 
                    return checker;
                }

                // default
                return float4(1, 1, 1, 1);
			}
			ENDCG
		}
	}
    CustomEditor "DebugMaterialEditor"
}
