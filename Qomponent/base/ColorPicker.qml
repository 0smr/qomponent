// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

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

            fragmentShader: 'qrc:/qomponent/shader/saturation-spectrom.frag.qsb'

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
            fragmentShader: 'qrc:/qomponent/shader/value-spectrom.frag.qsb'

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
