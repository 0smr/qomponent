#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float width;
	float height;
	float _radius;
	vec2 _center;
	vec4 color;
};

void main() {
    vec2 coord = qt_TexCoord0 * vec2(1, height / width);
    float ring = smoothstep(0., .5/width, distance(coord, _center) - _radius);
    fragColor = color * ring * qt_Opacity;
}
