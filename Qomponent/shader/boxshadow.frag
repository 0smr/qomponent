#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float radius;
    float spread;
    vec2 ratio;
    vec4 color;
};

void main() {
    highp vec2 center = ratio / 2.0;
    highp vec2 coord = qt_TexCoord0 * ratio;
    highp float dist = length(max(abs(center - coord) - center + radius, 0.0)) - radius;
    fragColor = color * smoothstep(0.0, spread, - dist + 0.001) * qt_Opacity;
}
