// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

Item {
    id: control

    property real length: vertical ? parent.width : parent.height
    property real padding: 5
    readonly property real parentPadding: (parent.flow ?? 0)
    readonly property bool vertical: (parent && parent.vertical) ?? false

    width: 0.001; height: 0.001
    z: 999

    Rectangle {
        x: !vertical ? -0.25 : control.padding
        y:  vertical ? -0.25 : control.padding

        width: !vertical ? 0.5 : control.length - 4 * control.padding
        height: vertical ? 0.5 : control.length - 4 * control.padding

        color: palette.windowText
        opacity: 0.2
    }
}
