#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 color;
};

void main() {
    vec2 uv = qt_TexCoord0;
    fragColor = vec4(mix(mix(vec3(1.), color.xyz, uv.x), vec3(0.0), uv.y), qt_Opacity);
}
