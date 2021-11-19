//--------------------------------------------------------------------------------------
// File: Lab04.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
	float4 vLightDir[1];
	float4 vLightColor[1];
	float4 vOutputColor;
}


//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float3 Norm : NORMAL;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float3 Norm : TEXCOORD0;
	float3 WorldPos : TEXCOORD1;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    output.Pos = mul( input.Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
    output.Norm = mul( float4( input.Norm, 1 ), World ).xyz;
    output.WorldPos = mul( input.Pos, World );

    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT input) : SV_Target
{
	float4 diffuse = float4(1.0, 0.0, 0.0, 1.0);
    float4 finalColor = diffuse *0.1;
    float3 Eye = float3(0.0f, 0.0f, -2.0f);
    float4 intensity = 14.5;
    float power = 4;
	float3 V = -normalize( Eye - input.WorldPos );

    for (int i = 0; i < 1; i++)
    {
		float3 R = reflect( normalize( vLightDir[i] ), normalize( input.Norm ) );
        finalColor += intensity * vLightColor[i] * pow( saturate( dot( R, V ) ), power );
    }   
    return finalColor;
}


//--------------------------------------------------------------------------------------
// PSSolid - render a solid color
//--------------------------------------------------------------------------------------
float4 PSSolid( PS_INPUT input) : SV_Target
{
    return vOutputColor;
}
