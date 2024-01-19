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

float sdRoundBox(vec2 region, vec2 pos, vec2 b, vec4 r) {
    r.xy = mix(r.xy, r.wz, region.y);
    r.x  = mix(r.x, r.y, region.x);
    vec2 q = abs(pos) - b + r.x;
    return clamp(q.x, q.y, 0.0) + length(max(q, 0.0)) - r.x;
}

void main() {
    float minSide = min(size.x, size.y), px = 0.5/minSide, strokeWidth = _sw/minSide;
    vec2 ratio = size/minSide, uv = qt_TexCoord0, pos = (uv - 0.5) * ratio;
    float d = sdRoundBox(round(uv), pos, ratio * 0.5 - px, min(_radius/minSide, min(ratio.x, ratio.y)/2));
    float f = smoothstep(px, 0.0, d);
    float s = smoothstep(px, 0.0, abs(d + strokeWidth - px) - strokeWidth + px);
    fragColor = mix(mix(vec4(0.0), color, f), stroke, s);
}
