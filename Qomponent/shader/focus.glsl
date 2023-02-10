#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

varying highp vec2 qt_TexCoord0;
uniform highp float qt_Opacity;
uniform highp float width;
uniform highp float height;
uniform highp float _radius;
uniform highp vec2 _center;
uniform lowp vec4 color;

void main() {
    vec2 coord = qt_TexCoord0 * vec2(1, height / width);
    float ring = smoothstep(0., .5/width, distance(coord, _center) - _radius);
    gl_FragColor = color * ring * qt_Opacity;
}
