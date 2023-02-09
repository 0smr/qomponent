// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

Item {
    id: control

    property alias color: line.color
    property real length: vertical ? parent.width : parent.height
    property real padding: 5
    property alias contentItem: line

    property bool vertical: (parent.flow ?? 0) === Grid.TopToBottom

    width: !vertical ? 0.0001 : length - 1 // -1 is for binding issue
    height: vertical ? 0.0001 : length - 1
    z: 999

    opacity: 0.2
    Rectangle {
        id: line
        x: !vertical ? -0.25 : control.padding
        y:  vertical ? -0.25 : control.padding

        width: !vertical ? 0.5 : control.length - 2 * control.padding
        height: vertical ? 0.5 : control.length - 2 * control.padding

        color: palette.windowText
    }
}
