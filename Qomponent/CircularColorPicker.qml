// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

Control {
    id: control

    /** @property {real} strokeWidth, Indicates colorpicker stroke width. */
    property real strokeWidth: width * 0.15
    /** @property {real} hsvHue, Indicates selected hsvHue value. */
    readonly property alias hsvHue: huema.angle
    /** @property {real} hsvValue,  Indicates selected hsvValue value. */
    readonly property alias hsvValue: valueSlider.value
    /** @property {real} hsvSaturation,  Indicates selected hsvSaturation value. */
    readonly property alias hsvSaturation: saturationSlider.value
    /** @property {real} hsvAlpha,  Indicates selected hsvAlpha value. */
    readonly property alias hsvAlpha: alphaSlider.value
    /** @property {color} color, readonly selected color value. */
    readonly property color color: Qt.hsva(hsvHue, hsvSaturation, hsvValue, hsvAlpha)

    contentItem: Item {
        implicitWidth: 175
        implicitHeight: width

        ShaderEffect {
            id: shadereffect
            width: parent.width
            height: parent.height
            readonly property real strokeWidth: control.strokeWidth / width / 2
            readonly property real v: control.hsvValue
            readonly property real s: control.hsvSaturation

            fragmentShader: "qrc:/qomponent/shader/color-ring.frag.qsb"
        }

        Rectangle {
            id: indicator
            x: (parent.width - width) / 2
            y: control.strokeWidth * 0.1

            width: control.strokeWidth * 0.8
            height: width
            radius: width / 2

            color: 'white'
            border {
                width: huema.containsPress ? 4 : 2
                color: '#ddd'
                Behavior on width {
                    NumberAnimation {
                        duration: 50
                    }
                }
            }

            transform: Rotation {
                angle: huema.angle * 360
                origin.x: indicator.width / 2
                origin.y: control.availableHeight / 2 - indicator.y
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: control.availableWidth * 0.3
            height: width
            radius: width

            color: control.color
            border {
                width: control.availableWidth * 0.03
                color: Qt.lighter(control.color, 1.8)
            }
        }

        MouseArea {
            id: huema
            anchors.fill: parent
            preventStealing: true

            property real angle: 0

            function angleFromCenter() {
                return Math.atan2(width/2 - mouseX, mouseY - height/2) / 6.2831 + 0.5;
            }

            onPositionChanged: {
                angle = Math.atan2(width/2 - mouseX, mouseY - height/2) / 6.2831 + 0.5;
            }

            onPressed: function(mouse) {
                const dist = Math.hypot(mouseX - width/2, mouseY - height/2);
                mouse.accepted = width/2 - control.strokeWidth < dist
            }
        }

        ArcSlider {
            id: valueSlider
            anchors.centerIn: parent
            width: parent.width * 0.65; height: width
            palette{ button: '#fff'; base: '#ddd' }
            startAngle: 15; sweepAngle: 90
            indicator.width: indicator.width
        }

        ArcSlider {
            id: saturationSlider
            anchors.centerIn: parent
            width: parent.width * 0.65; height: width
            palette{ button: '#fff'; base: '#ddd' }
            startAngle: 135; sweepAngle: 90
            indicator.width: indicator.width
        }

        ArcSlider {
            id: alphaSlider
            anchors.centerIn: parent
            width: parent.width * 0.65; height: width
            palette{ button: '#fff'; base: '#ddd' }
            startAngle: 255; sweepAngle: 90
            indicator.width: indicator.width
        }
    }
}
