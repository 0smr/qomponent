#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 size;
    vec4 color;
    vec4 highlight;
};
layout(binding = 1) uniform sampler2D source;

void main() {
    float m = min(size.x, size.y);
    vec2 uv = (qt_TexCoord0 - 0.5) * size/min(size.x, size.y);
    vec4 t = texture(source, qt_TexCoord0);
    // center and background circle
    vec2 c = smoothstep(vec2(0.5/m), vec2(0.0), vec2(length(uv) + 0.5/m) - vec2(0.5, 1.0/m));
    fragColor = mix(color, highlight, max(t.a, c.y)) * c.x * qt_Opacity;
}
