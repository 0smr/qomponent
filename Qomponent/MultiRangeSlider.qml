// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15

import Qomponent 0.1

Control {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            leftPadding + rightPadding, leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            topPadding + bottomPadding, topPadding + bottomPadding)
    padding: 0

    QtObject {
        id: priv
        readonly property var handles: new Map()
        property int count: 0

        function push(value) {
            handles.set(count++, value);
            handlesChanged(); /// Force emit handles changed signal.
        }

        function set(key, value) {
            handles.set(key, value);
            handlesChanged(); /// Force emit handles changed signal.
        }

        function del(key) {
            handles.delete(key);
            handlesChanged(); /// Force emit handles changed signal.
        }

        function get(key) {
            return handles.get(key);
        }

        function map(val: real, from, to): real {
            return Scripts._qmap.call(val, from, to);
        }
    }

    /** @property {real} from, Minimum value of the slider. */
    property real from: 0
    /** @property {real} to, Maximum value of the slider. */
    property real to: 1
    /** @property {real} stepSize, Precision that handles value rounding to. */
    property real stepSize: 0.1
    /** @property {size} handleSize, Size of the handle stick. */
    property size handleSize: Qt.size(container.height, container.height)

    signal handleValueChanged(var handle, real value)
    signal handleCreated(var handle, real value)
    signal handleRemoved(real value)

    /**
     * @param index {*}, Index of the handle to retrieve.
     * @return handle
     */
    function handle(index) { return priv.get(index); }

    /** @param index {*}, Index of the handle to delete/remove. */
    function remove(index) {
        priv.get(index).destroy();
        priv.del(index);
    }

    /**
     * @param value {int}, Value of the handle to create.
     * @return created handle.
     */
    function push(value = 1) {
        const handle = handleComponent.createObject(container, {
            x: value * container.width - handleSize.width/2, y: 0}
        );
        priv.push(handle);
        return handle;
    }

    Component {
        id: handleComponent
        Control {
            /// BUG: Write cleaner code.
            /// This is the part that x should change based on the value and container's width,
            ///  but since the dragHandler changes x, it requires a binding to norm too.
            x: !draghandler.active ? norm * container.width - width/2 : x
            property real index: 0
            readonly property real value: priv.map(norm, [0, 1], [from, to])
            readonly property real norm: draghandler.active ? (x + width/2)/container.width : norm

            width: handleSize.width; height: handleSize.height;
            padding: 1
            opacity: 1 - y/height
            hoverEnabled: true
            /// Emit handleValueChanged signal
            onValueChanged: control.handleValueChanged(this, value)

            contentItem: Rectangle {
                color: palette.button
                border.width: 0.5
                border.color: parent.hovered ? palette.windowText : palette.window
                rotation: -45
                radius: 2
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
                xAxis { minimum: - width/2 + 1; maximum: container.width - width/2 - 1 }
            }

            DragHandler {
                dragThreshold: 5
                xAxis.enabled: false
                yAxis { minimum: 0; maximum: height * 0.7 }
                onActiveChanged: {
                    if(!active && target.y > height / 3) {
                        priv.del(target.index);
                        /// Emit handleRemoved signal
                        control.handleRemoved(target.value);
                        /// Destroy the selected handle
                        target.destroy();
                    } else {
                        target.y = 0;
                    }
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
                property var object: undefined
                anchors.fill: parent
                pressAndHoldInterval: 250
                onMouseYChanged: {
                    if(object) {
                        object.y = Math.max(0, Math.min(mouse.y, height/2));
                    }
                }
                onPressAndHold: {
                    object = handleComponent.createObject(container, {
                        x: mouse.x - handleSize.width/2,
                        y: mouse.y,
                        index: priv.count++
                    });

                    /// Emit handleCreated signal
                    control.handleCreated(object, object.value);
                }
                onReleased: {
                    if(object && mouse.y < height * 0.3) {
                        priv.set(object.index, object);
                        object.y = 0; /// Snap handle to top
                    } else if(object) {
                        object.destroy();
                    }
                    object = undefined;
                }
            }

            Ruler {
                y: parent.height - height
                width: parent.width
                height: control.height/3
                color: palette.windowText
                origin: palette.highlight
                offset: 0.5
                step { y: 3; z: 9; w: 81 }
            }
        }
    }

    background: Item {
        implicitWidth: 100
        implicitHeight: 30
    }
}
