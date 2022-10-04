// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15

Control {
    id: control

    property real startAngle: 10
    property real sweepAngle: 100

    readonly property real visualAngle: Math.min(Math.max(startAngle, mousearea.angle), startAngle + sweepAngle)
    readonly property real value: (visualAngle - startAngle)/sweepAngle

    property alias indicator: indicator

    contentItem: Item {
        implicitWidth: 175
        implicitHeight: 175

        Shape {
            anchors.fill: parent
            smooth: true
            ShapePath {
                strokeColor: control.palette.base
                strokeWidth: 1
                fillColor: 'transparent'
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    id: pathAngleArc

                    centerX: control.availableWidth/2
                    centerY: control.availableHeight/2
                    radiusX: (control.availableWidth - indicator.width)/2
                    radiusY: radiusX
                    startAngle: control.startAngle - 90
                    sweepAngle: control.sweepAngle
                }
            }
        }

        MouseArea {
            id: mousearea
            anchors.fill: parent
            property real angle: 360

            function calculateAngle() {
                return Math.atan2(width/2 - mouseX, mouseY - height/2) * 57.29655 + 180;
            }

            function isPositionValid(angle) {
                const endAngle = control.startAngle + control.sweepAngle
                const validDist = Math.hypot(mouseX - width/2, mouseY - height/2) <= width / 2;
                const validAngle = control.startAngle - 10 < angle && angle < endAngle + 10;
                return validDist && validAngle;
            }

            onPositionChanged: {
                const newAngle = calculateAngle();
                // prevent slider jump
                if(Math.abs(newAngle - angle) < 180) {
                    angle = newAngle;
                }
            }

            onPressed: {
                const newAngle = calculateAngle();
                mouse.accepted = isPositionValid(newAngle);
                if(mouse.accepted) {
                    angle = newAngle;
                }
            }
        }

        Rectangle {
            id: indicator
            x: (parent.width - width) / 2

            width: 20; height: width
            radius: width / 2

            color: control.palette.button
            border {
                width: mousearea.containsPress ? 4 : 2
                color: Qt.darker(indicator.color, 1.1)
                Behavior on width { NumberAnimation { duration: 50 } }
            }

            transform: Rotation {
                angle: control.visualAngle
                origin.x: indicator.width / 2
                origin.y: control.availableHeight / 2 - indicator.y
            }
        }
    }
}
