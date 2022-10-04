// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: control

    property real to: 0
    property real from: 0

    ShaderEffect {
        id: effect
        width: parent.width
        height: width

        rotation: control.from

        readonly property real to: (control.to - control.from) * 0.0174533
        readonly property color color: control.palette.base;

        fragmentShader: "
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
            }"
    }
}
