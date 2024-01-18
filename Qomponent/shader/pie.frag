#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float to;
    float width;
    vec4 color;
};

void main() {
    highp vec2 normal = qt_TexCoord0 - vec2(0.5);
    highp float pie = smoothstep(0.0, 0.5/width, atan(normal.x, normal.y) - 3.142 + to);
    highp float ring  = smoothstep(0.0, 0.5/width, -length(normal) + 0.5);
    fragColor = color * ring * pie;
}
