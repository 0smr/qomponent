// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick

ShaderEffect {
    property real radius
    property point center
    property color color: '#000'

    readonly property real _radius: radius/width
    readonly property vector2d _center: Qt.vector2d(center.x, center.y).times(1/width)

    fragmentShader: "qrc:/qomponent/shader/focus.frag.qsb"
}
