// Butterfly shader - Flutter Fragment Shader API (GLSL ES 3.0).
//
// Loaded via FragmentProgram.fromAsset('shaders/butterfly.frag').
// Demonstrates PBR-lite with Schlick Fresnel and a procedural IBL
// approximation so it can ship without shipping a full cube map.

#version 460 core
#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uTime;
uniform vec3 uTint;
uniform vec3 uCameraPos;

out vec4 fragColor;

vec3 gammaCorrect(vec3 c) {
    return pow(c, vec3(1.0 / 2.2));
}

// Cheap procedural IBL diffuse term (top = sky, bottom = ground).
vec3 iblDiffuse(vec3 n) {
    vec3 sky = vec3(0.75, 0.82, 0.95);
    vec3 ground = vec3(0.30, 0.26, 0.24);
    float t = clamp(n.y * 0.5 + 0.5, 0.0, 1.0);
    return mix(ground, sky, t);
}

vec3 iblSpecular(vec3 r) {
    vec3 hi = vec3(1.0, 0.95, 0.85);
    vec3 lo = vec3(0.05, 0.06, 0.08);
    float t = clamp(r.y * 0.5 + 0.5, 0.0, 1.0);
    return mix(lo, hi, pow(t, 3.0));
}

// Schlick Fresnel approximation.
vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 centered = uv * 2.0 - 1.0;

    // Fake a wing flap with time so the shader is visibly alive.
    float flap = sin(uTime * 6.0 + centered.x * 2.0) * 0.25;
    vec3 worldPos = vec3(centered.x, centered.y + flap * abs(centered.x), 0.0);

    vec3 n = normalize(vec3(centered.x * 0.6, 0.7, 0.4 + flap));
    vec3 v = normalize(uCameraPos - worldPos);
    vec3 r = reflect(-v, n);

    float ndv = max(dot(n, v), 0.0);
    vec3 F0 = vec3(0.04);
    vec3 F = fresnelSchlick(ndv, F0);

    vec3 diffuse = uTint * iblDiffuse(n) * (1.0 - F);
    vec3 specular = iblSpecular(r) * F;

    vec3 color = diffuse + specular;
    fragColor = vec4(gammaCorrect(color), 1.0);
}
