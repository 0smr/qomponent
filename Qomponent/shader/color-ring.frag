#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float strokeWidth;
    float s;
    float v;
};

/**
 * @method hsv2rgb, convert HSV color to RGB color.
 * @param {vec3} c, HSV color value.
 * @returns {vec3}, return RGB color value.
 */
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.), c.y);
}

void main() {
    highp vec2 coord = qt_TexCoord0 - vec2(.5);
    highp float ring = smoothstep(0., .01, -abs(length(coord) - .5 + strokeWidth) + strokeWidth);
    fragColor = vec4(hsv2rgb(vec3(-atan(coord.x, coord.y) / 6.2831 + .5, s, v)),1.);
    fragColor *= ring;
}