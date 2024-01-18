// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic

Window {
    id: control

    color: 'transparent'
    visibility: Window.Hidden

    signal colorSelected(color selectedColor, bool valid);

    property color pickedColor: 'black'

    function activate() {
        showFullScreen()
    }

    function rgbString(c) {
        return "%1,%2,%3".arg(Math.round(c.r * 255))
                         .arg(Math.round(c.g * 255))
                         .arg(Math.round(c.b * 255));
    }

    function hslString(c) {
        return "%1,%2,%3".arg(Math.round(Math.max(0, c.hslHue * 360)))
                         .arg(Math.round(c.hslSaturation * 255))
                         .arg(Math.round(c.hslLightness * 255));
    }

    function hsvString(c) {
        return "%1,%2,%3".arg(Math.round(Math.max(0, c.hsvHue * 360)))
                         .arg(Math.round(c.hsvSaturation * 255))
                         .arg(Math.round(c.hsvValue * 255));
    }

    Item {
        id: indicator
        x: mousearea.mouseX
        y: mousearea.mouseY

        ToolTip {
            x: 5;
            y: -background.height - 10
            visible: control.visible && mousearea.containsMouse
            background: Rectangle {
                color: '#44000000'
                radius: 3
                width: childrenRect.width + 8
                height: childrenRect.height + 6

                Row {
                    spacing: 2
                    padding: 3
                    width: childrenRect.width
                    height: colorText.height

                    Rectangle {
                        width: height
                        height: parent.height;
                        radius: 2
                        color: control.pickedColor
                    }

                    Column {
                        id: colorText
                        Text {
                            color: '#fff'
                            font.family: Utils.systemFixedFont()
                            font.bold: true
                            text: "rgb:" + rgbString(control.pickedColor)
                        }

                        Text {
                            color: '#fff'
                            font.family: Utils.systemFixedFont()
                            font.bold: true
                            text: "hsl:" + hslString(control.pickedColor)
                        }

                        Text {
                            color: '#fff'
                            font.family: Utils.systemFixedFont()
                            font.bold: true
                            text: "hsv:" + hsvString(control.pickedColor)
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        propagateComposedEvents: true
        cursorShape: Qt.CrossCursor

        onPositionChanged: {
            /// get color under cursor and set to @a pickedColor
            control.pickedColor = Utils.pickColorAt(mouseX, mouseY);
        }

        onClicked: {
            colorSelected(control.pickedColor, mouse.button == Qt.LeftButton);
            control.hide();
        }
    }
}
