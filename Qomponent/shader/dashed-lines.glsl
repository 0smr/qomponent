#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

uniform highp float qt_Opacity;
varying highp vec2 qt_TexCoord0;
uniform highp vec4 color;
uniform highp vec4 originColor;
uniform highp float width;
uniform highp float height;
uniform highp float spacing;
uniform highp float lineWidth;
uniform highp float lineHeight;
uniform highp float xoffset;
uniform highp vec2 minor;
uniform highp vec2 major;

void main() {
    vec2 uv = (qt_TexCoord0 + vec2(xoffset/width - .5, 0.)) * vec2(width/spacing, 1.);
    vec2 gs = vec2(100./spacing/width, 1./height);
    vec2 mainGrid = fract(uv);
    vec2 minorGrid = fract(uv / vec2(minor.x, 1.));
    vec2 majorGrid = fract(uv / vec2(major.x, 1.));
    float ruler = mix(smoothstep(0., gs.y, mainGrid.y + minor.y - 1.), smoothstep(0., gs.y, minorGrid.y + lineHeight - 1.),
                      smoothstep(0., gs.x/minor.x, minorGrid.x - lineWidth/spacing/minor.x));
    gl_FragColor = mix(originColor, color, min(abs(floor(uv.x)), 1.));
    gl_FragColor *= (1. - smoothstep(0., gs.x, mainGrid.x - lineWidth/spacing * 0.99));
    gl_FragColor *= mix(smoothstep(0., gs.y, mainGrid.y + major.y - 1.), ruler,
                        smoothstep(0., gs.x/major.x, majorGrid.x - lineWidth/spacing/major.x * 0.99));
    gl_FragColor *= qt_Opacity;
}