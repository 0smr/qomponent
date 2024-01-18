// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

Control {
    id: control

    padding: font.pixelSize + 5
    implicitWidth: 200
    implicitHeight: 200

    property alias model: repeater.model
    property alias ball: ball
    property real stepSize: 3
    property int rings: 2

    readonly property real angle: (priv.visualAngle + 450 - 360 / priv.ticks) % 360;
    readonly property real value: {
        const index = Math.floor(angle/360 * priv.ticks);
        return (typeof control.model == 'number') ? index + 1 : control.model[index];
    }

    /// The shader that inverts color in the circle position.
    component InverterBall: ShaderEffectSource {
        id: shaderSource
        property color color
        property color highlight

        recursive: false
        sourceRect: Qt.rect(x, y, width, height)
        layer.enabled: true
        layer.effect: ShaderEffect {
            property var source
            property size size: Qt.size(width, height)
            property color color: shaderSource.color
            property color highlight: shaderSource.highlight

            fragmentShader: "qrc:/qomponent/shader/iball.frag.qsb"
        }
    }

    QtObject {
        id: priv
        property real index: 0
        property real level: 0
        property real ticks: repeater.count/control.rings
        property real visualAngle: 0
        property real radius: Math.min(availableWidth, availableHeight)/2
        property vector2d center: Qt.vector2d(availableWidth/2, availableHeight/2)

        function positioner(angle, radius) {
            return Qt.vector2d(Math.cos(angle), Math.sin(angle)).times(radius).plus(center);
        }

        Behavior on visualAngle {RotationAnimation { direction: RotationAnimation.Shortest }}
    }

    DragHandler {
        target: null
        dragThreshold: 1
        onCentroidChanged: {
            if(centroid.pressure) {
                const snap = 360/priv.ticks * stepSize, p = centroid.position,
                      center = priv.center.plus(Qt.vector2d(1,1).times(parent.padding)),
                      angle = Math.atan2(p.y - center.y, p.x - center.x) * 57.3,
                      d = Qt.vector2d(p.x, p.y).minus(center);

                const va = Math.round(angle / snap) * snap / 360;
                priv.level = Math.round((60 - Math.sqrt(d.x * d.x + d.y * d.y)) / ball.size).qclamp(0, control.rings - 1);
                priv.index = Math.round(((va + 1.25) * priv.ticks - 1) % priv.ticks) + priv.level * priv.ticks;
                priv.visualAngle = va * 360;
            }
        }
    }

    contentItem: Item {
        Item {
            id: ticks
            width: parent.width; height: parent.height
            Repeater {
                id: repeater

                /// Hours or minutes model can also be replaced with an array (i.e., numbers in Roman format).
                model: 12
                Label {
                    property vector2d pos: {
                        const lvl = Math.floor(index/priv.ticks),
                              a = (index + 1) * 6.283/priv.ticks - 1.57,
                              r = priv.radius - lvl * ball.size;
                        return priv.positioner(a, r);
                    }

                    x: pos.x - implicitWidth/2
                    y: pos.y - implicitHeight/2
                    font.pixelSize: ball.size/2
                    text: typeof control.model == 'number' ? modelData + 1 : modelData
                }
            }
        }

        /// The clock handle.
        Rectangle {
            x: priv.center.x; y: priv.center.y - height/2
            width: ball.radius; height: 1; radius: height
            color: palette.button
            transform: Rotation { angle: priv.visualAngle; origin{y: 0.5} }
            transformOrigin: Qt.TopLeftCorner
        }

        Rectangle {
            x: priv.center.x - 2.5; y: priv.center.y - 2.5
            width: 5; height: 5; radius: 5
            color: palette.button
        }

        InverterBall {
            id: ball
            property real size: 20
            property real radius: priv.radius - priv.level * size
            readonly property vector2d pos: priv.positioner(priv.visualAngle * 0.01745, radius)
            x: pos.x - width/2; y: pos.y - width/2

            sourceItem: ticks
            width: size; height: width
            color: palette.button
            highlight: palette.highlight

            Behavior on radius {SmoothedAnimation{}}
        }
    }

    background: Rectangle {
        radius: width
        color: 'transparent'
        border{width: 1; color: parent.palette.text}
    }
}
