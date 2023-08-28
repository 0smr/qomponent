// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T

import Qomponent 0.1

T.Control {
    id: control

    font { bold: true; pointSize: 10 }

    /** @property {Array<UITourItem>} list, provides a list of UI tour objects that will be displayed sequentially. */
    default property list<UITourItem> items
    /** @property {real} index, An alias to displayed item index. */
    readonly property alias index: internals.index
    /** @property {bool} external, set parent as external fullscreen window. */
    property bool external: false
    /** @property {Text} text, text item delegate. */
    property Component textItem: Text {
        width: implicitWidth
        height: implicitHeight

        color: palette.window
        textFormat: Text.RichText
        text: message
        font: control.font
    }

    // TODO: add transitions.
    // property Transition textEnter: Transition {}

    /**
     * @brief Starts the UI Tour from the specified index; if no index is provided, it starts from the beginning.
     * @method start
     * @param {Number} index
     */
    function start(index = 0) {
        if(index < items.length || internals.index < items.length) {
            popup.open();
        }
        internals.next(index);
    }

    /**
     * @method skip, Skip one item.
     * @param {Number} index
     */
    function next() {
        internals.next();
    }

    /**
     * @method skipAll, Skip all items at once.
     * @param {Number} index
     */
    function skipAll() {
        internals.index = Number.MAX_VALUE;
        internals.close();
    }

    QtObject {
        id: internals
        property int index: -1
        property int radius: (items ?? {}).qget([index, "radius"], 25)
        property int alignment: (items ?? {}).qget([index, "align"], Qt.AlignLeft)
        property point center: Qt.point(0, 0)
        property string currentText
        property Window window: control.Window.window

        function next(_index = undefined) {
            index = _index ?? index + 1;
            if(index < items.length) {
                const target = items[index].target;
                const point = control.external ? target.mapToGlobal(target.width/2 ,target.height/2) :
                                                 target.mapToItem(popup.parent, target.width/2 ,target.height/2);
                center = point;
                show(items[index].text, point, alignment);
            } else {
                index = -1;
                currentText = ""
                popup.close();
            }
        }

        function show(text: string, _point: point, alignment: int) {
            currentText = text;
            popup.coordinate = alignTo(_point, alignment);
        }

        function alignTo(coord: point, alignment: int) {
            const xradius = radius + popup.contentWidth /2 + 10;
            const yradius = radius + popup.contentHeight/2 + 10;

            const coordinates = {
                1 : Qt.point(coord.x - xradius, coord.y), // Qt.AlignLeft
                2 : Qt.point(coord.x + xradius, coord.y), // Qt.AlignRight
                32: Qt.point(coord.x, coord.y - yradius), // Qt.AlignTop
                64: Qt.point(coord.x, coord.y + yradius), // Qt.AlignBottom
            }

            return coordinates[alignment] ?? coord;
        }
    }

    Connections {
        target: control.items.qget([index, "target"], null)
        ignoreUnknownSignals: true
        function onClicked() {
            internals.currentText = ""
            internals.next();
        }
    }

    T.Popup {
        id: popup

        property point coordinate: Qt.point(0, 0)

        x: coordinate.x - contentWidth / 2
        y: coordinate.y - contentHeight / 2
        closePolicy: T.Popup.CloseOnEscape
        parent: control.external ? _window.contentItem : internals.window.contentItem
        modal: false; dim: true

        contentItem: Loader {
            property string message: internals.currentText

            sourceComponent: control.textItem

            NumberAnimation on opacity {
                running: internals.currentText
                from: 0; to: 0.8; duration: 600
            }
        }

        T.Overlay.modeless: FocusEffect {
            id: focusEffect
            center: internals.center
            color: control.palette.windowText
            opacity: visible ? 0.4 : 0

            NumberAnimation on opacity {
                running: internals.currentText
                from: 0; to: 0.4; duration: 500
                alwaysRunToEnd: true
            }

            NumberAnimation on radius {
                running: internals.currentText
                from: 130; to: internals.radius; duration: 500
                easing.type: Easing.InSine
                alwaysRunToEnd: true
            }
        }
    }

    Window {
        id: _window
        color: 'transparent'
        width: Screen.width; height: Screen.height
        visible: control.external && popup.visible && internals.index >= 0
        flags: Qt.FramelessWindowHint | Qt.WA_DeleteOnClose |
               Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput
    }
}
