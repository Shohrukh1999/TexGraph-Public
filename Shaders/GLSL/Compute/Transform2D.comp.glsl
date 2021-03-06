/*
 * @file    Tiling.comp.glsl
 * @author  David Gallardo Moreno
 */


#version 430
precision highp float;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(binding = 0) uniform writeonly image2D uOutputBuffer0;
layout(location = 80) uniform sampler2D uInputBuffer0;


layout(location = 100) uniform ivec3 uOutputBufferSize;
layout(location = 101) uniform ivec3 uInvocationOffset;

/*
layout(location = 0)  uniform float uOffsetX;
layout(location = 1)  uniform float uOffsetY;
layout(location = 2)  uniform float uScaleY;
layout(location = 3)  uniform float uScaleY;
layout(location = 4)  uniform float uRotation;*/
layout(location = 0)  uniform mat3 uTransform2DMatrix;
layout(location = 1)  uniform int uTiling;


void main(void)
{
    ivec2 lBufferCoord = ivec2(gl_GlobalInvocationID.xy + uInvocationOffset.xy);
    vec2 lUV = (uTransform2DMatrix * vec3(vec2(lBufferCoord.xy) / vec2(uOutputBufferSize.xy), 1.0)).xy;
    vec4 lOutputColor = (uTiling == 0 && (lUV.x > 1.0 || lUV.x < 0.0 || lUV.y > 1.0 || lUV.y < 0.0)) ? vec4(0, 0, 0, 1) : textureLod(uInputBuffer0, lUV, 0);
    imageStore (uOutputBuffer0, lBufferCoord, lOutputColor);

    //imageStore (uOutputBuffer0, lBufferCoord, vec4(uOffsetX, uOffsetY, 0, 1));
}
 