// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

Item {
    id: control

    property alias color: line.color
    property alias contentItem: line

    property real length: vertical ? parent.width : parent.height
    property real padding: 5
    property real thickness: 0.5
    readonly property real parentPadding: (parent.flow ?? 0)
    readonly property bool vertical: (parent && parent.vertical) ?? false

    width: !vertical ? 0.001 : length
    height: vertical ? 0.001 : length
    z: 999

    opacity: 0.2
    Rectangle {
        id: line
        x: !vertical ? -thickness/2 : control.padding
        y:  vertical ? -thickness/2 : control.padding

        width: !vertical ? thickness : control.length - 2 * control.padding
        height: vertical ? thickness : control.length - 2 * control.padding

        color: palette.windowText
    }
}
