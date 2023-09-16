// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

Item {
    id: control

    implicitWidth: 50
    implicitHeight: 50

    property color color: "#000"
    property real radius: width/2
    property real spread: 5

    ShaderEffect {
        id: effect

        width: control.width;
        height: control.height;

        readonly property color color: control.color;
        readonly property vector2d ratio: Qt.vector2d(width, height).times(1/whmax);
        readonly property real whmax: Math.max(width, height);
        readonly property real spread: control.spread / whmax;
        readonly property real radius: {
            const min = Math.min(width, height);
            return Math.min(Math.max(control.radius, spread), min/2) / whmax;
        }

        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform highp float qt_Opacity;
            uniform highp float radius;
            uniform highp float spread;
            uniform highp vec2 ratio;
            uniform highp vec4 color;

            void main() {
                highp vec2 center = ratio / 2.0;
                highp vec2 coord = qt_TexCoord0 * ratio;
                highp float dist = length(max(abs(center - coord) - center + radius, 0.0)) - radius;
                gl_FragColor = color * smoothstep(0.0, spread, - dist + 0.001) * qt_Opacity;
            }"
    }
}
