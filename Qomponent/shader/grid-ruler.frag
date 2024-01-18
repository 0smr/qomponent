#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 offset;
	vec4 color;
	vec4 origin;
	vec2 step;
	vec2 size;
};


void main() {
    vec2 eps = 0.5/step;
    vec2 coord = (qt_TexCoord0 - 0.5) * size + offset;
    vec2 grid = smoothstep(vec2(0.0), eps, eps - abs(fract(coord / step) - eps));
    vec4 _color = mix(color, origin, dot((1.0 - min(abs(floor(coord / step)), 1.)) * grid, vec2(1.0)));
    fragColor = _color * qt_Opacity * max(grid.x, grid.y);
}
