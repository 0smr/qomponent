// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

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

        fragmentShader: "qrc:/Qomponent/shader/pie.glsl"
    }
}
