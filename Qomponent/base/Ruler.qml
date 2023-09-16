// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

ShaderEffect {
    property real offset: 0;
    property real thickness: 0.7;
    property vector2d hw: Qt.vector2d(width, height);
    property vector4d step: Qt.vector4d(3, 3, 9, 27)
    property vector4d size: Qt.vector4d(3, 3, 6, 14).times(1/height)

    property color color: "#f1f2f3"
    property color origin: "#f70101"

    fragmentShader: "qrc:/Qomponent/shader/ruler.glsl"
}
