// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: control

    property real spectrumWidth: 5
    property color color: Qt.hsva(1, 1, 1, 1)
    function clamp01(v) { return Math.max(0, Math.min(v, 1)); }

    contentItem: Row {
        clip: true

        ShaderEffect {
            readonly property color color: Qt.hsva(control.color.hsvHue, 1, 1, 1)

            width: control.width - spectrumWidth
            height: control.height

            fragmentShader: '
                varying highp vec2 qt_TexCoord0;
                uniform highp float qt_Opacity;
                uniform highp vec4 color;
                void main() {
                    vec2 uv = qt_TexCoord0;
                    gl_FragColor = vec4(mix(mix(vec3(1.), color.xyz, uv.x), vec3(0.0), uv.y), qt_Opacity);
                }'

            PointHandler {
                onPointChanged: {
                    const pos = point.position;
                    if(active) {
                        color.hsvSaturation = clamp01(pos.x/parent.width);
                        color.hsvValue = 1 - clamp01(pos.y/height);
                    }
                }
                onActiveChanged: if(active) control.focus = true;
            }

            Rectangle {
                x: control.color.hsvSaturation * parent.width - 4;
                y:(1 - control.color.hsvValue) * parent.height - 4;
                width: 8; height: 8; radius: 4
                color: Qt.tint(control.color, '#99ffffff')
                border.color: '#fff'
            }
        }

        ShaderEffect {
            width: spectrumWidth; height: control.availableHeight
            fragmentShader: '
                varying highp vec2 qt_TexCoord0;
                uniform highp float qt_Opacity;
                void main() {
                    gl_FragColor.xyz = clamp(abs(fract(qt_TexCoord0.y + vec3(1.,.66,.33)) * 6. - 3.) - 1.,0.,1.);
                    gl_FragColor.w = qt_Opacity;
                }'

            PointHandler {
                onPointChanged: {
                    const pos = point.position;
                    if(active) control.color.hsvHue = clamp01(pos.y/height);
                }
                onActiveChanged: if(active) control.focus = true;
            }

            Rectangle {
                y: control.color.hsvHue * (parent.height - height);
                width: 10; height: 1
            }
        }
    }
}
