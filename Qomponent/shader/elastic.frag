#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float bend;
};
layout(binding = 1) uniform sampler2D source;

void main() {
    highp vec2 uv = qt_TexCoord0;
    uv.x += (uv.y - 1) * (uv.y - 1) * bend;
    fragColor = texture(source, uv);
}
