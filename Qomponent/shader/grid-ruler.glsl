#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

varying highp vec2 qt_TexCoord0;
uniform highp float qt_Opacity;
uniform highp vec2 offset;
uniform highp vec4 color;
uniform highp vec4 origin;
uniform highp vec2 step;
uniform highp vec2 size;

void main() {
    vec2 eps = 0.5/step;
    vec2 coord = (qt_TexCoord0 - 0.5) * size + offset;
    vec2 grid = smoothstep(vec2(0.0), eps, eps - abs(fract(coord / step) - eps));
    vec4 _color = mix(color, origin, dot((1.0 - min(abs(floor(coord / step)), 1.)) * grid, vec2(1.0)));
    gl_FragColor = _color * qt_Opacity * max(grid.x, grid.y);
}
