// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

ShaderEffect {
    property real spacing: 2
    property real lineWidth: 1
    property real lineHeight: 0.5
    property real xoffset: 0

    property vector2d minor: Qt.vector2d( 5, .7)
    property vector2d major: Qt.vector2d(25, 1.)

    property color color: "#f1f2f3"
    property color originColor: "#d73727"

    fragmentShader: "qrc:/Qomponent/shader/dashed-lines.glsl"
}
