// Copyright (C) 2023 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick

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

    fragmentShader: "qrc:/qomponent/shader/qrect.frag.qsb"
}
