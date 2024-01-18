// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

Item {
    id: cont
    anchors.centerIn: parent
    width: 150
    height: width

    MouseArea {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true
    }

    Control {
        transform: Rotation {
            origin: Qt.vector3d(mousearea.width/3+py/3,mousearea.height/2+px/3,0)
            axis:   Qt.vector3d(px/cont.width/2, -py/cont.height/2,0)
            angle:  Math.sqrt(px * px + py * py)/2
        }
    }

    Rectangle {
        id: background
        width: 100
        height: width
        smooth: true
        radius: 10

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: "#8138bc" }
            GradientStop { position: 1; color: "#b63f7a" }
        }

        anchors.centerIn: parent


        Item {
            id: foreground
            x: 10 + -py/10; y:10 + -px/10;
            width: rect.width
            height: rect.height

            Column {
                Text {
                    text: qsTr("Text")
                    color: 'white'
                }

                Text {
                    text: qsTr("Another text")
                    color: 'white'
                }
            }
        }
    }
}
