// Copyright (C) 2023 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

ShaderEffect {
    id: effect

    implicitWidth: 200
    implicitHeight: 200

    property color color: 'white'
    property color stroke: 'black'
    property real strokeWidth: 0
    property var radius

    readonly property real _sw: strokeWidth/2
    readonly property size size: Qt.size(width, height)
    readonly property vector4d _radius: {
        const _min = Math.min(width, height);
        if(Number.isFinite(radius)) {
            const r = radius;
            return Qt.vector4d(r,r,r,r);
        } else {
            const {x,y,z,w} = radius ?? {x:0, y:0};
            return Qt.vector4d(x, y, z ?? x, w ?? y);
        }
    }

    fragmentShader: "
        #ifdef GL_ES
            precision mediump float;
        #endif

        uniform highp float qt_Opacity;
        varying highp vec2 qt_TexCoord0;
        uniform highp vec2 size;
        uniform highp vec4 color;
        uniform highp vec4 stroke;
        uniform highp vec4 _radius;
        uniform highp float _sw;

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
            gl_FragColor = mix(mix(vec4(0.0), color, f), stroke, s);
        }"
}
