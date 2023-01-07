#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

varying highp vec2 qt_TexCoord0;
uniform highp float qt_Opacity;
uniform highp float to;
uniform highp float width;
uniform highp vec4 color;

void main() {
    highp vec2 normal = qt_TexCoord0 - vec2(0.5);
    highp float pie = smoothstep(0.0, 0.5/width, atan(normal.x, normal.y) - 3.142 + to);
    highp float ring  = smoothstep(0.0, 0.5/width, -length(normal) + 0.5);
    gl_FragColor = color * ring * pie;
}
