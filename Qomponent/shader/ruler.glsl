#ifdef GL_ES
    precision highp float;
#endif

uniform highp float qt_Opacity;
varying highp vec2 qt_TexCoord0;
uniform highp float offset;
uniform highp float thickness;
uniform highp vec2 hw;
uniform highp vec4 color;
uniform highp vec4 origin;
uniform highp vec4 step;
uniform highp vec4 size;

void main() {
    vec4 twidth = vec4(thickness)/step;
    vec4 _size = size/2.0;
    vec2 coord = (qt_TexCoord0 - 0.5) * hw + offset;
    vec4 theight = smoothstep(vec4(0.0), vec4(0.05/hw.y), _size - abs(vec4(1.0 - qt_TexCoord0.y) - _size));
    vec4 tick = smoothstep(vec4(0.0), 0.5/step, twidth - abs(fract(vec4(coord.x) / step) - twidth)) * theight;
    vec4 _color = mix(color, origin, (1.0 - min(abs(floor(coord.x / step.w)), 1.)) * tick.w);
    gl_FragColor = _color * qt_Opacity * max(max(max(tick.x, tick.y), tick.z), tick.w);
}
