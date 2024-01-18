// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

Control {
    id: control
    property int minors: 10
    property alias ruler: ruler
    property alias offset: ruler.offset

    QtObject {
        id: priv
        property real off: ruler.offset
        property real step: control.minors
        property real dist: control.availableWidth
    }

    contentItem: Column {
        clip: true
        spacing: control.spacing

        Ruler {
            id: ruler
            width: parent.width; height: 10
            step.y: 2
            step.z: Math.floor(priv.step / 2) * 2
            step.w: Math.floor(priv.step / 2) * 6
        }

        Item {
            width: parent.width
            height: control.height - ruler.height

            Repeater {
                model: priv.dist/(ruler.step.y) + 2

                Label {
                    readonly property bool needRotate: priv.step - 2 < implicitWidth
                    y: -font.pixelSize * needRotate
                    x: (index - 1) * priv.step - priv.off % priv.step + (priv.dist/2) % priv.step
                    color: '#fff'
                    font.family: Qomponent.monofont.name
                    font.pixelSize: 8
                    text: (x + priv.off - priv.dist/2).toFixed()
                    rotation: needRotate * 90
                    transformOrigin: Item.BottomLeft
                }
            }
        }
    }

    DragHandler {
        property real start
        target: null
        dragThreshold: 1
        onActiveChanged: if(active) start = ruler.offset;
        onTranslationChanged: ruler.offset = start - translation.x;
    }
}
