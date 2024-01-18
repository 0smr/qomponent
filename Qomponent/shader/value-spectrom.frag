#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float height;
};

void main() {
    fragColor.xyz = clamp(abs(fract(qt_TexCoord0.y + vec3(1.,.66,.33)) * 6. - 3.) - 1.,0.,1.);
    fragColor.w = qt_Opacity;
}
