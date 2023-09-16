// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

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

            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform highp float qt_Opacity;
                uniform highp float strokeWidth;
                uniform highp float s;
                uniform highp float v;

                vec3 hsv2rgb(vec3 c) {
                    vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
                    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
                    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.), c.y);
                }

                void main() {
                    highp vec2 coord = qt_TexCoord0 - vec2(.5);
                    highp float ring = smoothstep(0., .01, -abs(length(coord) - .5 + strokeWidth) + strokeWidth);
                    gl_FragColor = vec4(hsv2rgb(vec3(-atan(coord.x, coord.y) / 6.2831 + .5, s, v)),1.);
                    gl_FragColor *= ring;
                }"
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

            onPressed: {
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
