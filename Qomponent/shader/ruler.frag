#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float offset;
	float thickness;
	vec2 hw;
	vec4 color;
	vec4 origin;
	vec4 step;
	vec4 size;
};

void main() {
    vec4 twidth = vec4(thickness)/step;
    vec4 _size = size/2.0;
    vec2 coord = (qt_TexCoord0 - 0.5) * hw + offset;
    vec4 theight = smoothstep(vec4(0.0), vec4(0.05/hw.y), _size - abs(vec4(1.0 - qt_TexCoord0.y) - _size));
    vec4 tick = smoothstep(vec4(0.0), 0.5/step, twidth - abs(fract(vec4(coord.x) / step) - twidth)) * theight;
    vec4 _color = mix(color, origin, (1.0 - min(abs(floor(coord.x / step.w)), 1.)) * tick.w);
    fragColor = _color * qt_Opacity * max(max(max(tick.x, tick.y), tick.z), tick.w);
}
