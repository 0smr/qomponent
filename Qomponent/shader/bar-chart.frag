#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float height;
    vec4 color;
};
layout(binding = 1) uniform sampler2D source;

void main() {
    vec4 v = texture(source, vec2(qt_TexCoord0.x, 0));
    fragColor = smoothstep(0.0, 0.5/height, qt_TexCoord0.y - 1.0 + v.a) * color * qt_Opacity;
}
