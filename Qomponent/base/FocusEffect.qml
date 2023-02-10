// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

ShaderEffect {
    property real radius
    property point center
    property color color: '#000'

    readonly property real _radius: radius/width
    readonly property vector2d _center: Qt.vector2d(center.x/width, center.y/width)

    fragmentShader: "qrc:/Qomponent/shader/focus.glsl"
}
