// Copyright (C) 2023 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

ShaderEffect {
    property var source
    property real bend: 0

    fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform highp float qt_Opacity;
        uniform highp sampler2D source;
        uniform highp float bend;

        void main() {
            highp vec2 uv = qt_TexCoord0;
            uv.x += (uv.y - 1) * (uv.y - 1) * bend;
            gl_FragColor = texture2D(source, uv);
        }"
}
