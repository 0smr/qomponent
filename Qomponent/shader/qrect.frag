#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 size;
    vec4 color;
    vec4 stroke;
    vec4 _radius;
    float _sw;
};

float sdRoundBox(vec2 p, vec2 b, vec4 r) {
    // TODO: The radius should be able to cover values greater than 0.5.
    // vec4 r = min(min(_r, vec4(1.0, 1.0 - _r.xyz)), 1.0 - _r.x);
    // float hl = 0.5, vl = 0.5;
    r.xy = mix(r.xy, r.wz, round(p.y + 0.5));
    r.x  = mix(r.x, r.y, round(p.x + 0.5));
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

void main() {
    float _min = min(size.x, size.y), px = 0.5/_min, sw = _sw/_min;
    vec2 uv = (qt_TexCoord0 - 0.5) * size/_min;
    float d = sdRoundBox(uv, vec2(0.5 - px), min(_radius/_min, 0.5 - 2.0 * px));
    float f = smoothstep(px, 0.0, d);
    float s = smoothstep(px, 0.0, abs(d + sw - px) - sw + px);
    fragColor = mix(mix(vec4(0.0), color, f), stroke, s);
}
