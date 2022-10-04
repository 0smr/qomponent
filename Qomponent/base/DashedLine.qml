// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

ShaderEffect {
    id: effect
    property real seed: 0 // To animate the lines' x axis.
    property real num: width / 6 // The number of lines changes with width and may even be fixed.
    property color color: '#000' // Color of lines (background is transparent)
    readonly property vector2d ratio: {
        const max = Math.max(width, height);
        return Qt.vector2d(width/max, height/max);
    }

    fragmentShader: "
        uniform lowp float qt_Opacity;
        uniform lowp float seed;
        uniform lowp float num;
        uniform highp vec2 ratio;
        uniform highp vec4 color;
        varying highp vec2 qt_TexCoord0;
        void main() {
            vec2 uv = qt_TexCoord0*ratio/ ratio.x;
            // Slope can be changed by multiplying 'y' by any number.
            vec2 grid = fract(uv * vec2(num,1.));
            // You may also change the line width from 0.0 to 1.0. (change 0.5)
            gl_FragColor = color * smoothstep(0.0,ratio.x*1e-1,grid.x - 0.5) * qt_Opacity;
        }"
}
