// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick

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

        fragmentShader: "qrc:/qomponent/shader/boxshadow.frag.qsb"
    }
}
