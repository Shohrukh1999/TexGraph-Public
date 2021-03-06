/*
 * @file    Squircle.comp.glsl
 * @author  David Gallardo Moreno
 * @notes   https://thndl.com/going-round-in-squircles.html
 */

#version 430
precision highp float;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(binding = 0, r16f) uniform image2D uOutputBuffer0;

layout(location = 100) uniform ivec3 uOutputBufferSize;
layout(location = 101) uniform ivec3 uInvocationOffset;

layout(location = 0)  uniform float    uMargin;
layout(location = 1)  uniform float    uFalloff;
layout(location = 2)  uniform float    uCorner;

void main(void) 
{
    ivec2 lBufferCoord = ivec2(gl_GlobalInvocationID.xy + uInvocationOffset.xy);
    vec2 lUV = (vec2(lBufferCoord.xy) / vec2(uOutputBufferSize.xy));
    vec2 c = (lUV - 0.5) * 2.0; //remap from 0->1 to -1 -> 1
    c = abs(c);
    c *= (1.0 + uMargin);
    c = abs(pow(c.xy, vec2(uCorner)));
    float f = 1.0 - length(c);
    f = smoothstep(0.0, .01 + uFalloff, f);
    vec4 lOutputColor = vec4(vec3(f), 1.0);
    imageStore (uOutputBuffer0, lBufferCoord, clamp(lOutputColor, 0.0, 1.0)); 
}
