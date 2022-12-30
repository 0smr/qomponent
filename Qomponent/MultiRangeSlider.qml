// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            leftPadding + rightPadding, leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            topPadding + bottomPadding, topPadding + bottomPadding)
    leftPadding: 0
    rightPadding: 0
    hoverEnabled: true

    QtObject {
        id: internals
        property var handles: []
    }

    property real from: 0
    property real to: 1
    property real stepSize: 0.1

    signal handlerValueChanged(var handler)
    signal handlerCreated(var handler)
    signal handlerRemoved(var handler)

    function handle(index) { return internals.handles[index]; }
    function remove(index) {
        internals.handles[index].destroy();
        internals.handles.splice(index, 1);
    }
    function push( value = 0) {

    }

    Component {
        id: handleCmp
        Control {
            property real index: 0
            property real value: (x + width/2) / container.width * Math.abs(to - from) - from
            padding: 1; width: container.height; height: width;
            opacity: 1 - y/height
            hoverEnabled: true

            contentItem: Rectangle {
                color: palette.button
                border.width: 0.5
                border.color: parent.hovered ? palette.windowText : palette.window
                rotation: -45
            }

            background: Item {
                Rectangle {
                    y: parent.height - 2; x: (parent.width - width)/2
                    height: 7; width: 1.5; color: palette.button
                    radius: width
                }
            }

            DragHandler {
                id: draghandler
                yAxis.enabled: false
                xAxis { minimum: -width/2; maximum: container.width - width/2 }
            }

            DragHandler {
                dragThreshold: 6
                xAxis.enabled: false
                yAxis { minimum: 0; maximum: height * 0.7 }
                onActiveChanged: {
                    if(!active && target.y > height / 3) {
                        target.destroy();
                    } else { target.y = 0; }
                }
            }
        }
    }

    contentItem: Column {
        Item {
            id: container
            height: control.height * 0.4
            width: parent.width
        }

        Item {
            width: parent.width
            height: control.height/2
            MouseArea {
                anchors.fill: parent
                property var obj: undefined
                onMouseYChanged: {
                    if(obj) {
                        obj.y = Math.max(0, Math.min(mouse.y, height/2));
                    }
                }
                onPressAndHold: {
                    obj = handleCmp.createObject(container, {x: mouse.x - container.height/2, y: mouse.y});
                }
                onReleased: {
                    if(mouse.y < height * 0.3 && obj) {
                        obj.y = 0; internals.handles.push(obj);
                    } else if(obj) { obj.destroy(); }
                    obj = undefined;
                }
            }

            DashedLine {
                x: -2; y: parent.height - height
                width: parent.width + 4 + parent.width % 2
                height: control.height/3
                color: palette.windowText
                originColor: palette.highlight
            }
        }
    }

    background: Item {
        implicitWidth: 100
        implicitHeight: 30
    }
}
